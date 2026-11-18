Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060418;
	b=gAtVA9Vz5LUntMQpsx44oStycj8Paos004RI0yjyV0D/age+2v2w4CYZBPNSlAH96NK5
	 PCE03XN+g8OlMf0Gx8sQqH+QHIKZUjvnlI2opAmw8xEA9uB0iRozo1DXqL8Rx+BaD9Z3E
	 eya8kxyChQEvFKzoHFec5qrGjirFZSpScKK16juFjtNbCzz4KXVWCoZQZtonsASZyVY5G
	 ktN7D2ntY941KjEuPOthzFf60jetMI2PbpxuppvdiFY0kPs0Nt5cWXrygTX2Q3OPDgeF+
	 Z4cSHHFxRip3Ex7I9xpPBWJOMPfSzlXI7+Z2XnEHeYbaOxZhOvEqK9R5+feQiblY8Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n90XHUejAps+vpFs4NNULOVNLAUdhdscgl3W2C7kp2c=;
	b=wzFkb/IJ7FIEFSX6Z7kAowjsdI4XwpbHacVtyDKjDmUIkHhiWLnLWwWFwfiWMI23XeGq
	 oIYA/bgGnd7POMXKf+XtwpE/T0opAkrjJA/bXQ65pcrD8/zEwGcCR/9Sj87gjErimCVGe
	 AKyLfzsfnLwV4n9bTcAXHgwe7pdcePNKeIwv/w+je46eUq4ujNe7C+N3Vm9qNDCv+ev2O
	 rDqPWRAfJ8dHZAL+kV9eWPkinpSicZMIxr6STITplxAaWj0X+dVyWv0IU9Ym+M/8iN2tL
	 xUABOy9ZAovCRFPO4D42AKVcLOQyOQZlscaTLCULoxcISK0peCYTk02+CWLEnLvxCxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMQk2zpY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B139D606A326;
	Thu, 19 Nov 2026 03:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMQk2zpY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C001F000C4;
	Thu, 19 Nov 2026 03:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060418;
	bh=n90XHUejAps+vpFs4NNULOVNLAUdhdscgl3W2C7kp2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMQk2zpYh2f8Qpc/syFzJ2+MB6v+QNl01VisB53kWQefNk628G1icjxhBaDX6J/1x
	 9MnDRtprd7HMZ09jk+zHUSSfKkiqcM4WNTM/r0gXRHJ2QjmGHFaoKGU7An+v+zzzV8
	 IssvQGI94vE8kirrBlGuHWvdaTachte4/mwf88qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1190/1848] dmaengine: xilinx_dma: Freeup active list based on descriptor completion bit
Date: Wed, 18 Nov 2026 15:53:48 +0100
Message-ID: <20261118150009.319782653@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 7bcdaa65810212c999d21e5c3019d03da37b3be3 ]

AXIDMA IP in SG mode sets completion bit to 1 when the transfer is
completed. Read this bit to move descriptor from active list to the
done list. This feature is needed when interrupt delay timeout and
IRQThreshold is enabled i.e Dly_IrqEn is triggered w/o completing
interrupt threshold.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1691387509-2113129-6-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 5b585cc87781 ("dmaengine: xilinx_dma: Move descriptors to done list based on completion bit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 5ef9f53e37cfd..f47ffb520b843 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -180,6 +180,7 @@
 #define XILINX_DMA_CR_DELAY_SHIFT	24
 #define XILINX_DMA_BD_SOP		BIT(27)
 #define XILINX_DMA_BD_EOP		BIT(26)
+#define XILINX_DMA_BD_COMP_MASK		BIT(31)
 #define XILINX_DMA_COALESCE_MAX		255
 #define XILINX_DMA_NUM_DESCS		255
 #define XILINX_DMA_NUM_APP_WORDS	5
@@ -1717,6 +1718,14 @@ static void xilinx_dma_complete_descriptor(struct xilinx_dma_chan *chan)
 		return;
 
 	list_for_each_entry_safe(desc, next, &chan->active_list, node) {
+		if (chan->xdev->dma_config->dmatype == XDMA_TYPE_AXIDMA) {
+			struct xilinx_axidma_tx_segment *seg;
+
+			seg = list_last_entry(&desc->segments,
+					      struct xilinx_axidma_tx_segment, node);
+			if (!(seg->hw.status & XILINX_DMA_BD_COMP_MASK) && chan->has_sg)
+				break;
+		}
 		if (chan->has_sg && chan->xdev->dma_config->dmatype !=
 		    XDMA_TYPE_VDMA)
 			desc->residue = xilinx_dma_get_residue(chan, desc);
-- 
2.53.0



