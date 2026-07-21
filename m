Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334DB45DF74;
	Tue, 21 Jul 2026 22:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672461; cv=none; b=kYhkK44RMkV5sETVKMvEGcbLVDBAbKGQSaebHzuPhy94QuxRTvjNM9vQJV2apf022wbKlTd72NNhHnO+0ElmHoI4pfh1ujUd+W3Z2fwFrfrfcI4sbojrq5O7IiBqTSZAXVKzLN/+u//sM7NkM4tBJUSssAQsPRYJe/25yVsjGkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672461; c=relaxed/simple;
	bh=YRJv1Bv6Cm5Iy6r1NinN4SncT+So0qSxzsz5XfHjN+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9PBMaIkVhO1+DVPKD3CX3pWvBTG04lLgqkmpMYLR6WFCjP70jc9luon5P3oB/DY+SWhYCizbGiT1spz+QJCxowgr7ZPMIiL2rHPy1bNU2El3RwiqMcmI8YQlORwdppsSGMqccOQuKdRRx5fvFfy9ymPAvIhwZuMjY9pbpldOqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plQCcBk+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plQCcBk+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0781F000E9;
	Tue, 21 Jul 2026 22:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672460;
	bh=zJff40fhgqJXU3SoSHTZ7aZNLqBQb52R5PrHXieKHB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=plQCcBk+mQITCSMBcuV74tn4LQRgxtChFQ+cobTyxt9Nkhcx4rYlioGTbHG2s/oy3
	 rkvPSIXLL4vE/wCKkCuHKpVLdmQgzu1Ud4EErD3tPjOA4TI9Qsmw0LJrqn9blYdgaZ
	 R8OQetCF49FgZPYB4i27KnLikroiW3NyRM0wgLes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 590/843] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:23:45 +0200
Message-ID: <20260721152419.322949953@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit cdf3b5af2bc4431e58629e8ad2086b1e9185c761 upstream.

The pskb_may_pull() called by batadv_bla_is_backbone_gw() could reallocate
the buffer behind the skb. Variables which were pointing to the old buffer
need to be reassigned to avoid an use-after-free.

Cc: stable@vger.kernel.org
Fixes: 9e794b6bf4a2 ("batman-adv: drop unicast packets from other backbone gw")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/routing.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1034,6 +1034,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


