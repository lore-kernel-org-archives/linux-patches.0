Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622055;
	b=CEAfnBAn8JY1pNYMRsWW97lSgjB2cR7CcMz3ZZsOPAubC+XpGkbjs/3uc0rVRDPbzY+Q
	 uwtrgmFUaFE1V2xW0ccO+D+txez/6kT/0dks3bizaOtsnrv+YHKQDjw3VVarYo8kSoqAs
	 3FjfJ/x5x3VsvcgUZbJExN/Y674+qw5BZgiEUgl43d0N7ocx5l/SlTU4BHkQNsqRDWXYy
	 WZapqI4SELrfTIZDmznHdsXAekj/UJfh8rt+FsPdJkphNlHgbZ1eZ5csxgB4QWnpSBk+V
	 OzJuM5D1U6aNnHRHED9riM3cG389r4nD8SVno+7pWNnwuz/xyWHPXsrVYazODC8pOqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xIpNi6LPxteC3VV3BDEYeRgWdXG3UpQrf6bm/inyuyM=;
	b=DS+WsxJPTOrSJbHjF7RQ9W5bs9qb0vBZ70sdrgcPP+Eahi0XJ3/GZzJBbiQK0pVFb9PM
	 lQTmewSgZsBC4QewakgxR+nnIFyB3FU7zMuKOwahTM2q2h8CYB6JhhRBCa4q1T1GMT9av
	 YAAl6E1vDZgMug/E9qrxLsc5Mop/Q9HnbnFeU67XxiwBiRo4RtQFDZCbRqRtdFZTYPGf2
	 7hE8VJv1xx24s+hCANvE0ez9coCI8jnFtDC1hrh6zUfsShMpBC7Lul6n9HuKTJWhY7kwW
	 FD9Dz8EDRUuM2CwrMgDJOErCtt4hhavpON2Qb9CuBNj+Vzxq8z73RLaaYaqv+JAvwWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jis8rKx/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F4C606A31E;
	Wed, 25 Nov 2026 15:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jis8rKx/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDDA61F000CA;
	Wed, 25 Nov 2026 15:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622055;
	bh=xIpNi6LPxteC3VV3BDEYeRgWdXG3UpQrf6bm/inyuyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jis8rKx/lrmpuyCoKEKzBsjCgSLAnD/5Y9ONIMBQJAbBwZ1CXuflU43YXgP23UQg9
	 BdO6YQwYh+bKFJiCcH6p1y6HNR161vPWY9pAapZxNs4gHlKvsqlk/KfKQVZAA+dYqG
	 LIJ0uxjpWCke4CGe22YizruyslpAbOEk9YCRYCoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 417/990] net: fix mac_len of skbs copied by generic XDP
Date: Wed, 25 Nov 2026 15:29:44 +0100
Message-ID: <20261125143831.867330124@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianyi Gao <tianyi@cloudflare.com>

[ Upstream commit 71578e43b8a6723025579a08a707f4975a3cd567 ]

skb_pp_cow_data() copies the header fields of the old skb with
skb_copy_header(). skb_copy_header() does not copy mac_len.

Generic XDP uses skb_pp_cow_data() for programs with frags support.
After such a program, the skb can have mac_len 0.
cpu_map_generic_redirect() and tc ingress then get the position of the
Ethernet header wrong.

Copy mac_len in skb_pp_cow_data(), as dev_map_generic_redirect() does
after skb_copy().

Fixes: e6d5dbdd20aa ("xdp: add multi-buff support for xdp running in generic mode")
Signed-off-by: Tianyi Gao <tianyi@cloudflare.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20261103200036.65764-3-tianyi@cloudflare.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index de69f89086513..4ee359dfe93bc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -934,6 +934,7 @@ int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 
 	skb_reserve(nskb, headroom);
 	skb_copy_header(nskb, skb);
+	nskb->mac_len = skb->mac_len;
 	skb_mark_for_recycle(nskb);
 
 	err = skb_copy_bits(skb, 0, nskb->data, size);
-- 
2.53.0



