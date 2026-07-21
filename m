Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1344D44AB91;
	Tue, 21 Jul 2026 21:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669784; cv=none; b=qlxSVTVSqUaqcxUBDPaS/EiIuTtXjKDoh7Cguv8WUGjMWIUHLr4O/yN82zcCMsm9flr7dqEnOHufMSPSkRBv+GXZCr/w+KuP9XcmFJ20dAeyEamuS3uTX6LT9sNud0l9+/pAMUD9ezhFgf8rUbaKiQ5ear0pz79QxqB9/mnvZmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669784; c=relaxed/simple;
	bh=hZeP01nDkvOAT/X3ArRS2PUj4iHKewXvZbjWYwPjq2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGEjCGOtxkqH6SclrcXkDXbV1diKa3sMbbU8P8qzkeKlL/+M2HOq3x4oNsRA5vo3W9w3XgSrCzRmlYHikPd29iVOfDyMasNwOocM2eQiLeTfpe5gh7NQQE51EtsrB3vJ2tNiskC3N1iC/GDbQQ7YgqfNEbH0TLz2jG+X+i+9gZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jyd/wHAx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jyd/wHAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E171F000E9;
	Tue, 21 Jul 2026 21:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669783;
	bh=gbsdwuSSkxBDMBCodBWJlTMrEKlWOOe3ytoqawOEPvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jyd/wHAxcdMjgR2PUxzSZAsnn5vVII8T/MHppsk9fhQIVmgwMXkI71lyX0KFKovev
	 gc162nJC4dB7R+vfEp9ux+Pj8PUp1Iw1tXvCgmFhznqwiuZ7QvoBVzc4sfu2xjQ/GF
	 GGMr7QGHE70+cZRqHcB803oOjnUHJyNp35I0ohWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Wu <wufengwufengwufeng@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0684/1067] netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
Date: Tue, 21 Jul 2026 17:21:25 +0200
Message-ID: <20260721152439.898852882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Wu <wufengwufengwufeng@gmail.com>

[ Upstream commit 444853cd438201007da5359821adcc2995655ab1 ]

On links faster than ~34 Gbps, where byte rate may exceed 2^32-1
(~ 4.3 GBps), the comparison result becomes incorrect because the
truncated value no longer reflects the actual estimator rate.

Fix by changing the local variables to u64.

Fixes: 1c0d32fde5bd ("net_sched: gen_estimator: complete rewrite of rate estimators")
Signed-off-by: Feng Wu <wufengwufengwufeng@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_rateest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index b1d736c15fcbe5..7c05b63425784e 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -16,7 +16,7 @@ xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est64 sample = {0};
-	u_int32_t bps1, bps2, pps1, pps2;
+	u64 bps1, bps2, pps1, pps2;
 	bool ret = true;
 
 	gen_estimator_read(&info->est1->rate_est, &sample);
-- 
2.53.0



