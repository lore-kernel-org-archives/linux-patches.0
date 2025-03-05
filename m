Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0E814B075;
	Wed,  5 Mar 2025 17:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197572; cv=none; b=sFcZdpX2EWmxAe0dD0TM/yI+dq4YJo2HFtQqfgdjKbitL3yw0A64p2WUW4QxZrkG0/+kh1jIuP/GiaeffMi2I0QXg1+kx+0MTIrPMLB/pesqoOFUBt5lLe4O5cKgoqBJ2zrO6uPnTYl2TtvNqlI1yNDqfdOkOUyjhPbLdQdqWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197572; c=relaxed/simple;
	bh=UmDRCeG0fMTN79rZMSiMMYeZCUrj86CQ0qzi6fioaSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgoLvKc49R6Q5/ibkIXptSRl1IV9sEVZA+4mZY0zjVs475gfXib+h4r19sWwtcbLh82V/r5JGp0DeGUkxSKJL8zyebt8ijRxrW31UKi7KXrXMoRkASjf1EEaiOw5Hb24vpYO8pN8rVp/nui0jzxVb0rfY0+TY+/p+Q+cdepfaLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTv/ne/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTv/ne/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6467DC4CEE0;
	Wed,  5 Mar 2025 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197571;
	bh=UmDRCeG0fMTN79rZMSiMMYeZCUrj86CQ0qzi6fioaSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTv/ne/+Q0GZzytCj2Y21059odP2ujYgktcpCem4gc8jZaambCTtJWZYwiH0HAJtF
	 XaG96e5nvUDHChfdAE9CGpRW2d10cftC8sg4SX5zQOpK+zgP1kmtBTOKHlvDK7hIfo
	 qoO1EGbB6HiBHPNHfCX3go84DWA79gAHvCb9L938=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/142] ipv4: icmp: Pass full DS field to ip_route_input()
Date: Wed,  5 Mar 2025 18:47:24 +0100
Message-ID: <20250305174501.353915051@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 1c6f50b37f711b831d78973dad0df1da99ad0014 ]

Align the ICMP code to other callers of ip_route_input() and pass the
full DS field. In the future this will allow us to perform a route
lookup according to the full DSCP value.

No functional changes intended since the upper DSCP bits are masked when
comparing against the TOS selectors in FIB rules and routes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Acked-by: Florian Westphal <fw@strlen.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240821125251.1571445-11-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index b05fa424ad5ce..3807a269e0755 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -550,7 +550,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     RT_TOS(tos), rt2->dst.dev);
+				     tos, rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
-- 
2.39.5



