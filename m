Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE644255F5C;
	Wed, 30 Jul 2025 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869043; cv=none; b=Lj7a+b8nnlF5xpbRLBEidVrPcelWbBMMXVxDl7Cp0RgHUk6aR/pVWooMGKp2kVhPGYAE7ML3p9ldXmY/jrXWXcfGPgCkcewtMIsQQA9CQte4a3fJ74Y0KqjbuyxO7NQBFUihpg8jlvm9kbF/J7QnYjLyGFHo21g2VmP6F+i7Mrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869043; c=relaxed/simple;
	bh=k1vaAncHF4O4uLllmst3BBd5ctEBkxIihWWgHCFVi2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inPxDjvwGnihfw2NXnbZNlHl0uq+TVqXwooPhrUXZVGl3RE42/p8tbAPzQlTsTL5yQ3rFKBJbGwJRO055TJHhFPek7ECooVSvjMZsb0Fcoxvkb0oXJORs4sWrFzPFXJJm2rYu5aLRT/YuwvUcTVlfRvNfkKdT2J+hhVzGI9dm6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqsiV2Kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqsiV2Kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D470C4CEF5;
	Wed, 30 Jul 2025 09:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869043;
	bh=k1vaAncHF4O4uLllmst3BBd5ctEBkxIihWWgHCFVi2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqsiV2KkMNROKY4HXFWCMq6PBxMZTh15Xcbtzw2RcH2j7GD75+p6/YQ8qfh/n+YjX
	 WvLVAEvkz3pT01YmQVmrjGxl2TNpGv3rgLKrKyRjCmmaMWyUabvClN8td7ml2QMTXe
	 v+jG8w2jeGND2uE/owmk2uOYrkk5A8EX+EvCG/nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Brunner <tobias@strongswan.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 23/92] xfrm: Set transport header to fix UDP GRO handling
Date: Wed, 30 Jul 2025 11:35:31 +0200
Message-ID: <20250730093231.506665581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tobias Brunner <tobias@strongswan.org>

[ Upstream commit 3ac9e29211fa2df5539ba0d742c8fe9fe95fdc79 ]

The referenced commit replaced a call to __xfrm4|6_udp_encap_rcv() with
a custom check for non-ESP markers.  But what the called function also
did was setting the transport header to the ESP header.  The function
that follows, esp4|6_gro_receive(), relies on that being set when it calls
xfrm_parse_spi().  We have to set the full offset as the skb's head was
not moved yet so adding just the UDP header length won't work.

Fixes: e3fd05777685 ("xfrm: Fix UDP GRO handling for some corner cases")
Signed-off-by: Tobias Brunner <tobias@strongswan.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_input.c | 3 +++
 net/ipv6/xfrm6_input.c | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/net/ipv4/xfrm4_input.c b/net/ipv4/xfrm4_input.c
index 0d31a8c108d4f..f28cfd88eaf59 100644
--- a/net/ipv4/xfrm4_input.c
+++ b/net/ipv4/xfrm4_input.c
@@ -202,6 +202,9 @@ struct sk_buff *xfrm4_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 	if (len <= sizeof(struct ip_esp_hdr) || udpdata32[0] == 0)
 		goto out;
 
+	/* set the transport header to ESP */
+	skb_set_transport_header(skb, offset);
+
 	NAPI_GRO_CB(skb)->proto = IPPROTO_UDP;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 841c81abaaf4f..9005fc156a20e 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -202,6 +202,9 @@ struct sk_buff *xfrm6_gro_udp_encap_rcv(struct sock *sk, struct list_head *head,
 	if (len <= sizeof(struct ip_esp_hdr) || udpdata32[0] == 0)
 		goto out;
 
+	/* set the transport header to ESP */
+	skb_set_transport_header(skb, offset);
+
 	NAPI_GRO_CB(skb)->proto = IPPROTO_UDP;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);
-- 
2.39.5



