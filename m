Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948161C6F49;
	Tue, 27 Aug 2024 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770972; cv=none; b=F8ckA4cPthBcpW4JqXgH+X89sepKbSUVMpiFBPE492U3/KcWHb2fuOnGxLm02D7xPpqKYYPj3wOQ8RArtQEumTH8CvjAJtz+AvFyLSwow8ZE5mfMzs6G9STJCZz9TlaoBbtn4SYH8DxQykXvqVWZguLKS9cbAKnzR4ovbqp+sxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770972; c=relaxed/simple;
	bh=d/gM7Tuh0MGTI9jCNmw/JcfNw4r8+rVUN2piBbOjx9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si+NwNUwWkXVNh/vFlqQiucnCSY6fPGoGZBWzUGjoFBdXfmWF9jpP03M2o73QaNjY2q3bcLSftGMNchd+gGUyl17eM3+xtO933qAgfJ8OA6ZjgjabXuoepNKii2cCgwKO3jUrXlwKVU0ESTfKFBKbtSCd1Iyk0OpPRb4lFoJa1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aX5Fpc4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aX5Fpc4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A44C61049;
	Tue, 27 Aug 2024 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770972;
	bh=d/gM7Tuh0MGTI9jCNmw/JcfNw4r8+rVUN2piBbOjx9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aX5Fpc4sfHdROPqaSjVs23bGiVK8Idqc6pCzs28bXUXl6dWIS2GEpA0uwgq9spR/j
	 aCUN+vCtbc73yZRvRx3yHsx3vbEqUdnoDjpdfvc80sTeaEx+ERv7Y+Bp7nEy92MmGv
	 nVWXo0AhuZ7UHtNcUgaaKOu5EJ/l1oHxEnJ8w3rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 048/273] net: mana: Fix doorbell out of order violation and avoid unnecessary doorbell rings
Date: Tue, 27 Aug 2024 16:36:12 +0200
Message-ID: <20240827143835.226999546@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

commit 58a63729c957621f1990c3494c702711188ca347 upstream.

After napi_complete_done() is called when NAPI is polling in the current
process context, another NAPI may be scheduled and start running in
softirq on another CPU and may ring the doorbell before the current CPU
does. When combined with unnecessary rings when there is no need to arm
the CQ, it triggers error paths in the hardware.

This patch fixes this by calling napi_complete_done() after doorbell
rings. It limits the number of unnecessary rings when there is
no need to arm. MANA hardware specifies that there must be one doorbell
ring every 8 CQ wraparounds. This driver guarantees one doorbell ring as
soon as the number of consumed CQEs exceeds 4 CQ wraparounds. In practical
workloads, the 4 CQ wraparounds proves to be big enough that it rarely
exceeds this limit before all the napi weight is consumed.

To implement this, add a per-CQ counter cq->work_done_since_doorbell,
and make sure the CQ is armed as soon as passing 4 wraparounds of the CQ.

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1723219138-29887-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   22 ++++++++++++++--------
 include/net/mana/mana.h                       |    1 +
 2 files changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1777,7 +1777,6 @@ static void mana_poll_rx_cq(struct mana_
 static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
-	u8 arm_bit;
 	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
@@ -1788,16 +1787,23 @@ static int mana_cq_handler(void *context
 		mana_poll_tx_cq(cq);
 
 	w = cq->work_done;
+	cq->work_done_since_doorbell += w;
 
-	if (w < cq->budget &&
-	    napi_complete_done(&cq->napi, w)) {
-		arm_bit = SET_ARM_BIT;
-	} else {
-		arm_bit = 0;
+	if (w < cq->budget) {
+		mana_gd_ring_cq(gdma_queue, SET_ARM_BIT);
+		cq->work_done_since_doorbell = 0;
+		napi_complete_done(&cq->napi, w);
+	} else if (cq->work_done_since_doorbell >
+		   cq->gdma_cq->queue_size / COMP_ENTRY_SIZE * 4) {
+		/* MANA hardware requires at least one doorbell ring every 8
+		 * wraparounds of CQ even if there is no need to arm the CQ.
+		 * This driver rings the doorbell as soon as we have exceeded
+		 * 4 wraparounds.
+		 */
+		mana_gd_ring_cq(gdma_queue, 0);
+		cq->work_done_since_doorbell = 0;
 	}
 
-	mana_gd_ring_cq(gdma_queue, arm_bit);
-
 	return w;
 }
 
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -274,6 +274,7 @@ struct mana_cq {
 	/* NAPI data */
 	struct napi_struct napi;
 	int work_done;
+	int work_done_since_doorbell;
 	int budget;
 };
 


