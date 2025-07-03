Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A819CC3D;
	Thu,  3 Jul 2025 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555431; cv=none; b=CZZc4msuA5zabx/ciPlF6K9BlHDt7HPA6De16WcX6qumdmR8hcp43iEUU6wgqhBWIcxAtGw6A4anQyJrLaArFyvuEpjGGkk/Aq8yF920oZ7LU68kbpFMTdR3/B8xDF8FJ0Ax08Ldl8sHKi5tRv3xJ8SfJyUxXXZy0Rv7Cu3wATk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555431; c=relaxed/simple;
	bh=dNLyaHTZGhXEfaaVZaIo64u3zTPncf5Fj3rSghxlAHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoSVL65/iZShWnr94uYgkTPGpD42vTKtSDDZPOQcQXTJDDt7Q6VDxlG6YEY80tdEw9DPaAtx4MmVow+5jLeexTNEDok5H1DSO/zuoGP2kBPzvB22ttQcSdPjpo6IjAMpLLM0/O0/4Qb+svspGCW+JvudB4GtiXzSC4weUiNdXGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsPPnduQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsPPnduQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C42C4CEEE;
	Thu,  3 Jul 2025 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555431;
	bh=dNLyaHTZGhXEfaaVZaIo64u3zTPncf5Fj3rSghxlAHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsPPnduQcaKludbavBxByYe+l6flTm1+rQzJZhLu4kaahjIOPHuYTF5N5Z3+LPF/a
	 RnkW2SxegYSoVhvUUGMrqgA1U9iaMJQcBhPmTwoIDHKp3N20cqqn0Bbzsb60FxvBaZ
	 H8LMb7ilbkqkCwGEMFHpJEEJS2hXjY5MJXWWIYrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/139] NFSv4: xattr handlers should check for absent nfs filehandles
Date: Thu,  3 Jul 2025 16:41:15 +0200
Message-ID: <20250703143941.657406893@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit 6e9a2f8dbe93c8004c2af2c0158888628b7ca034 ]

The nfs inodes for referral anchors that have not yet been followed have
their filehandles zeroed out.

Attempting to call getxattr() on one of these will cause the nfs client
to send a GETATTR to the nfs server with the preceding PUTFH sans
filehandle.  The server will reply NFS4ERR_NOFILEHANDLE, leading to -EIO
being returned to the application.

For example:

$ strace -e trace=getxattr getfattr -n system.nfs4_acl /mnt/t/ref
getxattr("/mnt/t/ref", "system.nfs4_acl", NULL, 0) = -1 EIO (Input/output error)
/mnt/t/ref: system.nfs4_acl: Input/output error
+++ exited with 1 +++

Have the xattr handlers return -ENODATA instead.

Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 97a009e007f95..3085a2faab2d3 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -6059,6 +6059,8 @@ static ssize_t nfs4_proc_get_acl(struct inode *inode, void *buf, size_t buflen,
 	struct nfs_server *server = NFS_SERVER(inode);
 	int ret;
 
+	if (unlikely(NFS_FH(inode)->size == 0))
+		return -ENODATA;
 	if (!nfs4_server_supports_acls(server, type))
 		return -EOPNOTSUPP;
 	ret = nfs_revalidate_inode(inode, NFS_INO_INVALID_CHANGE);
@@ -6133,6 +6135,9 @@ static int nfs4_proc_set_acl(struct inode *inode, const void *buf,
 {
 	struct nfs4_exception exception = { };
 	int err;
+
+	if (unlikely(NFS_FH(inode)->size == 0))
+		return -ENODATA;
 	do {
 		err = __nfs4_proc_set_acl(inode, buf, buflen, type);
 		trace_nfs4_set_acl(inode, err);
-- 
2.39.5



