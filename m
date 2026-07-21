Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F362385D67;
	Tue, 21 Jul 2026 19:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662881; cv=none; b=QY8t7SoRDfxL2jtRuSxWkll68ScWXX8AYLkvwWv02Pccn5QwxymSTCOlMz0JlmwUbHSTGRJWcFvNwypI61MiyRrFF42sG7kazGOz9QfBRIrLfOJVKHSXWepZWJz2wWp9icJFVysIh8WVQEajmqtu+htAKaBloKf1EvGKxGd92Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662881; c=relaxed/simple;
	bh=syOqBsvhLUTaXZDNrhHdXDpCl8Afu1y2AcLCJy4y0P8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBJCEeBMHkaro2+uANnNABbcoZzF7L+WzHgblu494msWvkYEMN0tXiFaKC/P44iaP+P5OhAe7CTBjOW0lTO8U9EGGNUNfn+PkkQ18dJ/ax+JCiVY4xtO7E9y4TO01VRQ/MIRPyL75oepNvZ5uuq3bsuofwL8X7K6cp9IfmquP9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAiBe+1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAiBe+1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EF21F000E9;
	Tue, 21 Jul 2026 19:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662880;
	bh=tB5xhDmNsogjh8Pbc356/56yIp5RdLYJS2IwHBsFcSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAiBe+1Gpg9XZ+z6ko0CnlRHP7QonNdnw70dei07MPcvuX6LqPXLqtLcuZZVgERZQ
	 gSZgW19StYA6+cAdC/HwkTdh+Sz1b+Sq84HjZbN9YJMiEy9lh+2a3Gk7LbUmss58X4
	 BUO16zQh0wixHDRokyPKCSX5LKJEBhVyAP4HSZ7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0613/1276] net/sched: act_ct: fix nf_connlabels leak on two error paths
Date: Tue, 21 Jul 2026 17:17:36 +0200
Message-ID: <20260721152459.826604671@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit 16e088016f38cf728a0de709c3335cc5a3850476 ]

tcf_ct_fill_params() calls nf_connlabels_get() (setting put_labels) when
TCA_CT_LABELS is present, but two later error sites use a bare return
instead of "goto err", skipping the err: nf_connlabels_put() cleanup.
They also precede the "p->put_labels = put_labels" assignment, so the
tcf_ct_params_free() fallback does not release the count either. Each
failed RTM_NEWACTION on these paths leaks one nf_connlabels reference:
net->ct.labels_used is incremented and never released. The action is
reachable with CAP_NET_ADMIN over the netns, i.e. from an unprivileged
user namespace on default-userns kernels.

Impact: an unprivileged user with CAP_NET_ADMIN over a network namespace
(e.g. via user namespaces) leaks one nf_connlabels reference per failed
RTM_NEWACTION on the two error paths; net->ct.labels_used is never
released.

The err: label is safe to reach from both sites: p->tmpl is still NULL
there (kzalloc'd, not yet assigned) and nf_ct_put(NULL) is a no-op, so
no inline release is needed.

Fixes: 70f06c115bcc ("sched: act_ct: switch to per-action label counting")
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260617215708.1115818-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index c82755749211c8..fc71cc407bc8bc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1294,7 +1294,8 @@ static int tcf_ct_fill_params(struct net *net,
 	if (tb[TCA_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
 			NL_SET_ERR_MSG_MOD(extack, "Conntrack zones isn't enabled.");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto err;
 		}
 
 		tcf_ct_set_key_val(tb,
@@ -1307,7 +1308,8 @@ static int tcf_ct_fill_params(struct net *net,
 	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
 	if (!tmpl) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to allocate conntrack template");
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err;
 	}
 	p->tmpl = tmpl;
 	if (tb[TCA_CT_HELPER_NAME]) {
-- 
2.53.0



