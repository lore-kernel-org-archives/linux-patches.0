Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DBB3AC00;
	Fri, 24 Apr 2026 13:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037590; cv=none; b=Twtdzj6tifi649J4ZtMDFfGtW8KRfRzFM6Nm+1QBxRtlYTceBwCabnULWBEjddzrQy+pVmi24UrRFI1k6Q5xOFJ3TSpkhUq5KJD+FlVVo6F7V/mCfa7mCcOrriznUol4KQ9dIQRgDg01zS+hoUw3Ts4Ids1G+2Ikuy38MBdbz2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037590; c=relaxed/simple;
	bh=LD5MujiVBRD+nghyXFEALmfNTKmzlXp1f6S1efyPA9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cytuGwtGof6+kVNkAa3yqPya4xJoYnVYqc1Jxj5nAdjOp1RAaJ3WpXyDAxjCrCY5SpfrBadzNJ5RnqwpiWlj9ZRxvynDrIWv9VU4av8w3CV6+GFxwAZ7DYw3/y67q93hbE8SXCMvuDapyo2u7wyP3srqSxQn/IRDEyTtx7PHIU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjhaFtwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjhaFtwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE972C2BCB2;
	Fri, 24 Apr 2026 13:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037590;
	bh=LD5MujiVBRD+nghyXFEALmfNTKmzlXp1f6S1efyPA9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjhaFtwh9+JkBAsz7lvQ1MMwTlnvVGNBmRq3WFhays5DwQmTkE/ONK+QArWtduSmV
	 Y4DuKEnTK7dRM+dFBbJgG78iBzcUva1MfvSd/RoEwb7dgLupvWuPtTnjAw4I6IQgHx
	 neanjPeuXVHd66JXUXk+n/uYMpqjNPWDaBgpMz+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingquan Chen <patzilla007@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 37/42] net/packet: fix TOCTOU race on mmapd vnet_hdr in tpacket_snd()
Date: Fri, 24 Apr 2026 15:31:02 +0200
Message-ID: <20260424132428.321641994@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingquan Chen <patzilla007@gmail.com>

commit 2c054e17d9d41f1020376806c7f750834ced4dc5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2717,7 +2717,8 @@ static int tpacket_snd(struct packet_soc
 {
 	struct sk_buff *skb = NULL;
 	struct net_device *dev;
-	struct virtio_net_hdr *vnet_hdr = NULL;
+	struct virtio_net_hdr vnet_hdr;
+	bool has_vnet_hdr = false;
 	struct sockcm_cookie sockc;
 	__be16 proto;
 	int err, reserve = 0;
@@ -2818,16 +2819,20 @@ static int tpacket_snd(struct packet_soc
 		hlen = LL_RESERVED_SPACE(dev);
 		tlen = dev->needed_tailroom;
 		if (vnet_hdr_sz) {
-			vnet_hdr = data;
 			data += vnet_hdr_sz;
 			tp_len -= vnet_hdr_sz;
-			if (tp_len < 0 ||
-			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
+			if (tp_len < 0) {
+				tp_len = -EINVAL;
+				goto tpacket_error;
+			}
+			memcpy(&vnet_hdr, data - vnet_hdr_sz, sizeof(vnet_hdr));
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
@@ -2864,12 +2869,12 @@ tpacket_error:
 			}
 		}
 
-		if (vnet_hdr_sz) {
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


