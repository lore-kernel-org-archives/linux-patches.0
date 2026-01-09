Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41A432BF21;
	Fri,  9 Jan 2026 11:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959973; cv=none; b=FXumWTlUN9GvP3usJ2q9xanIFPL6KJSwa6JYUmynGWTyttw/IVOFg4zASwzcbYIr3kgzXjzwKZZcL4JisZOIpTKMDDZq4cORP4rHCiEzOyQL9DYJWZkvW2guq++oaV2bxdLNmEmSxa/pmfoSNVE9sSWAdE9rez/byZPRAww/gmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959973; c=relaxed/simple;
	bh=zmk407QINqb/S4qQpQe/7IAVIjnJOUg7AM6rxz8mMHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNwZPEuB4T84UoqDxjdjBTdtkYOnQL7g22BFZphMMTrQtyAzqceHmuJUZT8tU9BFYpKcEi659wOj/2pWYeMfxeVbggSeFK5NsZ4V4ISD+DRDw939vx1zyjE05GpHp/vjfGULx+2pFtiJQgMG4Es1jC5mU039cs++cIoBZVx5+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWRnF3Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWRnF3Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728AAC4CEF1;
	Fri,  9 Jan 2026 11:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959972;
	bh=zmk407QINqb/S4qQpQe/7IAVIjnJOUg7AM6rxz8mMHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWRnF3VdN7Wbskv9v6VpVvXdSSMpxHgbllSdpdTliv+I1xmS+hJRWQt2u8aH3LExp
	 C89LadtgZnui51L2P6imwahfS2R1JbPehZAY6AZosRd5pCyW4MC8HprrbSqFE0n3T5
	 C9j4zhFkHly5EMKxOWJUFITLMcSEZnNivih28C1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/737] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Fri,  9 Jan 2026 12:36:19 +0100
Message-ID: <20260109112143.025523459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 634f3853cc98d73bdec8918010ee29b06981583e ]

Add a sanity check to skip path discovery if the maximum number of
encapsulation is reached. While at it, check for underflow too.

Fixes: 26267bf9bb57 ("netfilter: flowtable: bridge vlan hardware offload and switchdev")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 1894032a7971c..75dddcaa9aa37 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -140,12 +140,19 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				info->num_encaps--;
+				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+					info->indev = NULL;
+					break;
+				}
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
-- 
2.51.0



