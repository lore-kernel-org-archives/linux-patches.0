Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84708489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:16:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C089C4339E;
	Fri, 10 Mar 2023 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457789;
	bh=XBU8D8qCTdri4yb2hdbXJsnfT83G4IlUS2XpdONSXBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZkHYedMKzlGQzZD3IgDwyg+00U01S2aRcNr0WtF2Z3+01NQb4mNkOWJbdnGcc5rd
	 tbB3Y4aAZ1U0PnQD4id2jQ1hMA4B6eK5XXJeB7Tlfb+uMxHWp47pF7cRStHkKXGitZ
	 SJru6oPnT6ZrFiMR8/ltJOERdBGTF85XEK6hPsZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/252] wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()
Date: Fri, 10 Mar 2023 14:36:38 +0100
Message-Id: <20230310133719.668933755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 212fde3fe76e962598ce1d47b97cc78afdfc71b3 ]

The brcmf_netdev_start_xmit() returns NETDEV_TX_OK without freeing skb
in case of pskb_expand_head() fails, add dev_kfree_skb() to fix it.
Compile tested only.

Fixes: 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1668684782-47422-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 31bf2eb47b49f..6fd155187263f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -313,6 +313,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 			brcmf_err("%s: failed to expand headroom\n",
 				  brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			dev_kfree_skb(skb);
 			goto done;
 		}
 	}
-- 
2.39.2



