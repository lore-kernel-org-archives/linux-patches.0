Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CCF80614;
	Mon,  8 Apr 2024 14:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585154; cv=none; b=R7BGu5j+ifV/xv1ZBZjFTK5OkkA42Wd2sBptsIa1ttcDGZKgjMp6hZ+ZP/uGn57flH/jsKbKLc40XQy34qCMlyiOwDGrqQlE9gH8E3KXa5j3g1nmqUiKzSGW75os07kao/9obsvIRRRaFAEfampK+UFn1Oep2el9l4pFosmBdkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585154; c=relaxed/simple;
	bh=x5JY+2OaA03Eiyjk4YrsYzpxx2SI2HZw9jj/qOVNpNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nCuq6bL2T75sBi8AYHSs5qP//OiLJhxkOcINYwoFwhnbsl00xiVJQpc9SsdPg4QQA0Ox18iXRLKFqHZiz5quQW7kcp41RIFprJM4Vy+/ONPYinePH6B5QWgL+k98m/VhLNl7uufgV7gtnRd0RjVGOzpQ6ES978Q32/g7/9Orufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VFXefnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VFXefnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C923C433F1;
	Mon,  8 Apr 2024 14:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585153;
	bh=x5JY+2OaA03Eiyjk4YrsYzpxx2SI2HZw9jj/qOVNpNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VFXefnI+JzFcHC9cUoxLu0rRo6DcjB2Xols2gN8E7YACz+alP9SzqA4J6G7H7DHA
	 Jy6OIlhMFpDqHGVwJyekMxk/rhZKsT7jJH1P9axnyuejdZ+UQL3rS8tTuTqGVo4yZ7
	 8fhT+pJ1xeFqf13GFvw5b0+IrKqVRCyVehtuRi4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Antoine Tenart <atenart@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 651/690] udp: prevent local UDP tunnel packets from being GROed
Date: Mon,  8 Apr 2024 14:58:37 +0200
Message-ID: <20240408125423.226214034@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -522,6 +522,12 @@ struct sk_buff *udp_gro_receive(struct l
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
 			NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled : 1;
 


