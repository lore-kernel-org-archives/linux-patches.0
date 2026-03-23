Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463BC39A7EF;
	Mon, 23 Mar 2026 16:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283144; cv=none; b=lwpj4Gv65UANUSBjgyBB7lEsPTm4LZd69qAET41rCWrmV/X4zQATsTQCNz8oUKYOiPfkhvXporykCxIvXvV69OGCEqqRPhXAeP4YPj8VlOemSmJiPODpQbcKPxMhfcTzTFSOTuSXz8WSb2ixgtVzKiqpLnHS36cakXjoDMrcO5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283144; c=relaxed/simple;
	bh=kDnytxX5FcU/ziN4F5v2iR2gQojDID0AH2N2RI9SB4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6Heu2xVhPVhxjExgoCxkMLKya8aZdklPMpBr4DbHDe6KFehhv5DTEZudjIOySsYIYcBP8tGCECBAnFD9ZtiSnrP0mxRGS5+j5Pa0mdHY3gO8dYnHthtoGtiQot7tRklck646w2gPpDhXrEP4weUKO0OI8uOGq6z6s43aZe2LMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zLNAdwUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zLNAdwUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32DEC4CEF7;
	Mon, 23 Mar 2026 16:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283144;
	bh=kDnytxX5FcU/ziN4F5v2iR2gQojDID0AH2N2RI9SB4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zLNAdwUo4o0YLXtrz3AgoGZ4N5csqB9uXkgz9hwTfSOb7hhJXpFBAcqkQwPl0PyrM
	 PREcdIakdMFR2LU0b3EiZ3oRqffUpw1Ijfunner9/5cn2j1/8aaglBPQitz8gUW8FW
	 7brZFcbpAikNN+xGI5j2ggWUCtBs7xeMca3g2lYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/481] netfilter: nft_ct: drop pending enqueued packets on removal
Date: Mon, 23 Mar 2026 14:46:38 +0100
Message-ID: <20260323134535.326872401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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
index 70783671a2b01..c5d78f2525226 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -23,6 +23,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
 #include <net/netfilter/nf_conntrack_seqadj.h>
+#include "nf_internals.h"
 
 struct nft_ct {
 	enum nft_ct_keys	key:8;
@@ -537,6 +538,7 @@ static void __nft_ct_set_destroy(const struct nft_ctx *ctx, struct nft_ct *priv)
 #endif
 #ifdef CONFIG_NF_CONNTRACK_ZONES
 	case NFT_CT_ZONE:
+		nf_queue_nf_hook_drop(ctx->net);
 		mutex_lock(&nft_ct_pcpu_mutex);
 		if (--nft_ct_pcpu_template_refcnt == 0)
 			nft_ct_tmpl_put_pcpu();
@@ -980,6 +982,7 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	struct nf_ct_timeout *timeout = priv->timeout;
 
+	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
 	kfree(priv->timeout);
@@ -1112,6 +1115,7 @@ static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
 {
 	struct nft_ct_helper_obj *priv = nft_obj_data(obj);
 
+	nf_queue_nf_hook_drop(ctx->net);
 	if (priv->helper4)
 		nf_conntrack_helper_put(priv->helper4);
 	if (priv->helper6)
-- 
2.51.0



