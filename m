Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032789;
	b=obpMkh/9nlqrDhej31fEcH6AS77dFQJaLPfImCwXEdUUqbFuCZCYHpd2DZB7YBRi8pV1
	 e+S3E3DMBGJzWk4TXuA/Gx+ISeWJBQ35sG+XHV7PfZSVDHCPwXdRivih3Xwxp90hwEiny
	 +hCoLc9BnR+8EL+KnRKslTFIGCRZKOzRjGaG2NygelYDfmi2jJ6KJBcBSiIUsceeYEfV2
	 3cofjSx2KaGr8xX0qjFwfalxEwbJulMW1Qv8Yaool+Da6gFLBEeijd09Qx6cv3YIWMmjI
	 kY5EF5jLAhhn732a0fXo4A7z9sLeGeSxhWb+Ze4iyWBJ4ILOF1N4iC1NJjJiE0LODXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HinZpb6I6bhK9WTuNTSOVrusPoWdjUXKtFgZTCQueb8=;
	b=NID4w2g4u0a9ofpaC0BambcNt40Yztv/tCiuHq7FOfYNqiMVFgoECup3oM67PCtwCCCF
	 i5k3ocPLvBejIerXX7/P2NDTOUCRN7p1yIolgspyVnXFZNPxh2SQggq5GcsS9PwkfYx1L
	 f2sXvTAGcEtu6q4S6DlibqefHrwED8l545sQXdqCoxILELT8EP9zA5Ui8e/VXU4dWbC4C
	 AfHklZ9bxDxUdi8+oOEra9WSBvYbf5B19/FouPr+Tbt5lW3nr9CUz9sqrUoZ0UZbhLMRC
	 tCKMnyYGbbLU4JFLfKWfzT0MbAFWZuQRCvEttiH0W5XQ1Yvl7+DGuD4Q1M06zUm2NgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FRuZMH/w";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23978606A320;
	Wed, 18 Nov 2026 20:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FRuZMH/w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C9C1F000C4;
	Wed, 18 Nov 2026 20:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032789;
	bh=HinZpb6I6bhK9WTuNTSOVrusPoWdjUXKtFgZTCQueb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FRuZMH/w2jSQOOWNBPjga4dF2lPzPr2vvSklyAnQDwjO3ZbNPu0sp8kkJM0L/hhEY
	 2rstnrPxdaswA7JQWnRJrp/a2s1vMK9WZSNxZA2RYBHcUjh2vf75ersoHa0VdhQHCc
	 f1qLWTrAgSHkbQnON8CXKvaS8G8IEu3V4U7JSWUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1536/1756] net: sparx5: fix tx DCB index drift in fdma xmit
Date: Wed, 18 Nov 2026 16:01:03 +0100
Message-ID: <20261118150110.097502471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 1df26063ab9ba64f5fb11049fa4be686b7fc309e ]

sparx5_fdma_xmit() advances dcb_index before checking that the FDMA is
done with the DCB, and does not undo the advance when the check fails.
Before commit f4aa7e361ae2 ("net: sparx5: use FDMA library for adding
DCB's in the tx path") the next DCB was always the one after last_dcb.
Since then dcb_index drifts one DCB further away from last_dcb on every
failed transmit.

While the ring is full, this drops frames even though completed DCBs
sit behind dcb_index. After a run of failures, dcb_index can also land
on last_dcb itself. Re-adding last_dcb loses the frame, because the
FDMA has already passed the tail of the chain, and that DCB is never
completed again.

Fix this by making dcb_index the next DCB to use, and advancing it only
after the DCB has been added, as the rx path does. dcb_index and
last_dcb now only move together, so dcb_index always points at the DCB
after last_dcb.

The issue was found by an AI code review agent. It was reproduced on a
sparx5 PCB135 board with a modified kernel that forces 63 consecutive
transmit failures. Afterwards, about 1 in 64 frames is lost for good.
With the fix, the same test loses no frames.

Fixes: f4aa7e361ae2 ("net: sparx5: use FDMA library for adding DCB's in the tx path")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021-sparx5-fdma-last-dcb-v2-1-7b8fabdb9239@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
index c21f643423275..95f8116b34633 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -217,7 +217,6 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 	struct fdma *fdma = &tx->fdma;
 	void *virt_addr;
 
-	fdma_dcb_advance(fdma);
 	if (!fdma_db_is_done(fdma_db_get(fdma, fdma->dcb_index, 0)))
 		return -EINVAL;
 
@@ -235,6 +234,8 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb)
 		     FDMA_DCB_STATUS_BLOCKO(0) |
 		     FDMA_DCB_STATUS_BLOCKL(skb->len + IFH_LEN * 4 + 4));
 
+	fdma_dcb_advance(fdma);
+
 	sparx5_fdma_reload(sparx5, fdma);
 
 	return NETDEV_TX_OK;
-- 
2.53.0



