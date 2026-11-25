Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625002;
	b=RLJ6PYbcoaI0f5eGOQNS8Jig6Q0x7b2DjMai32YxwYP9szA6x0k257IZU8NMBDbucQuK
	 bqhpElzTohusUJQGuS/BUI0Y4ap6WMRarhxFNaFuS94BB1mfvdwLOQjT7p0V9thZDXFVp
	 STiVo0zttkFgx+h4+OqA5RIr9MBY4UL7KGyDn9JPaxwAzZCNaC7Qp28HN05bMKtzsxLEV
	 mdbakvj7t5pOF8cmLyb//rjOMcM5oWJ9YWPCGjqqmFZenSIGqDJqMTeYzvbgKkd56oE7P
	 jRT4lNMOfYgC1JCHNQ7IZWAe8dmrTO0YvFVbmcwomvZjdp+Ts/W1UDMi/NNM3fxFcIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BC1FrhP39+FEEkf8HZP/IiqlLqJW7clKNPUiRhiYa1k=;
	b=IltlqTc8LYjelti7zfl0xGaIOnUCV42SobCWM+QINBekK/6GnUjU5CXrokZ1hesEC+bF
	 ZOTORNjUiBboByIiWpz9RHGMqtb9s31OkfotQz7z8hE7EUgxyUd25IRETIUYQS27mVlv/
	 caOl4OUfwO5XjZ/lanzpM6HVr/jjlQewSL/iy2TBSBq/QVsWG49Yse5hilIOv67uFnX/x
	 IcMWrnbblgU9UgWKSx++kW7IiRESxG/hrE8aTKx44JST1mftRH0ga/pIuFaY58YZw8tIl
	 cr4+aoMUe6oJY3rNWQW2ZF8OMFCc/9yuz1o9T03bzlO6pDt1tsOeau+ZKJgFSSKzv4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNmTo0Ec;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12315606A321;
	Wed, 25 Nov 2026 16:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNmTo0Ec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623181F000C0;
	Wed, 25 Nov 2026 16:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625001;
	bh=BC1FrhP39+FEEkf8HZP/IiqlLqJW7clKNPUiRhiYa1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNmTo0EcTRLbFxeq5EXhPIe4ZGWHuNQe6USEaDnlpUXaWdASNf7Kz28X8dDm7zC7q
	 0dl7gy+BTheGryOaFbpliPd0y0WzmIBZrWWiMpdLUpF6vUP/eamPBbQie7UQ881F7h
	 gisN7gnKS2Ym/tAlPKYedxcLtnw5/BXe3aIM+dzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyi Gao <tianyi@cloudflare.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/816] net: fix mac_len of skbs copied by generic XDP
Date: Wed, 25 Nov 2026 15:31:07 +0100
Message-ID: <20261125143856.584352947@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a203cc89d33fa..5c7af2ce14a80 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -964,6 +964,7 @@ int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 
 	skb_reserve(nskb, headroom);
 	skb_copy_header(nskb, skb);
+	nskb->mac_len = skb->mac_len;
 	skb_mark_for_recycle(nskb);
 
 	err = skb_copy_bits(skb, 0, nskb->data, size);
-- 
2.53.0



