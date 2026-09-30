Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0B1519907;
	Wed, 30 Sep 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789444; cv=none; b=fi1DIOBkbCo6m5ETOagtKTphXOUeQ2DNz6OTWk6hhuMKm4ffnpsdeVyf7QNXYC73ULOGC+p1/0cXJ0tXuPgHB735XwqPBrApgERR/g2061lx3Z0VbOWqDwYdYbKkTdyWnrmZHGyWMLXWaS231244O1ELWFi858tUB2CTjwyP+GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789444; c=relaxed/simple;
	bh=RMcQu80CfmsAKM3zR85v4a7MFHzcsrSOvxVwECEuJgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1OVoKz5lhBj0J6sDag2A+yk6rJTDhJ4mNEF9lFfbntLD5vkv+5GBlpEOC47Vs/XglWwbHM9ArA9NnMnPrGACHgx6I0ePnZMbtoHLr5EG4+zLroGTxFWEyjtefZ8dyzzLnWiwaVFlzLpG068MuvavqmkYT9upXVVXCOyjf6OGtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IM4ZG35x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IM4ZG35x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003071F000FF;
	Wed, 30 Sep 2026 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789442;
	bh=2Q/WKIYrJOPxVbcgIze+497lPM9xwdjkWXoHmgvEWmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IM4ZG35xiiDOnV0gX024s7a89F6oyXCGwErqE3dqff7nUMv2/2n3+iG98IG+I0oia
	 jTwL7Wo4I1tbfvIxniZjdI1hwFgz7mAKG+jbVu85jbna8QTg210vabgPY/9oN0JdIx
	 MiCKHFs8FEQr2OUtQLT81Ez1CVpK7PAMavwHEWTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Qin <cccccccccccc777777@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 478/877] rds: ib: Clear the sg list when mapping an MR fails
Date: Wed, 30 Sep 2026 17:23:09 +0200
Message-ID: <20260930152424.984634888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongliang Qin <cccccccccccc777777@gmail.com>

commit 58eb1b3325edac42dc6df72c80962bd53a3c8ca7 upstream.

rds_ib_map_frmr() stores the caller's scatterlist in the MR before DMA
mapping and registration can fail. On failure, __rds_rdma_map() unpins
the pages and frees the scatterlist, but rds_ib_free_frmr() can still
return the MR to the pool with the stale pointer set.

This leaves the pool with a dangling scatterlist and can lead to local
privilege escalation. KASAN detects the resulting use-after-free when the
MR is later torn down:

BUG: KASAN: slab-use-after-free in __rds_ib_teardown_mr
Read of size 8

Call Trace:
 __rds_ib_teardown_mr
 rds_ib_unreg_frmr
 rds_ib_flush_mr_pool
 rds_ib_flush_mrs
 rds_free_mr
 rds_setsockopt

Store the scatterlist in the MR only after DMA mapping succeeds. If DMA
mapping fails, return directly while the MR fields remain clear; the caller
keeps ownership of the scatterlist and its pinned pages. If a later
registration step fails, unmap the scatterlist and clear the MR fields
before returning.

Fixes: 1659185fb4d0 ("RDS: IB: Support Fastreg MR (FRMR) memory registration mode")
Cc: stable@vger.kernel.org
Signed-off-by: Dongliang Qin <cccccccccccc777777@gmail.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260922031546.3874605-1-cccccccccccc777777@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/ib_frmr.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/net/rds/ib_frmr.c
+++ b/net/rds/ib_frmr.c
@@ -204,19 +204,16 @@ static int rds_ib_map_frmr(struct rds_ib
 	 */
 	rds_ib_teardown_mr(ibmr);
 
-	ibmr->sg = sg;
-	ibmr->sg_len = sg_len;
-	ibmr->sg_dma_len = 0;
 	frmr->sg_byte_len = 0;
-	WARN_ON(ibmr->sg_dma_len);
-	ibmr->sg_dma_len = ib_dma_map_sg(dev, ibmr->sg, ibmr->sg_len,
+	ibmr->sg_dma_len = ib_dma_map_sg(dev, sg, sg_len,
 					 DMA_BIDIRECTIONAL);
 	if (unlikely(!ibmr->sg_dma_len)) {
 		pr_warn("RDS/IB: %s failed!\n", __func__);
 		return -EBUSY;
 	}
 
-	frmr->sg_byte_len = 0;
+	ibmr->sg = sg;
+	ibmr->sg_len = sg_len;
 	frmr->dma_npages = 0;
 	len = 0;
 
@@ -264,6 +261,8 @@ out_unmap:
 	ib_dma_unmap_sg(rds_ibdev->dev, ibmr->sg, ibmr->sg_len,
 			DMA_BIDIRECTIONAL);
 	ibmr->sg_dma_len = 0;
+	ibmr->sg = NULL;
+	ibmr->sg_len = 0;
 	return ret;
 }
 


