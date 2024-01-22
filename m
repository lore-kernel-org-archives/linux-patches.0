Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B066774B;
	Tue, 23 Jan 2024 01:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972017; cv=none; b=Ccg8KqW5CakXWf5oArZ9sv73SwsBZOawJ9Kcz6m48awzt/BsTkUiSbQPWNhTj3B1poxMGOKSBiRtUNLH1kRyEkjfLjdxDLAN4PNypGal0oUI4SS7JmMidSLP49I1ExXsJcfwcSWcKIX+wcJPbsg/AZAt+Wmt0XSsbGa41LwnbvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972017; c=relaxed/simple;
	bh=WjCpqle69H6oKSP0Qf8prkXDAs0snknlS4HKTK12SAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UXisBo1lTOw1SYq62FLpGda1MAgRY5Ji6kiayYz9pWor+On0jdNU3uTbhf1e7C6cCLHdtr4+D8snLaBfGSKFara/5Q5AN50b0s5Wx2L1UCcx3UGrMTDqnwfLneHvJYHKFcMWgOYAhdBid/fHsXxomtEBtjXhtE1KVaxhtR94IaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPZL7Y8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPZL7Y8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B64C433C7;
	Tue, 23 Jan 2024 01:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972017;
	bh=WjCpqle69H6oKSP0Qf8prkXDAs0snknlS4HKTK12SAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPZL7Y8Co9olZeDw1Qx5gR3aJrKeDtSKfvdI1gEciGs9MPzBN20IAyTXwSFYIx9tn
	 UV8ScPm2NhInqvcslJgGUXrVU7Zh7txcKuaXo3NrrzR+6YIRUbpicMI+r6MtB56+9n
	 1BHKj87l+I+3MvJv1P2kMfahshSDyNqBIAlcKutM=
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
Subject: [PATCH 6.1 389/417] net: ravb: Fix dma_addr_t truncation in error case
Date: Mon, 22 Jan 2024 15:59:17 -0800
Message-ID: <20240122235805.243498868@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c2c56a5289ca..e7b70006261f 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1965,7 +1965,7 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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



