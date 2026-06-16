Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EAC33AD9B;
	Tue, 16 Jun 2026 16:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629200; cv=none; b=sLdr12Ot4NgATfs7OZJ4Al4BNPkNbWSALEXHY2GZyRZL67oB/Rm9RfYFjbSs5T1o3kZJNUCp7MYDWadgZrNyth2z0gE9peA3YoVNbql7O7VpzR+nfwgICimScvv0PWWrz9TGdRfj2DNc2GNmL2TLaiSgTZgKugKrlDzzH+KTqyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629200; c=relaxed/simple;
	bh=o1sSYpAX0+ik9o0DQTT55T39cx5UF5P5bjpFjNtlv+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4QfViOXLEApuRYvVwx+qD/Uqsi5D2C9uRYwHabBVYHzuw3UYp1kBOdesV/Qki0Ff4Ua1eO5fDa3j5US+jdym5guEFBsvz6jGMI05w3RynVfRgdLIwJC8Vq+ubxLrvpP8rWDAZYuD+nlg23eDpKxPDrBdXsBqEEQNIqx93u5dXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eM3eWPrt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eM3eWPrt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFA21F000E9;
	Tue, 16 Jun 2026 16:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629199;
	bh=jje9zgTViTQvvoEyA7gdWrwF7qFg6E0X9qxq01UKFnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eM3eWPrt4WFCNEjfmqTQQI+Mrgouwvsl/dQymReusBA/eGgPGlxVo5g8qu+PqfFLI
	 Xzr7Xs6kSG638PAKomAPlQEzzcROrYJy/iFNhP0wclrKTEaF0wmaESQy3O1kbqhv/4
	 Tuc9pPZIeqSwIjG7Eh0s8OFN1OMM59aynPK11bWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/452] net: ethernet: mtk_eth_soc: Fix use-after-free in metadata dst teardown
Date: Tue, 16 Jun 2026 20:27:47 +0530
Message-ID: <20260616145130.298033812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 80df409e1a483676826a6c66e693dba6ac507751 ]

mtk_free_dev() calls metadata_dst_free() which frees the metadata_dst
with kfree() immediately, bypassing the RCU grace period.
In the RX path, skb_dst_set_noref() sets a non-refcounted pointer from
the skb to the metadata_dst. This function requires RCU read-side
protection and the dst must remain valid until all RCU readers complete.
Since metadata_dst_free() calls kfree() directly, a use-after-free can
occur if any skb still holds a noref pointer to the dst when the driver
tears it down.
Replace metadata_dst_free() with dst_release() which properly goes
through the refcount path: when the refcount drops to zero, it schedules
the actual free via call_rcu_hurry(), ensuring all RCU readers have
completed before the memory is freed.

Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260602-airoha-mtk-metadata-uaf-fix-v1-2-3aaa99d83351@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 74cb96dbff9ee4..6de783fe116ce8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4246,7 +4246,7 @@ static int mtk_free_dev(struct mtk_eth *eth)
 	for (i = 0; i < ARRAY_SIZE(eth->dsa_meta); i++) {
 		if (!eth->dsa_meta[i])
 			break;
-		metadata_dst_free(eth->dsa_meta[i]);
+		dst_release(&eth->dsa_meta[i]->dst);
 	}
 
 	return 0;
-- 
2.53.0



