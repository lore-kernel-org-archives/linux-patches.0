Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435AE340DA7;
	Tue, 16 Dec 2025 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884676; cv=none; b=eFbdQZL6VbrUbL011wvflSe2yr1pN8m9T4Lcfbl34z4H22p2zjp1sX6rqbcbRJC4AXLcvZBut5Fb8CIuoChIb2MDlYVKEKQxhndKouuco2xFLu+titwIIdOXIRVGmoxeuXxaXNhkIKcGMNk0gu9V365K5sC6FJnD3z8KZMwDGAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884676; c=relaxed/simple;
	bh=ZBpmAgow96JmU7OZke8oc1jkSyNFalFH8ICL9qwKW4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n+UFhl9WOx6vB3WOYzhupO1tcyw11JFlEP9ugUXV5uJgCyaT9qaC1IGGu/AzhKbxnkFnZ9FNpzLwrF9qBAy8aTr5+SLUtH6OmXF920X3fNCEWyOkIoixk/XSl5c2U2Rr8Al5371821vTjyLY4lhBQn/EN10V9u8zms5V1CMn9RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZ/lVpul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZ/lVpul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E67C19422;
	Tue, 16 Dec 2025 11:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884676;
	bh=ZBpmAgow96JmU7OZke8oc1jkSyNFalFH8ICL9qwKW4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZ/lVpulgs/PVZrOwxP+ysQ/1n505d2uz3NfkYwo5CPONY+ozbh2uRBMuW5dRiDKC
	 p4IdB4+kepOLF4mzQoptyy9vYXsJyW13DJt9r8zgZvdfHNk/rlkXjdnPHM87A4Y748
	 dSDWn0rF2HG8Z9CbyJbcSZE1BVMhtihJsgWU/Enw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/354] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Tue, 16 Dec 2025 12:13:52 +0100
Message-ID: <20251216111330.517447616@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index da9ebd00b1989..55734156166d2 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -141,12 +141,19 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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



