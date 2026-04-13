Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4970F317141;
	Mon, 13 Apr 2026 16:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099145; cv=none; b=VsTYbEzkhjxUQIiMarT6s7oBf932vRU2VIxQLz6xk/k/5YHNC3SYb7EoQ8zkSJQ15tygbeCSdjoQ3oQvrqwus6jeU//jlgIXIePRKGCRTobrGnVqv/bl0rYuMYqGaKcl3hFfxQJlcO8F3DZyxEScFg/fKUEyBDbJKYlQOpGMgf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099145; c=relaxed/simple;
	bh=J9OTCl8RJQpWl3WuIYDNEwUFLHSC3FKZCcu/DzvSNw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UklN64KD+zhaY/Ha3zDpu6dE/8tMtUbpH1Rkinridzj3iqluOuF/hvJrVwKXmnufAC42GBCXvFQMVF+AwHaKyoeT4L8hA89qfkB2wy1z91wuyiXNQNqZaexg7hXFzuOMlhiVJ+qO8dn4bClW2vQNam4Dcpy8IfJROQyyhXdgve0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHaxOS4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHaxOS4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C9FC2BCB3;
	Mon, 13 Apr 2026 16:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099145;
	bh=J9OTCl8RJQpWl3WuIYDNEwUFLHSC3FKZCcu/DzvSNw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHaxOS4bspAhtJ+6AMF5EFu1Su5V4wx1zJU4OIblzj5YmOwy8YoFEHdXYMSOIjt3R
	 VnUbd1QYXiRiM4vHhyw+5cgjvBaiWr2cV0IpJytEiI0froLf13LeqYSMaHrbtMGFtD
	 9qpG0NQOijc9rQONLs5h38ctvjnxu4hLbs+893jI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/491] netfilter: nft_ct: drop pending enqueued packets on removal
Date: Mon, 13 Apr 2026 17:57:35 +0200
Message-ID: <20260413155826.930500875@linuxfoundation.org>
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

[ Upstream commit 36eae0956f659e48d5366d9b083d9417f3263ddc ]

Packets sitting in nfqueue might hold a reference to:

- templates that specify the conntrack zone, because a percpu area is
  used and module removal is possible.
- conntrack timeout policies and helper, where object removal leave
  a stale reference.

Since these objects can just go away, drop enqueued packets to avoid
stale reference to them.

If there is a need for finer grain removal, this logic can be revisited
to make selective packet drop upon dependencies.

Fixes: 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 0b194628818a5..e788d5d9e7aeb 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -23,6 +23,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
+#include "nf_internals.h"
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -533,6 +534,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		nf_queue_nf_hook_drop(ctx->net);
 		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
@@ -930,6 +932,7 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	struct nf_ct_timeout *timeout = priv->timeout;
 
+	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
 	kfree(priv->timeout);
@@ -1062,6 +1065,7 @@ static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
 
+	nf_queue_nf_hook_drop(ctx->net);
 	if (priv->helper4)
 		nf_conntrack_helper_put(priv->helper4);
 	if (priv->helper6)
-- 
2.51.0



