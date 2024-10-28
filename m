Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026242C697;
	Mon, 28 Oct 2024 06:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097591; cv=none; b=KARHY2PYIVfkiTuppPaqB6yvgSRKKTGSN/65wHXr3RLHIdBGxyNmthVupYh0ER5vSHO47mDfEgaLBAJANv2mpwsAdeTfWAE+IjoDjIUWCjvo2H63u4xGkR4LozRRAqFsqkzC5zFGkQwbW/W8fdNzETggTS/3Bb5ZcAlKDJ6otxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097591; c=relaxed/simple;
	bh=CIhdBmEToAOqUfz29ttJ0Xwc4V+XIf6YY6wzTPUSG3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eR1YyfknYXs2kyjVlr1HJ2sSch27UT6nHRfXk50G7TSFpxO+cYM7XJ37EiX/4fzSTPgRk+WUwshD5gG7qgbWtTt2yBBANct53jNipH7yuf5x+8wFxfLw64riMbn1B3IZD3qhAfJ9+ZyWWhMWNUmY0otHVKIlM4qEzls+9DrYNns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/6clBRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/6clBRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F55C4CEC3;
	Mon, 28 Oct 2024 06:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097590;
	bh=CIhdBmEToAOqUfz29ttJ0Xwc4V+XIf6YY6wzTPUSG3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/6clBRloAd4qu4B81AIA8F/eeUqPKQx5QXvwJzdVxAd8mGkx61G+KCCAaK7LPUBB
	 StjbtUZMQhbHe7UU9L9Ssiyo+vbdT6RKI93YsUlIYIsmUbyDcrVAxh7icZs+XV6t2S
	 J1edH4zEtj928etXpsPN0WBpPsZFkKgyXpW8t8fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/208] net: systemport: fix potential memory leak in bcm_sysport_xmit()
Date: Mon, 28 Oct 2024 07:23:59 +0100
Message-ID: <20241028062308.110062596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf1611cce974a..49e890a7e04a3 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1359,6 +1359,7 @@ static netdev_tx_t bcm_sysport_xmit(struct sk_buff *skb,
 		netif_err(priv, tx_err, dev, "DMA map failed at %p (len=%d)\n",
 			  skb->data, skb_len);
 		ret = NETDEV_TX_OK;
+		dev_kfree_skb_any(skb);
 		goto out;
 	}
 
-- 
2.43.0



