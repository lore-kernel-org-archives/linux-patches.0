Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11467811FB;
	Mon,  8 Apr 2024 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582942; cv=none; b=bcH1vN9CdpAGSVMUg1FYtg69Z1n8q5FDGjYnaXD9fGG6HVdU6uDeQuHgAW/P6yS+BruSh8T0tTKzQCQdGAMLet3Cusj2DzgKvQM5HzuoHTXmDHhbh0m6I0aiSmq/LWxm/UChRgzxdjnyTY3txmu0L3aiD8pRR+0RD+zmyk+rGKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582942; c=relaxed/simple;
	bh=xR7mfkdzsNPniI+1ZLWUbhrBY/7QGaE9qmmxTrQONOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lYqnTXzJRnmnjDgLkyUTVyn+V5aYdQ+B8VFz+F7cu9AYeKcCRJBA7rqVIBIG0oOY+nfcOWBlEWvWQ7W4GIGn5eA2Pnck7NkyBjvRt1I3qhZiI5989zGrjpZ0XZFB4OAB0kXEGaZN1wOVnu9li8X+i+Dosbe11lJuvwx6e2qckuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xSt0Ufy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xSt0Ufy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356E7C433F1;
	Mon,  8 Apr 2024 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582941;
	bh=xR7mfkdzsNPniI+1ZLWUbhrBY/7QGaE9qmmxTrQONOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xSt0UfyPKZD70YUES4oQYAVnGFiPKJjmq5iM23C1YYWIAxne9sOvlDiNg5MaAzj/
	 ZuffKqMAQJc+QLbGSMVb6uFshqCSqBHuZhvekthbGhaOkwAoSq0WNbyRfTaVn8Xktn
	 Js3oI9tTzLyZ1ZiOYWMftZB2uPIGWfAfNsOPLR80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 123/273] udp: prevent local UDP tunnel packets from being GROed
Date: Mon,  8 Apr 2024 14:56:38 +0200
Message-ID: <20240408125313.114833115@linuxfoundation.org>
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

commit 64235eabc4b5b18c507c08a1f16cdac6c5661220 upstream.

GRO has a fundamental issue with UDP tunnel packets as it can't detect
those in a foolproof way and GRO could happen before they reach the
tunnel endpoint. Previous commits have fixed issues when UDP tunnel
packets come from a remote host, but if those packets are issued locally
they could run into checksum issues.

If the inner packet has a partial checksum the information will be lost
in the GRO logic, either in udp4/6_gro_complete or in
udp_gro_complete_segment and packets will have an invalid checksum when
leaving the host.

Prevent local UDP tunnel packets from ever being GROed at the outer UDP
level.

Due to skb->encapsulation being wrongly used in some drivers this is
actually only preventing UDP tunnel packets with a partial checksum to
be GROed (see iptunnel_handle_offloads) but those were also the packets
triggering issues so in practice this should be sufficient.

Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
Fixes: 36707061d6ba ("udp: allow forwarding of plain (non-fraglisted) UDP GRO packets")
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp_offload.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -559,6 +559,12 @@ struct sk_buff *udp_gro_receive(struct l
 	 */
 	NAPI_GRO_CB(skb)->is_flist = 0;
 	if (!sk || !udp_sk(sk)->gro_receive) {
+		/* If the packet was locally encapsulated in a UDP tunnel that
+		 * wasn't detected above, do not GRO.
+		 */
+		if (skb->encapsulation)
+			goto out;
+
 		if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
 			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_test_bit(GRO_ENABLED, sk) : 1;
 


