Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8980413B79F;
	Tue, 27 Feb 2024 13:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040807; cv=none; b=aborTJIT0SwkifhV/vtrOtmBHxrazdtJOzRl1pP9eI1zPGpX9olFJI1xtBuDPY2UW1p2TqCf4/zNIAhLtYxPg3cLsLrfbzn3Mwv6BRS88IjZDcRFOpF8F86SFbFJ2/BFvqs7HuGcSiAstxDVx5nKmY6czow3aEofOU/nCuF0euQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040807; c=relaxed/simple;
	bh=ZyDABXNks4nm3xrs8SRB7Jnq+lGDi6AVy1oYTxxweIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPE3BH47vVv53SZxSEgocRgT/NFk60YCYy6o1t162jFLpJrQAPaKwqxxyU/UL0AG9kzjLSF213bthzJf9YuFog0a7fxKktWL4CdKzKg7eWOcmGC67AnsZyYAm8sMRzdrjBUeH61dZZYAhecDy63TSqrEwjTVim4myv6/LnIw1/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BB/yibyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BB/yibyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18561C433F1;
	Tue, 27 Feb 2024 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040807;
	bh=ZyDABXNks4nm3xrs8SRB7Jnq+lGDi6AVy1oYTxxweIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB/yibyHhlkcfR/5pLCzg3hyrbU91tycIceKjDBpIb7GjjRU5Ao1NCLRk0DZYsr0r
	 LK9FnClxTkFXbry1mjRZYzeTAF0QNaVp08vGb6o7mcbv1mZtm/sn/piDhjkGuD+aAc
	 Zzp7Vqz2HcEKoxGxYOGY+6ru3MuOw2DQrfcUYozc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 088/334] fs/ntfs3: ntfs3_forced_shutdown use int instead of bool
Date: Tue, 27 Feb 2024 14:19:06 +0100
Message-ID: <20240227131633.361333523@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 97ec56d390a3a0077b36cb38627f671c72dddce6 ]

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c  | 3 ++-
 fs/ntfs3/ntfs_fs.h | 6 +++---
 fs/ntfs3/super.c   | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index fbfe21dbb4259..350461d8cece5 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -853,7 +853,8 @@ void ntfs_update_mftmirr(struct ntfs_sb_info *sbi, int wait)
 	/*
 	 * sb can be NULL here. In this case sbi->flags should be 0 too.
 	 */
-	if (!sb || !(sbi->flags & NTFS_FLAGS_MFTMIRR))
+	if (!sb || !(sbi->flags & NTFS_FLAGS_MFTMIRR) ||
+	    unlikely(ntfs3_forced_shutdown(sb)))
 		return;
 
 	blocksize = sb->s_blocksize;
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 7ce61fb89216a..3fc027ce6e4d9 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -62,7 +62,7 @@ enum utf16_endian;
 /* sbi->flags */
 #define NTFS_FLAGS_NODISCARD		0x00000001
 /* ntfs in shutdown state. */
-#define NTFS_FLAGS_SHUTDOWN		0x00000002
+#define NTFS_FLAGS_SHUTDOWN_BIT		0x00000002  /* == 4*/
 /* Set when LogFile is replaying. */
 #define NTFS_FLAGS_LOG_REPLAYING	0x00000008
 /* Set when we changed first MFT's which copy must be updated in $MftMirr. */
@@ -1001,9 +1001,9 @@ static inline struct ntfs_sb_info *ntfs_sb(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
-static inline bool ntfs3_forced_shutdown(struct super_block *sb)
+static inline int ntfs3_forced_shutdown(struct super_block *sb)
 {
-	return test_bit(NTFS_FLAGS_SHUTDOWN, &ntfs_sb(sb)->flags);
+	return test_bit(NTFS_FLAGS_SHUTDOWN_BIT, &ntfs_sb(sb)->flags);
 }
 
 /*
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index af8521a6ed954..65ef4b57411f0 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -719,7 +719,7 @@ static int ntfs_show_options(struct seq_file *m, struct dentry *root)
  */
 static void ntfs_shutdown(struct super_block *sb)
 {
-	set_bit(NTFS_FLAGS_SHUTDOWN, &ntfs_sb(sb)->flags);
+	set_bit(NTFS_FLAGS_SHUTDOWN_BIT, &ntfs_sb(sb)->flags);
 }
 
 /*
-- 
2.43.0



