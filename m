Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CCC78285;
	Mon,  8 Apr 2024 13:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583148; cv=none; b=I6A36cex5QiVIR4K3jDLLhSzhxMv3zU9lulXz3tXrJ059jXzrkVLVdzTesMlq7hAWpeK9tmhJjWoSIAKmdVS3IUgyOezhnY0aLww/+wHTpmly0e6SWngnrWQDyNozr1P/jRIKg2oXX0+YESCIIbejNuTb5XYJ1UFyUtgTKOV8j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583148; c=relaxed/simple;
	bh=jyKOit/RFiH/1leLbgvy0YECfZwvjZ1gRfaT9y/Zumk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtG/Y/s3mQYrNMX+w6HEohrHtdSE3BNUvoz3zD5J8ihCYNUo/AwHD89ux0UzLo6+Ffw7u7wLeAZ64QBmAJQUGyblTHYjQ0sZdVwC6tZTl3kxZ7M+U+0ceB7B+VsgAqVhIdQsgLtrTnCfho64qK286YHNjJhj6ID95qgN2602H1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLgAc/wx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLgAc/wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDBBC433F1;
	Mon,  8 Apr 2024 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583147;
	bh=jyKOit/RFiH/1leLbgvy0YECfZwvjZ1gRfaT9y/Zumk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WLgAc/wxLD1PPcRjO4cVwZPxLz+5IFtgYPJr3BLM2Y6RQw4MUYuasH4B7XV/37ci6
	 cRlkRjpyHsnPWd06Rm5BmZAEj3nm3yvaOTmuJ6rPk5SjT7VCPpt1UYt+PefzoaKQUv
	 MtuvEoL0riJxjNiaRoaXthj5XS/Oj0TIg3gnZfdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 122/273] udp: do not transition UDP GRO fraglist partial checksums to unnecessary
Date: Mon,  8 Apr 2024 14:56:37 +0200
Message-ID: <20240408125313.084913791@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

commit f0b8c30345565344df2e33a8417a27503589247d upstream.

UDP GRO validates checksums and in udp4/6_gro_complete fraglist packets
are converted to CHECKSUM_UNNECESSARY to avoid later checks. However
this is an issue for CHECKSUM_PARTIAL packets as they can be looped in
an egress path and then their partial checksums are not fixed.

Different issues can be observed, from invalid checksum on packets to
traces like:

  gen01: hw csum failure
  skb len=3008 headroom=160 headlen=1376 tailroom=0
  mac=(106,14) net=(120,40) trans=160
  shinfo(txflags=0 nr_frags=0 gso(size=0 type=0 segs=0))
  csum(0xffff232e ip_summed=2 complete_sw=0 valid=0 level=0)
  hash(0x77e3d716 sw=1 l4=1) proto=0x86dd pkttype=0 iif=12
  ...

Fix this by only converting CHECKSUM_NONE packets to
CHECKSUM_UNNECESSARY by reusing __skb_incr_checksum_unnecessary. All
other checksum types are kept as-is, including CHECKSUM_COMPLETE as
fraglist packets being segmented back would have their skb->csum valid.

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    8 +-------
 net/ipv6/udp_offload.c |    8 +-------
 2 files changed, 2 insertions(+), 14 deletions(-)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -722,13 +722,7 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_com
 		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
 		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 
-		if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
-			if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
-				skb->csum_level++;
-		} else {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			skb->csum_level = 0;
-		}
+		__skb_incr_checksum_unnecessary(skb);
 
 		return 0;
 	}
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -174,13 +174,7 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_com
 		skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
 		skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
 
-		if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
-			if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
-				skb->csum_level++;
-		} else {
-			skb->ip_summed = CHECKSUM_UNNECESSARY;
-			skb->csum_level = 0;
-		}
+		__skb_incr_checksum_unnecessary(skb);
 
 		return 0;
 	}


