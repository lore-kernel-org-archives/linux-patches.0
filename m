Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA69A1FA8F1;
	Tue, 17 Dec 2024 17:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456656; cv=none; b=eiSggl3wppnkE2vkGs8s9BLX4VX+EjL6NO147eJNqPE1oOnG9loM2x7ug20ATZMlmLoQ8h+XHMQRp99Q4tVwu4kfJ6HgQnYRXs5wB1WiJVlif5PIt75mXP59uiYjLgO1CfyEPbzMk//94I5TJeD9xnPmn9Q4xajSC5RU5ZbvWQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456656; c=relaxed/simple;
	bh=MrZJ8+2B0exVMMhfclbnbjaAER+blynkmmAkokiHz+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1a+Kmw8f8vRksa6uHrZ1vDUgNOR5/t2V1tRCrxhK0J+EVdrl27n2VmulzBhyFNYwjUtnkp2zNQJHsOLe5YKJdTljPcl42H8VR9N07ePla1o7187aFzwkVBTkqAypTdK3dzfMm6hCmVQfk3P5fRJsTzNAqwPm/klD/t2Impcwlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G27kvbeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G27kvbeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5822C4CEE0;
	Tue, 17 Dec 2024 17:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456656;
	bh=MrZJ8+2B0exVMMhfclbnbjaAER+blynkmmAkokiHz+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G27kvbeExEzngE6+1ALAl/B2QNNHVsebfA5iAnlTTmznbiZ9jgH5dat+NMQsNxxWp
	 mUbwzPHjy8X1cF+NEqubwxww6izQQOafAhgY3VkZGGS/54cDNBH1/eSz4KjWivylQ/
	 J6ACr79dpjdTqsJ7ml36PczxiH4XmOrfgvSD9/co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/172] net: renesas: rswitch: avoid use-after-put for a device tree node
Date: Tue, 17 Dec 2024 18:08:02 +0100
Message-ID: <20241217170551.568603594@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 66b7e9f85b8459c823b11e9af69dbf4be5eb6be8 ]

The device tree node saved in the rswitch_device structure is used at
several driver locations. So passing this node to of_node_put() after
the first use is wrong.

Move of_node_put() for this node to exit paths.

Fixes: b46f1e579329 ("net: renesas: rswitch: Simplify struct phy * handling")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://patch.msgid.link/20241208095004.69468-5-nikita.yoush@cogentembedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index af0bc95ad6ae..3b57abada200 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1891,7 +1891,6 @@ static int rswitch_device_alloc(struct rswitch_private *priv, unsigned int index
 	rdev->np_port = rswitch_get_port_node(rdev);
 	rdev->disabled = !rdev->np_port;
 	err = of_get_ethdev_address(rdev->np_port, ndev);
-	of_node_put(rdev->np_port);
 	if (err) {
 		if (is_valid_ether_addr(rdev->etha->mac_addr))
 			eth_hw_addr_set(ndev, rdev->etha->mac_addr);
@@ -1921,6 +1920,7 @@ static int rswitch_device_alloc(struct rswitch_private *priv, unsigned int index
 
 out_rxdmac:
 out_get_params:
+	of_node_put(rdev->np_port);
 	netif_napi_del(&rdev->napi);
 	free_netdev(ndev);
 
@@ -1934,6 +1934,7 @@ static void rswitch_device_free(struct rswitch_private *priv, unsigned int index
 
 	rswitch_txdmac_free(ndev);
 	rswitch_rxdmac_free(ndev);
+	of_node_put(rdev->np_port);
 	netif_napi_del(&rdev->napi);
 	free_netdev(ndev);
 }
-- 
2.39.5



