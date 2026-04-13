Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443A0306B0A;
	Mon, 13 Apr 2026 16:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097759; cv=none; b=jEw9nEhUYfTmyWxlquPdztnGJu3Nd1a/e9gckHUgy6+Xnf32C30xDkHwQPeU7Gmkk9778v+XZNe/z+GCZwpsdwINtm+QvC5QBjm0+MHS+oFgZDWV2mipXrW20/MAo4UzMKb+pDpsf9ucsbXSKcPAlIfswsacSgkpUGI3I1dzqoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097759; c=relaxed/simple;
	bh=jPu781NXK+M+rsVW+ALTVZLHPohaw5gSIHd2YsyfOVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gx12TfZqnKG3dF+fzzSdSOxs020pTYqZ0sHuIgjDHxZhnGZmS94wed41fxhWQGu39O02sLU3qPq4MeRe5cukElFwpQHPmfdaT6eAZj0rQYkS+kZ4oVc8EJMIzcmntJsRACUitzM5loQ6eH5K93h4C0pnuI6OZhhx0HjZsVjx69Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D23hUWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D23hUWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF539C2BCAF;
	Mon, 13 Apr 2026 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097759;
	bh=jPu781NXK+M+rsVW+ALTVZLHPohaw5gSIHd2YsyfOVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1D23hUWx5FA1v0rtEhjI2aHDj25fL7UIL7fY7ArQOPBg6sdqa0YhaCSBliwyA2vCQ
	 ammrm000TRYBjiGbtFcSTjedE8uVS76VYhT40K0hKvTmhEl9KOjA81nGqLJNtV347b
	 CFpyxBDA5LafF1o1LB6uGs3F59ogSrpBYI9go0BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 260/570] netfilter: xt_CT: drop pending enqueued packets on template removal
Date: Mon, 13 Apr 2026 17:56:31 +0200
Message-ID: <20260413155840.217308568@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5d19cb059b197..3dd02482b437b 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
+#include "nf_internals.h"
 
 static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 {
@@ -269,6 +270,9 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
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



