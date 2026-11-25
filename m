Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621161;
	b=Vx/OI2A2IUahBZSWlqZ3scsqZW2lFRnftl7J29Xd22Y3VkIJA0f/SvsosvMHjAsGwRtV
	 j8CDdq/vMh5S6zchEwwO4GbT92mHqnFCKjwD052+21cux4Dgb87eobzwkyR40h0fL/Q0d
	 H4QLErWkbMBxYHIzcKAl51aVcEo2GGkQdaESyANaZGsqGW/H+QQ/y07sUFTEkv0YAXE+m
	 OxQpZuYFLgdSzLnBVD/0xaMIlcRmYn0RdkitMoasfi0aQoN2LYz4OH2meaZJ7NGhcUydk
	 BnmA7wWOQiajcRsEzwY4iULoksiGGFLWiTtkflmZhYS5oOiRpAyEydbIVQ2ks5hS92g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxDwINe6aJdr17LVMj3pz5QJQoAa39T0vU3ZDcef0F0=;
	b=W1uBq/MrVU8tJQDf2yQq4G03A3YoE5uc0P0QpXiFGD0/ofDlTnugK10oLr9djqtg/gQ7
	 8wgjmaCF4m0Awf7SAcE1OfW7cmARF5eeYdhCyT4QtN/AxcN4rosRRmtE/ySIvz+vX85y1
	 UuLonwxG3BySKwzlDtGZ7g9gmFt+IfOjpcT5Bd9o1/3FPGF6nEp08JeGYNYtsY4fbVZ/c
	 zQlAGXKzMuF66HIKrwd2J/a9lRYgyfD6alMuOEP8zeRN1OZ0xibWAOQXUONTbHSB/WMkl
	 stYD6ljKXwPQml7IkMMF/lx03zoAjK5eoaDHBr1SKI8BuvWp0KHthGwDikTLj5jLfpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZM4+gysk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12BB606A6AD;
	Wed, 25 Nov 2026 15:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZM4+gysk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251851F0093C;
	Wed, 25 Nov 2026 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621161;
	bh=oxDwINe6aJdr17LVMj3pz5QJQoAa39T0vU3ZDcef0F0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZM4+gysk0OM9pKZzQ1WkTywOyH/4oWUvePiiXW/H7rQUZHUAfJ2EeP+A7XI+FEldl
	 AO9+YHGnANxG+wBNjes7bh3CtpagMMu0eKEWwH6Hgr66NHkIQcC8+2B+80f4jovrUZ
	 A8Sl9L0bLS+9kG1T4YphHsC58Sod+bDZ8oyxzx4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 140/990] net: stmmac: copy XDP metadata in AF_XDP zero-copy RX
Date: Wed, 25 Nov 2026 15:25:07 +0100
Message-ID: <20261125143825.364898572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 41d78e9ac0984f0e9577e5312e62400b5a6760c8 ]

stmmac_construct_skb_zc() reserves headroom for the XDP metadata and
records the length reported by the XDP program, but only copies the
packet data starting at xdp->data. The bytes in
[xdp->data_meta, xdp->data) are never copied into the new skb, so the
skb advertises metadata that is not there: after eth_type_trans()
anchors mac_header, data_meta points at uninitialized headroom instead
of what the program wrote.

Copy the metadata together with the packet data starting at
xdp->data_meta, leaving skb->data at the start of the frame and the
metadata immediately before it, and record its length. This keeps
data_meta valid for the stack and TC BPF after eth_type_trans() anchors
mac_header.

Fixes: bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20261027-stmmac-xdp-fixes-v2-4-10eae8a093a8@oss.qualcomm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a79332f92be79..4d5e3ec64dfa5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5201,7 +5201,8 @@ static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
 		return NULL;
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	__skb_put(skb, datasize);
+	memcpy(skb->data - metasize, xdp->data_meta, datasize + metasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-- 
2.53.0



