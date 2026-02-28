Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E8E38CFE6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302121; cv=none; b=KQ0MUfx2RQZe7cujRU6W6HEyw4E7f/nMeskjHR9rOHXEvvyjEvMgB3uBbKaxxE8CffIeb3YrrcbrCifThvp3QpsA0nGS3hVDehD14mgAeZYa1KwMA83CuBdfEoIirtTjoR5BwWi80Y6qa/ruaTLdNdtfUw+uLcDVTskMwiYVX7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302121; c=relaxed/simple;
	bh=vCjFclKE2L4E4kyR9zC62v7nq0sPh6EHH8479x7zdQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJoBABzoFXrGpSICec1GXQ1ReSQ2+6GNRGQGjQdqk7YZdYu7hGJOLj6Ql3/3odXgxXlO5JidPmJb83koFMOw/ohRS3HpzQ9Kp5gkoL5821cat/MpbnL5HYRiF1UF9+eXdhhdDtdq4Xu6W9Usp4/sjaBT3Z0QPPGnH0Gx4Jx8jfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSt6goH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSt6goH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758F4C2BC87;
	Sat, 28 Feb 2026 18:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302121;
	bh=vCjFclKE2L4E4kyR9zC62v7nq0sPh6EHH8479x7zdQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSt6goH5yvGhy2RGbwXm1tpyQqKulOhga3OElC1NNtdTIgAwdZAo+9GSDoFRhTw0r
	 Nd/1GyIJAanM5+demETrYZbXU63/wit/Ltbd72bOdUrP+u4WayTBQaTb5so8oVNNGs
	 Y+U/iETeMc9LXn6ahBUlrAoDmejeDTyLiKjOTFLN6HvFX7g6AB06e53UqOs5M1jDM2
	 f//1rsFkqXfDRaf3Ilk4WrfAGJ5ncyhqFRfMvYhuo8CDG14jYKlRcPTEeBKQiv+l4B
	 A1KRgrZvd6gkWgBm6z5t2ncOBD5HXLcwiBueJw0RTDlUcOwT9+0uIsYLwaD0N1ZVXu
	 D0n6/GrN4+kgA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abhishek Bapat <abhishekbapat@google.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/283] quota: fix livelock between quotactl and freeze_super
Date: Sat, 28 Feb 2026 13:04:13 -0500
Message-ID: <20260228180709.1583486-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Abhishek Bapat <abhishekbapat@google.com>

[ Upstream commit 77449e453dfc006ad738dec55374c4cbc056fd39 ]

When a filesystem is frozen, quotactl_block() enters a retry loop
waiting for the filesystem to thaw. It acquires s_umount, checks the
freeze state, drops s_umount and uses sb_start_write() - sb_end_write()
pair to wait for the unfreeze.

However, this retry loop can trigger a livelock issue, specifically on
kernels with preemption disabled.

The mechanism is as follows:
1. freeze_super() sets SB_FREEZE_WRITE and calls sb_wait_write().
2. sb_wait_write() calls percpu_down_write(), which initiates
   synchronize_rcu().
3. Simultaneously, quotactl_block() spins in its retry loop, immediately
   executing the sb_start_write() - sb_end_write() pair.
4. Because the kernel is non-preemptible and the loop contains no
   scheduling points, quotactl_block() never yields the CPU. This
   prevents that CPU from reaching an RCU quiescent state.
5. synchronize_rcu() in the freezer thread waits indefinitely for the
   quotactl_block() CPU to report a quiescent state.
6. quotactl_block() spins indefinitely waiting for the freezer to
   advance, which it cannot do as it is blocked on the RCU sync.

This results in a hang of the freezer process and 100% CPU usage by the
quota process.

While this can occur intermittently on multi-core systems, it is
reliably reproducing on a node with the following script, running both
the freezer and the quota toggle on the same CPU:

  # mkfs.ext4 -O quota /dev/sda 2g && mkdir a_mount
  # mount /dev/sda -o quota,usrquota,grpquota a_mount
  # taskset -c 3 bash -c "while true; do xfs_freeze -f a_mount; \
    xfs_freeze -u a_mount; done" &
  # taskset -c 3 bash -c "while true; do quotaon a_mount; \
    quotaoff a_mount; done" &

Adding cond_resched() to the retry loop fixes the issue. It acts as an
RCU quiescent state, allowing synchronize_rcu() in percpu_down_write()
to complete.

Fixes: 576215cffdef ("fs: Drop wait_unfrozen wait queue")
Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Link: https://patch.msgid.link/20260115213103.1089129-1-abhishekbapat@google.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/quota/quota.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/quota/quota.c b/fs/quota/quota.c
index 0e41fb84060f5..5be53cae2c95d 100644
--- a/fs/quota/quota.c
+++ b/fs/quota/quota.c
@@ -899,6 +899,7 @@ static struct super_block *quotactl_block(const char __user *special, int cmd)
 		sb_start_write(sb);
 		sb_end_write(sb);
 		put_super(sb);
+		cond_resched();
 		goto retry;
 	}
 	return sb;
-- 
2.51.0

