Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD151C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC42C4339B;
	Mon, 20 Mar 2023 15:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324958;
	bh=rEzDGNZMJOr22C/pfGJunXDJWsvBlZz/NIE1o+SClOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSGrce44sxGSziMcJWV4JKk7QODY5yoM9JPz8sPn6DSB2FhtGsxjBvS80NJwCR2Rs
	 pyni9ZkhaYrbMAQqBFRTwxO+nDfap8sbe3zXC9tGsZX26YrwfNP4IRlCp/28F3nOZj
	 w7cXpQpvhZliaY/yPlgm/+x/1RmSXrXobJNuAKvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 033/115] nfc: st-nci: Fix use after free bug in ndlc_remove due to race condition
Date: Mon, 20 Mar 2023 15:54:05 +0100
Message-Id: <20230320145450.839788742@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
References: <20230320145449.336983711@linuxfoundation.org>
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
index e9dc313b333e2..3564e3335a988 100644
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



