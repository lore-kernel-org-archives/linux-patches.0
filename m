Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DCB2517BA;
	Wed,  5 Mar 2025 17:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197350; cv=none; b=Y+cE2AiDJoVUFyD4iWMGix5llizuZa9/kLMj93XIBjws6Ul8aG3HootJOSmKU66ucEcMEdF/wgGQTJIBNIdzMpEeN+XusRPyPffrpn7NWxAUnyxfZR3hFdeehYP5ypNbJI4DL+6Vtl1MLJ6dQfC1ssWDPKhs8burWl4VnT1bTmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197350; c=relaxed/simple;
	bh=7bdtJOpIkdz8iqblNQwHqjF98e+nnh7GVt+w8kBinfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEG7vrESbJaXF/4t6Wb1UdCelAtsGVHucKiElvVp8BAY0o5/mSSqzZIEHUzUACpmZuf9AsbtSJkCuzsbUhkDJNLerCr4Qu9VlC8PhHSUHovrCBv2P2PnzYYLZMLJ4CgivEpvphAPEiMENS5c1gaGDPe/m1r5fRMYIbE2zb2R3Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJt78b7z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJt78b7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683A6C4CED1;
	Wed,  5 Mar 2025 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197349;
	bh=7bdtJOpIkdz8iqblNQwHqjF98e+nnh7GVt+w8kBinfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJt78b7zIuPkyd63WnxB4+vmUJre95QXy8MCEqyB7NipFJNm32NaMvz42k9KfDCCT
	 G3EsQkXl8NXsoDO1x4CFQ3dL6Mg9RPpalrpTf6UDp/2FaID2qXWtjt+l+SF38ag/X9
	 OS+szgZ++F8/7hRUJyiHRZE4g7JS0Qv0TXaPMMDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/176] ipv4: icmp: Unmask upper DSCP bits in icmp_route_lookup()
Date: Wed,  5 Mar 2025 18:48:14 +0100
Message-ID: <20250305174510.471343775@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 4805646c42e51d2fbf142864d281473ad453ad5d ]

The function is called to resolve a route for an ICMP message that is
sent in response to a situation. Based on the type of the generated ICMP
message, the function is either passed the DS field of the packet that
generated the ICMP message or a DS field that is derived from it.

Unmask the upper DSCP bits before resolving and output route via
ip_route_output_key_hash() so that in the future the lookup could be
performed according to the full DSCP value.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 3807a269e0755..a154339845dd4 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -93,6 +93,7 @@
 #include <net/ip_fib.h>
 #include <net/l3mdev.h>
 #include <net/addrconf.h>
+#include <net/inet_dscp.h>
 #define CREATE_TRACE_POINTS
 #include <trace/events/icmp.h>
 
@@ -502,7 +503,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->saddr = saddr;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_uid = sock_net_uid(net, NULL);
-	fl4->flowi4_tos = RT_TOS(tos);
+	fl4->flowi4_tos = tos & INET_DSCP_MASK;
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
-- 
2.39.5



