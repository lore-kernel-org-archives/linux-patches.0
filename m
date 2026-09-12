Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D138137CD32;
	Sat, 12 Sep 2026 08:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200918; cv=none; b=dTAXxg2KVcKsSt2GsidCVu5BCElCfK5rNOf1h0k4KY+xf5XLS3XJtxLg5GlGioLZyY+t0uyIOR4XrqQEhRwwn4RqJ8fQ1poxoKD+kBuoa8djiTIbaFwZSd8Q38oeBkCPJL766hBdWErEcyr4XcVVLj0qCmZ8fAqQ97Rp6LIFBm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200918; c=relaxed/simple;
	bh=n8zJxYN4CV1Eq49B1XVMvLahHZ1xPfnbeHjveuxt1qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m88Uff63v67bR8CPyIpI1NQ+24h3z39a+ZDGmnkNBh3+rwHOIuFbU9jmKbrV4Ew9ewbLw52EcqIRxUpiEZGp8vvEDbXINPXa9QPJu//mHY48jtyOYjR7KGjXzeKzIKN8CzCeGVklFcEq2nJcD+ceEMHe0swUFKic+ctZh8pLch8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jxN6M37R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxN6M37R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B13F1F000FF;
	Sat, 12 Sep 2026 08:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200917;
	bh=W7/Flfjl5OLexxcu0AYuIy0c5EmKtGskSNAX5MjZV8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jxN6M37R7IOgchhS8m4HB7ilRuGiQUvDqFa5HY9smO+XFifq96JRoZdZVQTDHczwN
	 AxdDtHlkS9zKG8RjHoXG3yiH97eM7wQHtsmnOG/6nzc9TK0aIebm3GahSe/2hasbaI
	 zB+WXw5fjNvMOSIWsJ/bLu947meMJ1vj6kcja2iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0889/1815] wifi: mt76: fix RXDMAD_C buffer recycling race
Date: Sat, 12 Sep 2026 08:43:59 +0200
Message-ID: <20260912065709.790009676@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit e1f97c10a4ec2b9db69a134b757304399ca903ce ]

The RXDMAD_C buffers come from the RRO data queues' page pools, which are
bound to a different NAPI, so the direct page-pool recycle used here could
race the owning NAPI; take the non-direct path as is already done for WED
RX queues.

Fixes: e50d4d710efd ("wifi: mt76: Add mt76_dma_get_rxdmad_c_buf utility routione")
Link: https://patch.msgid.link/20260722082610.2699628-17-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 8a9087427231a..687e659f40873 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -990,7 +990,8 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 	struct sk_buff *skb;
 	unsigned char *data;
 	bool check_ddone = false;
-	bool allow_direct = !mt76_queue_is_wed_rx(q);
+	bool allow_direct = !mt76_queue_is_wed_rx(q) &&
+			    !mt76_queue_is_wed_rro_rxdmad_c(q);
 	bool more;
 
 	if ((q->flags & MT_QFLAG_WED_RRO_EN) ||
-- 
2.53.0



