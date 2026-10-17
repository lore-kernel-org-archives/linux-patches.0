Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072C0385D7B;
	Sat, 17 Oct 2026 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258930; cv=none; b=ItACv1TIyZX+f9QQ5PzyNoChZaEm0qJz24PCmInyQMmWLvPd4IaH3eQjwEUoBpr8aZEJ1vNP86OTHS9xGtqJ9ULG0RSwZu4at3DdyUpFKwGucTKAwbzeXCaLPSvX7tVXrT5hdhHGIv2oTCTGXQybub1uQvext/9GmNpsnVO2g/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258930; c=relaxed/simple;
	bh=vVJ0bDuCPZlaRfuBQvK5cn7Wap4NNxyzrPpv0br8boQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OO/SX52Plj4y9ysJEu4gRS30xQV8jEXlBqmt86n5hG0MAXFpscGayBIt/x4TRATSHwFDYx6ZjHNnZsXK4qsGbwT5FBfhoGH/LQkv5KSskrHxvRYcdafUuWMTSf9bdHGNd5wZd5zFzVScarwKhIhtYFLd+xIKBHKc5sp6YkyCLa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sieo+4Li; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sieo+4Li"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7FF1F000C4;
	Sat, 17 Oct 2026 17:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258928;
	bh=YuukhLQfLtkNjqroqAIzd2/SmczIxoNmHqAnK4iPYzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sieo+4LisoQy9bkU5bUk4IIiDBbIUTBciIDqnz+w9CX+zBbBAex3dUgtsAcxnchvr
	 88KX9JOK5mEyP9dFQQCJ4GR6ZelIsRcV+aF5CNvWwuMpJYcGXsTH/zuvNExiaaiM7s
	 xQJY642glTvetO4IPbKhwfaLaObT8+e1Xhrbt81g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1045/1674] netfilter: bridge: eb_tables: close module init race
Date: Sat, 17 Oct 2026 17:55:17 +0200
Message-ID: <20261017160457.958398835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 32e73f04d5b17..ca6f0b7710823 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2607,19 +2607,20 @@ static int __init ebtables_init(void)
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



