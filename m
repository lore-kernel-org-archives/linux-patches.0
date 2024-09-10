Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DBB18CC11;
	Tue, 10 Sep 2024 10:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963269; cv=none; b=ot5yV1jxdbkp1Yziy+yxyGHOI2/5VvCiYXjUk9Li4WKtL+F7Kiia0FY1zFGb1sSPAMbRa7jlsF1DqN96vtvIHRhvZslwtYZSK783oAIv7d4smygUqgkHf+Ik+HebpDcRiJWSkulJwXZMCoU4js3V4fza6zjSlH8iDRO3cLDmZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963269; c=relaxed/simple;
	bh=tHkmUJMmAoUy04VKw/IMvWDnuK/ef1Ddox1TBx/uNjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VStsIVpTlg9CkKpn0Gwe11W2/ZltLRTfDcPUIOPC5Dp3HHWAv+LixrUsZohCaAZqobI05Sp9QPHvSfsKysX0GFXmJc1sK5t0pqCAr05uODwCw8/DIiULnua94EyKDd9Wbtp1THqbn1dKSwPYGiiMNXq2UO69vMOqKO78VMmqa8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BAutv/0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BAutv/0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F86C4CEC3;
	Tue, 10 Sep 2024 10:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963268;
	bh=tHkmUJMmAoUy04VKw/IMvWDnuK/ef1Ddox1TBx/uNjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BAutv/0HIfhOs1HpLF9HpGMeqbpflFK4QSu8xTApiuZSvVc3VJoife0Tbhx/zKb2r
	 k5kGNT8vGBRklFZEyNxFlcek1oMgM7PJmdt3cCg/gsk4ijHkPs++ozZXS6a0f2ApwJ
	 VXanrR/CykLnQ9GSr+rUGxrrfaW5Yob1ev0VdDwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 192/192] fuse: add feature flag for expire-only
Date: Tue, 10 Sep 2024 11:33:36 +0200
Message-ID: <20240910092605.689955946@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 5cadfbd5a11e5495cac217534c5f788168b1afd7 upstream.

Add an init flag idicating whether the FUSE_EXPIRE_ONLY flag of
FUSE_NOTIFY_INVAL_ENTRY is effective.

This is needed for backports of this feature, otherwise the server could
just check the protocol version.

Fixes: 4f8d37020e1f ("fuse: add "expire only" mode to FUSE_NOTIFY_INVAL_ENTRY")
Cc: <stable@vger.kernel.org> # v6.2
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/inode.c           |    3 ++-
 include/uapi/linux/fuse.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1327,7 +1327,8 @@ void fuse_send_init(struct fuse_mount *f
 		FUSE_ABORT_ERROR | FUSE_MAX_PAGES | FUSE_CACHE_SYMLINKS |
 		FUSE_NO_OPENDIR_SUPPORT | FUSE_EXPLICIT_INVAL_DATA |
 		FUSE_HANDLE_KILLPRIV_V2 | FUSE_SETXATTR_EXT | FUSE_INIT_EXT |
-		FUSE_SECURITY_CTX;
+		FUSE_SECURITY_CTX |
+		FUSE_HAS_EXPIRE_ONLY;
 #ifdef CONFIG_FUSE_DAX
 	if (fm->fc->dax)
 		flags |= FUSE_MAP_ALIGNMENT;
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -365,6 +365,7 @@ struct fuse_file_lock {
  * FUSE_SECURITY_CTX:	add security context to create, mkdir, symlink, and
  *			mknod
  * FUSE_HAS_INODE_DAX:  use per inode DAX
+ * FUSE_HAS_EXPIRE_ONLY: kernel supports expiry-only entry invalidation
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -401,6 +402,7 @@ struct fuse_file_lock {
 /* bits 32..63 get shifted down 32 bits into the flags2 field */
 #define FUSE_SECURITY_CTX	(1ULL << 32)
 #define FUSE_HAS_INODE_DAX	(1ULL << 33)
+#define FUSE_HAS_EXPIRE_ONLY	(1ULL << 35)
 
 /**
  * CUSE INIT request/reply flags


