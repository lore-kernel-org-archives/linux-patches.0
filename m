Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE47B157E6B;
	Wed, 30 Jul 2025 09:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868573; cv=none; b=cGC4dHxx60ugGdjkSVr01/ux4sqz4OtN1WErbZ1wfm/CIVIKUmVS9kAs+/KMU29mp/Zrp7ZHuJENEmhl5t3Wg1CZ94UKaZD2CvuTt0ccDUEgk3cuFurJTtt9gu4W4SwAZL58G4E2TmhpkK0w/tKM2HJ0JsWrgKhB2AFI3E6guAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868573; c=relaxed/simple;
	bh=Bqx2Wllxe0Qlj/KzwcsLTcHWRj6ZoNUaSWAIonHJR+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dljVARw1CJwQIN7wYqcd8vApkIhwxYt8rduEQ/sv4uMHIsb/+TZaVmEcTIQzLMn/A8kNd7BdvhUjb3d4iGdzy6B1GC57mKgw8II3zuJZjaBQCCRXe6IXO9HR5XsIgxhPYgB3LIt08QLwT6F+WzpU4cL8yBaPklbNWDXtAD6Snf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCn38aZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCn38aZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D0EC4CEE7;
	Wed, 30 Jul 2025 09:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868573;
	bh=Bqx2Wllxe0Qlj/KzwcsLTcHWRj6ZoNUaSWAIonHJR+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCn38aZmQSBFckToclwvOBuAxkI/urE+F4rPx4K6cD4rJGHQ1c1rJnFPSGMJODtlc
	 Ia4PUex0Y7OqI/N4xutKG0ckkTHzlxtisHtFF+ZIfkNS8Wjwc4qGlWrVfIfmN8rWZO
	 tDZpkpHhCkyyWlwGE+hV9FAHM5/Zx8OP4kr4iNEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tobias Brunner <tobias@strongswan.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/117] xfrm: Set transport header to fix UDP GRO handling
Date: Wed, 30 Jul 2025 11:34:49 +0200
Message-ID: <20250730093234.360032481@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 17d3fc2fab4cc..12a1a0f421956 100644
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



