Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D991718E37C;
	Mon, 28 Oct 2024 06:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097217; cv=none; b=suLOifrknQqtxpqB7m1F3juWy+YU9gbHhk/MYoeFuPkjtVZ0UI2PrRfheetMqPVD0rkc8TswvnPL3PrZTHQuEI6TV+92ArOezyAJJ+83wa235RaPwOlzYzfdn/g855eCLMFvzBm0cdT4GDLCJSyeemqv51oqhvyPCRJVHzLQVNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097217; c=relaxed/simple;
	bh=ukMEKbwS1EbOS6HiDq/GWxJyeBCUzINhn7IJ3VdqLKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jz0UanXKPX2GkimlW8Snes4mfeQ7khNzjrdm+Jmy+QbIHzvp37kOq4aBhyFyvAv8sQiSwBvPkBjLz2lyntbaEOto/Ur6DaCEenmCDmm9GcdacK51bgqdJa7p+K9ylMAYElPEH/luz/vmOsILEOXxF/IsPXdj7O0L5tA4sUyroRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eDchz5/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eDchz5/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D640C4CEC7;
	Mon, 28 Oct 2024 06:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097217;
	bh=ukMEKbwS1EbOS6HiDq/GWxJyeBCUzINhn7IJ3VdqLKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eDchz5/UdsQt3/FZHwpaeHhZIOpG/VAhrgkqHa7IQTCpAB9XfhUg3PLW9IZpwPfSW
	 ZCm4tD0ODLM0gxiz1dI/YOZeTdRB6+PYAJcP3UqqHv4QZLqs4aeHVHF8RFMVYGVEhm
	 SpdZ8zEdXtEH9J12KLgNy6M1tsZvL5iTZHS3JI6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 035/137] net: systemport: fix potential memory leak in bcm_sysport_xmit()
Date: Mon, 28 Oct 2024 07:24:32 +0100
Message-ID: <20241028062259.706543084@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit c401ed1c709948e57945485088413e1bb5e94bd1 ]

The bcm_sysport_xmit() returns NETDEV_TX_OK without freeing skb
in case of dma_map_single() fails, add dev_kfree_skb() to fix it.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://patch.msgid.link/20241014145115.44977-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 425d6ccd5413a..1693f6c60efc7 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1348,6 +1348,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		netif_err(priv, tx_err, dev, "DMA map failed at %p (len=%d)\n",
 			  skb->data, skb_len);
 		ret = NETDEV_TX_OK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



