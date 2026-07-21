Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B19434E2F;
	Tue, 21 Jul 2026 22:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674052; cv=none; b=jGKK3APNjYJqP15QkHrMIBf1WD2wWIfAEJozVmGhYW6+/9aspRKzUaxM0YWWl6W57xq+c+MD/0e3a62sIaSo8o0en4LO1gelqPieqveahLIdN8ICce1vo4KeCIcwJrA6Me+dvbqU8cmtfVhVQMc6Ji9GL6EofqomS81g9jl5glA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674052; c=relaxed/simple;
	bh=OCxrSBSIMjMGaD4D7pDO0YhbTy+tQuE999W2a7szho4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4It0+WTxLJ+rV87tbeZ8nvzHJmLo616EblhCUZqz+kY/xy2M+i1iFBoTq8q1MQcP05QwKFcxVK+t8E2RA45VZCHrFijmWQWn9HNA4a60yNm4p7PdENjm/+uT7IY1YRyCYQyIbk6KlOlvIh5WDsCCVwQANLW/XUlq99p5EV9WuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lp2NNWy3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lp2NNWy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1811F000E9;
	Tue, 21 Jul 2026 22:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674051;
	bh=0oP7cs2+BdGCeqbFxP9E7Qm9K7LUWx1TCsJyDnkA1Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lp2NNWy3M7jQvM2dLajbfOKKiwkZDfsmD8JX5qf3nXhpyf4LVd7We/ACYJ5C0SPoh
	 0DxpvSiphYjCE62DNeHdklnGPQJrRYGSEiINiMi3GkiRYH/wG3NawDD/K6Glbgndj2
	 h/iaubRQ8HrfeOLtAuuOQ4ytRFp23sQVMUWAFKAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Wu <wufengwufengwufeng@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 394/699] netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
Date: Tue, 21 Jul 2026 17:22:33 +0200
Message-ID: <20260721152404.583435347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



