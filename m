Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB203E00A3;
	Wed, 30 Sep 2026 19:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796299; cv=none; b=ObHRscorOf8+4fO75sZ81KTzL+vyXEs/uBbaBg9JcmybTAAiwueiIrB2ajwUX6yTszfedtS2N0X8oDmjpBNg0krdSy2s3EHGHdgNyowY322y/uuFalnHaHLgig7NWUnFM9gRSP+FAxRz81yb1UC4nqermZRkbf98zQ9A30W/wKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796299; c=relaxed/simple;
	bh=i3MwQzKlT3Q0UR4HvtL1pAgR5aQwu8Hg8AS1b1jAuus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLteLEF7BqRHSLPMuUdyIXQunCSZFWeX3kLVBNa9hh7om9oQOT/op5OtcPc7mva6OrVIWDL4XvjggD7vAulTirvpNKkWS3qMV+BiJuUrHyfn1AKGDxl3qoAKvIQaUPsvlmZYtsmgFCpAybZoKJzDIU680wdYMisRl8f5gPOlSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIIu4Et6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIIu4Et6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0201F000FF;
	Wed, 30 Sep 2026 19:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796298;
	bh=+2jepoUfqvLkz/x9WTqRUpk3lEivDxlZZfqML5O734c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIIu4Et655qylzVCLpFk8qhzZOYwTUzEaRoJIS1bScbyPhqHuAiMhBzPzbCRFmb+C
	 k512BBRUR/LX0NNvQZcwr3kAGgH/cU9XpiqP2oGjzObNDQ8IQpmfgq4XYD0vJ4os1P
	 2B5NjsPtYjtxdZ9xu9I+678s/TC7UWyb/RcZooLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0865/1193] net/packet: clear RX owner on VNET header error
Date: Wed, 30 Sep 2026 17:25:49 +0200
Message-ID: <20260930152453.453851378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2434,7 +2434,9 @@ static int tpacket_rcv(struct sk_buff *s
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


