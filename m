Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738931C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06D2C4339C;
	Mon, 20 Mar 2023 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324599;
	bh=xCmItfak/Ee3pijQvtPOXKezg1qLH8Yi/tBnF8gDm+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BE79otu1C2vn3zC9WbMzRu0l9RnpGXcfQUGBwvhbtVAOgZbIFzR6fLr7V9S/6KPdM
	 pylygaO61RqtafbEEWOvBkcS5g83la+tUIOifr5SfbQxQzwPqSONXHTHyypLfG8opC
	 z5x43lDXix5/h0mqh0vyIOXPEyXIf4FWSgvl1PJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 23/99] nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
Date: Mon, 20 Mar 2023 15:54:01 +0100
Message-Id: <20230320145444.354789776@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 5000fe6c27827a61d8250a7e4a1d26c3298ef4f6 ]

This bug influences both st_nci_i2c_remove and st_nci_spi_remove.
Take st_nci_i2c_remove as an example.

In st_nci_i2c_probe, it called ndlc_probe and bound &ndlc->sm_work
with llt_ndlc_sm_work.

When it calls ndlc_recv or timeout handler, it will finally call
schedule_work to start the work.

When we call st_nci_i2c_remove to remove the driver, there
may be a sequence as follows:

Fix it by finishing the work before cleanup in ndlc_remove

CPU0                  CPU1

                    |llt_ndlc_sm_work
st_nci_i2c_remove   |
  ndlc_remove       |
     st_nci_remove  |
     nci_free_device|
     kfree(ndev)    |
//free ndlc->ndev   |
                    |llt_ndlc_rcv_queue
                    |nci_recv_frame
                    |//use ndlc->ndev

Fixes: 35630df68d60 ("NFC: st21nfcb: Add driver for STMicroelectronics ST21NFCB NFC chip")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230312160837.2040857-1-zyytlz.wz@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/st-nci/ndlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/st-nci/ndlc.c b/drivers/nfc/st-nci/ndlc.c
index 5d74c674368a5..8ccf5a86ad1bb 100644
--- a/drivers/nfc/st-nci/ndlc.c
+++ b/drivers/nfc/st-nci/ndlc.c
@@ -286,13 +286,15 @@ EXPORT_SYMBOL(ndlc_probe);
 
 void ndlc_remove(struct llt_ndlc *ndlc)
 {
-	st_nci_remove(ndlc->ndev);
-
 	/* cancel timers */
 	del_timer_sync(&ndlc->t1_timer);
 	del_timer_sync(&ndlc->t2_timer);
 	ndlc->t2_active = false;
 	ndlc->t1_active = false;
+	/* cancel work */
+	cancel_work_sync(&ndlc->sm_work);
+
+	st_nci_remove(ndlc->ndev);
 
 	skb_queue_purge(&ndlc->rcv_q);
 	skb_queue_purge(&ndlc->send_q);
-- 
2.39.2



