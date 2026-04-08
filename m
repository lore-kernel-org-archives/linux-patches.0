Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F3C324B1F;
	Wed,  8 Apr 2026 18:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672481; cv=none; b=BbAHqSVdmAqVM+2viLr34R2fwEmiEfvgpF+Bl+uY8d7Qf/Fuufcp4MS5aIcRXIqBaGST7+UN1esmerhwPd5XCgnObidc7wqZeyYdYZhHK0vFdOg+BW/pmuJxmorMVd+mA5W+r1A7TVba/hFwDPMuyfs/0YXWGNsmfdJQa/ET1bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672481; c=relaxed/simple;
	bh=SeafxZw7k9fNF4cCWcDIO3yHRKSSvRxJt5nyB8vDazc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lp40z1G+p2fGDYdn0pb9uBMSXBUJvWsMg+A/mnRA1puVE/DpuOwxb8OwEa4CC1woAkKa9DZhm5jjTcmnx1hgeviD67AewR1OxuzU4gf1C/lnqBbCSWVlao37zXgTKX/FrTIyK9mPBvaSNzXD3PRiJHvi4w3cCUEnf6LVU4WekqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIpc9bR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIpc9bR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892E2C19421;
	Wed,  8 Apr 2026 18:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672480;
	bh=SeafxZw7k9fNF4cCWcDIO3yHRKSSvRxJt5nyB8vDazc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIpc9bR0Bz4sEWtEJFnQsL5G38RfDN0iq8pE9th6ZiTa43wVDKfK7nXkMXJCw+Pbm
	 GAeBJPOmALmPXGtI1b2161PplvtkLfVEHvaQgKhzHrQfETpvYQLH+nL0Dmv4JpCc0g
	 XzxBWeY160mn+J1Cy2b3fDYr951d96TbF4ESZUig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Oskar Kjos <oskar.kjos@hotmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/160] ipv6: icmp: clear skb2->cb[] in ip6_err_gen_icmpv6_unreach()
Date: Wed,  8 Apr 2026 20:01:50 +0200
Message-ID: <20260408175914.068077276@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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
index 1d1c56e0e2460..0002fe04e0409 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -679,6 +679,9 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
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



