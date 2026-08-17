Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6EE1D435F;
	Mon, 17 Aug 2026 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975312; cv=none; b=oedOCTQz6wTr/StYVXJLph5TpdQlGOoT1bzFbWIRQdjrxzMwDLlT7M+Zcizt+YKCKF4up4bWaaCRWFGo4TjGvig4mmzWD4oRBgbFjcYD7FY871Svpu0l4BEdz2O3BEypjP8+NrjWl4a00DPA0mG2O1DbTOc6BDHdMQa2/YmM640=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975312; c=relaxed/simple;
	bh=IRcIkwcx/+Ui+W3SRZZ3vokr9WzViyGH6zklRfY3KDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZRTKBNlu9jdwd2FDJTwY5SEr1anjd970l8aNTvOyOPgzY8BhyXFo88o8FoODBMFYwwjKABVcjkEciJSRz4AMI+GQCdEsVrpvS6w2bOF5sCtj0jWkwPYz3L22tZEDB5edivG4Y37npJQgxepyBpwQ6oRowiQocypugDRMU99Aa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdqTqyKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdqTqyKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0E01F000E9;
	Mon, 17 Aug 2026 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975311;
	bh=nicPoSGrYhzWOPla6r8MiqFllEAOwCOrEA2sKMx6REw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdqTqyKuvxEqYa/Bo4ymUmL+yS1onKh+C/s3BKaO9uwNVNldwFet6IVJ4NrnEMfi0
	 wC7sPnSGgP1faQbi9iD4oKwFdcF3FSymZA3grS/0xr54e/knWvAN+aPdid6xE11ejS
	 l3cxVzPsnIA4NZPW/pIJyrGWCKEGven0dsv/6dTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 234/250] ip6_tunnel: clear skb2->cb[] in ip6ip6_err()
Date: Mon, 17 Aug 2026 15:33:15 +0200
Message-ID: <20260817132546.050342849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -677,6 +677,9 @@ ip6ip6_err(struct sk_buff *skb, struct i
 		if (!skb2)
 			return 0;
 
+		/* Remove debris left by outer IPv6 stack. */
+		memset(IP6CB(skb2), 0, sizeof(*IP6CB(skb2)));
+
 		skb_dst_drop(skb2);
 		skb_pull(skb2, offset);
 		skb_reset_network_header(skb2);


