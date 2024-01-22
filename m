Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C4E1350CA;
	Tue, 23 Jan 2024 01:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971940; cv=none; b=iy8yBCpy7Cx9n74mkT/llMu6r1roIs3wVVcXH3+/r/B89oy7V3bnu0q5RKawiqgihF5+wC263JsmjGO+e9AJNKLlHzKO8eEtQlWZQs5FMLTVNcDiXkUaik4fgOopxKX8mV5KVKh9T/+pYvc2WMZgk9T5gD/j3qeYT6GeGEm8PyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971940; c=relaxed/simple;
	bh=lwuJ03xo6N88D/scfQGgAgYJSRjSmhn+zU9vzG2RuNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CsLBc2BsOuy8qo6R0S00AtnLdH30DowtkQOJB54PVYKsZPSRt8OXUM2w8e9FlVgL0hC/G+k362SDJZOLvDwe8C+sHAyQ3XCjAcnahrP1w89TKqthdDyKDZjWUkqFmsNX4a324Pm7pRLScN2KsAnTYx/WwemDo+UUBr8wDUEkXRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ubr/0rfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ubr/0rfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7461BC43390;
	Tue, 23 Jan 2024 01:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971939;
	bh=lwuJ03xo6N88D/scfQGgAgYJSRjSmhn+zU9vzG2RuNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ubr/0rfkqNY9YVNq5ibuOTqDJHKHrTqG+4ZqkeIvAkgjyxw350Q6uTp1faXCvtPDV
	 TAp6db6vW9Xg+BW6OJxO2xr/BkXxCLfApGkPqBiU5T65xJPk3WBOv8nnl8D8P4YwR9
	 RHyhD2VUAcmZBXTyy8wrUgrFBMSXVD6oO8HEkkIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/286] net: ravb: Fix dma_addr_t truncation in error case
Date: Mon, 22 Jan 2024 15:59:35 -0800
Message-ID: <20240122235742.406796243@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit e327b2372bc0f18c30433ac40be07741b59231c5 ]

In ravb_start_xmit(), ravb driver uses u32 variable to store result of
dma_map_single() call. Since ravb hardware has 32-bit address fields in
descriptors, this works properly when mapping is successful - it is
platform's job to provide mapping addresses that fit into hardware
limitations.

However, in failure case dma_map_single() returns DMA_MAPPING_ERROR
constant that is 64-bit when dma_addr_t is 64-bit. Storing this constant
in u32 leads to truncation, and further call to dma_mapping_error()
fails to notice the error.

Fix that by storing result of dma_map_single() in a dma_addr_t
variable.

Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index f092f468016b..8a4dff0566f7 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1500,7 +1500,7 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct ravb_tstamp_skb *ts_skb;
 	struct ravb_tx_desc *desc;
 	unsigned long flags;
-	u32 dma_addr;
+	dma_addr_t dma_addr;
 	void *buffer;
 	u32 entry;
 	u32 len;
-- 
2.43.0



