Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B415D1D078B;
	Wed,  2 Oct 2024 14:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880325; cv=none; b=pyTLGCjY2jEM/56MofKnKZkEX5iA7hJwcX4hSXVYlErsd0Yqt8IiaMJeYjn3CX9wukOQw1rPbRbum/QDLgxmGtpkUkH6IFyA1ozYC+7EJl4jqbGRLuiYdnJImzpF3aUt4LzsB+OO6mXT7NC1/tPpYvJBO9aJJH4MK3KFAq5ziRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880325; c=relaxed/simple;
	bh=nYRiTQYeD6dtM2qducOEIjnJaf5RbnK7LhPz2wRIfC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGtjPL/Dbl3OXn3vH4wPq3u4Vqm1ssodrbgx5ng8Zhu0M3eCWH8m/jIvSWQrLjzihaL7tnhvmKfT9K7VFW+J37dcYERusYFe5eDIJN6xVARz9PmrgW1zsG/jMPsKiU6ZDFw3m10m1uvqtW2u5hGRQujSPK8pkzWz+NLNqkxxOCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loytPz1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loytPz1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B321C4CEC2;
	Wed,  2 Oct 2024 14:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880325;
	bh=nYRiTQYeD6dtM2qducOEIjnJaf5RbnK7LhPz2wRIfC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loytPz1w9MzcPljk3j16uBKxn054kY9DYPCVc3W9EVczrkW5FW7Jm0buBdrotbdEg
	 +Q+IwrvSaL1ir9uWfChTKN9lHRQq/B/UC6sFAhtXD98jV6gUZG6HHv+hVQ8xj7U/an
	 A1pvdjtrPy5htykiu4R5agb+0RrI1xI0vZNcuw6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 420/538] fs: Create a generic is_dot_dotdot() utility
Date: Wed,  2 Oct 2024 15:00:59 +0200
Message-ID: <20241002125809.012870214@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit 42c3732fa8073717dd7d924472f1c0bc5b452fdc upstream.

De-duplicate the same functionality in several places by hoisting
the is_dot_dotdot() utility function into linux/fs.h.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/crypto/fname.c    |    8 +-------
 fs/ecryptfs/crypto.c |   10 ----------
 fs/f2fs/f2fs.h       |   11 -----------
 fs/namei.c           |    6 ++----
 include/linux/fs.h   |   11 +++++++++++
 5 files changed, 14 insertions(+), 32 deletions(-)

--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -74,13 +74,7 @@ struct fscrypt_nokey_name {
 
 static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 {
-	if (str->len == 1 && str->name[0] == '.')
-		return true;
-
-	if (str->len == 2 && str->name[0] == '.' && str->name[1] == '.')
-		return true;
-
-	return false;
+	return is_dot_dotdot(str->name, str->len);
 }
 
 /**
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1949,16 +1949,6 @@ out:
 	return rc;
 }
 
-static bool is_dot_dotdot(const char *name, size_t name_size)
-{
-	if (name_size == 1 && name[0] == '.')
-		return true;
-	else if (name_size == 2 && name[0] == '.' && name[1] == '.')
-		return true;
-
-	return false;
-}
-
 /**
  * ecryptfs_decode_and_decrypt_filename - converts the encoded cipher text name to decoded plaintext
  * @plaintext_name: The plaintext name
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -3370,17 +3370,6 @@ static inline bool f2fs_cp_error(struct
 	return is_set_ckpt_flags(sbi, CP_ERROR_FLAG);
 }
 
-static inline bool is_dot_dotdot(const u8 *name, size_t len)
-{
-	if (len == 1 && name[0] == '.')
-		return true;
-
-	if (len == 2 && name[0] == '.' && name[1] == '.')
-		return true;
-
-	return false;
-}
-
 static inline void *f2fs_kmalloc(struct f2fs_sb_info *sbi,
 					size_t size, gfp_t flags)
 {
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2667,10 +2667,8 @@ static int lookup_one_common(struct mnt_
 	if (!len)
 		return -EACCES;
 
-	if (unlikely(name[0] == '.')) {
-		if (len < 2 || (len == 2 && name[1] == '.'))
-			return -EACCES;
-	}
+	if (is_dot_dotdot(name, len))
+		return -EACCES;
 
 	while (len--) {
 		unsigned int c = *(const unsigned char *)name++;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2844,6 +2844,17 @@ extern bool path_is_under(const struct p
 
 extern char *file_path(struct file *, char *, int);
 
+/**
+ * is_dot_dotdot - returns true only if @name is "." or ".."
+ * @name: file name to check
+ * @len: length of file name, in bytes
+ */
+static inline bool is_dot_dotdot(const char *name, size_t len)
+{
+	return len && unlikely(name[0] == '.') &&
+		(len == 1 || (len == 2 && name[1] == '.'));
+}
+
 #include <linux/err.h>
 
 /* needed for stackable file system support */


