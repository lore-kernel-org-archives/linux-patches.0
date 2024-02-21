Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B261E4B2;
	Wed, 21 Feb 2024 13:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522978; cv=none; b=DJRl6kVeuZgHy1qhz4OmC0rhPjwHRcDfASxfLKPOkOXrT/JVFbNoZ1RUyCrABBTfTDQWWPRtg8+RGXwSIjmNbl21dSGN7pVZfOtJhj2ECp7IKJ3O7rLu46CJgmteBspb6Rcw5EiS6A2HZZn6VnY/IckXqD/3GZx1VYVqMV5eeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522978; c=relaxed/simple;
	bh=5GTUTUO794I6YsiJhQ+ntaqpj6Qx2nVEyUCjjxd6z7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXf5EeECgHpr1LBD0y9Obow9okkH6UhckcuaKVLF7SN78vdmwkXAA2ASqSyab/yLO77i6GVwBH6m3ocmn9GzdHBA9aUAHjiWCKDERlemX+gaUvT/4piY5utLLOPqspoH4KzQKcjk4NB7QyRrr48R+nxwwAGNc8OGhu+GtZWLivU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsUPoSMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsUPoSMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A35DC433F1;
	Wed, 21 Feb 2024 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522978;
	bh=5GTUTUO794I6YsiJhQ+ntaqpj6Qx2nVEyUCjjxd6z7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsUPoSMNTPKGrStdbb/X/gQajMuHtVOe66tI+Rg5YZAQPOjsbD/sxBMHbkluLkhpJ
	 TDfncB6TX1EBgCNo+kffBUNdgRQlphEV3GrYTmcNjRA+q18nWfrtu07wk2j8B/JQnx
	 PGda3bqCA/4MhO/xbR1T7r651sXRSiLvNdiDDoGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/476] tunnels: fix out of bounds access when building IPv6 PMTU error
Date: Wed, 21 Feb 2024 14:05:58 +0100
Message-ID: <20240221130019.368804488@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

[ Upstream commit d75abeec401f8c86b470e7028a13fcdc87e5dd06 ]

If the ICMPv6 error is built from a non-linear skb we get the following
splat,

  BUG: KASAN: slab-out-of-bounds in do_csum+0x220/0x240
  Read of size 4 at addr ffff88811d402c80 by task netperf/820
  CPU: 0 PID: 820 Comm: netperf Not tainted 6.8.0-rc1+ #543
  ...
   kasan_report+0xd8/0x110
   do_csum+0x220/0x240
   csum_partial+0xc/0x20
   skb_tunnel_check_pmtu+0xeb9/0x3280
   vxlan_xmit_one+0x14c2/0x4080
   vxlan_xmit+0xf61/0x5c00
   dev_hard_start_xmit+0xfb/0x510
   __dev_queue_xmit+0x7cd/0x32a0
   br_dev_queue_push_xmit+0x39d/0x6a0

Use skb_checksum instead of csum_partial who cannot deal with non-linear
SKBs.

Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_tunnel_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index d3275d1ed260..50ddbd7021f0 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -332,7 +332,7 @@ static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
 	};
 	skb_reset_network_header(skb);
 
-	csum = csum_partial(icmp6h, len, 0);
+	csum = skb_checksum(skb, skb_transport_offset(skb), len, 0);
 	icmp6h->icmp6_cksum = csum_ipv6_magic(&nip6h->saddr, &nip6h->daddr, len,
 					      IPPROTO_ICMPV6, csum);
 
-- 
2.43.0



