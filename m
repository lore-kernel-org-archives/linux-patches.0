Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE852C697;
	Mon, 28 Oct 2024 06:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097683; cv=none; b=dp+nVgNGz9nyOvgrm20l84tHYF6ONYNS0AkSRgN4ZqP6jJ+2GVvj3KwcSUGyljC0Xm5Th5eRZfVfb+Xdsyd9KewzHQix09Mlk7iWR+jWJXSqBQEZFRzdgI4Qs1dkBwEHa95S33cLijOXxpnUl1Y3Wz4m9VJ/2EuE3f3H5ilEJLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097683; c=relaxed/simple;
	bh=RmA09PuJT7bP+u/hIfPQWapYUaeSO4EA/Y848uUArBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seiVKAabcr78uDSdGt3Yv1UWh3NRp/420NborBkYKWF17tgact1zVln9qB8R5xVio298ci71axNNDc2V7br/um/Rc14NgjjGq8MVvu1vGaFxy4xJgGqQ8N3E3yUPtqRqd4ZIk9jJ49Pg4UqHNSdkEl7RK1tPmVrvPaH91kEFqN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCHbahU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCHbahU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748C6C4CEC3;
	Mon, 28 Oct 2024 06:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097682;
	bh=RmA09PuJT7bP+u/hIfPQWapYUaeSO4EA/Y848uUArBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCHbahU14d85YEzRHJFl3J+BkPPGPHQf9+BKYiIIqwmH3C2srRtbYz9GeQcJUsYIC
	 h2UEiyulG7KU0WQ5+sXJ3xZaARtuqGQDioEay1YJA5pduj9LBGeGhE45U1M/TQYqwK
	 prCOq6/2/FQL3wLIWP/j4t2Ub/7eAaXsgeQFUHsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 065/208] net: bcmasp: fix potential memory leak in bcmasp_xmit()
Date: Mon, 28 Oct 2024 07:24:05 +0100
Message-ID: <20241028062308.254766197@linuxfoundation.org>
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

[ Upstream commit fed07d3eb8a8d9fcc0e455175a89bc6445d6faed ]

The bcmasp_xmit() returns NETDEV_TX_OK without freeing skb
in case of mapping fails, add dev_kfree_skb() to fix it.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20241014145901.48940-1-wanghai38@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 6bf149d645941..f0647286c68b2 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -322,6 +322,7 @@ static netdev_tx_t bcmasp_xmit(struct sk_buff *skb, struct net_device *dev)
 			}
 			/* Rewind so we do not have a hole */
 			spb_index = intf->tx_spb_index;
+			dev_kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
 
-- 
2.43.0



