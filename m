Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7C57DA6A;
	Wed,  5 Feb 2025 14:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766313; cv=none; b=E6sNWh2+KeAnAd5D0YdtGiRe6IVjIeDmCP/O6Dp9YqRQgotImFBARiX1ku5J+j2xm2eon3GNxhvkem4jwPA2s8ulkCX29H1PcgQW+jl1km9AYvGKn/AAE9El8YpAY1eJvyK+HQcsdSBURzXKice6lU9MJge66sMoBj63oMVo7C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766313; c=relaxed/simple;
	bh=FarcMaAoDZQrHlOx4EpChfiic6vPLgdZao089XwGkOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZntCKJGN1K3RTkG9mUhbRz5RspY6h72lSK4j/H1aOkYRVpNCnb5vmbCalTqnL+48M5Yfb2AE9Cz4VsKiB8afmAByBUnI6mWY5f4OBlQvZsY1lQd00LFf37Rd4oO66Z5ow1X82VLlTSCTtDn8pLvMg5IBZiXs+gvyhdRERlohic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9H0NHo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9H0NHo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFF1C4CEDD;
	Wed,  5 Feb 2025 14:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766313;
	bh=FarcMaAoDZQrHlOx4EpChfiic6vPLgdZao089XwGkOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9H0NHo2vRO/s9Q/+jtMnZGNnGH4mCO5lrbPboys4TudOl9n9uzDmCb+FDtitJhsC
	 6Gw4sFC//c76oMADOo5sK3GpK9a34E51zJIJtKcpX86PqB0tmQeOU/SKnm2KVGiCjs
	 Dvfs4/ahRrzqFILZ2VjDwL3shAn89vKgOl30XQ8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 351/393] hostfs: fix string handling in __dentry_name()
Date: Wed,  5 Feb 2025 14:44:30 +0100
Message-ID: <20250205134433.736107914@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1fb8eacb9817f..1efbcfa1f1f88 100644
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -93,32 +93,17 @@ __uml_setup("hostfs=", hostfs_args,
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



