Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3AC47F2F9;
	Sat, 12 Sep 2026 13:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220254; cv=none; b=oin4Zw2Un8f1nDcXuUl3xXWElwF//Im+LGFc1jgAcpR4jMixoD1GuJ90gTiCVgyYSvhVV4AZYpxTe55F0L+llEpUuhTK7BDL1G4iaWBZjakMvXGiIiY8k3DQVZvrKzJXinesy9+D+imb1mgXdg6nGQjc3OSd0wPAE18jg5vpZ6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220254; c=relaxed/simple;
	bh=eE6W7btdmWhEny+qpY3a5c99mhFj37hz4rdb+ctrFN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aprTzLpxo4j0tD8Sydj+HzsEUCt4Y00eFNZLLVgmqMzK8WLNAId5yphPRdmxN9MQ38wR1soCHdLjmdFW+zslbGnQ+paMHZkTnDRt/CokXLJ/Dctge/FgZAQ/7yC/ovcG/F5iJ8JfTsXSYqBNamBVi+SZZDRXvJgXdFC7rSg8Ydg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krCc3aQa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krCc3aQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D5381F000FF;
	Sat, 12 Sep 2026 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220253;
	bh=yEIM01pws8e4P3yjC03P9EbBGhtuFX2IAt0NZMlkinY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krCc3aQauKzzBNFCyatImNZjciMIjjt3mHd6acQ80RumVC6BNF2bk1xdodFCr7yDr
	 SEeU0lEiFFAmA2prb83/HfJPYpg6uI4/zuPefHhjzaYEYjyU7IPl9MBfVnBZi3fuTO
	 B/B7GWqGmJ18BC9MtgkNKpb6tcGZj+EEp3ceQ1rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0139/1424] ipip: fix skb leak in collect_md mode when metadata_dst allocation fails
Date: Sat, 12 Sep 2026 08:42:51 +0200
Message-ID: <20260912065610.411467272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Anton Danilov <littlesmilingcloud@gmail.com>

commit 6776efe4a52f289a3fc18f8adf19b035a7d8e1bb upstream.

In collect_md mode ipip_tunnel_rcv() returns 0 without freeing the skb
when ip_tun_rx_dst() fails to allocate the metadata_dst. ipip_rcv() and
mplsip_rcv() are registered as xfrm_tunnel handlers, so tunnel4_rcv()
and tunnelmpls4_rcv() read the zero return as "the packet has been
consumed" and do not free it either. The skb is leaked.

The other tunnel drivers all dispose of the packet at this point:
ip6_tunnel.c jumps to its drop label, ip_gre.c and ip6_gre.c return
PACKET_REJECT, which makes gre_rcv() free the skb. Only ipip returns 0.

Jump to the existing drop label instead. It frees the skb and still
returns 0, so the packet keeps being reported as consumed, which is what
we want here: the outer header has already been pulled, and neither the
remaining handlers nor an ICMP unreachable have any use for it.

Triggering this needs an ipip or mplsip tunnel in collect_md mode and an
atomic allocation failure, which is why it has gone unnoticed.

Fixes: cfc7381b3002 ("ip_tunnel: add collect_md mode to IPIP tunnel")
Cc: stable@vger.kernel.org
Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260819104338.432631-2-littlesmilingcloud@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -240,7 +240,7 @@ static int ipip_tunnel_rcv(struct sk_buf
 		if (tunnel->collect_md) {
 			tun_dst = ip_tun_rx_dst(skb, 0, 0, 0);
 			if (!tun_dst)
-				return 0;
+				goto drop;
 			ip_tunnel_md_udp_encap(skb, &tun_dst->u.tun_info);
 		}
 		skb_reset_mac_header(skb);


