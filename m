Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020650;
	b=iGGwWYwAJpqT5jioRzWQ5Rl4Wv3WWdWUMotfy2sJWvtFqOu+W0YlcEbHJ3LEETpDq1HO
	 +ZNKDyMo3+5veXAcAVyvXyO0d9k9oQdPy0OgYh/g35iDYu1S5A1ljNG/kU8aabd6NTUXH
	 DWEnU7N3rrvOh5vLTDiMBFYob/wEnHAWww3e2moCnPDN9nUK9HEcavvo7hVsLOqiJNNmQ
	 7EaGOaY5122VmRfVZK8+rRuAZzh8leRSBdenGbQRnmLyVQFqTfXPJ1cCQyxenLzBRqlS8
	 ELiWezzmltdoKHd359bDVSIsHCvp0fUB31wZ98tjuFVU1v+4ckyb/Q6yv3cSwzPp7xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Mwbge+FXkuh+SAXeUFIcQzURPqILVMHovQTUXIzr6s=;
	b=XTqNOFruEY2k5og4zaJz9vu+lKvagd7VXL/8ol6VNOzn9fQR8EMUht4mmIL45B6/M7bt
	 7t600ignXY+JAmqZM3elnd2LKMOPEiydscLs2x1IsQrW5P7g2AUba/sV8tTIRwt1Huit9
	 gGNC4ddBjc+ZrgkeX3qQl+2UN5KM5U/Q0kCCdodQhBrnrHQxfCcAceAC2vHWiB62Tmxvv
	 HUfr7iUfv80uH6z+Zb2mFO/7oSzQ/ijcr4DPKyRNOjDkRgNBnoC4GZz3TwP5KzE/njdFf
	 AcJ7UxuXDQ7uuz4EzNjEmO6wZ8OT0HkchqFcNBAFVreJFidMwwpQsIZ5CFvAIH7P4sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EQWg//jb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C478B60A2605;
	Wed, 18 Nov 2026 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EQWg//jb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40CD1F000C4;
	Wed, 18 Nov 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020650;
	bh=3Mwbge+FXkuh+SAXeUFIcQzURPqILVMHovQTUXIzr6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EQWg//jbZwzn57kFy+m00GXvmzliq9JbkOx/EFXMW3+Gkn+JTh8sxFmrV3VYFPFoT
	 5espw6YMLGhgsKnF14FZOQSFCuIDMHBcVfguRHun4wdb+MHvIax+cjCahWNYWNOK/k
	 fHHP46ULSTWzEvgXthV6muPI+2nhGq3u76oiuBSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2010/2651] f2fs: quota: fix quota flush failure during filesystem freeze
Date: Wed, 18 Nov 2026 15:54:10 +0100
Message-ID: <20261118150358.631271352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianan Huang <jnhuang95@gmail.com>

[ Upstream commit f6f8f34480c78eade6542faea6386c47c9b4c6b3 ]

Quota flush retries can be exhausted during filesystem freeze.

freeze_super() and the quota checkpoint may race as below.

freeze_super()                       f2fs_ckpt
- down_write(&sb->s_umount)
- sb->s_writers.frozen = SB_FREEZE_PAGEFAULT
- sync_filesystem()
 - f2fs_sync_fs()
  - f2fs_issue_checkpoint()
   - queue CP_SYNC -----------------> - block_operations()
                                      - down_read_trylock(s_umount)
                                        : fails; freeze holds write lock
                                      - quota flush retries exhausted
                                      - set CP_QUOTA_NEED_FSCK_FLAG

During the PAGEFAULT sync pass, freeze_super() holds s_umount for
write, but umount_lock_holder is not set until f2fs_freeze().  Thus
quota writeback tries to acquire s_umount again and can exhaust retries.

With checkpoint merge enabled, f2fs_issue_checkpoint() may dispatch
CP_SYNC to f2fs_ckpt. That thread also cannot acquire the freeze lock.

Record current as umount_lock_holder around the VFS PAGEFAULT sync so
checkpoint runs in the freeze caller and quota flush uses its existing
s_umount write lock.

Fixes: eb85c2410d6f ("f2fs: quota: fix to avoid warning in dquot_writeback_dquots()")
Signed-off-by: Jianan Huang <jnhuang95@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 070a0bfdbb015..09bc78f2d0b58 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2154,6 +2154,25 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
 	return err;
 }
 
+static int f2fs_sync_fs_super(struct super_block *sb, int sync)
+{
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+	bool freeze_sync = sync &&
+			sb->s_writers.frozen == SB_FREEZE_PAGEFAULT;
+	int err;
+
+	/* freeze_super() holds s_umount for write during this sync pass. */
+	if (freeze_sync)
+		sbi->umount_lock_holder = current;
+
+	err = f2fs_sync_fs(sb, sync);
+
+	if (freeze_sync)
+		sbi->umount_lock_holder = NULL;
+
+	return err;
+}
+
 static int f2fs_freeze(struct super_block *sb)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(sb);
@@ -3776,7 +3795,7 @@ static const struct super_operations f2fs_sops = {
 #endif
 	.evict_inode	= f2fs_evict_inode,
 	.put_super	= f2fs_put_super,
-	.sync_fs	= f2fs_sync_fs,
+	.sync_fs	= f2fs_sync_fs_super,
 	.freeze_fs	= f2fs_freeze,
 	.unfreeze_fs	= f2fs_unfreeze,
 	.statfs		= f2fs_statfs,
-- 
2.53.0



