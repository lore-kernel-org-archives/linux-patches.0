Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F002AEEB;
	Sat, 12 Sep 2026 15:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227121; cv=none; b=spdTHA3zilwnnnrhcb8uos8egkGJ8M7NJwVh5/a6moZmk74e4t3lTmYsS1dQT2yk86iDIcQbYCb5WEIyoTD7PvqJTNVaCUnfuPghxeVE7fLLINmKSARA3Z9bsNWsGRjNCSzbCqYuaIyuiJgTV4Z5284/UKQ7bOMOHp+n9LrTLLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227121; c=relaxed/simple;
	bh=nG2ttcLNH853Sk6fieM7F8cFKOoudfOw0jPyt7MiJ2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgrTnhUt07lF/rTVGqoKwRcI+Cx963RvxdUMT9PP4l5gCc0xtWQS7TmOuMC9sxpOkaLPSsAQ47YQFw+WpfXLaLc0TmflBrNZ/OZNAqLlq5xPqcHjbyMwVNj5Wzwzz2Er33ryC0SEcwBCLb0hW6DWwx8G3P5irejV/fStUf+BHYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZv9fF4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZv9fF4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0672A1F000FF;
	Sat, 12 Sep 2026 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227119;
	bh=gCzIJ/kq67YxsOUoU55MP1BB0jaJtzK65m0bMZ1l/XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZv9fF4YX02flH61QpO1uxPiQqGCiwxOVcZ96N0nDRnt81lTH87x3KzpF9ni2Ye9P
	 PM2ofvEAcnVrWQZZlyW7QyRAWD7g+BFtrBuvVV8fn+7PRuihmDku57bhx0Z3CgEuV0
	 v/XVF35xAGhIRvrrpODIGikATonsvXoFBqi/fC6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0117/1191] ipip: fix skb leak in collect_md mode when metadata_dst allocation fails
Date: Sat, 12 Sep 2026 08:47:25 +0200
Message-ID: <20260912065550.818538562@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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


