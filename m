Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3EA3CEB9E;
	Thu, 17 Sep 2026 18:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668079; cv=none; b=g22G7fo+5c7rwTDXRjDaNloGuoCg1nCmVTMmSosgLIgWJIGRURAX2yvfKkBb4SVEM282/Jugyy4NuHJ3bIeXJvVaxcMSEPlXYmRx8JgA7Et1+96wkCsMQo1g3Gz4m9bGELA+zYnnMWtUazmcxfBbNsfOBCllBJeo4CW0eq09Wl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668079; c=relaxed/simple;
	bh=uYV1sxMDlQ5fSkVl32VEXPmkCdxpwYSRXSGWOvK4p84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/MCXGZrslPdz5do2tNYdgTwqYS22BGfn/FT3Q/CgUXUBfzn5vvHJwso7sEKemSEK7JGqO5Hkt9+Ribf89mkhgK04cnw6tKEdh6EhzgJ3agtj/kPOT03kfc7IzhtkVjq51BVnxTlNEyG9TCXeEVQY6q561fe8OxFsVzwzzJgz/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXereR9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXereR9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BD41F000FF;
	Thu, 17 Sep 2026 18:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668078;
	bh=GKmfJ6ICrQckFKY/eI2dTu5K2U85y1kBIiK4KoINrm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXereR9+V66HvBmwkXNc4RD2mx5PdNFHx3LRpfdKCzIb/jFg0NtyiUuwz59UrxD7/
	 ZUektPDrHAx0/MuIupyFsXzLde0O6KbaSl0ysCnQGugqqX59q7C61roKDDzRUZHR2k
	 +qLzulx03XaE+dKa+sbpt8xQkvLFy9IHUoTj5pDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0306/1102] net: hns3: improve the unused_tuple parameter setting
Date: Thu, 17 Sep 2026 16:04:09 +0100
Message-ID: <20260917151547.303339859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 1ad6f1ff3e96c7ee888475740c8acdaf822e0813 ]

Currently, when the tc tool is used to set flow table rules, the IP address
and MAC address can be configured separately, for example, src_xx or dst_xx
can be configured separately.

Therefore, the driver needs to check whether the mask is all zero in
keys, such as FLOW_DISSECTOR_KEY_IPV4_ADDRS, FLOW_DISSECTOR_KEY_IPV6_ADDRS,
and FLOW_DISSECTOR_KEY_ETH_ADDRS.
If the mask is all zero, the tuple is not configured.
In this case, the driver adds the tuple to unused_tuple.

Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260610060618.834987-3-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c  | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 786aefc3d107e..334707e6d1c33 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7261,6 +7261,10 @@ static void hclge_get_cls_key_mac(const struct flow_rule *flow,
 		ether_addr_copy(rule->tuples_mask.dst_mac, match.mask->dst);
 		ether_addr_copy(rule->tuples.src_mac, match.key->src);
 		ether_addr_copy(rule->tuples_mask.src_mac, match.mask->src);
+		if (is_zero_ether_addr(match.mask->dst))
+			rule->unused_tuple |= BIT(INNER_DST_MAC);
+		if (is_zero_ether_addr(match.mask->src))
+			rule->unused_tuple |= BIT(INNER_SRC_MAC);
 	} else {
 		rule->unused_tuple |= BIT(INNER_DST_MAC);
 		rule->unused_tuple |= BIT(INNER_SRC_MAC);
@@ -7309,6 +7313,10 @@ static int hclge_get_cls_key_ip(const struct flow_rule *flow,
 		rule->tuples.dst_ip[IPV4_INDEX] = be32_to_cpu(match.key->dst);
 		rule->tuples_mask.dst_ip[IPV4_INDEX] =
 						be32_to_cpu(match.mask->dst);
+		if (!match.mask->src)
+			rule->unused_tuple |= BIT(INNER_SRC_IP);
+		if (!match.mask->dst)
+			rule->unused_tuple |= BIT(INNER_DST_IP);
 	} else if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
 		struct flow_match_ipv6_addrs match;
 
@@ -7321,6 +7329,10 @@ static int hclge_get_cls_key_ip(const struct flow_rule *flow,
 				      match.key->dst.s6_addr32);
 		ipv6_addr_be32_to_cpu(rule->tuples_mask.dst_ip,
 				      match.mask->dst.s6_addr32);
+		if (ipv6_addr_any(&match.mask->src))
+			rule->unused_tuple |= BIT(INNER_SRC_IP);
+		if (ipv6_addr_any(&match.mask->dst))
+			rule->unused_tuple |= BIT(INNER_DST_IP);
 	} else {
 		rule->unused_tuple |= BIT(INNER_SRC_IP);
 		rule->unused_tuple |= BIT(INNER_DST_IP);
-- 
2.53.0



