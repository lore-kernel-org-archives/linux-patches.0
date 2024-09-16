Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870F9155C8A;
	Mon, 16 Sep 2024 12:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488256; cv=none; b=J/PEW1vyA+q9xlnaPBI9hTPv9GAXwcqMM6/xD2Epwb1cteQL2rmILDgt3CiwiH4zdCBwrwB0cRCQni3AgpJBLG9W74IpKw7q7IlaHOZltWmEOXUlk7eRvr6xiXcGL6IJSya2EBmeFfIp6BDz1gjpjjJb5wFNur7p9+eOT8rqat0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488256; c=relaxed/simple;
	bh=LICkqYE61a1kFS8jzFQuBCdOJbYEBMwdzzNefSp9Xr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrJxelhp9hzdd+R0TWprwq9RXv6phuaELBMJ0NjfVr0rUxtfwd2dqNcy9LltHGYmCIwKNy/wXme03BPc/6vm+WbyoybuLAXQPdJ96QFNo3gMey5XriXHM6jzHq4KtD3K7E4MDOVwvfGcs8Chpepde8qbju2lE7FZNW0buSvkBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0sSfN59; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0sSfN59"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1C3C4CEC4;
	Mon, 16 Sep 2024 12:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488256;
	bh=LICkqYE61a1kFS8jzFQuBCdOJbYEBMwdzzNefSp9Xr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0sSfN59EphhEZvTiCVTQrAl+lCduccR7ioExL7kUXWBtoP+yyyrviLcDJ0FI8Wp7
	 FGKEd7Sd21Hc2tcxDT40FZpbq6iUckpcBLCbNaXcec0Qb/eZ+pwM3/bKYlvBTjxK2Z
	 F1zRpko4N+l/3nOp2dnZN6ezwMQ94NzTyDy3noSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 050/121] net: tighten bad gso csum offset check in virtio_net_hdr
Date: Mon, 16 Sep 2024 13:43:44 +0200
Message-ID: <20240916114230.781993769@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

commit 6513eb3d3191574b58859ef2d6dc26c0277c6f81 upstream.

The referenced commit drops bad input, but has false positives.
Tighten the check to avoid these.

The check detects illegal checksum offload requests, which produce
csum_start/csum_off beyond end of packet after segmentation.

But it is based on two incorrect assumptions:

1. virtio_net_hdr_to_skb with VIRTIO_NET_HDR_GSO_TCP[46] implies GSO.
True in callers that inject into the tx path, such as tap.
But false in callers that inject into rx, like virtio-net.
Here, the flags indicate GRO, and CHECKSUM_UNNECESSARY or
CHECKSUM_NONE without VIRTIO_NET_HDR_F_NEEDS_CSUM is normal.

2. TSO requires checksum offload, i.e., ip_summed == CHECKSUM_PARTIAL.
False, as tcp[46]_gso_segment will fix up csum_start and offset for
all other ip_summed by calling __tcp_v4_send_check.

Because of 2, we can limit the scope of the fix to virtio_net_hdr
that do try to set these fields, with a bogus value.

Link: https://lore.kernel.org/netdev/20240909094527.GA3048202@port70.net/
Fixes: 89add40066f9 ("net: drop bad gso csum_start and offset in virtio_net_hdr")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20240910213553.839926-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/virtio_net.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -173,7 +173,8 @@ retry:
 			break;
 		case SKB_GSO_TCPV4:
 		case SKB_GSO_TCPV6:
-			if (skb->csum_offset != offsetof(struct tcphdr, check))
+			if (skb->ip_summed == CHECKSUM_PARTIAL &&
+			    skb->csum_offset != offsetof(struct tcphdr, check))
 				return -EINVAL;
 			break;
 		}


