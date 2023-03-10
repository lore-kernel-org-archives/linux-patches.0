Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F82847D
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24A5C4339C;
	Fri, 10 Mar 2023 13:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678455945;
	bh=0xDsLSsV6SEBNtuAAJ2hEO9Qy7u870I976j/NVk4rLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5RDJyqH1JNRcmdA0HcbHPn4xYmNtAsAO2ECFPfQs5YiKbqg2GCb4R+yD/XfQL5TX
	 SDHFwINMhwCNna82WF8X5jdeCqDuuyxithy1RVtiEAGMx4eq/s3BXMDEIhCsGlZ3UW
	 lpWHuqnUc93senGIUgSICrdlhd22PZ8YPerliBlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 028/193] wifi: brcmfmac: fix potential memory leak in brcmf_netdev_start_xmit()
Date: Fri, 10 Mar 2023 14:36:50 +0100
Message-Id: <20230310133711.886431165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
index 9c8102be1d0b3..55027886f4041 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -226,6 +226,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 			brcmf_err("%s: failed to expand headroom\n",
 				  brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			dev_kfree_skb(skb);
 			goto done;
 		}
 	}
-- 
2.39.2



