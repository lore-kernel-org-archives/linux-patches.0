Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B43E28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7ACC433EF;
	Mon, 12 Dec 2022 13:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851670;
	bh=ACiR4qm1E19xMIk5BB0+BZSMefgIWKDrIKQaQdIWnFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIKvVQbesS6phsPDJ2vbBs+4nob4P/eyVmOKdGLHYtEMZLymzB2RLMsOljUJ2Pi/M
	 ZQa4b4G6tBghEhrQv17OCGwyQeuJFkM6Tz3ofOPOspP4ZEwZmfn5Nul35t7Dl2esY+
	 ZozhYAYD2DnkWpflpYhjygladfCdW9WZZ7VvP6To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 047/123] net: mana: Fix race on per-CQ variable napi work_done
Date: Mon, 12 Dec 2022 14:16:53 +0100
Message-Id: <20221212130928.896230907@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 18010ff776fa42340efc428b3ea6d19b3e7c7b21 upstream.

After calling napi_complete_done(), the NAPIF_STATE_SCHED bit may be
cleared, and another CPU can start napi thread and access per-CQ variable,
cq->work_done. If the other thread (for example, from busy_poll) sets
it to a value >= budget, this thread will continue to run when it should
stop, and cause memory corruption and panic.

To fix this issue, save the per-CQ work_done variable in a local variable
before napi_complete_done(), so it won't be corrupted by a possible
concurrent thread after napi_complete_done().

Also, add a flag bit to advertise to the NIC firmware: the NAPI work_done
variable race is fixed, so the driver is able to reliably support features
like busy_poll.

Cc: stable@vger.kernel.org
Fixes: e1b5683ff62e ("net: mana: Move NAPI from EQ to CQ")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1670010190-28595-1-git-send-email-haiyangz@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/gdma.h    |    9 ++++++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c |   16 +++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/gdma.h
+++ b/drivers/net/ethernet/microsoft/mana/gdma.h
@@ -488,7 +488,14 @@ enum {
 
 #define GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT BIT(0)
 
-#define GDMA_DRV_CAP_FLAGS1 GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT
+/* Advertise to the NIC firmware: the NAPI work_done variable race is fixed,
+ * so the driver is able to reliably support features like busy_poll.
+ */
+#define GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX BIT(2)
+
+#define GDMA_DRV_CAP_FLAGS1 \
+	(GDMA_DRV_CAP_FLAG_1_EQ_SHARING_MULTI_VPORT | \
+	 GDMA_DRV_CAP_FLAG_1_NAPI_WKDONE_FIX)
 
 #define GDMA_DRV_CAP_FLAGS2 0
 
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1071,10 +1071,11 @@ static void mana_poll_rx_cq(struct mana_
 	}
 }
 
-static void mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
+static int mana_cq_handler(void *context, struct gdma_queue *gdma_queue)
 {
 	struct mana_cq *cq = context;
 	u8 arm_bit;
+	int w;
 
 	WARN_ON_ONCE(cq->gdma_cq != gdma_queue);
 
@@ -1083,26 +1084,31 @@ static void mana_cq_handler(void *contex
 	else
 		mana_poll_tx_cq(cq);
 
-	if (cq->work_done < cq->budget &&
-	    napi_complete_done(&cq->napi, cq->work_done)) {
+	w = cq->work_done;
+
+	if (w < cq->budget &&
+	    napi_complete_done(&cq->napi, w)) {
 		arm_bit = SET_ARM_BIT;
 	} else {
 		arm_bit = 0;
 	}
 
 	mana_gd_ring_cq(gdma_queue, arm_bit);
+
+	return w;
 }
 
 static int mana_poll(struct napi_struct *napi, int budget)
 {
 	struct mana_cq *cq = container_of(napi, struct mana_cq, napi);
+	int w;
 
 	cq->work_done = 0;
 	cq->budget = budget;
 
-	mana_cq_handler(cq, cq->gdma_cq);
+	w = mana_cq_handler(cq, cq->gdma_cq);
 
-	return min(cq->work_done, budget);
+	return min(w, budget);
 }
 
 static void mana_schedule_napi(void *context, struct gdma_queue *gdma_queue)


