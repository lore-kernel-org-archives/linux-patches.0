Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139F03CDBD3;
	Thu, 17 Sep 2026 19:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671853; cv=none; b=cAbQBSRHcz0fEhPXWXxJ8YAwDhu3dlGyc0Lurl4YJjardgqB+MVBEE3cenmyY0KFsHgSYvf4zFUL2s5zor54BX/47zeGgBWku/EJ0SQFp9eWHUXfoqXch1/R8c4KIoOqV6VtGJ/Vg8pzXgf/sCjU11StGkDx+0NftddCPuRUZNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671853; c=relaxed/simple;
	bh=LJEMWYKtgj5nDKGOcwMzMfbQwNDSjtfXJ4UdMHKWx7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUj7frUXy/zXqagqkUmH+u1GZLxLesH95rLyo+xsmNi1xwh7Ku0aDD0peKUbSqBmpDl9dZOg1LW8w1DAiJsFmz0N4Orw3CO+S606aJkgBUHU4qZIEiHY8mfZaD5Kt9slv7eG3JgIpkNAXHxw7lS6WEHXuSzYgcP34A9xqKbreNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzUMGYDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzUMGYDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945E81F000FF;
	Thu, 17 Sep 2026 19:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671852;
	bh=F9JVMr3TmkGP0VeA6XJrrgA9XUej119YWqplRkzPpuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzUMGYDlR1XXcN1oQUULtCrUePrD4/3rmsJK4+8SmJEEBLcjUlsxovJ3+S0Bs1KxL
	 F1tt6nhmHhis/i6oNgqyhyfwjzzqMFnd5f7+Pke4ET2R479KwwWVP8JqXd5IKw3Tmp
	 2atf+Xy7hOYrroqpYBBkpvjQxvONa2rvkewTb4I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1093/1102] svcrdma: Adjust the number of entries in svc_rdma_recv_ctxt::rc_pages
Date: Thu, 17 Sep 2026 16:17:16 +0100
Message-ID: <20260917151608.301020153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20260917151716.OSVLjVCyTQ5T_oqmTIekbPPVvXVQlF9xf1IYbO3VJO0@z>

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 81381d1a90dea186ce4585d9bd3cdc40b50e9c48 ]

Allow allocation of more entries in the rc_pages[] array when the
maximum size of an RPC message is increased.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 9808eb765666 ("svcrdma: Reject Write/Reply chunks with segcount 0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/sunrpc/svc_rdma.h         |    3 ++-
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c |    8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -202,7 +202,8 @@ struct svc_rdma_recv_ctxt {
 	struct svc_rdma_pcl	rc_reply_pcl;
 
 	unsigned int		rc_page_count;
-	struct page		*rc_pages[RPCSVC_MAXPAGES];
+	unsigned long		rc_maxpages;
+	struct page		*rc_pages[] __counted_by(rc_maxpages);
 };
 
 /*
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -120,12 +120,16 @@ svc_rdma_recv_ctxt_alloc(struct svcxprt_
 {
 	int node = ibdev_to_node(rdma->sc_cm_id->device);
 	struct svc_rdma_recv_ctxt *ctxt;
+	unsigned long pages;
 	dma_addr_t addr;
 	void *buffer;
 
-	ctxt = kzalloc_node(sizeof(*ctxt), GFP_KERNEL, node);
+	pages = svc_serv_maxpages(rdma->sc_xprt.xpt_server);
+	ctxt = kzalloc_node(struct_size(ctxt, rc_pages, pages),
+			    GFP_KERNEL, node);
 	if (!ctxt)
 		goto fail0;
+	ctxt->rc_maxpages = pages;
 	buffer = kmalloc_node(rdma->sc_max_req_size, GFP_KERNEL, node);
 	if (!buffer)
 		goto fail1;
@@ -497,7 +501,7 @@ static bool xdr_check_write_chunk(struct
 	 * a computation, perform a simple range check. This is an
 	 * arbitrary but sensible limit (ie, not architectural).
 	 */
-	if (unlikely(segcount > RPCSVC_MAXPAGES))
+	if (unlikely(segcount > rctxt->rc_maxpages))
 		return false;
 
 	p = xdr_inline_decode(&rctxt->rc_stream,


