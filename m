Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91041A76A5;
	Tue, 30 Jul 2024 17:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360665; cv=none; b=V7QqsipUfDkeQmey1uUPAVHcjJDEKl2oERHVJBy6sF4lq1pL8Wx/EDT3fY9zoVe5RH1VF5X9MjURQ5oLl+3dgqn37A3vEg7q7GsGedgLJfmIz+cN5mDwe4NGX2Lyx5O5HEr0kNVYL530hmwagSqz/bmAZ1z9CXXzAR261rjAI3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360665; c=relaxed/simple;
	bh=yf3E1id5Qyf0iOJSM0yLNd7IbbEPt/dpJC2RGR6mj74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sgEnvTrASpOZDu1J24DfO+blldqeu+aOt4n5ynqlMtLmPU4rs6TxzzvneOu0l+a+GEuQtujKQI6HB86yYwZydliS7YM8w2CbToIKJyca+DM2YJAEGTEVLBZWWCI0M9stYDylsaFunl8HWQW6LYlNW2IjToFtV2+EfauEnJnB0Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DQd8DLWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DQd8DLWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C42DC4AF0C;
	Tue, 30 Jul 2024 17:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360665;
	bh=yf3E1id5Qyf0iOJSM0yLNd7IbbEPt/dpJC2RGR6mj74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQd8DLWSgSBsyGIlfCBbJAGQ2hvE5vYOudFvXWWUCv+jh4o9Vaw/SKPD6TJjVKp4r
	 tqyntlGQ6ybDxOimT2DT94156eTc0/Nw+ZadatdZD+ca9GUCfKMN29E6NH8OG6EOoC
	 JIRXZo/IYdqONdBsF7Dipz5jm3SJbzlbJ97FDO0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 770/809] net: mediatek: Fix potential NULL pointer dereference in dummy net_device handling
Date: Tue, 30 Jul 2024 17:50:46 +0200
Message-ID: <20240730151755.377799711@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 16f3a28cf5f876a7f3550d8f4c870a7b41bcfaef ]

Move the freeing of the dummy net_device from mtk_free_dev() to
mtk_remove().

Previously, if alloc_netdev_dummy() failed in mtk_probe(),
eth->dummy_dev would be NULL. The error path would then call
mtk_free_dev(), which in turn called free_netdev() assuming dummy_dev
was allocated (but it was not), potentially causing a NULL pointer
dereference.

By moving free_netdev() to mtk_remove(), we ensure it's only called when
mtk_probe() has succeeded and dummy_dev is fully allocated. This
addresses a potential NULL pointer dereference detected by Smatch[1].

Fixes: b209bd6d0bff ("net: mediatek: mtk_eth_sock: allocate dummy net_device dynamically")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/4160f4e0-cbef-4a22-8b5d-42c4d399e1f7@stanley.mountain/ [1]
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240724080524.2734499-1-leitao@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c84ce54a84a00..c11bb0f0b8c47 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -4198,8 +4198,6 @@ static int mtk_free_dev(struct mtk_eth *eth)
 		metadata_dst_free(eth->dsa_meta[i]);
 	}
 
-	free_netdev(eth->dummy_dev);
-
 	return 0;
 }
 
@@ -5048,6 +5046,7 @@ static void mtk_remove(struct platform_device *pdev)
 	netif_napi_del(&eth->tx_napi);
 	netif_napi_del(&eth->rx_napi);
 	mtk_cleanup(eth);
+	free_netdev(eth->dummy_dev);
 	mtk_mdio_cleanup(eth);
 }
 
-- 
2.43.0



