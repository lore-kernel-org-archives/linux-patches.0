Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5612AF07;
	Mon, 28 Oct 2024 06:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098099; cv=none; b=rHMU+t5KIaEHvLJRPIMSg+DMfOYiG/XyJ10UxU9KUxzJsvsHcznU/Hy1HeX8vM9wElL5bxpSjf/D2geVNP535y41Kwj9OsHqnyRM3flxE+1gqm2pp+qacdZGXb+g1R5V4cyqRUBybw3eifOz+icv888rjCi+Ky49NvGlVQqX+hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098099; c=relaxed/simple;
	bh=+UQ+9PrSwJ3M4ePU9w+awWNiwmyGJOkJ24A0NpB/Ips=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQ57cfMPtfT1AXC4lRuvx0b/BeQEAe4baG7rTd8ud8Ao1aj3hBW03BxpZw/xlL78LrydQa00ZwfxONVYxsoSdmSMLz5HuEbIKdRLsVwxFoDl0OC1DZcQVuPHsTdWCOa0xHb/gFjgc9CeAOaDkTRBd0Z18xEfNgPqavlZ4ybiYRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5zRC47q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5zRC47q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA0BC4CEC7;
	Mon, 28 Oct 2024 06:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098099;
	bh=+UQ+9PrSwJ3M4ePU9w+awWNiwmyGJOkJ24A0NpB/Ips=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5zRC47qAh0d7BL+0PPWxCL0wsQfw0G8+dxRAlpL6XAnQTIPd5nMagz6vDPk6uGCC
	 COOuh1lEdnql/dIA5czC/IStohi3QHLHikjBjpsW0hUZlEZwc8zB9yl62arz2IcleT
	 pDt1StEybVP7WZ/GOHGqMEm+mxYvkxRoJkbcy2hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 076/261] net: bcmasp: fix potential memory leak in bcmasp_xmit()
Date: Mon, 28 Oct 2024 07:23:38 +0100
Message-ID: <20241028062313.933890997@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 82768b0e90262..9ea16ef4139d3 100644
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



