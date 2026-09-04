Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314B41CB50;
	Fri,  4 Sep 2026 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502383; cv=none; b=ZPikCXDM1lTATmS1ylg7QAWgfwiu8SJ/CZ2Qep+QRc2nZo6FJzBagHMwazat1DbFn0zfAn33pDtJ0/Fw1xpUUk626alXznKyIEFbpn9zBaG/vjJ6ZfUBHU1GWY/6tmRxyxjbUkEV+z41iRgZHzLVVfW2gOaLcQxm0utTlUVL33k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502383; c=relaxed/simple;
	bh=+6Tbtr97/uH9hTPS0tmDtk/APxktiVwYa5Fkpymurdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de2U0GsNDaGop1zqJ7EUsA3lkQgIz+pqTGqdO4RgOLJZs59Cw6anBUelEtTk1yA6BT+zrDkJtYN+qqM57ArBUVahp6E0aA/QRsaQ8lHuvJlnLROzU5FelsZUZ3Brf1LRIuaZGIc0mnyMA9QqOTsz0F/WTv3SVVm7pltw3CleHcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAWgla+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAWgla+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4257F1F00A3D;
	Fri,  4 Sep 2026 06:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502382;
	bh=1GYhfCmEECnQ82IZxMwsCl+DC82x07zXG4ZO2Rim9ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAWgla+XWatkw/4Q/NneYW7prdku9ykdrm5IjirLMx9rBk+5Z46aAkjVurJuw4CxV
	 nJdGlCe1DleheIKq4uiUIReRPWRaVoDd4INi1luM0gIodGOgc0iLqcF33RwsvJtGKN
	 oJ6vvTbpIxkS94arhlisiQcVyFsLdRIxT2BM36a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 189/403] ipip: fix skb leak in collect_md mode when metadata_dst allocation fails
Date: Fri,  4 Sep 2026 06:59:52 +0200
Message-ID: <20260904045739.155566211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -248,7 +248,7 @@ static int ipip_tunnel_rcv(struct sk_buf
 
 			tun_dst = ip_tun_rx_dst(skb, flags, 0, 0);
 			if (!tun_dst)
-				return 0;
+				goto drop;
 			ip_tunnel_md_udp_encap(skb, &tun_dst->u.tun_info);
 		}
 		skb_reset_mac_header(skb);


