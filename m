Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B7E32470A;
	Mon, 23 Mar 2026 14:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277482; cv=none; b=PZxG1WNij2h0x05Ed3Oj9n+FEmlRJnlTXEUWCyTFDcjRzQNbTmIWpVtFB2en7unl7vylfUKjFtuD+RICdZn5g4tUY3HmBViDQCKn5AfRWznvD3XgLG4HxxCHNDi53MQQiQBLdIhKmjmaf86/sFcZDukBuPWclEpAi+LK2t7trV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277482; c=relaxed/simple;
	bh=9jRb3F855/VZhspygaD4LxpPBWKa5OODgyKOq5sTK+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pwu5h1Tw/bm1T/KRCqVG1O2vb+Mxs+luAuRPXseVQFeAlflKUjC6psSOjIBuvun5wlYSQerzCmDcOLYYn1zFpu/d1GBReoIOmtptNDBh9YvfVfu0y6JIMCiqGZc/qzKaV8BMuDBOn4Ny3KfHbHpv5xD2IP283SX3ehrPHBB/GfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1Hua3vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1Hua3vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4911BC4CEF7;
	Mon, 23 Mar 2026 14:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277482;
	bh=9jRb3F855/VZhspygaD4LxpPBWKa5OODgyKOq5sTK+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1Hua3vpASyhoorHrYEwDnv53yHD2Cfma0XE9JoW17RUa31xRwPFXXLnVSc5Tbf1D
	 6NpcL5uQlYI7ZiFWDMhCXlu5NjvQ9bc850XIrk7wusuTA9Vsd0PxlrBUhTXEXhps8E
	 mGsjo4ZNrUs3ETJrbFThb2Dv/FMDb2Hs+S2RxWwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 429/460] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Mon, 23 Mar 2026 14:47:05 +0100
Message-ID: <20260323134537.095256409@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

[ Upstream commit d73f4b53aaaea4c95f245e491aa5eeb8a21874ce ]

Call synchronize_rcu() after unregistering the hooks from error path,
since a hook that already refers to this flowtable can be already
registered, exposing this flowtable to packet path and nfnetlink_hook
control plane.

This error path is rare, it should only happen by reaching the maximum
number hooks or by failing to set up to hardware offload, just call
synchronize_rcu().

There is a check for already used device hooks by different flowtable
that could result in EEXIST at this late stage. The hook parser can be
updated to perform this check earlier to this error path really becomes
rarely exercised.

Uncovered by KASAN reported as use-after-free from nfnetlink_hook path
when dumping hooks.

Fixes: 3b49e2e94e6e ("netfilter: nf_tables: add flow table netlink frontend")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c12560e94f3b..663c064135181 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8966,6 +8966,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	return 0;
 
 err_flowtable_hooks:
+	synchronize_rcu();
 	nft_trans_destroy(trans);
 err_flowtable_trans:
 	nft_hooks_destroy(&flowtable->hook_list);
-- 
2.51.0



