Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045965;
	b=dCDZhsUhvwJCM2Jdgh6ipDo5hHB9mm4lHKp88UHoGs5P7IwklBEm89rYZcSR0WKAOsUk
	 bWFUY/X7CXvkTszLJoh/QHVhIP52TdndAbpwbn54L/Lcup2O6FweyFGQtu/RtpMokVwt7
	 NzPWgnsChHjIrzeYQpPVLmveJr5UayaR53HAwTOKNa09CX9ZpvRTrPYF8nIjLoK+7TlNl
	 m0yBNHkgB0uxvX91U0bA7GT4/xbRrNRE/C+JxoFNOgPJjKMl1N9yui6jMlerh+vW9jLiX
	 UbljgLRL8PORSKVgfUruQLcZOiQ9GrGpbTfGnym9LoGlPJWwwq+ngs/XrXrZPbbHdkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9wlfG4JScfiMJq8GZh/vhWtDAp+eLJpV98eD3M7k5EM=;
	b=T+4FJyww37u4o3F5fWK2ELz5+gg2N99tmu86Wf+htlVdA8Q0TcI8wr/fi8KHUTYVoFT9
	 sumxYdL7T+BZsqnJpUfEHk+CWclEE8g72RA0IGVthQmhpGQdRjYfcK0qdCeY99IXJxAe5
	 CFvnBLw11pT3FVpISfg125pJZ1em4Sd/7MhnbCmT46XGMCjraV8IjUmSslgFjYRkwA8/B
	 0oGYEFkxqaCbdanMA1upSH8dBrx90K9IIw62J4N4+3u0yTtZvOfPVyNCd+lNHjTwcEHk7
	 ttYrQJpCmDQ5BR8yT+Y4jblSOk9iZ/gJ3pnBf31l3dTqHe44dA7pVgLpch6DMuZYLDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVSx8XrO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D79606A32A;
	Wed, 18 Nov 2026 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nVSx8XrO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C351F000C4;
	Wed, 18 Nov 2026 23:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045964;
	bh=9wlfG4JScfiMJq8GZh/vhWtDAp+eLJpV98eD3M7k5EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVSx8XrOsw/q6XULNT5Y8D3JKUVG349LmiVCZJaVvYOwLpzjyrKyt+lYbCrVntAno
	 7DtfG2Jibw/JeGFPuV7w93r9NnUH57CYP5ZCUHk8XwyOVA05Opqur9SsSCSUMWSnJl
	 jrJh3kaVb35VeJ/N7gmrfY/SbFLb7nRC6iPjsqVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1075/2857] net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring
Date: Wed, 18 Nov 2026 15:35:09 +0100
Message-ID: <20261118150240.316020713@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit d54b21d824302af52d06574870817fbe14774dab ]

hisi_femac_net_close() frees the receive ring while the RX address queue
still holds every address that was pushed to IQ_ADDR.

A port that keeps receiving then DMAs arrived frames into buffers that
other slab caches have already taken back; on an EC6108V9C (hi3798mv100)
the queue still held all 52 armed addresses right after the interface
was closed, and had dropped to 43 after 15 s of broadcast traffic.

Reset the port before the buffers are released, so that the receiver no
longer holds any of their addresses.

Fixes: 542ae60af24f ("net: hisilicon: Add Fast Ethernet MAC driver")
Cc: stable@vger.kernel.org
Signed-off-by: David Yang <mmyangfl@gmail.com>
Link: https://patch.msgid.link/20261025182022.2959333-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hisi_femac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index ce2571c16e431..50eeaac096b63 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -491,6 +491,7 @@ static int hisi_femac_net_close(struct net_device *dev)
 	netif_stop_queue(dev);
 	napi_disable(&priv->napi);
 
+	hisi_femac_port_reset(priv);
 	hisi_femac_free_skb_rings(priv);
 
 	return 0;
-- 
2.53.0



