Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063175;
	b=O+tx38ivOXCNK6OHr2Sd0ajAPPpdtTEVPiFeBsqMVx99Y4pNfj+fpaasYt606S1tZflh
	 nEQlM8SI3W7efeS21HHrtx4C39zXRFW8j9Dr++vjoy24E1qHSFBw/ur6wCnJp93J0bnWO
	 cDNXXUbEJPG56k9CmdI4Z+qK6GqIZzFXvS8v8rZ2O3Gr86FHLIqipKmMBxJi++JZWmyfZ
	 z67ShH/uOh5YqXNZBssaNaN8/8wkRvn1IxJWi1X1f4QCWa6WVxhmRNBd5/bZ9AnHcgEIo
	 LtlRXkOURpNcspfvWbbSfGc8P/Po9gpuY0wfswR/Kbm0CaGtuNflijMcyDYRdA2yiTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aGVQVVNLrlbVcv2e+V5QAVHRkNAPjBq+wvdzDfv/wqg=;
	b=4L5bA0k9fPKFXa2P8HB8iAQegIU/gsoHq60MmJKcLBLRhhdTWgChBNzso30U80agztyI
	 CxuNlb72dMlx5cCWQgkNgCrOFt8Tu4Ga5yUMQkEn9BaKm7I4uoUFqdI0AyRJPNyvR8VVs
	 VK0X3lUrv5SbmM1OdCUmBHMmDTXjcxNheGkLWivaN4KliGOR9TEcFsMhat97+o/gWW3DG
	 BIn1IFjd4waMLaUQePp6hTD3QI/qRk9o0WZaFYmf9EzoyCR7+qeVeQ9/+iTSBs0NNlY4f
	 r5BUScwkGUflA3DluMSNG01JYEotCT9IYiMwwFYDJvljkapUS6RdDMgbAl1R+H2Kd1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZuRRbv4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAD1606A330;
	Sat,  7 Nov 2026 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0ZuRRbv4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C5D1F0089F;
	Sat,  7 Nov 2026 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063175;
	bh=aGVQVVNLrlbVcv2e+V5QAVHRkNAPjBq+wvdzDfv/wqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZuRRbv4rP7Z+Px2NGrvVwRtnjzPNX7erwHFCufBVegMOr+s0MCjfehk9mEZA2fr1
	 jR8eofOHNe8az377/c2WI8KN6kRmQYaaFJrZ8YR+lHe8NjYgQjRMqiWN4j7a1Qvctv
	 jSJehL8UPm3AS96o975nY94pokpcr0XCpX0F79lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/869] ocfs2: exit recovery thread on mount error path
Date: Sat,  7 Nov 2026 08:51:13 -0500
Message-ID: <20261107134906.685238375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 6163a859649e9432e9c79c541f36dbf3bba9172f ]

When a mount fails after the cluster connection has been established, e.g.
in ocfs2_mount_volume(), ocfs2_fill_super() unwinds via
out_debugfs/out_super and frees the osb without disabling recovery.

A node failure event can concurrently launch the recovery thread, which
blocks in __ocfs2_wait_on_mount() waiting for the volume state to become
VOLUME_MOUNTED or VOLUME_DISABLED.  As the mount error path neither sets
VOLUME_DISABLED nor wakes osb_mount_event, the thread can never make
progress: the kthread leaks and stays blocked on the wait queue embedded
in the freed osb, which may then be accessed as freed memory.

Fix it by setting VOLUME_DISABLED and waking osb_mount_event on this path
so the thread bails out, and replace the plain kfree(osb->recovery_map)
with ocfs2_recovery_exit(), which waits for a running recovery thread to
exit before the recovery map is freed.

Link: https://lore.kernel.org/20260828112825.666097-1-joseph.qi@linux.alibaba.com
Fixes: f1e75d128b46 ("ocfs2: rewrite error handling of ocfs2_fill_super")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index dc252b53c7dcf..433b673ae5158 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1170,8 +1170,17 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 out_debugfs:
 	debugfs_remove_recursive(osb->osb_debug_root);
 out_super:
+	/*
+	 * A recovery thread launched by a node failure event may still be
+	 * waiting for the volume to be mounted.  Set VOLUME_DISABLED and
+	 * wake it up, then wait for it to exit before osb is freed,
+	 * otherwise the kthread would leak and stay blocked on the wait
+	 * queue embedded in the freed osb.
+	 */
+	atomic_set(&osb->vol_state, VOLUME_DISABLED);
+	wake_up(&osb->osb_mount_event);
 	ocfs2_release_system_inodes(osb);
-	kfree(osb->recovery_map);
+	ocfs2_recovery_exit(osb);
 	ocfs2_delete_osb(osb);
 	kfree(osb);
 out:
-- 
2.53.0



