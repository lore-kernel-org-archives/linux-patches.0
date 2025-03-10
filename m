Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F2A23535B;
	Mon, 10 Mar 2025 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627887; cv=none; b=O+mhyNKwyqnpyboSY5ea/8MLoHa/9expN4s6ApvY+3BRmSnVJhFsyGMlx1HvXhv7FoVhZUpKws1RzKs3qsSK8IIGGec822dGLg1au908eH7pux0gibfCEcPrminhDTforjXUyIpNbCA2AzmFjLZYqkiYb3bFpgOHHehQdyLvQdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627887; c=relaxed/simple;
	bh=/Z8UVRcukBjLcV7CDp+vMFN3Dfcj5hDCWqfDime4alw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ex9ECR3cE3tu50qKEi1l6x+NV0HJuwLqWKNmLkx64H4Kq+KhuuekAdsNfLKENQlFZ/va9gHXrtIROn2zE6dc7iflPsABlGZO8UJFMXEhI5IT2QuPB6Eu5SvXgQn5v6QckRKBTQmlGKiQLlcdSRtYbkvuxLOLIdRWzwAaHj+7ChM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ixFoMe4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ixFoMe4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D7FC4CEED;
	Mon, 10 Mar 2025 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627887;
	bh=/Z8UVRcukBjLcV7CDp+vMFN3Dfcj5hDCWqfDime4alw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ixFoMe4ubSQKgZ+sw6WgxBReiTUdAsnCc9Vfks/F4OZMCCt8CEtgucs9wQcGZajJ
	 /fcSeH6IBX7eQV97y5Lwo/PQ76OiibSH6Npf/660//mIF0IkDYG8aUYkxD5aiRTWUu
	 94fo9rYpvy9hMeiyPi/h98Mpv+OPyiKjVrdopEXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/145] NFS: O_DIRECT writes must check and adjust the file length
Date: Mon, 10 Mar 2025 18:05:09 +0100
Message-ID: <20250310170435.361092917@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 258521d5125ed..a1ff4a4f5380e 100644
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
@@ -728,6 +742,7 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	struct nfs_direct_req *dreq = hdr->dreq;
 	struct nfs_commit_info cinfo;
 	struct nfs_page *req = nfs_list_entry(hdr->pages.next);
+	struct inode *inode = dreq->inode;
 	int flags = NFS_ODIRECT_DONE;
 
 	trace_nfs_direct_write_completion(dreq);
@@ -749,6 +764,10 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
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



