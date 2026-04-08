Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6CF3D8918;
	Wed,  8 Apr 2026 18:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672005; cv=none; b=YE8Oq8d9p2n0pz2zNDX8qBhzUx2/MlHQzjDvrOgrVHB4VXxN7d5Ft0L2lbaAWfpZKUt2KcEn4RGUPinwuBwr1tQZ6/d+seGZAOEIPJdkKGpA0SBXB5+wdCV806yJ+EydfEFqEGvnRYpwY9DZzjkGfTjs8N/PNErbdgK4HHwtXvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672005; c=relaxed/simple;
	bh=ICIcgYwO3bIvWoKAQvH29DLZFtEus5wCDxDSL5FPpiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCWhFd8baq8F+b3S8SR1nnYSC71K+nsf/O8NI5i6u2/jHnzaZsAKHOIq3cEeCP+6+1SNkYa9P+gJaXpxQfjqqdAiaM7zs4/tHuxcJJVLXtvLVgpLaU4aduDkNmpbks6HVYesNr1jqe2FmHAbX/3KMW3DZQjv+AtcjoNQMhnL7Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEJqZlnI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEJqZlnI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2138FC19425;
	Wed,  8 Apr 2026 18:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672005;
	bh=ICIcgYwO3bIvWoKAQvH29DLZFtEus5wCDxDSL5FPpiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEJqZlnIWxQT3hUpnxNVHpy/77St+oL4xv8mwSxgv5q6xlPWd/7aoKI/tN1rJAJv7
	 HT5rL8nhus66uNurR1GUoFyBnwgY71cseBGBfJ+wKZTucCR6/Op30n2YvLinAULExb
	 /NavgxtWNI4qR8py+nu//ii4Ekjo+WpGRzd+xyoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Oskar Kjos <oskar.kjos@hotmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/312] ipv6: icmp: clear skb2->cb[] in ip6_err_gen_icmpv6_unreach()
Date: Wed,  8 Apr 2026 20:01:08 +0200
Message-ID: <20260408175939.406138996@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 86ab3e55673a7a49a841838776f1ab18d23a67b5 ]

Sashiko AI-review observed:

  In ip6_err_gen_icmpv6_unreach(), the skb is an outer IPv4 ICMP error packet
  where its cb contains an IPv4 inet_skb_parm. When skb is cloned into skb2
  and passed to icmp6_send(), it uses IP6CB(skb2).

  IP6CB interprets the IPv4 inet_skb_parm as an inet6_skb_parm. The cipso
  offset in inet_skb_parm.opt directly overlaps with dsthao in inet6_skb_parm
  at offset 18.

  If an attacker sends a forged ICMPv4 error with a CIPSO IP option, dsthao
  would be a non-zero offset. Inside icmp6_send(), mip6_addr_swap() is called
  and uses ipv6_find_tlv(skb, opt->dsthao, IPV6_TLV_HAO).

  This would scan the inner, attacker-controlled IPv6 packet starting at that
  offset, potentially returning a fake TLV without checking if the remaining
  packet length can hold the full 18-byte struct ipv6_destopt_hao.

  Could mip6_addr_swap() then perform a 16-byte swap that extends past the end
  of the packet data into skb_shared_info?

  Should the cb array also be cleared in ip6_err_gen_icmpv6_unreach() and
  ip6ip6_err() to prevent this?

This patch implements the first suggestion.

I am not sure if ip6ip6_err() needs to be changed.
A separate patch would be better anyway.

Fixes: ca15a078bd90 ("sit: generate icmpv6 error when receiving icmpv4 error")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Closes: https://sashiko.dev/#/patchset/20260326155138.2429480-1-edumazet%40google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Oskar Kjos <oskar.kjos@hotmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260326202608.2976021-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index ea1cdacbdcf1b..80eabb22d144f 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -677,6 +677,9 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 	if (!skb2)
 		return 1;
 
+	/* Remove debris left by IPv4 stack. */
+	memset(IP6CB(skb2), 0, sizeof(*IP6CB(skb2)));
+
 	skb_dst_drop(skb2);
 	skb_pull(skb2, nhs);
 	skb_reset_network_header(skb2);
-- 
2.53.0



