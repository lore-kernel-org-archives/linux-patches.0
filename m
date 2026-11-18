Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037025;
	b=MmAUuN0kVsgFEPI5eoVPhse6pcLTa426m98upFSt2BnRTdlS4WeYZygchPaBSCWHEOZ5
	 nrb4dxlXjQy94SUma1IoJ+d3Lv3RdViWHfy/UQUlbaooO8PfyEkRB+TKeMw20zrHm1hTo
	 M9eMf73wVJhVJlAKCZxEe+V0ArBLwyvsHEpNnhIQ2/POj87x3Ow0W8lRj5XbT58KiNh3L
	 i5aVT+8OHLqhWBhQ/CuOFD6fee6hFc4RW8GVtLncENux35ElC835Iy3YH59DaBAPDjJ2R
	 cm8jypHsQL0AZ6N1xo0CV1Lt2ktqVjtRWJR26mK7JxLxh0OCRH4Pz3gtsxjrZ2yUnmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jOkEMkGNHKjCufMc6eEN/ygL7K7ugs4YLuw3up+Gw5U=;
	b=Uxu8MqZ4PpXoZRXXI+vNouRe4S31+OstLLpfs+h+GZhroI3H0L8+XB0J01VF7e3iD9IB
	 bp0gzZNcO9QCwcYDLfpDAMBG6lcRl86zobcDeRc58/Waifs8GbhFWCeWN9fjhEVIE/XJn
	 svkgs089TKpLTMMNNpIRlkQ35+5RzXAYzqPQQtCMt+ytm4ODE6fWhtpjmQ5728/sc86qw
	 I28qu1U5b2Hu38ILcYQk8EQ6u7NVut3gbsziMZlIJ5hyIiCJwMCEg97DPhSd8y2oRTTxu
	 VHCmnaMM2EwL0krX+JCofA1t7+T08jr1U9zrBPDbSVERG45KdXSnUPbpSnNN9dnRreQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1I3KmQo9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB1606A32F;
	Wed, 18 Nov 2026 21:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1I3KmQo9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F9B1F000C5;
	Wed, 18 Nov 2026 21:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037025;
	bh=jOkEMkGNHKjCufMc6eEN/ygL7K7ugs4YLuw3up+Gw5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1I3KmQo9wnyCB/lVKeytSK2JtFA779BNXMkGuhx0v//8Kq5a5tB4Miv2w3mRnUoBw
	 uE+ie9oUn91qCa0AWMTMzP/PUZ4B45Xtz3KIa0DDnjotEn09Q0qblbwzdNMeCg1K6R
	 n9LZB6p6U7bzRDFOoS6pF+1p9L7pvdRsPIMzKLTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1267/3318] net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring
Date: Wed, 18 Nov 2026 15:31:29 +0100
Message-ID: <20261118150358.230271891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb7b0293fe85c..ed0920d580198 100644
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



