Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F164DBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E33C433EF;
	Tue,  7 Mar 2023 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213251;
	bh=9m15ma9Ry7fVbi0COTk9hlqb6TcyuDNFbdcgq6uTU6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QydatI8IDw3v1eiAx4u1MF7NRV5/6z1jkZgKLRkvzltRbiaDPKp+b62gNeuhdYLZU
	 Z9Rp7RFEM1YBuYQGz6UCzOZftkQD3fuFF4q5/rtskfiBOLy+jpMbmLws1ypbOBnwFZ
	 dPM4/LPTOZ4MklkNd3BuYZ6SzFxpWjf0LApPjoqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Serge Semin <Sergey.Semin@baikalelectronics.ru>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 448/885] dmaengine: dw-edma: Fix missing src/dst address of interleaved xfers
Date: Tue,  7 Mar 2023 17:56:22 +0100
Message-Id: <20230307170021.942640730@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 13b6299cf66165a442089fa895a7f70250703584 ]

Interleaved DMA transfer support was added by 85e7518f42c8 ("dmaengine:
dw-edma: Add device_prep_interleave_dma() support"), but depending on the
selected channel, either source or destination address are left
uninitialized which was obviously wrong.

Initialize the destination address of the eDMA burst descriptors for
DEV_TO_MEM interleaved operations and the source address for MEM_TO_DEV
operations.

Link: https://lore.kernel.org/r/20230113171409.30470-5-Sergey.Semin@baikalelectronics.ru
Fixes: 85e7518f42c8 ("dmaengine: dw-edma: Add device_prep_interleave_dma() support")
Tested-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dw-edma/dw-edma-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index c54b24ff5206a..52bdf04aff511 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -455,6 +455,8 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
+			} else if (xfer->type == EDMA_XFER_INTERLEAVED) {
+				burst->dar = dst_addr;
 			}
 		} else {
 			burst->dar = dst_addr;
@@ -470,6 +472,8 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
+			}  else if (xfer->type == EDMA_XFER_INTERLEAVED) {
+				burst->sar = src_addr;
 			}
 		}
 
-- 
2.39.2



