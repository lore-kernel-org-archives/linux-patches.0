Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 796958F5E;
	Tue,  8 Jul 2025 16:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993769; cv=none; b=WcRkHh4G2w1hBwG+9EhRl0/W42y7J8lrgqma1fTCIOaAZjyNvOvYLJsxibPaMuXWIIyBx04w2EPMIu6tOJrskH0wPYGn0H7XOVRBhEkcTnGS+EQlzYvH/v0VZUA7fMTOKcXNH4smmlC1zBd7XYqqIkvxkK6y6Mbv28O4obU/1Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993769; c=relaxed/simple;
	bh=T6azYQkLQfEPoKzQg9smdOE9tu1MN7c4FcF149OcD98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TjXj9WRJJJ2Hja4RoGEiNqXzWsflvtoED+S0YYKE6Kn8hS2OUcb2byxY1ktTXAYq9bM5Ud89ayZxWR7UgkL1Okz4/iMCAw25Osz7vPX8hkw65JcetoTmj65h0lKFyOu9ELkkGBm/jvMh3ukxzJ7AbclxgQ6gWNgh1TfGpjFlkYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPqVQdVg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPqVQdVg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0293CC4CEED;
	Tue,  8 Jul 2025 16:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993769;
	bh=T6azYQkLQfEPoKzQg9smdOE9tu1MN7c4FcF149OcD98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPqVQdVgnhU+C/ZZZxCXY7Zpuz9CFv+ZPKIrBmk91rXAs3X1AWT15UKgb3gV/DK2G
	 SFJTEQDerzF698qI/oPiuCADeuXt5bj6rOXC5YcVpsjzrCKVYO05O/nNTjNVaaBKof
	 eYISP825IBRVmNIZz5RnMIevAf3xKHan6iwnPDiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 003/160] NFSv4.2: fix listxattr to return selinux security label
Date: Tue,  8 Jul 2025 18:20:40 +0200
Message-ID: <20250708162231.601961758@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

[ Upstream commit 243fea134633ba3d64aceb4c16129c59541ea2c6 ]

Currently, when NFS is queried for all the labels present on the
file via a command example "getfattr -d -m . /mnt/testfile", it
does not return the security label. Yet when asked specifically for
the label (getfattr -n security.selinux) it will be returned.
Include the security label when all attributes are queried.

Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index e4b3f25bb8e48..9d4e4146efef0 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10528,7 +10528,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3;
+	ssize_t error, error2, error3, error4;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10551,8 +10551,16 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 	error3 = nfs4_listxattr_nfs4_user(d_inode(dentry), list, left);
 	if (error3 < 0)
 		return error3;
+	if (list) {
+		list += error3;
+		left -= error3;
+	}
+
+	error4 = security_inode_listsecurity(d_inode(dentry), list, left);
+	if (error4 < 0)
+		return error4;
 
-	error += error2 + error3;
+	error += error2 + error3 + error4;
 	if (size && error > size)
 		return -ERANGE;
 	return error;
-- 
2.39.5



