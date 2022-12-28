Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC701C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42334C433EF;
	Wed, 28 Dec 2022 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246214;
	bh=fCTy5XsnxXJd1DH8S1nEC1bP1x0RlusDZgk6MB26vuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KKqUAwY/8wA6FIKdML7Qh846jZwD/eNGMIkl0e4FbqpKtnYTtPwDIVrYQb2cUzH++
	 pEBuJK6Af1hw4cKquYyHHQmb4LwmAW2uvadva51I2vAWAI/rgOEuE/POb4IfgRtP+R
	 R/2EOLLqzquTDpiZANijSvC/IIc9Hh2wU1yH8MAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.0 1032/1073] usb: cdnsp: fix lack of ZLP for ep0
Date: Wed, 28 Dec 2022 15:43:40 +0100
Message-Id: <20221228144356.224206172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawel Laszczak <pawell@cadence.com>

commit ae423ef5d095e09970f52c08020fdbf7f9d87c22 upstream.

Patch implements the handling of ZLP for control transfer.
To send the ZLP driver must prepare the extra TRB in TD with
length set to zero and TRB type to TRB_NORMAL.
The first TRB must have set TRB_CHAIN flag, TD_SIZE = 1
and TRB type to TRB_DATA.

Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
cc: <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20221122085138.332434-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ring.c |   42 +++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2006,10 +2006,11 @@ int cdnsp_queue_bulk_tx(struct cdnsp_dev
 
 int cdnsp_queue_ctrl_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 {
-	u32 field, length_field, remainder;
+	u32 field, length_field, zlp = 0;
 	struct cdnsp_ep *pep = preq->pep;
 	struct cdnsp_ring *ep_ring;
 	int num_trbs;
+	u32 maxp;
 	int ret;
 
 	ep_ring = cdnsp_request_to_transfer_ring(pdev, preq);
@@ -2019,26 +2020,33 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_dev
 	/* 1 TRB for data, 1 for status */
 	num_trbs = (pdev->three_stage_setup) ? 2 : 1;
 
+	maxp = usb_endpoint_maxp(pep->endpoint.desc);
+
+	if (preq->request.zero && preq->request.length &&
+	    (preq->request.length % maxp == 0)) {
+		num_trbs++;
+		zlp = 1;
+	}
+
 	ret = cdnsp_prepare_transfer(pdev, preq, num_trbs);
 	if (ret)
 		return ret;
 
 	/* If there's data, queue data TRBs */
-	if (pdev->ep0_expect_in)
-		field = TRB_TYPE(TRB_DATA) | TRB_IOC;
-	else
-		field = TRB_ISP | TRB_TYPE(TRB_DATA) | TRB_IOC;
-
 	if (preq->request.length > 0) {
-		remainder = cdnsp_td_remainder(pdev, 0, preq->request.length,
-					       preq->request.length, preq, 1, 0);
+		field = TRB_TYPE(TRB_DATA);
 
-		length_field = TRB_LEN(preq->request.length) |
-				TRB_TD_SIZE(remainder) | TRB_INTR_TARGET(0);
+		if (zlp)
+			field |= TRB_CHAIN;
+		else
+			field |= TRB_IOC | (pdev->ep0_expect_in ? 0 : TRB_ISP);
 
 		if (pdev->ep0_expect_in)
 			field |= TRB_DIR_IN;
 
+		length_field = TRB_LEN(preq->request.length) |
+			       TRB_TD_SIZE(zlp) | TRB_INTR_TARGET(0);
+
 		cdnsp_queue_trb(pdev, ep_ring, true,
 				lower_32_bits(preq->request.dma),
 				upper_32_bits(preq->request.dma), length_field,
@@ -2046,6 +2054,20 @@ int cdnsp_queue_ctrl_tx(struct cdnsp_dev
 				TRB_SETUPID(pdev->setup_id) |
 				pdev->setup_speed);
 
+		if (zlp) {
+			field = TRB_TYPE(TRB_NORMAL) | TRB_IOC;
+
+			if (!pdev->ep0_expect_in)
+				field = TRB_ISP;
+
+			cdnsp_queue_trb(pdev, ep_ring, true,
+					lower_32_bits(preq->request.dma),
+					upper_32_bits(preq->request.dma), 0,
+					field | ep_ring->cycle_state |
+					TRB_SETUPID(pdev->setup_id) |
+					pdev->setup_speed);
+		}
+
 		pdev->ep0_stage = CDNSP_DATA_STAGE;
 	}
 


