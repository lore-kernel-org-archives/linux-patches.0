Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15EF34402F;
	Tue, 11 Nov 2025 01:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823577; cv=none; b=qqHtRIYw73oRXRVY3dJffzniHXGRX9Qrlf0Z+CdoiTjZKNYHkS19dvsafXO0ZjZAEzJZKpWE9op6N1HRWAZwpYvibmnqddcjxPogdEVUTZtsc1yN1+KVwq5Kgf8IgsZ0o+1DUWEJsgThs+8edNAR+8zN/87DBWm9ndtpH4uD2SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823577; c=relaxed/simple;
	bh=A0OTyj9pKIEEROtY7mluokDlXwe7BVJQJe1XZ+jo1ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMKZw0Ve0yhGxXuaxxShK2OGj2zzBa/bFE10mxMVu3cqR4LRvuGVu2BU6Nr8VxnCFTWz3pboF77xs8b0u7RqfSfp0VZxipAzpReJj3CAOPI0XLbD8vk0/pynKop9RoeXr/iBKQ+WVrTI2TuKQGeIbyWHefv7mBn1cjdXf/ePazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTTYV1RQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTTYV1RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1D6C113D0;
	Tue, 11 Nov 2025 01:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823576;
	bh=A0OTyj9pKIEEROtY7mluokDlXwe7BVJQJe1XZ+jo1ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTTYV1RQpehmawPTlAn6xAX21rxhOeAbbWeNuLvlnharsJ0wECN/sdTbo3WoE2poa
	 I96RJ8vcFgzECgYQL8GJBduwacOOg3re12PwmUFm6vn7HQVzFaAEhAuezx+dws4TgN
	 mgKhrSNsohHV8Wbyyc4fCswM+AQgUBXhoImfIMNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/565] net: stmmac: Correctly handle Rx checksum offload errors
Date: Tue, 11 Nov 2025 09:41:32 +0900
Message-ID: <20251111004532.222503719@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ee0aace5f844ef59335148875d05bec8764e71e8 ]

The stmmac_rx function would previously set skb->ip_summed to
CHECKSUM_UNNECESSARY if hardware checksum offload (CoE) was enabled
and the packet was of a known IP ethertype.

However, this logic failed to check if the hardware had actually
reported a checksum error. The hardware status, indicating a header or
payload checksum failure, was being ignored at this stage. This could
cause corrupt packets to be passed up the network stack as valid.

This patch corrects the logic by checking the `csum_none` status flag,
which is set when the hardware reports a checksum error. If this flag
is set, skb->ip_summed is now correctly set to CHECKSUM_NONE,
ensuring the kernel's network stack will perform its own validation and
properly handle the corrupt packet.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250818090217.2789521-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 16f76a89cb0d0..04bacb04770fa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5658,7 +5658,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
+		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb) ||
+		    (status & csum_none))
 			skb_checksum_none_assert(skb);
 		else
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.51.0



