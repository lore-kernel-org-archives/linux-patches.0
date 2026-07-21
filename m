Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4308C3D3321;
	Tue, 21 Jul 2026 17:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654276; cv=none; b=PM81wHb550O/+EMidxU3RBMqRdRJA3S/Q8uT3bImL7Kev0yRZb1qKuqMi31Nt5MQUkF+Tc7xK87VQ01PR1ilxsV17awSps6jUv/hPDa1Lk1foodipjzkmuN6KgfI/+2+KsF3RZDQigP+j+NFU8Y7CH2hRuBzbftcFT0YkmSqFuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654276; c=relaxed/simple;
	bh=7T9qKVCogrrDZfc0eFdTmJnbu8oZ7RxdNYx2S0b0EBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBP2fdsLiJ+SaA2CzdTLPm/ts+1PBgzLKyy1ZVSfsNGNEFDFf2B0ayCONW5TcbwKRBhNO1ffh43MvqGqmrB5MVbCFBOujY2Qp4RUKG4K6nDFHFuyF8avEpy43SjbDx2MWk1Jz2V/vA1bpSOtLdpVSlIAEDp6jLw56SR0az8nYUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTskAceK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTskAceK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3F91F000E9;
	Tue, 21 Jul 2026 17:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654275;
	bh=WjV3JpgSdp3QZ1/DTFeexzv6JK9f3BB5HdX8ME3AXzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cTskAceKvded1Eb49owDsJJxh1x2Kg6GSZtZEpeH+0P0pI43HGJgBtJiSDxbmXL5r
	 VvgR0OfvhRx3ZTk5rqtUfr8c4wvByPwlYgFaSWIwXEC09ZN/6bp2MQaY3gVYEDGHuH
	 Xv9J5FhLFAv8Jdt+Mqxwd4U+b0TKgHtgFzF4SOCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1642/2077] batman-adv: bla: reacquire gw address after skb realloc
Date: Tue, 21 Jul 2026 17:21:55 +0200
Message-ID: <20260721152631.480603911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1029,6 +1029,7 @@ int batadv_recv_unicast_packet(struct sk
 							  hdr_size);
 			batadv_orig_node_put(orig_node_gw);
 			if (is_gw) {
+				orig_addr_gw = eth_hdr(skb)->h_source;
 				batadv_dbg(BATADV_DBG_BLA, bat_priv,
 					   "%s(): Dropped unicast pkt received from another backbone gw %pM.\n",
 					   __func__, orig_addr_gw);


