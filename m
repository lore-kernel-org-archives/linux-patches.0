Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020633;
	b=ehwMygw+44Q3xRg7Qv0+NHqUeMnodT/QfCRgGG1oE5bsLyZjf3cF6vLLPhagVyQDGakv
	 5h+9qebvrtorjmOeNq38HtwfA8e0Nc6Fl9j0VGmBMhI6fuIzvapIM0Mqv6emSASfjLYg7
	 1yMcoRg6PqlwNT6kGm71/ExVJKVyADNO1zf+OSRYgTaNUcnGW5jF9xnQ7pDZPzA+iobp/
	 v7QXNtFt8CTddQ8QulX1TE0khBuu1ZT/JtXtjgy4/ZqvuEFAeOwb785v4uB+l37jl8Lc3
	 kHfkD3mJWlJ/+CBO+CriSlRwIv0oKruBpIlaqLSxXMYSU+AodmQGlZsX2XJNKS1BEmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uE1wRrHFewMUIh2AETVFUb19BkKlCBDz19eSleeKnVE=;
	b=qcBLuzSBfPUMoGEH6b+MrKIpPJpxkztSGJmsxHNAZEvkbCW5AxXD2tgwM7L5vUEvAf20
	 739+WldhBdGNGsbR7hukLvxCZlVa8UajPQzMhckknrtM3LwSxm+S74loEI+B5usW/ydCJ
	 WRe7kRdGR0TKMS0yhPPnF9R46xQVjUSyx1cauX9/EdWovSyTrwf6Ys+gdw+3Hx7bABmoh
	 mBxq61bW7BZbioCsJeqKaXC4z/q3KPgF570E3ZewG1K30NYC57hwbCoYztOvcI0TOfl5n
	 bD3q8CkxQ7xz5RegcaPdrJDpsYuo606j6aOYjIzfWk+umfdly73Iw3QkTlJ67mqg3FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sOaFn+Pi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBBE60A2605;
	Wed, 18 Nov 2026 16:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sOaFn+Pi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C151F000C6;
	Wed, 18 Nov 2026 16:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020633;
	bh=uE1wRrHFewMUIh2AETVFUb19BkKlCBDz19eSleeKnVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOaFn+PinenTSBDhHVR+J568IaIVhrx0nof/sVWhFiaLcVWU84qs/AjjdLOf8er6Q
	 s9/Y9uUDaykGmfwxxuF4KG45jAU/j08pmBkt97jMsbE2Xm5K376RpAfSpEtx8VLmv0
	 AVH/mFlZJeCe3Qna7KgNMN59z3E1TPu+9OIXIZ6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Melikov <mail@gmelikov.ru>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2022/2651] bnx2x: fix header length calculation for encapsulated TSO
Date: Wed, 18 Nov 2026 15:54:22 +0100
Message-ID: <20261118150358.998348728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: George Melikov <mail@gmelikov.ru>

[ Upstream commit 4fc1d5bb448dfab391a96f949d02ad03ad8cda5c ]

Commit 80bfab79b835 ("net: adopt skb_network_offset() and similar helpers")
replaced the difference between the inner transport header and the outer
network header with skb_inner_transport_offset().
The helper is relative to skb->data, so the new calculation incorrectly
includes the outer Ethernet header in fw_ip_hdr_to_payload_w.

On a BCM57810 transmitting TCP over VXLAN with an outer MTU of 1500,
hardware segmentation emits packets declaring an outer IPv4 total length
of 1514 while the actual IP packet is only 1500 bytes long. The receiver
drops these malformed packets, severely degrading TCP connectivity.

Subtract skb_network_offset() to restore the original calculation of the
length from the outer network header to the inner TCP payload.

Reproduced with plain kernel VXLAN and one TCP flow on kernel
7.0.0-31-generic: 50 of 200 captured packets had an invalid outer IP length
with the original driver, versus none with this fix. Disabling TSO/GSO on
the test VXLAN device also eliminated the error with the original driver.

Fixes: 80bfab79b835 ("net: adopt skb_network_offset() and similar helpers")
Signed-off-by: George Melikov <mail@gmelikov.ru>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261009-bnx2x-tso-fix-v1-1-1ebea422422d@gmelikov.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 5a9742fd3ddfb..6fb0619731aee 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3666,7 +3666,8 @@ static void bnx2x_update_pbds_gso_enc(struct sk_buff *skb,
 	u8 outerip_off, outerip_len = 0;
 
 	/* from outer IP to transport */
-	hlen_w = skb_inner_transport_offset(skb) >> 1;
+	hlen_w = (skb_inner_transport_offset(skb) -
+		  skb_network_offset(skb)) >> 1;
 
 	/* transport len */
 	hlen_w += inner_tcp_hdrlen(skb) >> 1;
-- 
2.53.0



