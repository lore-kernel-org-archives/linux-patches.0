Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44B3BC4C9;
	Thu, 15 Jan 2026 17:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497656; cv=none; b=gXYShGmQZKwVvSrR1HAoOCIRHaqUWM7vrrJuuqIS6dqfopUsP4PYtChpx8Fy7GCzkZKo4+d3dLUGfyOraGFZVOoX8WXPhO+onKYnGT/ovSRykRk5pcYB5cHe8+ctFavDOoQsBQTShMjZFkJly5xrOaI7s7NlZ+pcJSx8L1qbAEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497656; c=relaxed/simple;
	bh=ijArLLLlgpCeffPJIECZ2q0rxenCQdCUWc9wWrouxJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sul5Z7f2IUCSU5hjN2kvDZd7NiEUbj7FYAgyAUpKxRAatE+KTw6ShC8ZzaVZ24wbQ+1/s2+2gJFA/2slZ5LrnNlRwx5YaUuZPj66qtj59CSvdkUG8uDh0d1bGrwm4ko4PQNTylfeTQ9Di9XhwYAI8jO8xrqRKRqYiG19f7wy+iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkUPVD/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkUPVD/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4669C19423;
	Thu, 15 Jan 2026 17:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497656;
	bh=ijArLLLlgpCeffPJIECZ2q0rxenCQdCUWc9wWrouxJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkUPVD/nHLCT4NtBlxcqpAZfDKZujedRBfmh70vjT5d7XTuA6fpw5cW6ExOjtTJ9O
	 J0NaQTRGBelJdml3hT9tg19cEbrZ7wr7vJAsRSfgLqjVy1TcmIcN3JwahrFxNb2H0y
	 FolWsAQhb1wZGKPXlsbRZKRNayYE1awitCJtIRNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 157/554] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
Date: Thu, 15 Jan 2026 17:43:43 +0100
Message-ID: <20260115164251.949191684@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41d04fa12f67d..e1d7231b87748 100644
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



