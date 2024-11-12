Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614F71BD031;
	Tue, 12 Nov 2024 10:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407716; cv=none; b=JVL7zwGP+Ae39Aiu1WfZ3jtz8UHAVmOHIBzNdUp3NlVd8Vtj2ZeZuP0VhQBb247hLfuC22nP4pVgnfYTQsVg/fEMAHu+ER778HOBrnkRBBfdIWbrWtyZ//FloYRBf/nXlYT2W3470kxeqbUEKYzX3TcjfTjb4IYc0Dq7a50CpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407716; c=relaxed/simple;
	bh=/3CFN+gpkjFPllCJmcYm3Oa39TjLS2RcFpEOnhps6vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxLlxZILJNBi+ubI8i1+v5Y7fCM16k70gqQRX0FMhs2/a/rkiEf29e87vvGKLrHmBCozZFIIeoz+tOwjTcr1kajwtjYYpoHrG4vmk+DPIWEtjElgjQlPSYQuX/LdmnL8NpxzVCwMD5HhIjgWWS3iH1mq/QW2lGieORR25ikAJok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0kIauE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0kIauE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EA5EC4CECD;
	Tue, 12 Nov 2024 10:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407716;
	bh=/3CFN+gpkjFPllCJmcYm3Oa39TjLS2RcFpEOnhps6vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0kIauE1otXXFcqxeKB+ykhDWhM1YMp1ZvytlkMdMEUgLDIJyfjH4GMR8cFNOcWmH
	 qYSFZbTNs6ptYmLiDl8wew+qfViwquSxbYs5xPpzzMAH36fHJwnJv/4E3Vx2js8DUN
	 O32xjOH4wHHwz3DbxwZeBcYrsJKKAcdpbrUF2MYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/119] nfs: avoid i_lock contention in nfs_clear_invalid_mapping
Date: Tue, 12 Nov 2024 11:20:36 +0100
Message-ID: <20241112101849.790694412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit 867da60d463bb2a3e28c9235c487e56e96cffa00 ]

Multi-threaded buffered reads to the same file exposed significant
inode spinlock contention in nfs_clear_invalid_mapping().

Eliminate this spinlock contention by checking flags without locking,
instead using smp_rmb and smp_load_acquire accordingly, but then take
spinlock and double-check these inode flags.

Also refactor nfs_set_cache_invalid() slightly to use
smp_store_release() to pair with nfs_clear_invalid_mapping()'s
smp_load_acquire().

While this fix is beneficial for all multi-threaded buffered reads
issued by an NFS client, this issue was identified in the context of
surprisingly low LOCALIO performance with 4K multi-threaded buffered
read IO.  This fix dramatically speeds up LOCALIO performance:

before: read: IOPS=1583k, BW=6182MiB/s (6482MB/s)(121GiB/20002msec)
after:  read: IOPS=3046k, BW=11.6GiB/s (12.5GB/s)(232GiB/20001msec)

Fixes: 17dfeb911339 ("NFS: Fix races in nfs_revalidate_mapping")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index ca76b0b51b779..d0fc3e80cd64c 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -206,12 +206,15 @@ void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
 		nfs_fscache_invalidate(inode, 0);
 	flags &= ~NFS_INO_REVAL_FORCED;
 
-	nfsi->cache_validity |= flags;
+	flags |= nfsi->cache_validity;
+	if (inode->i_mapping->nrpages == 0)
+		flags &= ~NFS_INO_INVALID_DATA;
 
-	if (inode->i_mapping->nrpages == 0) {
-		nfsi->cache_validity &= ~NFS_INO_INVALID_DATA;
-		nfs_ooo_clear(nfsi);
-	} else if (nfsi->cache_validity & NFS_INO_INVALID_DATA) {
+	/* pairs with nfs_clear_invalid_mapping()'s smp_load_acquire() */
+	smp_store_release(&nfsi->cache_validity, flags);
+
+	if (inode->i_mapping->nrpages == 0 ||
+	    nfsi->cache_validity & NFS_INO_INVALID_DATA) {
 		nfs_ooo_clear(nfsi);
 	}
 	trace_nfs_set_cache_invalid(inode, 0);
@@ -1340,6 +1343,13 @@ int nfs_clear_invalid_mapping(struct address_space *mapping)
 					 TASK_KILLABLE|TASK_FREEZABLE_UNSAFE);
 		if (ret)
 			goto out;
+		smp_rmb(); /* pairs with smp_wmb() below */
+		if (test_bit(NFS_INO_INVALIDATING, bitlock))
+			continue;
+		/* pairs with nfs_set_cache_invalid()'s smp_store_release() */
+		if (!(smp_load_acquire(&nfsi->cache_validity) & NFS_INO_INVALID_DATA))
+			goto out;
+		/* Slow-path that double-checks with spinlock held */
 		spin_lock(&inode->i_lock);
 		if (test_bit(NFS_INO_INVALIDATING, bitlock)) {
 			spin_unlock(&inode->i_lock);
-- 
2.43.0



