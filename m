Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C1D3B7770;
	Tue, 21 Jul 2026 20:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666884; cv=none; b=AKMTlpUBR/zc9N0e2lT8VhQ1SgaaSQCoCoPoEzC2ifPIEVSLy35BsShrRXt5rTqdC0kqY+X/xaBhyisUl3dETl+5hKP1gBv1o7ixbKo5/DGfM1l6OP/zY+3piWyRO8+FdIms+iAADJ0U88t5lwAT+vuO2cC9r4u9ic8lRlZXZ04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666884; c=relaxed/simple;
	bh=kl1p749QFavnFJXFi+WNKa++StgqBXh8GgokluzpK28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nax3k+iqfOVMCmeYRuZeBilzB81PG1Yx0RoLWOQXGULuUg6UzDJbrt9LmLeZfGLWygHwwF9VJfYAXYnlrtUi3sQOJN1iMi2CYFd0mn3QksBpfpXrXcPRWujzcF3StUeHRLSBrgdpXy/Vl0bCJdcxx9K+YLF2KtiRfFT4JwRlC4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UcXxTJKw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UcXxTJKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E701F00A3E;
	Tue, 21 Jul 2026 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666882;
	bh=SKYv/C+LOsUM+Ry35GYV2VvnjVLfZQEhgSC+Fp7BRdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UcXxTJKwDoFet4y601+zYij6gpOuSZ7m2U1HS9TpC19LFLKyjcdVZkFIKL/GXOtvM
	 YKBcVcAMqsZ4LFCiVhpnsX/IW45ZXAkf1hlwcxVx5Pxz+Gv8/SIFkHkedxodyVGryK
	 Lh8GvUMepRhliW1NdZHMXueDRdzo76oNQDpGJk6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Wu <wufengwufengwufeng@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0851/1266] netfilter: xt_rateest: fix u64 truncation in xt_rateest_mt()
Date: Tue, 21 Jul 2026 17:21:28 +0200
Message-ID: <20260721152500.897550442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



