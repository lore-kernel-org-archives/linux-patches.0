Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C046E421F1F;
	Tue, 31 Mar 2026 16:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974646; cv=none; b=O9sCL5wvXKqXkjAPc5XrUwz//1I2g1xOFcLAzxf+G3OWMmWm3RYm4FFIKawlmERo+k8hlYBK+8CJuZsRsJ6qzRiMBrXGF/tpsYF1bUvavvlkpN9H2VovTdiAWV4wTBu5GqJn8M+nejvcU1iwZenEgRbGhKlgypV+/yz+17qZd4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974646; c=relaxed/simple;
	bh=/vWOAha95RU6gcqfMndIwMubfY7Pj8F58dHzD9jCalk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pmOTLYJCMMZy7nsWon123RX5ZN3fxRgRb8Yo/plDyTZkNRIgN0/OMCpPbyddmfXe75v//eYPgz8V2Q0CNVWLKgXVGJlB5ekfOIOe4p4VkE2C8FJ6PIbGlIycxNVvkieoUoydlQE7eb77uq3Gn98Gzao2SP9guGH2xqV2QiQyFYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UjFMJh66; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UjFMJh66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12521C19423;
	Tue, 31 Mar 2026 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974646;
	bh=/vWOAha95RU6gcqfMndIwMubfY7Pj8F58dHzD9jCalk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjFMJh66HVpUgG9aNL9lnSFz8+k8z7Dm67oCk++qxs1cExOooB7A5pnaB3JRdRAbb
	 7+yE/lIEIObZJiNvTGi2fT7OMvc2hRiu+IhASVsPRO/RVtBvTtfMZXWr/Clyz+9weI
	 54rO57vlQNS9tzasYWsRwdjgz+e3ubPCz7ObE+8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/175] dmaengine: xilinx: xilinx_dma: Fix dma_device directions
Date: Tue, 31 Mar 2026 18:22:29 +0200
Message-ID: <20260331161735.858557283@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

[ Upstream commit e9cc95397bb7da13fe8a5b53a2f23cfaf9018ade ]

Unlike chan->direction , struct dma_device .directions field is a
bitfield. Turn chan->direction into a bitfield to make it compatible
with struct dma_device .directions .

Fixes: 7e01511443c3 ("dmaengine: xilinx_dma: Set dma_device directions")
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260316221728.160139-1-marex@nabladev.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 176cac3f37a73..f2006e6996220 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2901,7 +2901,7 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
-	xdev->common.directions |= chan->direction;
+	xdev->common.directions |= BIT(chan->direction);
 
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
-- 
2.53.0



