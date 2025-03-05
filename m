Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F0424C07D;
	Wed,  5 Mar 2025 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197352; cv=none; b=TaUjHVkZqxMoLaYSCcS98Ykk8uy6neAkCF3ly+ZCcMgq1OR2wH7C7+PqdcMrFLsxAizGMunCMfh5GUigj1HuhFMKfwa2fd/kgJPteM0VUV2iX8LoOF99HQ2MK7wyfERvrHWu86UJJj5qxh2/y5v45V3RvqgToHuiQExvkuIgEnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197352; c=relaxed/simple;
	bh=qBntL0jYTZn7DO6Wusg2BMQRN/tvvHk8tNid8FFwGj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSsaJxjdnkT7qEeajmGklnP63S9a12IEdKY0tzKPeqH+t0AEcDg6Altjrk23790ah1hVAZ6uXfd3ilL0EYRJmG4tlnZGYovzUmeReLSUy7lnI0Fbp+rB44g7zZV1G8ngWr1+molxhLwqxVjNMpH5hv9vpedWEbix39h7sj00oEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySw2WqRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySw2WqRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA7AC4CED1;
	Wed,  5 Mar 2025 17:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197352;
	bh=qBntL0jYTZn7DO6Wusg2BMQRN/tvvHk8tNid8FFwGj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySw2WqRuM0sgmJHoYY80WCGteq29+oqRyTG3OdYh1DpijWkrvpmAGWUYevECF5iiX
	 AoS18vrQfJlr3UyCJ+39Vi4JXq7iyXGcqlNZEOUWO8Kz/y3n8/jFqRNPtBh6jSna6j
	 c4TcC9mtbLGbzygN3VfqyJyy1u1M3mhBWlWl3sDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/176] ipvlan: Unmask upper DSCP bits in ipvlan_process_v4_outbound()
Date: Wed,  5 Mar 2025 18:48:15 +0100
Message-ID: <20250305174510.511555979@linuxfoundation.org>
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
index 1d49771d07f4c..d22a705ac4d6f 100644
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



