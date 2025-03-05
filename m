Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015C3250C1D;
	Wed,  5 Mar 2025 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197586; cv=none; b=mQ4ypHj2ffXN41c/fa3dMSaE8+dHUtJCy1voOcoqS8moyMzQBLQVPbhAs/N0OBLgwWlTj5R2FkeFRmuMzLMRFbRBMhsPixQC8n9tWp3rSqSC6ukwmnEvweDTScjSV2nKyLQDwWp/BGUlR3eexBSlmXFq8uEgfRYzGbSUFA0jxPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197586; c=relaxed/simple;
	bh=dBm4OkqFCQI49vePFq4xLGk4kU3zGwigYBPb7HDHzPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ek4sBw87Q4nJPokjvZK3jn98evo3/V5XYMGrVGoD3kizKj4uIIPICQl3zbrjbiOiQ8w6j4Hv6ntQN/fPKDX8ZdjGc0LeuarTFRuRrO5bJqJ6lw9BvesH159ungIg1Jn9TRpbpGJeCHlMUlhEkxLOfuKB/o0IdCI1mYWqoXzCSsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK0kwWtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK0kwWtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E28C4CED1;
	Wed,  5 Mar 2025 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197585;
	bh=dBm4OkqFCQI49vePFq4xLGk4kU3zGwigYBPb7HDHzPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK0kwWtBGTvV7ZEpX9PkNrxKlsjPcdIkU5dAhHvQ2Qlc4YEu1ETFSlWxiqVVLrsD9
	 QuVpCEqyZP3jFhCWjCHioaqeFdp0CA+TLq9jH33qYzHGblSv8BeEQEpdNanuw1m1ZE
	 e9caTczjg6CF23buOqqkNOj9OHpqCg/GybveTBxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/142] ipvlan: Prepare ipvlan_process_v4_outbound() to future .flowi4_tos conversion.
Date: Wed,  5 Mar 2025 18:47:29 +0100
Message-ID: <20250305174501.550084795@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 0c30d6eedd1ec0c1382bcab9576d26413cd278a3 ]

Use ip4h_dscp() to get the DSCP from the IPv4 header, then convert the
dscp_t value to __u8 with inet_dscp_to_dsfield().

Then, when we'll convert .flowi4_tos to dscp_t, we'll just have to drop
the inet_dscp_to_dsfield() call.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/f48335504a05b3587e0081a9b4511e0761571ca5.1730292157.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index b1afcb8740de1..fd591ddb3884d 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -3,6 +3,7 @@
  */
 
 #include <net/inet_dscp.h>
+#include <net/ip.h>
 
 #include "ipvlan.h"
 
@@ -422,7 +423,7 @@ static noinline_for_stack int ipvlan_process_v4_outbound(struct sk_buff *skb)
 	int err, ret = NET_XMIT_DROP;
 	struct flowi4 fl4 = {
 		.flowi4_oif = dev->ifindex,
-		.flowi4_tos = ip4h->tos & INET_DSCP_MASK,
+		.flowi4_tos = inet_dscp_to_dsfield(ip4h_dscp(ip4h)),
 		.flowi4_flags = FLOWI_FLAG_ANYSRC,
 		.flowi4_mark = skb->mark,
 		.daddr = ip4h->daddr,
-- 
2.39.5



