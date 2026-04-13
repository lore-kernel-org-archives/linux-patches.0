Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E368231619A;
	Mon, 13 Apr 2026 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099174; cv=none; b=LyZvaFNH6nlBM+/AAHOL2wxVe6kMDHunJ+ZIwP19QuxDkeWdFARECq1M0RC41wcWGRkzOUJwV9KqPLHelcKUl8TEtUS8o/Q0SjlomuKxUC65vlJj7w6p7JijhYSYG4p3M9jW2fQLwIHBbAPZDo9o3T0zBc72zgv07zQHZWkuh9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099174; c=relaxed/simple;
	bh=KkBL1umFUqO8JVKlUkfD5m4o7JtDK0JzgqKD3tIu++M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbaKQ4Gh2DS8XbX4PiyE5gs6ym6v8oOZBB8/IeUyv8fzL34dtaTs+a1649w1GEKRLyzzVy+R9TK7VRrJhnHQW3aKZfEzhSb1+uvSqZM2/yKwqziONNMLZ6d9z3acm72c49FGkU4tJWoXcB8N9exuQlqGboGh1+1cWncOCLFxV+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zaj/j3lH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zaj/j3lH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D22C2BCAF;
	Mon, 13 Apr 2026 16:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099173;
	bh=KkBL1umFUqO8JVKlUkfD5m4o7JtDK0JzgqKD3tIu++M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zaj/j3lHp9Wqf5em/8ioM6s0FTBuY9FS4NPUBqhiBiucs/APg0q0ATXo1uIddSKcT
	 qe9+5KnfAjfg7uKtsbGuWeWvpvftfqOBA0zPxSQCBE11HkGMCBs1GrBnx8YxnyLsxz
	 Qbr+BlR5O9SwkJceULVL2Q+fW6UChiTFnL/ffftY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/491] netfilter: xt_CT: drop pending enqueued packets on template removal
Date: Mon, 13 Apr 2026 17:57:36 +0200
Message-ID: <20260413155826.967212071@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f62a218a946b19bb59abdd5361da85fa4606b96b ]

Templates refer to objects that can go away while packets are sitting in
nfqueue refer to:

- helper, this can be an issue on module removal.
- timeout policy, nfnetlink_cttimeout might remove it.

The use of templates with zone and event cache filter are safe, since
this just copies values.

Flush these enqueued packets in case the template rule gets removed.

Fixes: 24de58f46516 ("netfilter: xt_CT: allow to attach timeout policy + glue code")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_CT.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index ffff1e1f79b91..6ad76f3a956cc 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
+#include "nf_internals.h"
 
 static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 {
@@ -270,6 +271,9 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
+		if (info->helper[0] || info->timeout[0])
+			nf_queue_nf_hook_drop(par->net);
+
 		help = nfct_help(ct);
 		if (help)
 			nf_conntrack_helper_put(help->helper);
-- 
2.51.0



