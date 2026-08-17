Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C06B3CDBC3;
	Mon, 17 Aug 2026 14:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977671; cv=none; b=f0AdF3OXjamDUejDXYvJP0tkZ4xeFBYLNhVQNwbpmKr4U6QlMDV97TrN9E1m3+Yb4EnR50QE4UgqdBzkSWjxlc+sSL4+4ZgEjm4E61LSlCNcI9u9suDGt0uuzQraOjgDQBQPOZhZvTM1/eIHi6qABM5iZfw33aogmRaSvrlYgoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977671; c=relaxed/simple;
	bh=IEAipcdm7yi/FU9P6BL9J59JykOuWFhBZvtuCue6uZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl7zS0TFXR7ansJmM6z3ge/+BFxtGd8Vfh8juTu2j9Jfm+jW3cTVf+N1mC36BPw1T8ky57eYQY6uKPr0moUW/jqB09tNtXY7/xIxuoBNGgRHXBR9opt9DbkXaQpWDbH+8DqqZdt/65Ebxvq5z0HFCGZnReGrPaO+kXWqAsQ6E4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnPgtU0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnPgtU0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DD61F000E9;
	Mon, 17 Aug 2026 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977670;
	bh=aB0hXK+eKRJEutR2Aw+P2vNRkwXIjzheECY/jWvcsyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnPgtU0w2mW+iFRdHe2OCHvEULksW8rCEAd3sx115Fc9rFvKexQMorse7LvCurCRn
	 ovW053P7xRfBHNPFLzgbFV0YdWUwatzAWLGDDjaiF2Vnc+oNf1BKwz2/ykSKzazy6l
	 2EC3E/8V2gzgneLjLKW47MfiWYrbV7qzRpReRG2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 410/456] net/packet: reset the MAC header on the packet-socket transmit path
Date: Mon, 17 Aug 2026 15:33:20 +0200
Message-ID: <20260817132555.300603833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit c2707480cfbf19c7619acc9c089d17f20869821f upstream.

packet_parse_headers() resets the MAC header only for a SOCK_RAW frame
whose socket did not bind a protocol. A protocol-bound SOCK_RAW socket,
any SOCK_DGRAM frame, and the legacy SOCK_PACKET path therefore leave
skb->mac_header unset here.

For frames sent via __dev_queue_xmit() this is harmless: it resets the
MAC header unconditionally. But the packet-socket PACKET_QDISC_BYPASS
path uses dev_direct_xmit(), which does not, so the frame reaches
ndo_start_xmit() with the MAC header unset. A driver that reads
eth_hdr(skb) on transmit then dereferences skb->head + (u16)~0, an
out-of-bounds access ~64 KiB past the head -- the same class fixed for
one consumer in commit f5089008f90c ("macsec: do not read an unset MAC
header in macsec_encrypt()").

packet_parse_headers() runs only on the transmit path, where skb->data
points at the start of the L2 header for every packet-socket type
regardless of its length: SOCK_RAW and SOCK_PACKET carry a user-supplied
header and SOCK_DGRAM has one built by dev_hard_header(). Reset the MAC
header unconditionally, mirroring __dev_queue_xmit(), so the frame is
anchored on the bypass path too.

Found by 0sec (https://0sec.ai) using automated source analysis;
verified against source and matched to the macsec KASAN report in
f5089008f90c. Compile-tested.

Fixes: 75c65772c3d1 ("net/packet: Ask driver for protocol if not provided by user")
Cc: stable@vger.kernel.org
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260724144015.63219-1-doruk@0sec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1942,11 +1942,12 @@ static void packet_parse_headers(struct
 {
 	int depth;
 
+	/* On TX skb->data is the L2 header; anchor it for all socket types. */
+	skb_reset_mac_header(skb);
+
 	if ((!skb->protocol || skb->protocol == htons(ETH_P_ALL)) &&
-	    sock->type == SOCK_RAW) {
-		skb_reset_mac_header(skb);
+	    sock->type == SOCK_RAW)
 		skb->protocol = dev_parse_header_protocol(skb);
-	}
 
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type == ARPHRD_ETHER) &&


