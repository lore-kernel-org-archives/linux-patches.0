Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F249F411661;
	Tue, 21 Jul 2026 19:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660980; cv=none; b=cb1wyOdqRT4puR1KCd6lRX8PKZwfs8ZzwmZfzdrMY1UGWrcB0rEj2DavLfdNQMpSUCbbfDOdsouvvFNKurqMl/onQKNkVB1W1N06aqkDv0W9T0seG/uNfQfeQYGTBXxTc9uKmT+whVH1Qle7dnnYQpHbio5ZxHvh6iPpriqf6qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660980; c=relaxed/simple;
	bh=6BCmaCSP+XiudJlBhofefa5ybySF+7ltT2440ZnZlTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYhjf9XELvA+oFC8uhuMr336aDd8z9NIA2wUvCeXPgZALysvC3NPh2tbiKnFhm+iz1YMx8N/ezhM/CNxjyWD8pIwSHv4hZTGU3jjh9GOqtYMnNprvSneLe3CigbVnLGN0tlTF85L1VPFooW5pWjssrs0Qo/pcxnV+TtXVSlyGU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yyWpDnn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yyWpDnn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F141F00A3D;
	Tue, 21 Jul 2026 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660978;
	bh=nwsgQySA/k0Ggj7JHd8SaOCcuJfgW9zN/YDcQQ6fPfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yyWpDnn/D0BPNKnj+xSmww4djeScqsEjh2U2MD7WJi7DFCVBg+TvwSCKdh7UZwNz6
	 V738ZTNvDlBzrCAMr6tlPTIPnOXBme6zYKEdciS52bwdvhw0aE7gbcN859UpIi0cNP
	 DesaPvTpUiRztSHzJHpI701bhdnPZdf/0Z3dVcf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1184/2077] net/sched: act_ct: fix nf_connlabels leak on two error paths
Date: Tue, 21 Jul 2026 17:14:17 +0200
Message-ID: <20260721152620.748390925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 6158e13c98d358..f5866a364a74ae 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1295,7 +1295,8 @@ static int tcf_ct_fill_params(struct net *net,
 	if (tb[TCA_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
 			NL_SET_ERR_MSG_MOD(extack, "Conntrack zones isn't enabled.");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto err;
 		}
 
 		tcf_ct_set_key_val(tb,
@@ -1308,7 +1309,8 @@ static int tcf_ct_fill_params(struct net *net,
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



