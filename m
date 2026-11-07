Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065509;
	b=znyf2EkwH9F5usITCAuEYLQB+xjxr92VnQiKpfCROnEbe8iuXTi1lwXcKM+62fSK+elK
	 5cmQTqBBwvLfOqH1MIikI+qNIRsX4T9N0UMTTncmYR50VWIIlxBHhmQ4NQtmRFDhp1reB
	 ssy0WhqcwmIn1Ner7yzJI2PjFNg4IESlQEtXG34jWbZYd2hYJFo2FWAL85RKzLenO9GXh
	 EZyyNROmxXGfMqXA4aqb5HVSkzsg+2wn6EacsWQkusWMW/xSV0yuMnG4QkRax1k1IXOWO
	 57cTo5iYbFzUFZ3ILnHLhlppwWpXUlWrG7VI8L4s/70tw/DgclvUNknLFNWhGhaLQUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065509;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d8SI+smTJYYkmJbyjWe76XiTjIfeB4ViCbsXJ886C2I=;
	b=HhF9MrwvkQ47V5OJp6zkSbhFmkbvebN0KT8B3nypDOw4AyA0ePaL0ye0T4DSvi1eaeh2
	 cRM7CZ8ob7e27MA4bV5rIjkdburtYqCbrhNBvKEmwKdUNN20RyYN0yQuhBoqwVwAgtrrv
	 QszsfQM+BgKvoxeyVager5pt4xrH6eMyhihZuTXy3B8CVdgkFljiJinv2u4cXAjbyQUFk
	 PsuKXEgOMCH6d1qPeoNts1S5lqgxAkqs8RH+W59E3vkyMbKd3taKrLi+mv4w8Ty58mPbr
	 6jBlfuw8cGQzFayuCCZKq03O02cJr4fX7pygN/qSHLdiBi4UJYS005ekyfvsFrD4eqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MT90XdH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A919606A32C;
	Sat,  7 Nov 2026 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MT90XdH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34601F0089F;
	Sat,  7 Nov 2026 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065509;
	bh=d8SI+smTJYYkmJbyjWe76XiTjIfeB4ViCbsXJ886C2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MT90XdH7j2SBiDZApgByrXfxw1N+Wp5AMxrf3eKsFzk5nzeFRUlwVZKJm4d58rUJE
	 LcVUu2zvwCQl2BgmCgCe6Bdcg0l/Ho+7E7+nbn4eLy6b1GowIqOX2inwiG+Fdxd2VH
	 pKbSExBSQ0ze983SyDDvL6Gy4HiQX1oVlGDDfmME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1193/1257] net: hisilicon: hisi_femac: Stop the receiver before releasing the RX ring
Date: Sat,  7 Nov 2026 08:58:09 -0500
Message-ID: <20261107135012.115682004@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 016605e86f0b0..a44ea0a2b1ee6 100644
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



