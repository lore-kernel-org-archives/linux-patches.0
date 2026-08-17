Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20023E44F3;
	Mon, 17 Aug 2026 13:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974650; cv=none; b=DLKRgj4DjXK8qi492e4izQwWeEMGL6qg1pScR1/Mhwj/Q9KAVRSjm/OFfASZjkrzO912xFw7Dk9AwmQArnegfr062gzoZ9t6E835pNFvv5FQGhrK4xFC3T3JZDUW8gy7hhts6wzD46G0TEuV2nAUkOgrmNGMhKYQQ158KkKiNu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974650; c=relaxed/simple;
	bh=vmTH3XA54m7gDPHw44FXKNRaqjAg4LVgeYd8NFdm6kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+xchc0I0zBlm3TLoBYjO+aff6unJd5+8WVHlplxFTsPWtnSiHzq9j/4O9C80f5BIrdp5hKaA5jj1p3dpO7p01AADZVf9koozd0ugoCPpr8lgEVMyikyl2NoFsOHsT77nkzqdhW46l5T2nKXZZ+YcGRa77a1b5gQb9lsbscEDfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z6jrbPHq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z6jrbPHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7011F00A3E;
	Mon, 17 Aug 2026 13:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974643;
	bh=GPOP6jSs/PgknQcsLtvf+H6IiYIA1DAgsCyCWo17Ess=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6jrbPHq3SiT/c8G3TwhnfeNW6QdSgsKVjpuRpDFlrqh8CRY6SbLwNf0TyJJBfCt1
	 QhfH5ILFV52IVkKhK3ZCIYjpYinNorVCkgeSxnExe7S6jLGSzwTuvI1PQmlPdr+PkC
	 pGtmf+Vzl8u3ECOFemTwHQzRD0rdPDHlyFB3qUic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 255/271] ip6_tunnel: clear skb2->cb[] in ip6ip6_err()
Date: Mon, 17 Aug 2026 15:33:00 +0200
Message-ID: <20260817132547.237061944@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit f803c086399da277b5d0ff36a107d0f162751800 upstream.

ip6ip6_err() clones an outer IPv6 ICMP error skb, pulls it to the
quoted inner IPv6 packet, and then passes the clone to icmpv6_send().
The clone still carries the outer packet's inet6_skb_parm in skb->cb.

If the outer packet had a Home Address Option, IP6CB(skb2)->dsthao
remains non-zero after skb_pull(). icmpv6_send() later calls
mip6_addr_swap(), which uses that stale dsthao offset against the quoted
inner packet. A malformed inner destination-options header can then make
the HAO lookup and address swap run past the end of the quoted packet
and corrupt skb_shared_info.

Clear skb2->cb[] before pulling the quoted inner IPv6 packet so the
reply path does not reuse metadata left by the outer IPv6 stack.

Fixes: e490d1d85cf5 ("[IPV6] IP6TUNNEL: Split out generic routine in ip6ip6_err().")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/fe1a5e765fbca88d69391887f0ed26a19e3e4d39.1785736562.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_tunnel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -684,6 +684,9 @@ ip6ip6_err(struct sk_buff *skb, struct i
 		if (!skb2)
 			return 0;
 
+		/* Remove debris left by outer IPv6 stack. */
+		memset(IP6CB(skb2), 0, sizeof(*IP6CB(skb2)));
+
 		skb_dst_drop(skb2);
 		skb_pull(skb2, offset);
 		skb_reset_network_header(skb2);


