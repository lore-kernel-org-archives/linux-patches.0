Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211539;
	b=U0naEoU7zFz3I2PKavoROPqPTefRTDYkQBatV4OocgCmjg+9WCH5mY0iaSaJc4A3Qn8+
	 EfCOop4YlO/UimcpoAILi5pL4+Zn6qyhAguNBBk3zDd5sJF8K/03GT+a++1nhfqfkhtrh
	 RW4KdWi+E6vcywFK0jSX9NxEJwn9qgoJOfYgihR4CbwfprnbY2Mlw74Xpz0pMrHpzOBu0
	 hiDzEabPo2QDZOFyCT/qNEQcAdh2Dlzlt+EtL6tL8WG7HeFVOoKt68G2XCzOxwiiDTNoY
	 nEu8vK8O2LuRm2LEc8oijnat3Wp0IsSMXtvuMkM8y7yk1btOLhK0wcRb0UZPoSYyHgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgSOcrrgQBX8BOOYN3pJQ8TAPF5gqcWhuQsHojskedQ=;
	b=qarjf+N7ThUNAMHVSHvQr9X3yY+pxBlbh+frk5o6J8aLPxYR+n8+Vxq/1GgdED3gSqe4
	 MIy1BuJuOKa5/P2UoreWZDIlrLFhwNtZPXgPMqHq9VdXUCeh5RAys3kw/qnnyDjegnghm
	 9YK4P7G2CUcSyRPZt6TcwoDuqbDv7zDg42PeZBTNHv40Oibp21s2xv50kuOz6y6nTkmp9
	 U2ip/ukg4vO73CdcDHz/RBolD+YMBIVAJG9EKke6xeBrC8j8dPcI5wZVg7fz9EeloRcpp
	 Zizl7fLmN6hnVu9uS8ANVUi377vACe+1hAL+FzBT/cKgjsQ698NkueE6nQTCvQEI5tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OtU7jiR1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF26606A333;
	Wed, 28 Oct 2026 18:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OtU7jiR1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7721F031E2;
	Wed, 28 Oct 2026 18:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211538;
	bh=sgSOcrrgQBX8BOOYN3pJQ8TAPF5gqcWhuQsHojskedQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtU7jiR1QFmlPVekFzMZHCbqK3YnOedxscBEZsN6pbhFaE77u2p341djO03bEnnE4
	 5AEBjOkdK38rD7WJRuNYcf9fnpp7+vUCpat0ZNdEdGRTBg3w8uC3UKWZHOsEcc21De
	 zNVo2YZj7cDpTGvnJQpdiJFVvzTzQATW72m54e0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Dai Ngo <dai.ngo@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/571] netfilter: nf_tables: release flowtable after rcu grace period on error
Date: Wed, 28 Oct 2026 17:59:18 +0100
Message-ID: <20261028170017.766676111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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

(cherry picked from commit d73f4b53aaaea4c95f245e491aa5eeb8a21874ce)
The cherry-pick did not apply cleanly and required manual conflict
resolution because the nftables code differs between the 5.15.y and
Linux 6.12.y branches.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 90048faccf2a3..b4c3615a2bf6a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8121,6 +8121,7 @@ static int nf_tables_newflowtable(struct sk_buff *skb,
 					       &flowtable->hook_list,
 					       flowtable);
 	if (err < 0) {
+		synchronize_rcu();
 		nft_flowtable_hooks_destroy(&flowtable->hook_list);
 		goto err4;
 	}
-- 
2.53.0



