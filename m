Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A78E352074;
	Tue, 26 Aug 2025 14:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217593; cv=none; b=mhTYLvebSYko9kvYsK4/gFx3gvc24tdEPCrJA3G9b4V1HbF2L3m2GwPezKUQ8TdUoWxHaCgSMtOQQcnKQMe0mZOoggFsL+mbwY2HcBDmtbGmh+3Jt/qwlsaVvs4lVdBgOIi42dWx9aieP0u9T1M6VbJ7Nr20KL+S/SLqlnBkXGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217593; c=relaxed/simple;
	bh=TyanilUoJldmfHhOhg33Tk5SkKrpKU/0O1AoDP2FycE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifEVj6w34jQL5UTjvsqrmdkdzInzgLtXVxykU1dboXArRbaAQgxJYuHNyixdMzEaFue52oaQsDvH+L2vP+Bx0tPCUHmq25D+8f44Xm+eJJg23EFoPh19icF4aMlgRu2T59kUkzTYGLvP6xDm1SQ9IBfCSyKH45OwqiNLzDjhECE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UH6QVcKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UH6QVcKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A02DC4CEF1;
	Tue, 26 Aug 2025 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217593;
	bh=TyanilUoJldmfHhOhg33Tk5SkKrpKU/0O1AoDP2FycE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UH6QVcKeiwpHifMaqOFCVHdYtX6OeuKCcFxrmjxhgFuc2HNq4N/ojn383/i1f758R
	 Kkpwl/LC7/5MHXNaMZvigKmeRR6AxUl6DtEldzIw3oT34iyQmmulvxf8pJKLbQtOsV
	 B4nIJ7M0uTbKpb52qJrZNzS7M27oBldPuuIjSlC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/523] NFSv4.2: another fix for listxattr
Date: Tue, 26 Aug 2025 13:06:20 +0200
Message-ID: <20250826110928.660810696@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit 9acb237deff7667b0f6b10fe6b1b70c4429ea049 ]

Currently, when the server supports NFS4.1 security labels then
security.selinux label in included twice. Instead, only add it
when the server doesn't possess security label support.

Fixes: 243fea134633 ("NFSv4.2: fix listxattr to return selinux security label")
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Link: https://lore.kernel.org/r/20250722205641.79394-1-okorniev@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 77cc1c4219e1..97b5ff9c5c3e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10378,7 +10378,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3, error4;
+	ssize_t error, error2, error3, error4 = 0;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10406,9 +10406,11 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 		left -= error3;
 	}
 
-	error4 = security_inode_listsecurity(d_inode(dentry), list, left);
-	if (error4 < 0)
-		return error4;
+	if (!nfs_server_capable(d_inode(dentry), NFS_CAP_SECURITY_LABEL)) {
+		error4 = security_inode_listsecurity(d_inode(dentry), list, left);
+		if (error4 < 0)
+			return error4;
+	}
 
 	error += error2 + error3 + error4;
 	if (size && error > size)
-- 
2.39.5



