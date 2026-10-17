Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E863C8C65;
	Sat, 17 Oct 2026 17:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258440; cv=none; b=K3XUmUi//sVUMi1g0sfyh/xTDcB/VYlyAL8Kv6ilmffZIhR98CDg8UiNo0SreCE/BYy780aVZhmGhx5UHX4zvEbAoz6ID+8KIpL9lV3+QsOjXrI19Y4jpeI8l0TZ5rC3A1y63AnXh1Vp2b4ktaiu7Q84sQcomNxCGO06RZWLtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258440; c=relaxed/simple;
	bh=URqt3cGJc5Pw2F2fyshAivqSablUpkTyOrAkTVWkN/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CS3oVAXWj356bhyFDDUYUCsh3cI7/0EadEIcnGSb1dcUM7R321pRvNxf+yoVcS4yA+Nb2sEovs14HCyDABKVtbpGYl/Uev2z7m6nhSCkr++wAAyScMU4qtuWGonXeTEdLneScb/mjLmdA/bPy1SKNkmbnupST/Ei1a7VHQp+Xs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pflW1YU/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pflW1YU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1AE1F000C4;
	Sat, 17 Oct 2026 17:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258439;
	bh=isPBMlTqDh/y/w8mS2WRjp0WqSNYWx7+HHNBQBcIaS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pflW1YU/LyVcXp7IIoJMmo3SM3UVOuYEi8+cSgMwCN1r5qhZgwKXED/MqUI2aanz6
	 V0OVtV6dSqVlD8MuVGG4MJKCCLdHzZwWz15w0pDErThUi4dBBFVymQKBfnMyKUHWuF
	 wvXVTH+MnR6K7HnFxxRi4oqSC9Xgvkwzlc+5qbBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FengWei Shih <dannyshih@synology.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0845/1674] md: suspend array while updating raid_disks via sysfs
Date: Sat, 17 Oct 2026 17:51:57 +0200
Message-ID: <20261017160452.815230384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FengWei Shih <dannyshih@synology.com>

[ Upstream commit 2cc583653bbe050bacd1cadcc9776d39bf449740 ]

In raid1_reshape(), freeze_array() is called before modifying the r1bio
memory pool (conf->r1bio_pool) and conf->raid_disks, and
unfreeze_array() is called after the update is completed.

However, freeze_array() only waits until nr_sync_pending and
(nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
occurs, nr_queued is increased and the corresponding r1bio is queued to
either retry_list or bio_end_io_list. As a result, freeze_array() may
unblock before these r1bios are released.

This can lead to a situation where conf->raid_disks and the mempool have
already been updated while queued r1bios, allocated with the old
raid_disks value, are later released. Consequently, free_r1bio() may
access memory out of bounds in put_all_bios() and release r1bios of the
wrong size to the new mempool, potentially causing issues with the
mempool as well.

Since only normal I/O might increase nr_queued while an I/O error occurs,
suspending the array avoids this issue.

Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
the array. Therefore, we suspend the array when updating raid_disks
via sysfs to avoid this issue too.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
Link: https://lore.kernel.org/linux-raid/20251226101816.4506-1-dannyshih@synology.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f4d9defee5d04..c8cb2a83e2f54 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4309,7 +4309,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err < 0)
 		return err;
 
-	err = mddev_lock(mddev);
+	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->pers)
@@ -4334,7 +4334,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	} else
 		mddev->raid_disks = n;
 out_unlock:
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
-- 
2.53.0



