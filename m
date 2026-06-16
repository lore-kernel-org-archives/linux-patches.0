Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB53D810C;
	Tue, 16 Jun 2026 18:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634493; cv=none; b=bSIb5TBbHBEbeB2P7fyfhI4o0bRzFFaqIviWrf69f5z2Pm8sweb5V364iAaeG3kHX7N7bT/N0aWmO7QUZWOt5vb1/rinKS5NeWrEer6R3oqDSBhuvjIuxRq96PCubEPWMlEys172jdceG4hZHGB8tPG0u/NR13srzaRdI658rZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634493; c=relaxed/simple;
	bh=muVXzIQk6G6Wu3dcnPdiXMvLqxwQu1S3L9Qv/sk/RHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A90g0x78alQ5YR66TzIeFDFB+3P8+RZcpH1qw8Yov4f65dEQWzJLbr0otnNgxsWBIK5E7nZSqmg+AEaJfmF2PkrL2cHdFNuIGsBcg+awMoWKkfCrbsPjHEoJsphydQ6jpFM6MOcbk7MQfc3zASljzv2f05ToMK9wj5ZJIsRODwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/In9Dwd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/In9Dwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FAB1F000E9;
	Tue, 16 Jun 2026 18:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634492;
	bh=pemb/VtVt36Y4u/aLth0cWKArf+ZtBza2vus4EwJO7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/In9DwdiShvtmp9+ddiOFoFwxJ5q4JS5FvZRr6lFYuU8LEuzWidCuDHzkpS9Ol0G
	 9gUXnvEORaJJ9jDtyXPk9ZiNPJhNOp5DrYcPiVr7iUd9aoKnTeG9MC4lLl621xOFwr
	 SXS2J2lx36ivOgJ3JPVDGcJRFGKITqBpDwoKc540=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingquan Chen <patzilla007@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/411] net/packet: fix TOCTOU race on mmapd vnet_hdr in tpacket_snd()
Date: Tue, 16 Jun 2026 20:28:16 +0530
Message-ID: <20260616145114.716800026@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
[ replaced `vnet_hdr_sz` with `sizeof(vnet_hdr)` and `if (vnet_hdr_sz)` with `if (po->has_vnet_hdr)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2729,7 +2729,8 @@ static int tpacket_snd(struct packet_soc
 {
 	struct sk_buff *skb = NULL;
 	struct net_device *dev;
-	struct virtio_net_hdr *vnet_hdr = NULL;
+	struct virtio_net_hdr vnet_hdr;
+	bool has_vnet_hdr = false;
 	struct sockcm_cookie sockc;
 	__be16 proto;
 	int err, reserve = 0;
@@ -2829,16 +2830,20 @@ static int tpacket_snd(struct packet_soc
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
 		if (po->has_vnet_hdr) {
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
@@ -2875,12 +2880,12 @@ tpacket_error:
 			}
 		}
 
-		if (po->has_vnet_hdr) {
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


