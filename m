Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274B711C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953D0C433C7;
	Thu, 24 Aug 2023 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889295;
	bh=8zZfZTJDBN05/JCraAi4ueKVVkoUoJPjBayRVrDi1ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMYD1qL2F/IAl8h4ULW1BptE9fzHgUfqsCnzjIptgMP1uvvu77e/TngqExatWxukJ
	 wU1y+6iTH3IWgTo2HvZW/dauUb+spCsTGDI1Bv+dyfcHX2xbXVLCV7LWhGl1poYAWq
	 XjMy07ZPES3O5wvfxUPo9UfnZf0UtSS5KnT0q7mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/135] usb: cdns3: fix NCM gadget RX speed 20x slow than expection at iMX8QM
Date: Thu, 24 Aug 2023 16:50:00 +0200
Message-ID: <20230824145029.357185259@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit dbe678f6192f27879ac9ff6bc7a1036aad85aae9 ]

At iMX8QM platform, enable NCM gadget and run 'iperf3 -s'.
At host, run 'iperf3 -V -c fe80::6863:98ff:feef:3e0%enxc6e147509498'

[  5]   0.00-1.00   sec  1.55 MBytes  13.0 Mbits/sec   90   4.18 KBytes
[  5]   1.00-2.00   sec  1.44 MBytes  12.0 Mbits/sec   75   4.18 KBytes
[  5]   2.00-3.00   sec  1.48 MBytes  12.4 Mbits/sec   75   4.18 KBytes

Expected speed should be bigger than 300Mbits/sec.

The root cause of this performance drop was found to be data corruption
happening at 4K borders in some Ethernet packets, leading to TCP
checksum errors. This corruption occurs from the position
(4K - (address & 0x7F)) to 4K. The u_ether function's allocation of
skb_buff reserves 64B, meaning all RX addresses resemble 0xXXXX0040.

Force trb_burst_size to 16 can fix this problem.

Cc: stable@vger.kernel.org
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20230518154946.3666662-1-Frank.Li@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 24dab7006b823..210c1d6150825 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -2098,6 +2098,19 @@ int cdns3_ep_config(struct cdns3_endpoint *priv_ep, bool enable)
 	else
 		priv_ep->trb_burst_size = 16;
 
+	/*
+	 * In versions preceding DEV_VER_V2, for example, iMX8QM, there exit the bugs
+	 * in the DMA. These bugs occur when the trb_burst_size exceeds 16 and the
+	 * address is not aligned to 128 Bytes (which is a product of the 64-bit AXI
+	 * and AXI maximum burst length of 16 or 0xF+1, dma_axi_ctrl0[3:0]). This
+	 * results in data corruption when it crosses the 4K border. The corruption
+	 * specifically occurs from the position (4K - (address & 0x7F)) to 4K.
+	 *
+	 * So force trb_burst_size to 16 at such platform.
+	 */
+	if (priv_dev->dev_ver < DEV_VER_V2)
+		priv_ep->trb_burst_size = 16;
+
 	mult = min_t(u8, mult, EP_CFG_MULT_MAX);
 	buffering = min_t(u8, buffering, EP_CFG_BUFFERING_MAX);
 	maxburst = min_t(u8, maxburst, EP_CFG_MAXBURST_MAX);
-- 
2.40.1



