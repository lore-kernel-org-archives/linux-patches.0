Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F41478E57;
	Tue, 16 Jun 2026 17:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630819; cv=none; b=m8Q6lEytcDefMFBck6IKQiJHXNKDuh/SeZ30CBl14OffkCoOXSMOCePJDNSSwSTV4xBfqHzLJ43vt0PoP1oNvxBLa06V/OQSLoaSFX2ADfwd3ZIKStXazNtbO2UTNlAQOxUYwUFIY9pNbvDiHaEvOA7in1hJDAn8tyqsZPtSsMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630819; c=relaxed/simple;
	bh=V0lh+WQqPO5enBAKC/rDPJosp/URTeAiRoVw34iyX9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruaOXBD2oMik6OWhIXvzMsVBP6vEn6NG2WSsX95A4QkrQ8S0fbnJLodvwYYbM6+mltE129mJU4gpHoJwXoaw/mOr0OtdNshv57a50ZazD9M0g9EoURTopL8jL8Fpsmo4/4K7kRSyZNcOk9TVa0Bf/Kz2c6Cbbb6qejDGhKL4OlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvZjCwjv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvZjCwjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8909C1F00A3A;
	Tue, 16 Jun 2026 17:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630818;
	bh=B2Pcqzmm58eNzh/K0cQmSWkw3qiFiCP/x8r6WTQFMco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvZjCwjvAiDOblPhtj2HvjT5/J3V0RzMv9AdoLI+/LKzBL7MfLKb0eeKXBZ8rALbj
	 xH0tLJT8KNfjFrHBwOJyuVz2KZ5TTNqYEaFIvjd8zuGmkrLldh8wesnMesREY/PloA
	 iMbWhvcMPAPknPfFQE4omGpsL9SaVEpQlDhnVLaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingquan Chen <patzilla007@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/522] net/packet: fix TOCTOU race on mmapd vnet_hdr in tpacket_snd()
Date: Tue, 16 Jun 2026 20:23:36 +0530
Message-ID: <20260616145129.053927997@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Bingquan Chen <patzilla007@gmail.com>

[ Upstream commit 2c054e17d9d41f1020376806c7f750834ced4dc5 ]

In tpacket_snd(), when PACKET_VNET_HDR is enabled, vnet_hdr points
directly into the mmap'd TX ring buffer shared with userspace. The
kernel validates the header via __packet_snd_vnet_parse() but then
re-reads all fields later in virtio_net_hdr_to_skb(). A concurrent
userspace thread can modify the vnet_hdr fields between validation
and use, bypassing all safety checks.

The non-TPACKET path (packet_snd()) already correctly copies vnet_hdr
to a stack-local variable. All other vnet_hdr consumers in the kernel
(tun.c, tap.c, virtio_net.c) also use stack copies. The TPACKET TX
path is the only caller of virtio_net_hdr_to_skb() that reads directly
from user-controlled shared memory.

Fix this by copying vnet_hdr from the mmap'd ring buffer to a
stack-local variable before validation and use, consistent with the
approach used in packet_snd() and all other callers.

Fixes: 1d036d25e560 ("packet: tpacket_snd gso and checksum offload")
Signed-off-by: Bingquan Chen <patzilla007@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260418112006.78823-1-patzilla007@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 36347814ec7ceb..f3850784d66404 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2767,7 +2767,8 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
 	struct sk_buff *skb = NULL;
 	struct net_device *dev;
-	struct virtio_net_hdr *vnet_hdr = NULL;
+	struct virtio_net_hdr vnet_hdr;
+	bool has_vnet_hdr = false;
 	struct sockcm_cookie sockc;
 	__be16 proto;
 	int err, reserve = 0;
@@ -2868,16 +2869,20 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
 		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
-			vnet_hdr = data;
-			data += sizeof(*vnet_hdr);
-			tp_len -= sizeof(*vnet_hdr);
-			if (tp_len < 0 ||
-			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
+			data += sizeof(vnet_hdr);
+			tp_len -= sizeof(vnet_hdr);
+			if (tp_len < 0) {
+				tp_len = -EINVAL;
+				goto tpacket_error;
+			}
+			memcpy(&vnet_hdr, data - sizeof(vnet_hdr), sizeof(vnet_hdr));
+			if (__packet_snd_vnet_parse(&vnet_hdr, tp_len)) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
 			}
 			copylen = __virtio16_to_cpu(vio_le(),
-						    vnet_hdr->hdr_len);
+						    vnet_hdr.hdr_len);
+			has_vnet_hdr = true;
 		}
 		copylen = max_t(int, copylen, dev->hard_header_len);
 		skb = sock_alloc_send_skb(&po->sk,
@@ -2914,12 +2919,12 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 			}
 		}
 
-		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
-			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
+		if (has_vnet_hdr) {
+			if (virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le())) {
 				tp_len = -EINVAL;
 				goto tpacket_error;
 			}
-			virtio_net_hdr_set_proto(skb, vnet_hdr);
+			virtio_net_hdr_set_proto(skb, &vnet_hdr);
 		}
 
 		skb->destructor = tpacket_destruct_skb;
-- 
2.53.0



