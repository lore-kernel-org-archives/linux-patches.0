Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C4217B505;
	Wed,  5 Mar 2025 18:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198053; cv=none; b=oc6xyE6Gr++yYGy+Q5wE9X8FdRHT0v81aoA1OfLzzfIp2xEZW3z+QgkOwW57bBU4kBzyah9MqPwq3b0iSGOO3uzaogyOaoazvJ9Xby3fgODddMztxqnomzSr+IqmkpWZYtIewBPV28YBOaTugbTMoFmmnwdY7tGWlLuOhysYvpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198053; c=relaxed/simple;
	bh=ItaRR86vNvO60RK+zuAHmBf1S14xrKJ0sQxFJ43vMKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwxx/L9FJHh5aPgpCzt2xliB75Xs028luc7B/eq3NE3faixp208m9rbaHxDbkxJ6XDjE1z1e/0pAn2tC5+F3LtIFFcf4gSfIyenrxaOXdRiRzKngYB2DdRzQTe9fKH5HDfsFlabFq+xOyfHXr/YyDvCm5qy33EMqa2IVOxPLzEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GK9u31cN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GK9u31cN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DFDC4CED1;
	Wed,  5 Mar 2025 18:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198053;
	bh=ItaRR86vNvO60RK+zuAHmBf1S14xrKJ0sQxFJ43vMKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK9u31cNNC8YAU+da8Sw9+XIQI6z+I1U7qqUvBdvQpjHhdAce8pRJkPv3p0UXBhHo
	 waaHqSiBunAr2p95fHrVOgOQ3xi4HLJxp2WaLBhZ9eRR3XEaoWkgLqBp3hprWtZjiK
	 jhROqsHM3enHjhtJQAtdUZ9J4m8uLD/cM1AFNevE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/150] NFS: O_DIRECT writes must check and adjust the file length
Date: Wed,  5 Mar 2025 18:47:25 +0100
Message-ID: <20250305174504.458766765@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit fcf857ee1958e9247298251f7615d0c76f1e9b38 ]

While it is uncommon for delegations to be held while O_DIRECT writes
are in progress, it is possible. The xfstests generic/647 and
generic/729 both end up triggering that state, and end up failing due to
the fact that the file size is not adjusted.

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219738
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 88025c67fe3c ("NFS: Adjust delegated timestamps for O_DIRECT reads and writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 90079ca134dd3..2784586f93fc0 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -130,6 +130,20 @@ static void nfs_direct_truncate_request(struct nfs_direct_req *dreq,
 		dreq->count = req_start;
 }
 
+static void nfs_direct_file_adjust_size_locked(struct inode *inode,
+					       loff_t offset, size_t count)
+{
+	loff_t newsize = offset + (loff_t)count;
+	loff_t oldsize = i_size_read(inode);
+
+	if (newsize > oldsize) {
+		i_size_write(inode, newsize);
+		NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_SIZE;
+		trace_nfs_size_grow(inode, newsize);
+		nfs_inc_stats(inode, NFSIOS_EXTENDWRITE);
+	}
+}
+
 /**
  * nfs_swap_rw - NFS address space operation for swap I/O
  * @iocb: target I/O control block
@@ -732,6 +746,7 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	struct nfs_direct_req *dreq = hdr->dreq;
 	struct nfs_commit_info cinfo;
 	struct nfs_page *req = nfs_list_entry(hdr->pages.next);
+	struct inode *inode = dreq->inode;
 	int flags = NFS_ODIRECT_DONE;
 
 	trace_nfs_direct_write_completion(dreq);
@@ -753,6 +768,10 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	}
 	spin_unlock(&dreq->lock);
 
+	spin_lock(&inode->i_lock);
+	nfs_direct_file_adjust_size_locked(inode, dreq->io_start, dreq->count);
+	spin_unlock(&inode->i_lock);
+
 	while (!list_empty(&hdr->pages)) {
 
 		req = nfs_list_entry(hdr->pages.next);
-- 
2.39.5



