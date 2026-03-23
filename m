Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521313B47D8;
	Mon, 23 Mar 2026 14:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274440; cv=none; b=hDd9EeVRb3h5Qp7VuqfqAD6U7PB6oJ2457imC5RQvd3KXvmFqqfKS90+Upmie9SX6L8eRTf03eGPqOpZ+7mIu829kLiW+ciyHhtCM4GtTs1LFj6b6x5KE2DIxDk76AcZEcO6FiuTRTJ75eY6BANDaZHyjeB1z/fbNZPxS9ke6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274440; c=relaxed/simple;
	bh=i9X0sNCw5/emPtXgFa1Scno2pz23btyKf4WajEq0ISU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtJZaaJfTwAy6FQFRXLQxdsAoAc0/K9brG5ZdtmNH15KHZiVoT9l9YqMDDDW+e9Bjm1aDemb/k9tqA2fU5BBtpaemHvTm3CwBbYMq2trVCPB3chZfniU09U79KsbgPx5MEDLUECC5dhXTeoSlnHK5fnlsVmgNMJlxEywD5Y1Hjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TodF5Yk3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TodF5Yk3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E510C2BC9E;
	Mon, 23 Mar 2026 14:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274439;
	bh=i9X0sNCw5/emPtXgFa1Scno2pz23btyKf4WajEq0ISU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TodF5Yk38r0gTz8aINIlpaeWf44C0ojvwGXmgWCtGrJbHE8VO/mxEpZjwbb6SZGL7
	 RcqeFGXjhe4xZYM5vO8L4kt2w+iYVC0Hjz1siUlBXDTTgOzJPujbXkSjGcvlYpDoqm
	 bZi0tjqORnDNxT2QPr0j1GVGkwJ1yVpN0rb4y9hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 174/220] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Mon, 23 Mar 2026 14:45:51 +0100
Message-ID: <20260323134510.076117758@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 03321b800707c..fdbb1e20499bd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9203,6 +9203,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 	return 0;
 
 err_flowtable_hooks:
+	synchronize_rcu();
 	nft_trans_destroy(trans);
 err_flowtable_trans:
 	nft_hooks_destroy(&flowtable->hook_list);
-- 
2.51.0



