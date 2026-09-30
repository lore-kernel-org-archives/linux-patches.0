Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1875172F5;
	Wed, 30 Sep 2026 18:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792711; cv=none; b=StDiR52YlvcqVf2puq0p3LI8ojTFI899TLlu+SoLkbUqj8DqdSD8je1oKYNZuj0OiSsAHYHxeTK/LOyIwjnRgobyzJtkW+LtlbwFSDtvg9lI6bCQVSidstUXULu0pB3VsFa3LjpeO6OwJZp+5/sVVNHr83UY356bJjsO4QOgnTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792711; c=relaxed/simple;
	bh=cShzxRHcOBV0haL3fPYAJcgqwm2ImjuNxQ2Jw6ydxdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMVJpEqnSGhqacTPz08OS15b4ptnge/jO+9HTrXLDZbPHVgdOPbvi5/kpHfsCBjhfPqBSJprWSZbdVdzywgZ58rVZ5o+siOUNr9guKjsMYYEJZaa5y2qEzdwtePBWTVWXNbvpzTjU2RVg10I9GUUvwHKas/W1rA3H8iZl2iE62E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LTp0J6za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LTp0J6za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E49A1F0089A;
	Wed, 30 Sep 2026 18:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792709;
	bh=8Cf37mxC1gGuNmpClDyNGnXvr41PXfm0w/TIKPWfUTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTp0J6zaVg2Yz/vf4p56MTjrBRNNSNZOTi0RPiKt02Zk1PQ5c0zAaXzr6JNSGf0wu
	 F/G41DA7NBbYpiCYrtKkS2iez0+GQzGDVZbZu1CpOK+u9GDFkEcQItbne7T2nJ4Blb
	 h9UhnKaf0jz3meXxKN56KP5GRHu2Sqg9aCWC7u00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Qin <cccccccccccc777777@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 707/752] rds: ib: Clear the sg list when mapping an MR fails
Date: Wed, 30 Sep 2026 17:29:37 +0200
Message-ID: <20260930152413.529298290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


