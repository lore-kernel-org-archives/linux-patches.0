Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118EE2571A0;
	Wed, 30 Sep 2026 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783907; cv=none; b=twSz/DAMYgL+Mc9TUwqEv2nbMVUGq7ch67mOBJSlSHVelOeLfgidQmf7uxrcJC5L5VeRihskRzB/9HOdkuY3Bq5bmgpdZY53ezFfTSEIgNHXE7+tlqZ94sn90Us1ORHIs+mmA43Q6y+pweWKdKIlwkcmj8VVHx3zroeZRmNum00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783907; c=relaxed/simple;
	bh=TTH8qpow+gKsf8bmNm80kMXERhjrviunxjdNDkaEffQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4lISle6fJeXjPKkXO2Rk1lWeHPI1MPsZn78wbS0hBTtGPc9eDCSoiPPAX7HZ8s2yRetV/R3ZW66UFtEcsr0I4wTTYhJhtLUJ+X4Ei8za2+kMilvfcD/xBZyUcJF7pk6nJqy64eUekrIf89bIwVyLcQDv98nD4Til46WQsVyQZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERc6MsRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERc6MsRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F8441F000FF;
	Wed, 30 Sep 2026 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783903;
	bh=Au44xUURIERr4jCbpH2ZaI3kqGDZSyNwBzzPPkZt1tY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERc6MsRmNYkBHkuhWyJFEpht9DsTVE4BN/NJwiMn6L/6J1oQhZxO0H4wFGGwwvOza
	 d0TDY1OE91Xfg3rWyaarC79Jh6JlvpXZwJh3Y3EKJ+ZyiKkcWIQY4E9Ymm/p0N3rWd
	 y9Q/msIGmZ0Hjm/1Uhm8wZpBgovXh8j4FB98gbX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Qin <cccccccccccc777777@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 563/595] rds: ib: Clear the sg list when mapping an MR fails
Date: Wed, 30 Sep 2026 17:27:36 +0200
Message-ID: <20260930152359.832637144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


