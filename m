Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027815;
	b=OEsLYj42rCDM0EC5OUaXjnnRBJQ1vEqyRrj5x2TzkB+qZIQWR5Czp1/q4HConpan+cHa
	 UCoQVY6bCTWoMhwKrRZHnIKJZ1m7b3K7L+ZBjDJUeCelvpXM9CyjI/7YIjiBmtgYWvJDw
	 iTakMW2QhHTU8z6EBiLXNwfmYBQSWMYhCZklemSe5lIoAHF0dtmZLSsz4eCZ05izpa2pA
	 Hx4DCvrBASiQwXS3WkqFziCeHfjnsarQXSzpgtcWIORQTokAkEj9ZQ1zpGQN2ZNtSE1L0
	 F7lBtrTu4IgJ+Njx7DkAjprYrdGUuvH2b0+69CAH9FtRLArNwA1maxZ2CaF8rtOy6xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=778XnexGBELl+4CRcpm7oL6EfAHC5DUP74Aj1iICO0Y=;
	b=fxr8u0/h+FU5Nh5H/WjyVgtwmhW2Yhpq2X5pt4dkZL0xJUqg34NPTlC1UrMPDjdJaKxZ
	 zK8DZbcmiLluzOXzpiBCMnYtxJASQTYKhkiONueuUPny6ODowOU1IMDWjWbhG9D7MtgH5
	 gXag8NPfblsB4INjKRXIIv/eJudKgEI/e6iNzz1B3l80gcOq+qUVddoUo1wOZrDJFMOiT
	 R7gHDLPApPsLcEVJe8V7nJSzsRygzbJwGVcFdji8bcxXf89fKe7EjkF7yh1VYIkN4eHLW
	 /7ZVFl4jhz6Hz8z06lra7mj4KxyBeHDEh3CrTYoxSuI+3CT4ZYQOAK7HP9nVzpXFy2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnSKeosK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48FB606A320;
	Wed, 18 Nov 2026 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rnSKeosK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458051F000C5;
	Wed, 18 Nov 2026 18:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027814;
	bh=778XnexGBELl+4CRcpm7oL6EfAHC5DUP74Aj1iICO0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rnSKeosKXmCSYPPQUltXcMFaz+i78KnzIGs1YvsCU4Q+qznBFVOPff5JI7H77m7d4
	 Zp2OlioJ9TIXPpwmY2f8Qh7/vJbnGNvfyJ+DJ7VFhGfwUpVE3vTxRtRxD792gbYuWL
	 GlsU5X6FGRwO5QRnvBC9z+aM2FnPPZz3BTYw1zrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1924/2151] net: sparx5: fix tx DCB index drift in fdma xmit
Date: Wed, 18 Nov 2026 16:00:59 +0100
Message-ID: <20261118150231.866859696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dbe86f937b210..15ec9b053824f 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_fdma.c
@@ -217,7 +217,6 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb,
 	struct fdma *fdma = &tx->fdma;
 	void *virt_addr;
 
-	fdma_dcb_advance(fdma);
 	if (!fdma_db_is_done(fdma_db_get(fdma, fdma->dcb_index, 0)))
 		return -EINVAL;
 
@@ -235,6 +234,8 @@ int sparx5_fdma_xmit(struct sparx5 *sparx5, u32 *ifh, struct sk_buff *skb,
 		     FDMA_DCB_STATUS_BLOCKO(0) |
 		     FDMA_DCB_STATUS_BLOCKL(skb->len + IFH_LEN * 4 + 4));
 
+	fdma_dcb_advance(fdma);
+
 	sparx5_fdma_reload(sparx5, fdma);
 
 	return NETDEV_TX_OK;
-- 
2.53.0



