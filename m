Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDF43F6C4C;
	Wed, 20 May 2026 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297897; cv=none; b=caC14sk3AJmwrWR+7yWXe63kAd1IxAwCvHsSlocwVJrgDlFexoZDcn4dqy5UCjEoMGEVlfIYwVWzMtA+vd4ANh/bsdRiml75hra7e+l2uHJkEMTnCzVpRfhmSRoLuL4kWpuMWI2o+WvJib/9IB4kZZTeJAL+AosBrEzROmMzygk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297897; c=relaxed/simple;
	bh=mJc6uT6BaPJZ/nefZuCwiMuv1BX/DAZ6t+rYoOrdYA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDpngFku1bnYNV5OHLFyBuuAAl2ctDapTA474finhds6f1N41oSWJEPICvoiDabsMq3A1/UCl8AJ3eKG68QhcOlCilLTvN4o3h6eRtJLSKN5rOjMJxJGfG6RM/NpwqCdoK+9MMBx9Ul7Szh0/pySE7tZqt2hU4agBec7Gg4d0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrjKH/6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrjKH/6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EF71F000E9;
	Wed, 20 May 2026 17:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297896;
	bh=aikQOXxOD2V69NnsdJAvnx02S3hhz9DBY8kPK66jZCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nrjKH/6rGzuGFtgRIAtSZbKkwcJq9DaZtOAjySoQ7BtpYr2gxO136giq2L0Lv9yw6
	 KOMb/WWj1SL+3myNptgp9T3ncH+M7jm5yBViCN+HHOSCaVCZpxNcCgJFKECnljgh5m
	 Lnyi56YDkb5Mpp4YM6dJW7gdgSmcbNQsr3nGr5Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Hanna Czenczek <hreitz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/957] dm-mpath: dont stop probing paths at presuspend
Date: Wed, 20 May 2026 18:11:27 +0200
Message-ID: <20260520162138.967995407@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 51d81e14fe6788dc6463064c7517480f2acd2724 ]

Commit 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing
paths"), added code to make multipath quit probing paths early, if it
was trying to suspend. This isn't necessary. It was just an optimization
to try to keep path probing from delaying a suspend. However it causes
problems with the intended user of this code, qemu. The path probing
code was added because failed ioctls to multipath devices don't cause
paths to fail in cases where a regular IO failure would.

If an ioctl to a path failed because the path was down, and the
multipath device had passed presuspend, the M_MPATH_PROBE_PATHS ioctl
would exit early, without probing the path. The caller would then retry
the original ioctl, hoping to use a different path. But if there was
only one path in the pathgroup, it would pick the same non-working path
again, even if there were working paths in other pathgroups.

ioctls to a suspended dm device will return -EAGAIN, notifying the
caller that the device is suspended, but ioctls to a device that is just
preparing to suspend won't (and in general, shouldn't). This means that
the caller (qemu in this case) would get into a tight loop where it
would issue an ioctl that failed, skip probing the paths because the
device had already passed presuspend, and start over issuing the ioctl
again. This would continue until the multipath device finally fully
suspended, or the caller gave up and failed the ioctl.

multipath's path probing code could return -EAGAIN in this case, and the
caller could delay a bit before retrying, but the whole purpose of
skipping the probe after presuspend was to speed things up, and that
would just slow them down. Instead, remove the is_suspending flag, and
check dm_suspended() instead to decide whether to exit the probing code
early. This means that when the probing code exits early, future ioctls
will also be delayed, because the device is fully suspended.

Fixes: 5c977f102315 ("dm-mpath: Don't grab work_mutex while probing paths")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Hanna Czenczek <hreitz@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-mpath.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 00df5be165759..3a25ec2993dc2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -102,7 +102,6 @@ struct multipath {
 	struct bio_list queued_bios;
 
 	struct timer_list nopath_timer;	/* Timeout for queue_if_no_path */
-	bool is_suspending;
 };
 
 /*
@@ -1748,9 +1747,6 @@ static void multipath_presuspend(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
 
-	spin_lock_irq(&m->lock);
-	m->is_suspending = true;
-	spin_unlock_irq(&m->lock);
 	/* FIXME: bio-based shouldn't need to always disable queue_if_no_path */
 	if (m->queue_mode == DM_TYPE_BIO_BASED || !dm_noflush_suspending(m->ti))
 		queue_if_no_path(m, false, true, __func__);
@@ -1773,7 +1769,6 @@ static void multipath_resume(struct dm_target *ti)
 	struct multipath *m = ti->private;
 
 	spin_lock_irq(&m->lock);
-	m->is_suspending = false;
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) {
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 		clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
@@ -2100,7 +2095,7 @@ static int probe_active_paths(struct multipath *m)
 		if (m->current_pg == m->last_probed_pg)
 			goto skip_probe;
 	}
-	if (!m->current_pg || m->is_suspending ||
+	if (!m->current_pg || dm_suspended(m->ti) ||
 	    test_bit(MPATHF_QUEUE_IO, &m->flags))
 		goto skip_probe;
 	set_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
@@ -2109,7 +2104,7 @@ static int probe_active_paths(struct multipath *m)
 
 	list_for_each_entry(pgpath, &pg->pgpaths, list) {
 		if (pg != READ_ONCE(m->current_pg) ||
-		    READ_ONCE(m->is_suspending))
+		    dm_suspended(m->ti))
 			goto out;
 		if (!pgpath->is_active)
 			continue;
-- 
2.53.0



