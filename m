Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88EC284662;
	Tue, 21 Jul 2026 19:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663277; cv=none; b=RAMsYZobOxeteCZtBRVHvpQu08qqDY+xnoQYFR0iNAAn1BNW6JP2fDRSJt79o5YCqKpJhpWHAqaPDwWezB+NOILfaP0aRJJ7VyCHJVd0/r2Ck5L8Q2+nNJ9japEof6fGKW7fcANZ4ei4CDlWCR3YBrDjFJj8z5hULkiMb/PX1dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663277; c=relaxed/simple;
	bh=4P6HaZz8ZCsyKCNtZQuvmtLaqE9QLLDseEWzHw9VYsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0sKhYZEHoQaLIrU2nT0I8cOyTEMMbqBYgDD8pWygjI38AaNGuf552vchkYtxQWVIsE/I6gdZ34HOmkivsQ58xx5tA99yz42t7X1W73wOaWjSnhR2w+UWMeRSvTS8zV0YUOeIx+FPNCr1niqmDfKgrVUNvE7xpQc7EhqPRb+zx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp2RkTIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp2RkTIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD231F000E9;
	Tue, 21 Jul 2026 19:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663276;
	bh=sCtqol7zVifsh9Jxvco2Uj/F/098HapxQRbTP28VHO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gp2RkTIwcK3JdK+lgbhRUSGLKVcbzN2ML0SuQWzOZ0BNIP7JfaBUx8K3cQIynlf2Y
	 Mn90E+m44CdW8yEjPaErnrFvkfH4j/h23mclyz9hV9DFs+aPnBnD7CYW7tXT28KZ0b
	 nYVWq4TT1t+y3izgyOwbNgjJSZkuy1XmoZVRFRPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Wu <wufengwufengwufeng@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0762/1276] netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
Date: Tue, 21 Jul 2026 17:20:05 +0200
Message-ID: <20260721152503.128858047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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



