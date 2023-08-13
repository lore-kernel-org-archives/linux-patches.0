Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269399443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:24:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB88C433C7;
	Sun, 13 Aug 2023 21:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691961851;
	bh=uLMaG0mUvjSNjBNUqlUcPm1KaN+CxIvh8d5a2EwM2J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8SdHUHeNm8TmY2DHH6/2LcMeuYYAjfuM8yJWm3QGf6hKCL3hf4uT6I3wmRatM5VM
	 UD7twS4BLtsp7POkD1I6eHVUo0+92q3c2IaJ8juLvkp17x6RTJBnEyWy2JNXxsviKC
	 rb+QZzEz1vc+a8ClOPGeo2B9auwp0iQyl4xEkooM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.4 021/206] dmaengine: xilinx: xdma: Fix interrupt vector setting
Date: Sun, 13 Aug 2023 23:16:31 +0200
Message-ID: <20230813211725.587664404@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 96891e90d1256b569b1c183e7c9a0cfc568fa3b0 upstream.

A couple of hardware registers need to be set to reflect which
interrupts have been allocated to the device. Each register is 32-bit
wide and can receive four 8-bit values. If we provide any other interrupt
number than four, the irq_num variable will never be 0 within the while
check and the while block will loop forever.

There is an easy way to prevent this: just break the for loop
when we reach "irq_num == 0", which anyway means all interrupts have
been processed.

Cc: stable@vger.kernel.org
Fixes: 17ce252266c7 ("dmaengine: xilinx: xdma: Add xilinx xdma driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://lore.kernel.org/r/20230731101442.792514-2-miquel.raynal@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/xilinx/xdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index ad5ff63354cf..5116188b9977 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -668,6 +668,8 @@ static int xdma_set_vector_reg(struct xdma_device *xdev, u32 vec_tbl_start,
 			val |= irq_start << shift;
 			irq_start++;
 			irq_num--;
+			if (!irq_num)
+				break;
 		}
 
 		/* write IRQ register */
-- 
2.41.0



