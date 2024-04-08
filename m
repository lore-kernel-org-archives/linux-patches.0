Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9DF2DF73;
	Mon,  8 Apr 2024 13:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582790; cv=none; b=sxp+JeWDAF3i/2JDPg/X3KuPSAOAe6GGpDZAjAqu6/1CIVDNITesCvnWpzLMO+CaYLbrPGVmFT5rDCzzbV23IJn5Zd52IQFzF2U0fYYHVwZcdNxtzwcpc0G/2zCS+OBctzGjd/HKbLME1CxeKwPiN5gpw4Q3g0K7bNhgjR85eHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582790; c=relaxed/simple;
	bh=abEaaUcRm6DvMHULovQuQuVujQJFuVb9n3BaRqBvXE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBtAMVDUQMrlDB6KmkI/IyBaEfJ28QB3EZHLwGdcEDFsZL6CqgeNWrfOb3fOM0Kqycn1dKbdSlSYNUAgix/eJ8dDnwSAJGEfD0AcRGxvu6w/JnqKdw4PHrCErZqrdrb8xdqRMKLyGs9tVf2GPI8ge7gcDODUM+rPCdSay6i+uoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1YVlYlw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1YVlYlw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB969C433C7;
	Mon,  8 Apr 2024 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582790;
	bh=abEaaUcRm6DvMHULovQuQuVujQJFuVb9n3BaRqBvXE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1YVlYlwPLZDUPSMBhViTySh41BBJdZfipVuKtiON4U/wSmbB/Caol7knBAw1/17a
	 dCbpLkczCyQn/w1O/X8e1s/gPfzvvBDUJAR2wuX1oOMARDDRMxTWfSpA6mDTUKD9TA
	 Tq6c9Yyp0psCOgmjTNuxMlS0cCgFKk4YasO7ijcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 124/252] udp: do not transition UDP GRO fraglist partial checksums to unnecessary
Date: Mon,  8 Apr 2024 14:57:03 +0200
Message-ID: <20240408125310.473126041@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


