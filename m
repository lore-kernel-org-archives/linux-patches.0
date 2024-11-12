Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22A72309AE;
	Tue, 12 Nov 2024 10:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408028; cv=none; b=i7Bnz8PVqciBi3rNkWPfrmLh8674iBsQz6GUilqH+HjGAzTkvJqsZGVd+oE3iqCyKtSS7li7vD+Jv6f2JLRffoKHy2XlXEhWgbFN0raYuSpPG7l/DWPOvHzQwieulUFp2kR0WgR/aXHf+XSNGd1L629yRPnnKlL7Iu3ggEPVwaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408028; c=relaxed/simple;
	bh=kymSvZ1E6ys6qq3IaiJ+K+vjzdYvLTXigJrQIwO5n70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCp01CHpKsGEppPW3bCrT+SWOrm18swv5RvV785injy54SBIP3ssJ8MyZPfsrOrfPI9O09g362FTzYwYWDnK8MsgAA75Ig0H6aCaq+pbhwvm6x8B3AaBL3KoZdNKNHB9DF4hDyyRZhAZ4mw0XhhBGWKd1i/wBLclC7uI3PxItuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h21KjhvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h21KjhvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34FAEC4CECD;
	Tue, 12 Nov 2024 10:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408028;
	bh=kymSvZ1E6ys6qq3IaiJ+K+vjzdYvLTXigJrQIwO5n70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h21KjhvIJfwEgctLFbFv4Uv6HKX8pV/de27XLvphnNOCcG5wNwBUeYxDoLeLmpzcQ
	 An/7COFGW4l67mHAYuYEpddLIRTHFDbwFPjiEJsHAuPc35M4CnHLt50MASYGiuSxcR
	 ONPDKB/BPzpQ5qAH2Z+NNx7fv7774VluH9hZjHso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 038/184] nfs: avoid i_lock contention in nfs_clear_invalid_mapping
Date: Tue, 12 Nov 2024 11:19:56 +0100
Message-ID: <20241112101902.328623277@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index b6519f4b12663..e36f3efb3bbc8 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -205,12 +205,15 @@ void nfs_set_cache_invalid(struct inode *inode, unsigned long flags)
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
@@ -1421,6 +1424,13 @@ int nfs_clear_invalid_mapping(struct address_space *mapping)
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



