Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6CF83B38AD;
	Wed, 20 May 2026 16:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295081; cv=none; b=q7cN/2JAWMKS9IdcyJhKsEu1G4qLT5e8f0+5kBuW1RxPOvYAY78tN5zT2I6+Y9WXvyu1s3lJZBd1PO7CSjVPLHjLU2YOmpptO4k3ZqTEVM5mB+uBn+1DOkiyrbUtVxeVMAEgbaB0BAWwQvFnsZeGxe0wg8ctz2PrcRi9So0Ywys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295081; c=relaxed/simple;
	bh=fcg8e8O/0s9DwdMlfwxYNmspm/BbbCj8OxI8A7470zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BM1vgXFmwsLMHAgzew0Ab9NJ3f9JUYA0teWCB7m1apRTB9EGEK1eWrZdRKzSGZpCFG/BEj4NvZBLaGaX0uQZK4BmIhwk9rmsh0UYuCo7VjWfzlIsavZcaAp+tm1bfDZPDN8fJIiqjVivkE6knFdceaIHHFA621Ak0jih2itaKdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=muqs261y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="muqs261y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F761F000E9;
	Wed, 20 May 2026 16:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295079;
	bh=SNwod/wjI8EtCEis4n//0/uJz6lGnx1MSQ0kGPML2cI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muqs261yqn+G2NK7EUzQvMqE4dCLar4ROaSZO+LO9YbHWLuisSglgOdzUYxjR0t16
	 FSLCEqqr4Tfud8kM0PfrczTyGpKbKs9zK8tMirDWUaFwcUDLT+7AtMIKy6gUAP/iGF
	 0D7YyCbClluu3TSspQq+76Ij7EYKl/xUOqxRO+YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Martin Wilck <mwilck@suse.com>,
	Hanna Czenczek <hreitz@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0256/1146] dm-mpath: dont stop probing paths at presuspend
Date: Wed, 20 May 2026 18:08:26 +0200
Message-ID: <20260520162154.025600206@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 8f4ae2f515453..7cb7bb6233b64 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -102,7 +102,6 @@ struct multipath {
 	struct bio_list queued_bios;
 
 	struct timer_list nopath_timer;	/* Timeout for queue_if_no_path */
-	bool is_suspending;
 };
 
 /*
@@ -1749,9 +1748,6 @@ static void multipath_presuspend(struct dm_target *ti)
 {
 	struct multipath *m = ti->private;
 
-	spin_lock_irq(&m->lock);
-	m->is_suspending = true;
-	spin_unlock_irq(&m->lock);
 	/* FIXME: bio-based shouldn't need to always disable queue_if_no_path */
 	if (m->queue_mode == DM_TYPE_BIO_BASED || !dm_noflush_suspending(m->ti))
 		queue_if_no_path(m, false, true, __func__);
@@ -1774,7 +1770,6 @@ static void multipath_resume(struct dm_target *ti)
 	struct multipath *m = ti->private;
 
 	spin_lock_irq(&m->lock);
-	m->is_suspending = false;
 	if (test_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags)) {
 		set_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags);
 		clear_bit(MPATHF_SAVED_QUEUE_IF_NO_PATH, &m->flags);
@@ -2098,7 +2093,7 @@ static int probe_active_paths(struct multipath *m)
 		if (m->current_pg == m->last_probed_pg)
 			goto skip_probe;
 	}
-	if (!m->current_pg || m->is_suspending ||
+	if (!m->current_pg || dm_suspended(m->ti) ||
 	    test_bit(MPATHF_QUEUE_IO, &m->flags))
 		goto skip_probe;
 	set_bit(MPATHF_DELAY_PG_SWITCH, &m->flags);
@@ -2107,7 +2102,7 @@ static int probe_active_paths(struct multipath *m)
 
 	list_for_each_entry(pgpath, &pg->pgpaths, list) {
 		if (pg != READ_ONCE(m->current_pg) ||
-		    READ_ONCE(m->is_suspending))
+		    dm_suspended(m->ti))
 			goto out;
 		if (!pgpath->is_active)
 			continue;
-- 
2.53.0



