Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032180;
	b=Xr2FUtnUGK9UAuFfE4S0kxbtENDEWjFCxYzTmPAite0eiPnNSDsb7GoqSkrcFvPvtnOd
	 oFBIWBvMFKPjfqHiJXjJXx+VInyVC5P5k/rtJU95Qv4RzZ1E7W6O9E30jPdJVxPFiEoQI
	 bov5w5bG5gah01p0r25sR+ixpZ072pdmAnDu+e8aXOBaJN+8pXLVOIj5dbqFgA2ZEa5jG
	 QxuHALJqBFGbV8W4yF0tgiYjpHmxFvoHp2lt236EcsHiaOBEOstLkkPx3cI6zKn1R7OKG
	 skJ63CXfCOCQbUL4SKj8BCI51Lga8tJrVjUfPr87DFnsnj31AsAtDHR1GUIURQJQXAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nHtbZ2Awb4kNbSOum9jTfrwmocd+tohXQK+YTd58l78=;
	b=l8+kkQF8sdQrcSmrsdTrpH607kkduM0p59F2HTZ7ERx1s6q1825lB1IRD2p470p5y1vQ
	 OLq3lz1OtRkkM9xYEWxRVYvr1nJI9c3aNd5Uv4x0hq6br4QH4uX3feekyIjneKvGj8hCI
	 uBnn2jWVIptdHb5BRv1aWnDbnetyD5iBRAHd2WVUDMWAbKWz+IjaFXAyEfzS7iOxIYaCa
	 rWq/8t+ncdKtlgir1M1M+4kOydejRzaMbo+0wgqNhzF3PWwnbBz7BnD28ZClWMi6+XDYK
	 lgxOhFAZQn4o6rwBHfdnVAEvMPbadRw3UbB/HlYCs0cHaaL2OcYc2GeLcJmu98qOKMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6+7UtE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AAC606A31C;
	Wed, 18 Nov 2026 20:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H6+7UtE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 442FC1F000C4;
	Wed, 18 Nov 2026 20:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032179;
	bh=nHtbZ2Awb4kNbSOum9jTfrwmocd+tohXQK+YTd58l78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6+7UtE8WUJvgj7BaG9fDpw6AqX1jtbumgeevEvwXCUTY0AafLDfbkSZyF8Clpe0n
	 WvcbfaQHUxi3PRvgGuCYjOXuIX7mfuGaurR+rHxL0/HTelPIph7xRo6wnYqkCGQIZ8
	 iiTMGAqhI5EuP/o6NGyG4SEALO16TgeMkVFEQiWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianan Huang <jnhuang95@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1319/1756] f2fs: quota: fix quota flush failure during filesystem freeze
Date: Wed, 18 Nov 2026 15:57:26 +0100
Message-ID: <20261118150101.947481059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index acf6bdea8a451..53983e8385e45 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1734,6 +1734,25 @@ int f2fs_sync_fs(struct super_block *sb, int sync)
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
@@ -3301,7 +3320,7 @@ static const struct super_operations f2fs_sops = {
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



