Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1275833E345;
	Wed, 30 Sep 2026 16:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786043; cv=none; b=uLI5Vz1sZqq8AckLxxAYK+Xs+0ytWqmIiLQEW+L08EDUg6IiofloQ3vvrWLy7Fb2cCugPEsaLwF2/teLtO8ZHWyNMEp4GcxHTWoVblilSiuKFv/MyhYVqIk9Fqy9mCWDrRDHK9+Qt+U2fDgqR0si6+uM6jWvlWgBtCqiGDJkNq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786043; c=relaxed/simple;
	bh=ChseyufvV94A2Kh/ZYUJNn7JnGBfISyW7hCwCt4zn/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqkAoKo//6fjbkjP9ftc3h6g6OSpwZhq27+wQus21CvoEuOAexwXlx0La00lgZDmW3oybLZcqyJdUsppYtR1VX7adpuTRcIV4dePwnMFUrJqfGC6Da90Co3RM8s8aZLsuYN41YoX7Q9/00kd1pPpQnHKvjpHjJKzMk69i63SvFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBIbO4Dj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBIbO4Dj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2851F000FF;
	Wed, 30 Sep 2026 16:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786042;
	bh=U/nItmGAqWmufb/kDOWS79yDom4L9NoKbcHpsA9+G5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBIbO4DjVNC3JPQH85z/cM7OCzhdDaNEmtwUoq2PuxAhcilZ6pWHTXfOL4zxBBc7V
	 KO3iXnp+gGJOkNvhRlVNLGkGJST3ce1Oo3cBCq5fliHzZEtU9n+epDj08qKKm62bIg
	 SVJqFHUxAkTf2HF3YJKNZTZ7xwLK1ANrtQQLXDFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 721/982] net/packet: clear RX owner on VNET header error
Date: Wed, 30 Sep 2026 17:24:17 +0200
Message-ID: <20260930152432.238722833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2440,7 +2440,9 @@ static int tpacket_rcv(struct sk_buff *s
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


