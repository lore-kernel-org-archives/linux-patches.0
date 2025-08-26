Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2562F0671;
	Tue, 26 Aug 2025 13:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215998; cv=none; b=RisqPkRMtjDZX60p+5t2WGBPYzpMN8mqRBb9I+lF0/nQhfv4bUFh55o8ygt3LtDMfSFv9uPKjUMM0wMZMaphG/gLrJbBLMIkx3irHWfmpI1cb+41J1rbl782Lv8o9ikz9chficFI//4K+Zf9/IveHIIy6CcWVxZ4y8W3kD9Qk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215998; c=relaxed/simple;
	bh=/sp1+kAdxVk576aATu0PNy9cNdpcIlDsTdJ9nDkhqeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EaKf42tK/w3+du6TTtOZ5fWgg5ZvQUPeI0Xp1RAHzcxKQKvBZ+h8u7hFdJCHhI7+Ixanv0QaJHph+Dah40YsspQ1l05L8M8RUu2eMJdDKIFuBQtiLgmLgA7BvgYPaqERxylWFwZvWTy92/snVz++cCX+iSXpFcSjQTzu78cl+W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SQV0AHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SQV0AHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF10C4CEF1;
	Tue, 26 Aug 2025 13:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215998;
	bh=/sp1+kAdxVk576aATu0PNy9cNdpcIlDsTdJ9nDkhqeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SQV0AHRb3/4mWrbAovevGBQftYlmKDXDpW1/WJe4QjrL1HXKd1HX5knuAW9/lOLs
	 lXgyse7OERaIn3D5MEg/Ti7xS7/wk4sJMYWkdMPHJtlxf/RekqLuVOdbgc/zMknC0S
	 M4S45heZ081eSpvOUkGF/nJWchW328WCz/+vO4ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 228/644] NFSv4.2: another fix for listxattr
Date: Tue, 26 Aug 2025 13:05:19 +0200
Message-ID: <20250826110952.066195598@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9d4e4146efef..528e904f5475 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10528,7 +10528,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3, error4;
+	ssize_t error, error2, error3, error4 = 0;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10556,9 +10556,11 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



