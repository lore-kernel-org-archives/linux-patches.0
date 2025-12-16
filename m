Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DAA37D127;
	Tue, 16 Dec 2025 12:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888263; cv=none; b=ZfO7x/50PcXId/37iY1fngh25DAYqsc+Hl/bJLs6HzEsMFM3WqYPVKJQP3PKuIa2M8WgjSCXQ4QHFXVxtirUC8+mYShdq4rA8lnztPfFlOVitlsSPc7A4Qerxb+3e5ZGBMuMUjbZre4+bLlFsnlkDzIf5fdP32yDjnb3s4UEXkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888263; c=relaxed/simple;
	bh=+63wee75tyR4/ZB4Y7brvtuNgvDJa5GfGv1cUsN02zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RkSn4ZnF8977bgVJ3Tz2Cp/xHNj3sChkl7VjJkfqrBe16idHmeih0BUy/y9OCCHJggrJrB8gzpOjHGxoHO2IAVuA8/DWjMszYEcdo9KV2XBFRSueBcxvlxLA4yocjwGV0yvk9YsFbv0qDV9lZZ3ql6Mqm362G0k9PSa6YGhQPcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afzP6cRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afzP6cRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BF2C4CEF1;
	Tue, 16 Dec 2025 12:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888263;
	bh=+63wee75tyR4/ZB4Y7brvtuNgvDJa5GfGv1cUsN02zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afzP6cRw+onQQp+7H7UnFy2GIn5nAbaoscE3RanppUvj7yyGs6b1gmBDSVSApgVYb
	 uMLU+IfZf+D0cGJPreXvU61YP/or1Tnp1PrOdo6tIL3L9w4pMOz0bWjcA1FRqS/DKX
	 ivAdLcJVT9fCeTIAvdtAjGb8nDkGb7znmgEJWFRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 481/614] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Tue, 16 Dec 2025 12:14:08 +0100
Message-ID: <20251216111418.798838946@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 14dd1c0698c3c..e95e5f59a3d6a 100644
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



