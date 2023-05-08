Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45B4168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F2EC433D2;
	Mon,  8 May 2023 10:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541493;
	bh=5YO5igtr+mxYdWbXz7o5DURZML2fgtR0YUDUPlNuETc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzMSmMMFnxNMjtlU55eph0CUKMWB/8sKqeTfl2cUEQlij0TeGAoIkp9mWXhQUHSNA
	 4lkqPbm02mLqbpvwBibwfxOkbqgCUdVhkzDwyvsaRS3YWWlJiG/NC6fAH+P2cfRPky
	 gwfvOtMLiBd/HcShqIXOXTy6zMxW+LQRpXmAEInc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 131/663] erofs: initialize packed inode after root inode is assigned
Date: Mon,  8 May 2023 11:39:17 +0200
Message-Id: <20230508094432.777174885@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit cb9bce79514392a9a216ff67148e05e2d72c28bd ]

As commit 8f7acdae2cd4 ("staging: erofs: kill all failure handling in
fill_super()"), move the initialization of packed inode after root
inode is assigned, so that the iput() in .put_super() is adequate as
the failure handling.

Otherwise, iput() is also needed in .kill_sb(), in case of the mounting
fails halfway.

Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Fixes: b15b2e307c3a ("erofs: support on-disk compressed fragments data")
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Acked-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230407141710.113882-3-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h |  1 +
 fs/erofs/super.c    | 22 +++++++++++-----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index bb8501c0ff5b5..f246523dd7917 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -154,6 +154,7 @@ struct erofs_sb_info {
 
 	/* what we really care is nid, rather than ino.. */
 	erofs_nid_t root_nid;
+	erofs_nid_t packed_nid;
 	/* used for statfs, f_files - f_favail */
 	u64 inos;
 
diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index 626a615dafc2f..bd8bf8fc2f5df 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -381,17 +381,7 @@ static int erofs_read_superblock(struct super_block *sb)
 #endif
 	sbi->islotbits = ilog2(sizeof(struct erofs_inode_compact));
 	sbi->root_nid = le16_to_cpu(dsb->root_nid);
-#ifdef CONFIG_EROFS_FS_ZIP
-	sbi->packed_inode = NULL;
-	if (erofs_sb_has_fragments(sbi) && dsb->packed_nid) {
-		sbi->packed_inode =
-			erofs_iget(sb, le64_to_cpu(dsb->packed_nid));
-		if (IS_ERR(sbi->packed_inode)) {
-			ret = PTR_ERR(sbi->packed_inode);
-			goto out;
-		}
-	}
-#endif
+	sbi->packed_nid = le64_to_cpu(dsb->packed_nid);
 	sbi->inos = le64_to_cpu(dsb->inos);
 
 	sbi->build_time = le64_to_cpu(dsb->build_time);
@@ -800,6 +790,16 @@ static int erofs_fc_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	erofs_shrinker_register(sb);
 	/* sb->s_umount is already locked, SB_ACTIVE and SB_BORN are not set */
+#ifdef CONFIG_EROFS_FS_ZIP
+	if (erofs_sb_has_fragments(sbi) && sbi->packed_nid) {
+		sbi->packed_inode = erofs_iget(sb, sbi->packed_nid);
+		if (IS_ERR(sbi->packed_inode)) {
+			err = PTR_ERR(sbi->packed_inode);
+			sbi->packed_inode = NULL;
+			return err;
+		}
+	}
+#endif
 	err = erofs_init_managed_cache(sb);
 	if (err)
 		return err;
-- 
2.39.2



