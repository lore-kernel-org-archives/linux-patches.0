Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8176913B79B;
	Tue, 18 Jun 2024 12:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715313; cv=none; b=oOG033yMxRh2T2XmL8LKSWC62kXTEpHrD5YRxFLCAf22JZuBhzaKwajMp0PDrN57BZTPrvVPLVarU0NJgwL3EGop3ZVmtwr9rqTlLoEt+yth/EQK1yGOxTcKc5NieitQ5li179r6tuQXTD05v0Ur4Zic8oa4Oo4Hdo40Qe0DFFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715313; c=relaxed/simple;
	bh=UUT0ZsgBdAP36OL2JCE182a9cMW/Z59Jnsy7qwOWSpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEjGFtIKZEn8pGxJRYVDbRL7Kvgr9UxQKbxUMqt4LQDj8a0SVwGFp+ymgPMxMo7aYd+X449P+3/jmHsEOa1StLDutgiB0DvISSmMGgn59TplrfbLNL9ull+1ESB/yPZHoRoSfHV2wf6aEflHh9TZaroNibeV9EwJQSQ6yf1x4o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rWFBv3eM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rWFBv3eM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BDCC3277B;
	Tue, 18 Jun 2024 12:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715313;
	bh=UUT0ZsgBdAP36OL2JCE182a9cMW/Z59Jnsy7qwOWSpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rWFBv3eMuZGs4UZ1Zj1yLrA/zk1tKYIqh1YGyJCGwJZ28deJjMFMkSXmiHWXH2HhA
	 XZWj3HbRj5RjjwipSg9mc3u6YCeHNYy1xj/U2mtHbTab7PrwMl8d0sbxA9p0ar8frc
	 PHA1avTGx+OM8c1GGehIKsNENwLAauK4oZlfuOCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 266/770] NFS: fix nfs_fetch_iversion()
Date: Tue, 18 Jun 2024 14:31:59 +0200
Message-ID: <20240618123417.539850078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b876d708316bf9b6b9678eb2beb289b93cfe6369 ]

The change attribute is always set by all NFS client versions so get rid
of the open-coded version.

Fixes: 3cc55f4434b4 ("nfs: use change attribute for NFS re-exports")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/export.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/nfs/export.c b/fs/nfs/export.c
index f2b34cfe286c2..b347e3ce0cc8e 100644
--- a/fs/nfs/export.c
+++ b/fs/nfs/export.c
@@ -171,17 +171,10 @@ static u64 nfs_fetch_iversion(struct inode *inode)
 {
 	struct nfs_server *server = NFS_SERVER(inode);
 
-	/* Is this the right call?: */
-	nfs_revalidate_inode(server, inode);
-	/*
-	 * Also, note we're ignoring any returned error.  That seems to be
-	 * the practice for cache consistency information elsewhere in
-	 * the server, but I'm not sure why.
-	 */
-	if (server->nfs_client->rpc_ops->version >= 4)
-		return inode_peek_iversion_raw(inode);
-	else
-		return time_to_chattr(&inode->i_ctime);
+	if (nfs_check_cache_invalid(inode, NFS_INO_INVALID_CHANGE |
+						   NFS_INO_REVAL_PAGECACHE))
+		__nfs_revalidate_inode(server, inode);
+	return inode_peek_iversion_raw(inode);
 }
 
 const struct export_operations nfs_export_ops = {
-- 
2.43.0



