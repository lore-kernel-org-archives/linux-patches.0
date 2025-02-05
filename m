Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B5218FC9D;
	Wed,  5 Feb 2025 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768535; cv=none; b=crVN7n8s3gO6WexIeJCI/7N512H6GlbIGUXYMNnfAN/pF09lS/prpvhQyIeocSU+m4K6/JVLYR3g0V/bR2XmeIoXNCAoH4iXYJaXq5O8w0EOAN9Zzy7Bszk+XCQn0ngL3J+MFvehtAMYWq9DAUVtE3jrTNXZo8pZInAyBiB2whU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768535; c=relaxed/simple;
	bh=ntJTZVX+WBoVL4uWGdHAGItPSGxEudhfW4QVqcmVtnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pD7VV2oHE8bvSyDadfyFSvPQt2QpfS+pNyrHiN9jVfnqcdMKJuGwspYPM7CQnfwAWqDaKliE6clMVhFHodhW5XSwAIbfvGLvkjtEto7FHN1FwJ54hz1uxbTQ/66o9NzcZTP84Gyw1yjd7hInjXdX4aP3JWtEZSixR2CorL6TLcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jc4smkmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jc4smkmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C50C4CED6;
	Wed,  5 Feb 2025 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768535;
	bh=ntJTZVX+WBoVL4uWGdHAGItPSGxEudhfW4QVqcmVtnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jc4smkmvBoWo7EFP5cRQqvO9rM4QLKjB33t0e+OZT/QqTLyxL/ccEwDbejc/93kYF
	 hEBTGlUpEAZ3UX73AYSTeJisYhF7PRd1s1pEk3ld5zEc3cwNzpIw8QHpIpmdT9bcy4
	 LFwBVJ5UEx24naHGHdCPW8RQemv8gmX/jhcyGgNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 554/623] hostfs: fix string handling in __dentry_name()
Date: Wed,  5 Feb 2025 14:44:56 +0100
Message-ID: <20250205134517.412973820@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 60a6002432448bb3f291d80768ae98d62efc9c77 ]

strcpy() should not be used with destination potentially overlapping
the source; what's more, strscpy() in there is pointless - we already
know the amount we want to copy; might as well use memcpy().

Fixes: c278e81b8a02 "hostfs: Remove open coded strcpy()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hostfs/hostfs_kern.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/hostfs/hostfs_kern.c b/fs/hostfs/hostfs_kern.c
index 7e51d2cec64b4..bd6503b731426 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -95,32 +95,17 @@ __uml_setup("hostfs=", hostfs_args,
 static char *__dentry_name(struct dentry *dentry, char *name)
 {
 	char *p = dentry_path_raw(dentry, name, PATH_MAX);
-	char *root;
-	size_t len;
-	struct hostfs_fs_info *fsi;
-
-	fsi = dentry->d_sb->s_fs_info;
-	root = fsi->host_root_path;
-	len = strlen(root);
-	if (IS_ERR(p)) {
-		__putname(name);
-		return NULL;
-	}
-
-	/*
-	 * This function relies on the fact that dentry_path_raw() will place
-	 * the path name at the end of the provided buffer.
-	 */
-	BUG_ON(p + strlen(p) + 1 != name + PATH_MAX);
+	struct hostfs_fs_info *fsi = dentry->d_sb->s_fs_info;
+	char *root = fsi->host_root_path;
+	size_t len = strlen(root);
 
-	strscpy(name, root, PATH_MAX);
-	if (len > p - name) {
+	if (IS_ERR(p) || len > p - name) {
 		__putname(name);
 		return NULL;
 	}
 
-	if (p > name + len)
-		strcpy(name + len, p);
+	memcpy(name, root, len);
+	memmove(name + len, p, name + PATH_MAX - p);
 
 	return name;
 }
-- 
2.39.5



