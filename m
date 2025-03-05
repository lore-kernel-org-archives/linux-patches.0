Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD821A83E4;
	Wed,  5 Mar 2025 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197578; cv=none; b=ldl7Z0sjmbIZjxvAd1sX39er3mf7C3BLvbU2kjHItbPp9Q5zB3ioyVLn4rHmH2/auMSpCYbJZFiqq6Y8lsc9qpIpPQIcu1Do2cy+TpCo26Pvd8R3YOiHq93XfVAb1vZQwipUEGNpQnDBtlG6QeDtwOnCpnV+C3BkIZWUHpWGiLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197578; c=relaxed/simple;
	bh=zEXgY0q/wpxLSUJQ9olm1EjvqfUj37N78Rn0gr8ecEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EfxvSPeU19+q3szlyQ86dsDG58gn9QwR1n4wPK0HFL2cmg6uBxZ3KFOvmwFt8Lp9+Ktxl3oAUk0WZXlWGy1KoltpJ52L6SKe32bjdNhL1ea7w4I0DClNoeo/dqzk2CK8fOY7MgXfGn7XKQ0NtRC8yEfuwS0gzw1YPm6923/UFAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/BmKEVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/BmKEVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E07C4CED1;
	Wed,  5 Mar 2025 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197577;
	bh=zEXgY0q/wpxLSUJQ9olm1EjvqfUj37N78Rn0gr8ecEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/BmKEVrJmfC1A5cNIxwVhNJvKRLdUEszugpKa6Xjf3bEndLYWRMZi+22Nu3HNHtQ
	 KzJN3YvogquED/NdMQslNxmVsUXsij954PRFHSYRd7QR+bdEetJaId6CwH3GVbpuSj
	 0V8n5BTbUwOpWdYN2q4AmFZLlztcofMIFYnbL6FE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/142] ipvlan: Unmask upper DSCP bits in ipvlan_process_v4_outbound()
Date: Wed,  5 Mar 2025 18:47:26 +0100
Message-ID: <20250305174501.432761560@linuxfoundation.org>
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

[ Upstream commit 939cd1abf080c629552a9c5e6db4c0509d13e4c7 ]

Unmask the upper DSCP bits when calling ip_route_output_flow() so that
in the future it could perform the FIB lookup according to the full DSCP
value.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index fef4eff7753a7..b1afcb8740de1 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2014 Mahesh Bandewar <maheshb@google.com>
  */
 
+#include <net/inet_dscp.h>
+
 #include "ipvlan.h"
 
 static u32 ipvlan_jhash_secret __read_mostly;
@@ -420,7 +422,7 @@ static noinline_for_stack int ipvlan_process_v4_outbound(struct sk_buff *skb)
 	int err, ret = NET_XMIT_DROP;
 	struct flowi4 fl4 = {
 		.flowi4_oif = dev->ifindex,
-		.flowi4_tos = RT_TOS(ip4h->tos),
+		.flowi4_tos = ip4h->tos & INET_DSCP_MASK,
 		.flowi4_flags = FLOWI_FLAG_ANYSRC,
 		.flowi4_mark = skb->mark,
 		.daddr = ip4h->daddr,
-- 
2.39.5



