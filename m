Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A182512E1;
	Wed,  5 Mar 2025 17:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197361; cv=none; b=u/vcNKhxK6rI6JkkU/CETyivUfcPzvc5kuu25+NJJSCAcQABOeRgje/aZdLvnDQWo0rxiE1tkDpZsuwUnkU85x6OR4+2BQLPb0oSjOCSh3FFznD6sXUdl+eS3blKgcD0kib4F74FaLKKnQL7U2O7kbYINkAKYEZm4JB4CFpcgkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197361; c=relaxed/simple;
	bh=bXlSesPGrPjVQmzmIICJkiA910WtFHgrmqT+10X/Puw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUyYtDpJxsamfo6dqihGwHaoaxBFvtbnefs+IS4aJsF9fgAboeXQ1+O150+JX6vfbd8m3LeSrjRk5xlcOzFLqmUiGsRn9DGq1i0DLISyDIIdGgeBv5IISYcAC76syH2e2muZKJafPZ+ZKBzIssEn2SoCQeqYGV/kQkT+Fs88vBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irvznE84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irvznE84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25BDC4CEEC;
	Wed,  5 Mar 2025 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197361;
	bh=bXlSesPGrPjVQmzmIICJkiA910WtFHgrmqT+10X/Puw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irvznE84oJW5aN6Oo/wiBqOTqzm87McKJ74Q30Rw90ZVDX8Syq4BkJyeNimY5INas
	 ujg1b5uNjMLeBz/mf21UTq64827V60KY5+QecL1+3W7OezvMU5gxYH7I2ceP8I7pwe
	 D6TGPt580Yi0Ze9Qt6Oeyc15LaBF9dL28yPh7reA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/176] ipvlan: Prepare ipvlan_process_v4_outbound() to future .flowi4_tos conversion.
Date: Wed,  5 Mar 2025 18:48:18 +0100
Message-ID: <20250305174510.630333681@linuxfoundation.org>
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
index d22a705ac4d6f..38eb40cba5aac 100644
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



