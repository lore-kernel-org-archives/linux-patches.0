Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65202199385;
	Tue, 12 Aug 2025 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021701; cv=none; b=HAlOzOh3rH/tr8/jHA2D5L+TIaQiGAlU07PuKuAdkPbfGrD3KOU2EwrmsV8ug9uYvR/5tnLOGB/ltUufozOj5LxxNqdEJCukq/DmHHVJbBAdPWkoOAKGI2Cz60tbQMLtkIF0l6kZEjVC02IPK7tGiXISfY33ZvnINIEWjlMAQw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021701; c=relaxed/simple;
	bh=A4Rl4pFCZi6tgcOkX1Llq/Oc/3uQ8x9X1yxftfRDi8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpD9hQQbGlgNpFiXgml7XZvrvKYu5fuIXuRWzq/FqTmgw/crjaCDp4ALmPLPIIzXrygIcpCmYvaYO4D8EsW6p8bAzTTDz/dFYeZOJ6C/PS1LCaYcoiy8bXBpXrGHT3AS7W4Vtl/oIx93lyMzhYBtg46BMSdoSvXOwJGCBXqZN1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU9iBjEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU9iBjEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE53C4CEF0;
	Tue, 12 Aug 2025 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021700;
	bh=A4Rl4pFCZi6tgcOkX1Llq/Oc/3uQ8x9X1yxftfRDi8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iU9iBjEeir4y96cqzGiohHG9cwvIoh3Xhefo+ZU6lMmwHmM0N+HQ69VvF89Brig9B
	 u+9f4zifnx8pV7mxTQAT05P/0mi6qhp2zJs7AN3WtlPQxief8abZZ5gZlyOx2alzWp
	 rVESBtUTSg6SmZ8cucN5r+Cz2IA1Q3Z+QW9DKLMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/262] NFSv4.2: another fix for listxattr
Date: Tue, 12 Aug 2025 19:29:48 +0200
Message-ID: <20250812173001.677547972@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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
index 3085a2faab2d..89d88d37e0cc 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10630,7 +10630,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3, error4;
+	ssize_t error, error2, error3, error4 = 0;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10658,9 +10658,11 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



