Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AB63382F3;
	Mon, 13 Apr 2026 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099406; cv=none; b=P8VbGVNa2fPsKZx8qwCjt9+yeaJduXL2AV9dmzDTY55NbSnJkQf8JiHUWcFR7eEUTJXvocRjRh1ZUOLSCjuI3DsFgW87eYxUoLA/Xh4MU8O6p8T/bJs+PUZkhDw2OuXIwXoAxUwyn1UA1JJNFD7WtW3KZ3WzSksvOmEunqRAomU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099406; c=relaxed/simple;
	bh=eOjQ9FuqX0+AtMmCBgifr9ylb/gQKF1aI/KHdC/nmOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPIIyXMhYE88daU7EKyXdYqUzbCIpIktxhWFsGhqiIgr0kxX/SxWz5tkT5o8eVGYp9Bqo8GSb7oydYrbM8PTFPs2UGgLb1Gj+wBa7EqjAoTxGtp5P/gx6jvW89qlB90cHCzWnOIbkbPl8QZeayJOscoQkZR+Q75rz5W5g/h4b0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaXc8BMe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaXc8BMe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D18C2BCAF;
	Mon, 13 Apr 2026 16:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099406;
	bh=eOjQ9FuqX0+AtMmCBgifr9ylb/gQKF1aI/KHdC/nmOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EaXc8BMexobgCYTlTXTUx9qEcCikAKGWudaaMeZtPbGeztCHqamsiDwME4xI7trE4
	 4QKgB/SiYu360QhEH6BMztNp+k2Q1Ug4i8M9NZvMHoDfJeeOlTTWhOHwmvByV2O273
	 NVR6kmDZ4bv7VQc75sRxtoXDFQ0slBN2BhSmaQoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oskar Kjos <oskar.kjos@hotmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/491] ip6_tunnel: clear skb2->cb[] in ip4ip6_err()
Date: Mon, 13 Apr 2026 17:59:33 +0200
Message-ID: <20260413155831.322619422@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2edfa31769a4add828a7e604b21cb82aaaa05925 ]

Oskar Kjos reported the following problem.

ip4ip6_err() calls icmp_send() on a cloned skb whose cb[] was written
by the IPv6 receive path as struct inet6_skb_parm. icmp_send() passes
IPCB(skb2) to __ip_options_echo(), which interprets that cb[] region
as struct inet_skb_parm (IPv4). The layouts differ: inet6_skb_parm.nhoff
at offset 14 overlaps inet_skb_parm.opt.rr, producing a non-zero rr
value. __ip_options_echo() then reads optlen from attacker-controlled
packet data at sptr[rr+1] and copies that many bytes into dopt->__data,
a fixed 40-byte stack buffer (IP_OPTIONS_DATA_FIXED_SIZE).

To fix this we clear skb2->cb[], as suggested by Oskar Kjos.

Also add minimal IPv4 header validation (version == 4, ihl >= 5).

Fixes: c4d3efafcc93 ("[IPV6] IP6TUNNEL: Add support to IPv4 over IPv6 tunnel.")
Reported-by: Oskar Kjos <oskar.kjos@hotmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260326155138.2429480-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_tunnel.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index e8c4e02e75d43..dda90c77f8984 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -634,11 +634,16 @@ ip4ip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!skb2)
 		return 0;
 
+	/* Remove debris left by IPv6 stack. */
+	memset(IPCB(skb2), 0, sizeof(*IPCB(skb2)));
+
 	skb_dst_drop(skb2);
 
 	skb_pull(skb2, offset);
 	skb_reset_network_header(skb2);
 	eiph = ip_hdr(skb2);
+	if (eiph->version != 4 || eiph->ihl < 5)
+		goto out;
 
 	/* Try to guess incoming interface */
 	rt = ip_route_output_ports(dev_net(skb->dev), &fl4, NULL, eiph->saddr,
-- 
2.53.0



