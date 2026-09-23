Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC3F51CF76;
	Wed, 23 Sep 2026 14:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174865; cv=none; b=Dua/MWEagE6XA2b7z3qR1Dz2mXyavxgQecB7rMsPaK3sO8Xsl7oCyhWxo7VZIXs4wcVYBYOun2wYKrLwu4gaP0cZIQzFXIDozs2E2sGBsYronEWWwPFENsPb+Sq8wCwEDb793Oqdxao3mOcj8MoEjK9b9oxiCUgqwVbO35hg48Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174865; c=relaxed/simple;
	bh=+ZkEFL9vMIwfEqcW+f80S6oRJPo9zBqcRGc4QW+9jpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKjpGdtDyEje6P7hSgeW9W1YP7/M2sl5GQj/pylbaSPMEY4mMXNgsBlpJrY8z04QkEo/G3UMOFmmyvFbHUaaHETpLGbiSfSH9hG19Vo3X+6rFQVno0eRxRYAyO6cNONTeoLhwtMWqjZgnYoxna9r/6EKSKM2yb/p54Xhq5HxplQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ak7hUswS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ak7hUswS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FAF01F000FF;
	Wed, 23 Sep 2026 14:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174864;
	bh=Lj8mbw+8IDwsidWN6bLl7s/LP0MIigEPb+IJrvyf3eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ak7hUswS0aUJW+LsIRS29L10eG42dVZuJyPOdrEH1ccIaXbO8EZKHs4p0E2iTUbmI
	 qadVABfOPUy5x5JPdwHh4StHjdFcL0WJcux52JMb7mA4riJantSemJfqiIvLzbj6WN
	 Gl7JKCfR6DdqvKUAOyBi0SaGs4QjQpiZ2FnrJ9KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 251/398] net/packet: clear RX owner on VNET header error
Date: Wed, 23 Sep 2026 16:05:25 +0200
Message-ID: <20260923140649.915213424@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Amirkan <markdamirkan@gmail.com>

commit 33ff111d7ba3beb86e28938d6382bb5beabd865a upstream.

Commit 61fad6816fc1 ("net/packet: tpacket_rcv: avoid a producer race
condition") added rx_owner_map and made tpacket_rcv() claim a V1 or V2
ring slot before converting the virtio-net header.  If the conversion
fails, the drop path leaves the slot claimed.

With a one-frame TPACKET_V2 ring, an unsupported UDP GSO packet leaves
the only slot unavailable, so the ring also drops the next valid packet.

Clear the ownership bit on this error path.  TPACKET_V3 already clears
its block state here.

Fixes: 61fad6816fc1 ("net/packet: tpacket_rcv: avoid a producer race condition")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260913-b4-send-packet-vnet-v1-1-5545ffb528ae@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2383,7 +2383,9 @@ static int tpacket_rcv(struct sk_buff *s
 	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
 				    sizeof(struct virtio_net_hdr),
 				    vio_le(), true, 0)) {
-		if (po->tp_version == TPACKET_V3)
+		if (po->tp_version <= TPACKET_V2)
+			__clear_bit(slot_id, po->rx_ring.rx_owner_map);
+		else
 			prb_clear_blk_fill_status(&po->rx_ring);
 		goto drop_n_account;
 	}


