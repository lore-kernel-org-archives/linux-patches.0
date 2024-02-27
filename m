Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B01E13B797;
	Tue, 27 Feb 2024 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041821; cv=none; b=hZu/smdiRuaJ5Hp45u9tBxXul6Wlxi33kGivQBkI1MRr7jlluY+GAPGf5w3FFB388oZZyW8qD6dt1eij9A7XkbJT4zKnL0qiEQLs7ZTTxIYdl+QfZgbtZHIBy3Jj3NHeVHDauAndnEjjI+i1ROZiJRT0TwcHR6L8BwzsXgFKfhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041821; c=relaxed/simple;
	bh=A6R2+P+88TO1ESoAZ5UjoT4blw3yazRo81F8AQ/lfig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aab887H8jLJMalb9uOrx5SZKmope+A4JjA7AZjgaOMjMih3wuh9qItNFSJL1kSDqbXj4Ksad5NMjOkunHV5g5NA6UxtUpszrepW0lNH6+YWj6LwTc4nOeLoor3WSYaYA1HXArWddzwREHTH0xm8ap1K2PeZUuL2ede57MgTC25E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl4Hxiw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl4Hxiw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F10C433F1;
	Tue, 27 Feb 2024 13:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041821;
	bh=A6R2+P+88TO1ESoAZ5UjoT4blw3yazRo81F8AQ/lfig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl4Hxiw+Or8s0QPzff0VTRtjXWR7dHqaPWMmNByhvJwU2xS2BSZwcY1WyJXPvlCeh
	 gu9cBPVQAlLrwPgBH8n0cMC0xSRWNxiL9EVv2U4sD899CrIQ9rHySgvxKVOlSl0ru9
	 gBpW4N+6qOPmgPdYgouVBCkVtbXkgXostxsN47oY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/299] fs/ntfs3: ntfs3_forced_shutdown use int instead of bool
Date: Tue, 27 Feb 2024 14:23:12 +0100
Message-ID: <20240227131628.533114172@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 466ee5bd62260..c71a1eca427a3 100644
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
index a313b4ddee16f..378e261e23b04 100644
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



