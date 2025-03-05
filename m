Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6399D19C542;
	Wed,  5 Mar 2025 18:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198024; cv=none; b=F3boAqaMOmPQiPY64EF/SzSAF3DXOchWz3ROTn3rSeLPNKHB1/I2tgOfGoTG7b8QAZnw6tm2s5hvXi9mDmWRHUiIVW+Ahy0hUv8iX9OGWEYNit8ABe75ythEKMHoH1zfxXSXucAUwhqQf4rjfURjjJ0gVVT7+94AUhPV8qtlwvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198024; c=relaxed/simple;
	bh=tSMFVVSekHGjCYRndUYVyDJsI8bktsXxmC4wWWYKUsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIMq/mdEynoQyW6pzC97z6gL++ZSVHcZkbdLBsDIi3LrO8Tt8GIXJYcDzFj59mQaWwHzhxnYunnpFgDbodGoGVw+wV5nL/zpdU65Yodsmv4iJqWwhx3q0+mJABdBoKDAwuZZqJeeueXzvA2WpPoMiyE4X21bG06V9pkJ0MCaR6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBsb5nfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBsb5nfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED2FC4CED1;
	Wed,  5 Mar 2025 18:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198024;
	bh=tSMFVVSekHGjCYRndUYVyDJsI8bktsXxmC4wWWYKUsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBsb5nfWZwSKKa5YHSjEIPUuYzACOvveCACXHcNut5YNv+PN2e1mqbAmB6zB5jw+V
	 HKhBGLrkrw+Ry2P9RzQ7ORmU19KgQhs/65OuNrKiyddWnMCmcR/cNC90qX4Sr/c0+L
	 vFa31BsLQVpZDim4qP00dfmBQZIP4LvqQq3tMSKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/150] ipvlan: Prepare ipvlan_process_v4_outbound() to future .flowi4_tos conversion.
Date: Wed,  5 Mar 2025 18:47:46 +0100
Message-ID: <20250305174505.304022637@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



