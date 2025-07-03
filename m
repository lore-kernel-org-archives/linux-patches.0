Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA5C13A258;
	Thu,  3 Jul 2025 14:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751553926; cv=none; b=r3TctXfxWpbZf42w7rxWAAKQXa6xfF/CWwDcLG6tVuxbo4j+cwq8YP+6WXOCLKHQxfeZX96/zW58RMrqpQOd7EF+sXxEw19VZWwluvoV/8Mez4U3Qe1+4NG0kLZf857rqjw2TaVFm26ZiMdY5R18TQFV221PQ0TOx8pjYZLE2TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751553926; c=relaxed/simple;
	bh=mCuvNauRXR6Xzu5a4QX+F/t7XHFXVn59wOYRXWnG9gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZBXqKQ/oxdrtj8pWrQo4uAxfpuImDtLvVJM4+FkQZLra4HQa1CTjJSXsYPBO3LYfR59U/DtCd8iYHaNFtUlduEYzHmHztoeVUa8SOWgOQ3APiWNvkMAE504kWOkq/G9Ehc56VnBE5YHlta1De6kgpY2IK4uujg0qS1pfhwGvrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V84rF5GC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V84rF5GC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8C9C4CEE3;
	Thu,  3 Jul 2025 14:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751553926;
	bh=mCuvNauRXR6Xzu5a4QX+F/t7XHFXVn59wOYRXWnG9gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V84rF5GCppEixf0OTDQUETkS0vWODdvWe7/+doHbz9XbHCDndpaLB/lrMpREuX/CF
	 cUqTekgdZmGQ8di15XFEM78AZmQx9/JILPt8bWf2fCXB09nbqTAwgVC8Q4VzJYtTGj
	 or+E6C+kS7IsjOkPhbUlI/oaiFKSbaZ+JdP47riw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/218] NFSv4.2: fix listxattr to return selinux security label
Date: Thu,  3 Jul 2025 16:39:13 +0200
Message-ID: <20250703143956.173967545@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 57d49e874f51f..9832e27b5d29b 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10814,7 +10814,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3;
+	ssize_t error, error2, error3, error4;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10837,8 +10837,16 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



