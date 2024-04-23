Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BCB2143C4D;
	Tue, 23 Apr 2024 21:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908461; cv=none; b=FDNy5JyA4UP5uwcne6CpES8MRCE37hoiylagEvYYhI2OIR10pALkT6WM4VutCkgLqJE4pGP6Y1+9bzCzLp56YRHQLiD79WLQql+DOdbQINyLlHm0fDsawdYMv7CvpfHlBps9z5Ol6IKHsO0omVmevEjT05/ZCuDt/YCM/fyddho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908461; c=relaxed/simple;
	bh=UXmCDytUbbSuPNncs0zyjQ3bicZRDjk4ma71+9DeC20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXOquj9tIgwEYlomaBdxLH6pGMtaHUg8ZOoBfMEnVNC9QaUzCSGhEKxVlh/tD9qftMvC2f+06Ro/gxY7w4Y7vuBYWwgGDfbVSVEqnh7gpAcZQGLA//wDZ23W5z14d988ETjELgrRPaLMDStM07jPPz0fTuqInv1UTW0Dtblm8+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xAg3dv90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xAg3dv90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53E5C116B1;
	Tue, 23 Apr 2024 21:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908460;
	bh=UXmCDytUbbSuPNncs0zyjQ3bicZRDjk4ma71+9DeC20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xAg3dv90J+Toywt4xHc294512DKqEviqygJls/ToisRJ9zJlrbevuwnO/VdbleO64
	 3Bz8qlOlJI7Enjyj+VbEnR2+2UorEArWzUPnRTuMdXW2Gg4A2dia2V9n+J/DrU6yhA
	 +HjVAWG2cWpVC/YnW2/8s8QkQzH8Rsct0mz58NnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 021/158] netfilter: flowtable: incorrect pppoe tuple
Date: Tue, 23 Apr 2024 14:37:23 -0700
Message-ID: <20240423213856.554308440@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6db5dc7b351b9569940cd1cf445e237c42cd6d27 ]

pppoe traffic reaching ingress path does not match the flowtable entry
because the pppoe header is expected to be at the network header offset.
This bug causes a mismatch in the flow table lookup, so pppoe packets
enter the classical forwarding path.

Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9e9e105052dae..5383bed3d3e00 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -157,7 +157,7 @@ static void nf_flow_tuple_encap(struct sk_buff *skb,
 		tuple->encap[i].proto = skb->protocol;
 		break;
 	case htons(ETH_P_PPP_SES):
-		phdr = (struct pppoe_hdr *)skb_mac_header(skb);
+		phdr = (struct pppoe_hdr *)skb_network_header(skb);
 		tuple->encap[i].id = ntohs(phdr->sid);
 		tuple->encap[i].proto = skb->protocol;
 		break;
-- 
2.43.0



