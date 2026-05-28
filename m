Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC2D2F260C;
	Thu, 28 May 2026 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001413; cv=none; b=gO4W09TEKz6gMJU8VMG0teLGhoZoR59M0ymNSjHDl8fb1tR+xQQyucT8qpegwD8m2l7MwKMhq4w/EBtOYcdZgJgJAiNOFhRIpuxsKlIwzHrXVcfKoWlpfWSpILUk4G27RK3fZeZF+p1HDk+OVpMIYncF5tTQLu6+83YKBTFzNGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001413; c=relaxed/simple;
	bh=H4BcnmRjkFWDFRny7gQibtD3nshKtvQj53b9oEj/tKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XNn7SO6D00kolTU+KnpPZR1dwceAQCuXSZJRRDCNDyjcGP0LyW1HidiPxLvMt0xrp9ciw7A5f/PnIKrB6ADHH10YJjmqCeUgsLAh7WX5W1twZoIaLeXlAHPD1rpgkIJfxhHOV3trHPHaT+5gP94HGfTCUeOlQ4sGf3fj+qLc5Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rqh7i2Bw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rqh7i2Bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A31A1F000E9;
	Thu, 28 May 2026 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001412;
	bh=aBTer2sO1YjmDAYRcPmNzKE3PqhJgpWbeKebZ6dXvY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rqh7i2BwcX513O874a5WDO+Pu6435dlKABdFmgkBSVWYAVk2F6KTSQKuLMPsyY/dH
	 8sOrVQetpmAB+MkmwUx/0dRq71TifC/bByMaLXemfur68hS9aD6GuRl1zuCeCMCkJm
	 zLnUSiZNH49Rp4ardD8PYxFPUVda2EkhT7GnGPDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/186] netfilter: bridge: eb_tables: close module init race
Date: Thu, 28 May 2026 21:49:59 +0200
Message-ID: <20260528194932.155206318@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 27414ff1b287ea9a2a11675149ec28e05539f3cc ]

sashiko reports for unrelated patch:
 Does the core ebtables initialization in ebtables.c suffer from a similar race?
 Once nf_register_sockopt() completes, the sockopts are exposed globally.

sockopt has to be registered last, just like in ip/ip6/arptables.

Fixes: 5b53951cfc85 ("netfilter: ebtables: use net_generic infra")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index ec286e54229b7..ca426e49ea1a1 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2583,19 +2583,20 @@ static int __init ebtables_init(void)
 {
 	int ret;
 
-	ret = xt_register_target(&ebt_standard_target);
+	ret = register_pernet_subsys(&ebt_net_ops);
 	if (ret < 0)
 		return ret;
-	ret = nf_register_sockopt(&ebt_sockopts);
+
+	ret = xt_register_target(&ebt_standard_target);
 	if (ret < 0) {
-		xt_unregister_target(&ebt_standard_target);
+		unregister_pernet_subsys(&ebt_net_ops);
 		return ret;
 	}
 
-	ret = register_pernet_subsys(&ebt_net_ops);
+	ret = nf_register_sockopt(&ebt_sockopts);
 	if (ret < 0) {
-		nf_unregister_sockopt(&ebt_sockopts);
 		xt_unregister_target(&ebt_standard_target);
+		unregister_pernet_subsys(&ebt_net_ops);
 		return ret;
 	}
 
-- 
2.53.0



