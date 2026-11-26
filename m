Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705008;
	b=wbdguDfsP+AOgTaxuuTu5mkyFYZ12vGTQkP5xOZCFwY4+ms7zP6CP/m/mravgtgupEtM
	 O5oKuQHkHjmhwR62A81Xp0qxZs8smHj0j9E4Cq3GMmEy/WQ0YrJnaDoclAKQkhPaaVCOZ
	 i3/EE8vJo3GyhcNKNoAqFlrAxnFQ7XTnbk7fga79smreBjefecy0BaBiUMpDWFR0KpjF2
	 qUhx5tAe2mid8HchcldLDNkZVeIA7IQPflpxClJKiBPqMo2s1bG6+oUWMAoaRz3gE5nf1
	 sJLiq1Mxe0ndkYHXFattvmO90GiSgRz0Ft4vgOC1RSt+LMPnHa+SGHO/o1EwcGUxCrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nb6BzDVCzXLV/Bu6gRF7MTmWEvX2NvU08anQTgs8lgg=;
	b=5kWCYjHPmUeAxzRLGAuQxNX3NmZ+HYhssnCDm0ZVEiYKD9tX10eWPWtD6sb4+Vspxg8x
	 F7T/4EQbtE81pBB5FmuOluRJwCMBkeWcAgVg9R0Tz3xh1xL5owHVECouwKNf9avmkc/nl
	 spucAYOzeKXaZg30OcKjzBCwoKscbNGF0ydMbHC09k9jTJiLNCegrNX+owIC4gbc4nYpN
	 bB3OIyyIM7RGVmL7VL7oAH3kVT2vcTGlPwqjQwKzUae3H+XWXoJajrus6kx9xmedo+EIp
	 qv+l+o9wnoB4mB85zn95jcX73V0SeE101SIpDB3kFEbWJQ8TsiCb4ty1cSGU+H75EnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ae8IaYif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494CC606A32E;
	Thu, 26 Nov 2026 14:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ae8IaYif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756CF1F000C4;
	Thu, 26 Nov 2026 14:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705007;
	bh=nb6BzDVCzXLV/Bu6gRF7MTmWEvX2NvU08anQTgs8lgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ae8IaYifLNlslEbyQ7lcXUI2NsKanjygV39fYoI7/RSjAJ7TP/ZLntfG0fXQkH4yS
	 vDgUrOqx8b7K2XUtkaMeqNRo930VEWqvrvYTKjvxeb9csj6ShtAyGeSzBTGU8gZ564
	 ooAtBXNZJWWpZrdiG7lothEtrg9cBHJqLv8BPgBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/319] net: stmmac: copy XDP metadata in AF_XDP zero-copy RX
Date: Thu, 26 Nov 2026 15:36:59 +0100
Message-ID: <20261126144007.889728882@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a7347cd844b73..773c64dd130a3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4857,7 +4857,8 @@ static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
 		return NULL;
 
 	skb_reserve(skb, xdp->data - xdp->data_hard_start);
-	memcpy(__skb_put(skb, datasize), xdp->data, datasize);
+	__skb_put(skb, datasize);
+	memcpy(skb->data - metasize, xdp->data_meta, datasize + metasize);
 	if (metasize)
 		skb_metadata_set(skb, metasize);
 
-- 
2.53.0



