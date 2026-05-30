Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9142E7382;
	Sat, 30 May 2026 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166781; cv=none; b=A6FefYgt53gzIekmBY5Uqze4HoiHdnUgxTWkqRK1b/K70ziPgyWOF59li+QegMTgaRR5skG0GrysgQIQTOzPFZ2EICHXVPoTr0iWCegix+dlTwgCJ0fLzJE5jrfNfAL10mdlvAhLqDyLWMPri4pILPn07Qi3QJkm1kkqjt6yCIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166781; c=relaxed/simple;
	bh=hV/Er1OZiTwYlTT0deaCVwWf4gPx/vsyi0JHOS/DpBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+BSkzNkYH2b69QFz14THt6U7tUzekaTrhmWU5SbxeI5wj61Vwh/OxVUtpHQJSkVVSKitlJOVCppbMsLJQE/aXKd/FWTSpe9DRfhYh6X0UDBpf3vI8Zs5Z3qn/15jgF54lz/Lw84kxVCCVSz9YxMkc8b3FQ1yaSctL8mjy74E7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqSEkLvR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqSEkLvR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584C41F00893;
	Sat, 30 May 2026 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166779;
	bh=TyIweyhVnd+78YWfbfZb7PcBPB4mQJcIX0BAx8/7L4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqSEkLvRrJYw5cbv8bPxfupvBvx6C8twxup+S11+4eRqkfAMWC5Bh46lhVKr8JCH6
	 zjx7rAVpbsvYcVY6nqPPRSLpOsChsClFVbZ7JTeateLLcUdfOQM01wy4/PzMcPL/3D
	 8155av+UT1cW8prBy7QEq4iDJpoPW7dLrh3/tOP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Jiexun Wang <wangjiexun2025@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 468/589] netfilter: xt_policy: fix strict mode inbound policy matching
Date: Sat, 30 May 2026 18:05:49 +0200
Message-ID: <20260530160236.957372580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Jiexun Wang <wangjiexun2025@gmail.com>

[ Upstream commit 4b2b4d7d4e203c92db8966b163edfacb1f0e1e29 ]

match_policy_in() walks sec_path entries from the last transform to the
first one, but strict policy matching needs to consume info->pol[] in
the same forward order as the rule layout.

Derive the strict-match policy position from the number of transforms
already consumed so that multi-element inbound rules are matched
consistently.

Fixes: c4b885139203 ("[NETFILTER]: x_tables: replace IPv4/IPv6 policy match by address family independant version")
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index cb6e8279010a4..b5fa65558318f 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -63,7 +63,7 @@ match_policy_in(const struct sk_buff *skb, const struct xt_policy_info *info,
 		return 0;
 
 	for (i = sp->len - 1; i >= 0; i--) {
-		pos = strict ? i - sp->len + 1 : 0;
+		pos = strict ? sp->len - i - 1 : 0;
 		if (pos >= info->len)
 			return 0;
 		e = &info->pol[pos];
-- 
2.53.0



