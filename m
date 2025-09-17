Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A16C2F7ABF;
	Wed, 17 Sep 2025 12:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113202; cv=none; b=Y2PZ9siWx3z+axpe1VHvXxyBiEHeVYcXkyE9Nxzkz4xaDx/DdrGLEPNGNHKbVd7ItUin7rJL1fBHcR2sXjk1vP5wJZOa1e0Xu9DQjQZWFRCDrsD2foB2G3wFFz1mJI6P+n1L1fHMEvGI8jaecfG8o/tELaOunxkBb3PDzsD1hnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113202; c=relaxed/simple;
	bh=vuVj1RaMoAUBN42CNub/Amzklms5rgaz0XmNUEM5p+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rDV+1MSY65xmDuJR6oUuAT24HWLcyiguZCPO1sCDLpXzXZDi1tn735CkGM42YWzr2hq08vf1N8Jsw7TU0tEvf0c5Jt/jyvlT14fDBiqk9hJ2DLXrmkZXh90cB+YeTfmE5n3MrnKlWeXb20/j/v4lFj05xpDZ+1h7eP+RCY7ciZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGSSSyZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGSSSyZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4219AC4CEF0;
	Wed, 17 Sep 2025 12:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113201;
	bh=vuVj1RaMoAUBN42CNub/Amzklms5rgaz0XmNUEM5p+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGSSSyZX2i82U2h6HBoT43HFuuMA9RIyNN9DFOfX4MaPAmB924TcyOvjvgXgVSEjv
	 Xfqdh1iynpoJrf4B7S7OT85gc/mP/2O47CvNC0tECJRkJWW/FsxfTU3AwNKlaZLdtB
	 vPxZBtJRleVKJ79dYHyhbLsuUBmYgonmvfLt6mlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Theodore Tso <tytso@mit.edu>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/140] ext4: introduce linear search for dentries
Date: Wed, 17 Sep 2025 14:33:06 +0200
Message-ID: <20250917123344.662222544@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 9e28059d56649a7212d5b3f8751ec021154ba3dd ]

This patch addresses an issue where some files in case-insensitive
directories become inaccessible due to changes in how the kernel
function, utf8_casefold(), generates case-folded strings from the
commit 5c26d2f1d3f5 ("unicode: Don't special case ignorable code
points").

There are good reasons why this change should be made; it's actually
quite stupid that Unicode seems to think that the characters ❤ and ❤️
should be casefolded.  Unfortimately because of the backwards
compatibility issue, this commit was reverted in 231825b2e1ff.

This problem is addressed by instituting a brute-force linear fallback
if a lookup fails on case-folded directory, which does result in a
performance hit when looking up files affected by the changing how
thekernel treats ignorable Uniode characters, or when attempting to
look up non-existent file names.  So this fallback can be disabled by
setting an encoding flag if in the future, the system administrator or
the manufacturer of a mobile handset or tablet can be sure that there
was no opportunity for a kernel to insert file names with incompatible
encodings.

Fixes: 5c26d2f1d3f5 ("unicode: Don't special case ignorable code points")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c    | 14 ++++++++++----
 include/linux/fs.h | 10 +++++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 286f8fcb74cc9..29c7c0b8295fb 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1462,7 +1462,8 @@ static bool ext4_match(struct inode *parent,
 		 * sure cf_name was properly initialized before
 		 * considering the calculated hash.
 		 */
-		if (IS_ENCRYPTED(parent) && fname->cf_name.name &&
+		if (sb_no_casefold_compat_fallback(parent->i_sb) &&
+		    IS_ENCRYPTED(parent) && fname->cf_name.name &&
 		    (fname->hinfo.hash != EXT4_DIRENT_HASH(de) ||
 		     fname->hinfo.minor_hash != EXT4_DIRENT_MINOR_HASH(de)))
 			return false;
@@ -1595,10 +1596,15 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
 		 * return.  Otherwise, fall back to doing a search the
 		 * old fashioned way.
 		 */
-		if (!IS_ERR(ret) || PTR_ERR(ret) != ERR_BAD_DX_DIR)
+		if (IS_ERR(ret) && PTR_ERR(ret) == ERR_BAD_DX_DIR)
+			dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
+				       "falling back\n"));
+		else if (!sb_no_casefold_compat_fallback(dir->i_sb) &&
+			 *res_dir == NULL && IS_CASEFOLDED(dir))
+			dxtrace(printk(KERN_DEBUG "ext4_find_entry: casefold "
+				       "failed, falling back\n"));
+		else
 			goto cleanup_and_exit;
-		dxtrace(printk(KERN_DEBUG "ext4_find_entry: dx failed, "
-			       "falling back\n"));
 		ret = NULL;
 	}
 	nblocks = dir->i_size >> EXT4_BLOCK_SIZE_BITS(sb);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6de8d93838d1..37a01c9d96583 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1197,11 +1197,19 @@ extern int send_sigurg(struct file *file);
 #define SB_NOUSER       BIT(31)
 
 /* These flags relate to encoding and casefolding */
-#define SB_ENC_STRICT_MODE_FL	(1 << 0)
+#define SB_ENC_STRICT_MODE_FL		(1 << 0)
+#define SB_ENC_NO_COMPAT_FALLBACK_FL	(1 << 1)
 
 #define sb_has_strict_encoding(sb) \
 	(sb->s_encoding_flags & SB_ENC_STRICT_MODE_FL)
 
+#if IS_ENABLED(CONFIG_UNICODE)
+#define sb_no_casefold_compat_fallback(sb) \
+	(sb->s_encoding_flags & SB_ENC_NO_COMPAT_FALLBACK_FL)
+#else
+#define sb_no_casefold_compat_fallback(sb) (1)
+#endif
+
 /*
  *	Umount options
  */
-- 
2.51.0



