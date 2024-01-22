Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FB4130E42;
	Tue, 23 Jan 2024 00:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969069; cv=none; b=ULkxaLO6nnJcD1m3vl6yBYRQNo+uVCC5i4Ay+/gFbokz6IWK7na+2peNss0atJuPSt3g58BgLC1HGv6Cg0koxwmcUfTUgxkjvoDxvBuCN1lURgC5whyaAi0YVD3yeJFBY2NgG9r0faNg+dzMeozrR/HdjK5WbB9YsNmn0fvyTwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969069; c=relaxed/simple;
	bh=WyvD9Fl4sxD8dchNv/DQ6e11ltQFhN3Q0zPkBhCQIpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EWEeAvLkIkeZj0r8M90Qm+wAuxmQ5kkyB7Gvm/bg00gj980RxMrGJtUtavaGfhPItCIQwpgJEbUtb3XKSlwktbqi7wiBxRS+d8GFh/LLIJ4VLXnIpNvcMJPVqGXRGPJu0E76Obmjnd3UhfHk/BH6jWy6zCr3Wewd77ILyuU2n+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w32OvY4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w32OvY4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71892C433F1;
	Tue, 23 Jan 2024 00:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969069;
	bh=WyvD9Fl4sxD8dchNv/DQ6e11ltQFhN3Q0zPkBhCQIpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w32OvY4MQfzqrfyt7zfGK/7hxzjPmKWrmH0xPsG1pqBTltGpPQ4Ela7yQ4UBwg9nY
	 89o6AZH+2ToGh+cQPNHVpzwcHndlv/Y0F4zJG3xAIH8UiUUi22NFkhNy/9fEwMVMST
	 Fysg8uyKLi0vXLTBq/g2LN6uVfrZjZ4Jt203zqk0=
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
Subject: [PATCH 5.4 185/194] net: ravb: Fix dma_addr_t truncation in error case
Date: Mon, 22 Jan 2024 15:58:35 -0800
Message-ID: <20240122235727.161873220@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 42e62f51ba6d..53b9c77c7f6a 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -1497,7 +1497,7 @@ static netdev_tx_t ravb_start_xmit(struct sk_buff *skb, struct net_device *ndev)
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



