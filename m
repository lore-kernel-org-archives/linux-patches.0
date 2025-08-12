Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A072DE1E2;
	Tue, 12 Aug 2025 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021241; cv=none; b=DGFpchqw/cOFg0FfdHL5UA7+6jNTyX+A1FlQ7nmfUUBU+dD5AL3nVmmUoRDo2b+IWKxPUvD6TlKW41+OmoqbYkZycfjJeFKRozLGHzvr9g9Mczx4sngO0h2DhGbwx+IP6TByQTyS4wN1Wv2L/0tR37J7WVaRYmwDxe2i+vcZF84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021241; c=relaxed/simple;
	bh=G9lD97yEr66FsWsBq11njsZR7HGLdtuSWUFhSLUxppQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B61Gct19tnhPoiNnXKW6UXnRPXZdKxPKIeaxX5k3GhICXcMSeGGwSbB7KjVVoMn2Sa80BPouY01i0FxQa8tjyO4+kibi4rZuEkdyKsKy84KGl/gA/buRV+18CCGJLRibynOGSQR5zREb8NVOqy/oup/frRTVf92GzDMj81aQqKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IpmMIJO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IpmMIJO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5880DC4CEF0;
	Tue, 12 Aug 2025 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021240;
	bh=G9lD97yEr66FsWsBq11njsZR7HGLdtuSWUFhSLUxppQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IpmMIJO8+QJJT0rQd5iyFZ6tRbshJ8EBDpJzHksqm+z0L8LMjXj8sfm9mzbdSnY+g
	 pT9EY2NFRqUAEkfOFV6FCXn534Hw20lRZqn1pkFNfFs9qkkOB3tI3ftnn2ypO8WvlP
	 wWa7MwWuRj4+ceKSGibNEeBeHS6gpR/CSlBkpUnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/253] NFSv4.2: another fix for listxattr
Date: Tue, 12 Aug 2025 19:30:04 +0200
Message-ID: <20250812172958.029736232@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29f8a2df2c11..4abac68a4f0f 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10635,7 +10635,7 @@ const struct nfs4_minor_version_ops *nfs_v4_minor_ops[] = {
 
 static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 {
-	ssize_t error, error2, error3, error4;
+	ssize_t error, error2, error3, error4 = 0;
 	size_t left = size;
 
 	error = generic_listxattr(dentry, list, left);
@@ -10663,9 +10663,11 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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



