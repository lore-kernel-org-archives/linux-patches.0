Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626346;
	b=jmxWuK2+5wq5sT9AIYbijQ2ZAQLb+LJuPJNPBaDZCbA4ZBZ515K3k3Tgxm2RmCU1EVPQ
	 BSs6AIOXwFxZ/hqeAO4a/wSfEBDOU/h4ScARydCaiw3irHONBQ3AIkIFzcqXxAfnmI6HW
	 17bNDKMnWNP3GToJ4FX3s/cGMxdHPhFXT/8MKWzJR2Kf5SlZMbiM1FK7HmMRyla47/vGI
	 H9pIlwFgdTPFfVTdEZXWEVERlKUdvbOI3EM0IgewPF7ivTogigvvI8Vqkp5NEN3yWHAs5
	 41K7Un0imhqvzHaykJ9krkIEsBIw+fz+XbeMBci66FyqxBVOQwm7JCVYoymKbl5lOIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1SG0EZDdv+Km0fSmROA3w82piww/bSQyOE1i9ofx3D4=;
	b=pELP8EevOH3Dq/rrpyzgn/Ky2lHko/iprIRatNoTaUBQQwq92W1bFgbjFIXrSDxx4l5V
	 yllrWlWkE9tYdSV7oyjOa8P1IUrhNidbueUs6kbCQ/sh8biBavN7yRsIoV/cB9hxygVz4
	 /6A5ZLbnScOTpKUkDeSQ3ZonmMj7/Gn6hG4TZ7FKUc1KbvNNIxTDnfkLiiAeIcO5A8Q5P
	 K28D94viNMGob/ydPVO9IDmai4B2UjXMxiRn8qCw1T1bN/T/8h/dEJNm/JoiO0LCNBZty
	 zTbE8LLFvaoyK/xwiFWnPC817EPjw5UT9MdpwBf8UqpfxfHzs+2jSHibYCclgsaYCsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHLqipTf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C51D606A321;
	Wed, 25 Nov 2026 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bHLqipTf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 995681F000C4;
	Wed, 25 Nov 2026 17:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626346;
	bh=1SG0EZDdv+Km0fSmROA3w82piww/bSQyOE1i9ofx3D4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bHLqipTfpI645O5u0kDHo2AemGRZtQrXP7KXf0mcZImT8rDYV3DSai6EfsZgwP4Y2
	 nVB6l4ZtjuDtvcpmHR7ggYzjqcdlErrsmqqblpFm4Z26DGqurQlY9J1N0yLYiDGY1y
	 XnckHSIHMwu104qwV1huKaztiPZs6qRRixTfRlmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 814/816] net: stmmac: clear stale buf->page after recycling on skb build failure
Date: Wed, 25 Nov 2026 15:39:22 +0100
Message-ID: <20261125143908.012931884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

commit 0a7822e34a0bfde31b194ac3da3253e5032b44cc upstream.

In stmmac_rx(), when napi_build_skb() fails the descriptor page is
recycled back to the page pool with page_pool_recycle_direct(), but
buf->page is left pointing at the recycled page, unlike every other
consumption site in the function which clears the pointer after handing
the page away.

With the stale pointer stmmac_rx_refill() skips the replacement
allocation and programs the already-recycled page back into the RX
descriptor.

Clear buf->page on the napi_build_skb() failure path to keep the buffer
lifecycle consistent with the other consumption sites.

Fixes: df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX path")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260921-stmmac-fix-napi-build-skb-error-v1-1-3d54bf6d9bb6@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5710,6 +5710,7 @@ read_again:
 			if (!skb) {
 				page_pool_recycle_direct(rx_q->page_pool,
 							 buf->page);
+				buf->page = NULL;
 				rx_dropped++;
 				count++;
 				goto drain_data;


