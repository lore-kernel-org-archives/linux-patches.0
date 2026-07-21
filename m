Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA1D46D080;
	Tue, 21 Jul 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657716; cv=none; b=kXavwwHNLktaWMP7wnTxtsiBztLS90xyl62w/Tr3A8FRicThIPxyret/CPclsgmVVkf+TmaFfeZ3kN5UZ1bdH1z+F1ahT6ohhBTpMxCl/3dJH8V3oaB6itxDop4312zp72QUmepp32PHB0ocdz4YrmXhkm+n2XkINzTPYBFiugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657716; c=relaxed/simple;
	bh=86oAd8M91FDojNCQSR5iDqC6t/le1g9r87VyC3TP0s8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+N7z7KuCTKvPhLh6SsvwVI+fBAS0Yxw3Pn24QWdl6TRgACIj3oq9rsw0R8lN60sf+XoJ4JSoj5keIQ4SgbU6n6wparkHAhm5b+SkbhUjhjeF5IHefUQBCiEhYmofON/MEQNj43bAoOHeJ8VOt+ra2hPY1XJBWR0IWEptJ5qdng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UUipI6fO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UUipI6fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCC21F000E9;
	Tue, 21 Jul 2026 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657715;
	bh=Kqf59NiX74Qk4zUwhKbzMMaT+wvLnMOF7aqiX6QxaXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUipI6fO4ZM1bqKLDIHtqM6lxbJgDx1CgN8abaCIQYWmsRc9+Z3/fUUqpjhnvxiER
	 zdO3R3Kzdq2ypXBFIXkSspu01QmzkIzm0krZ6uswC8JY97+jahVSgLgVn+iJnlIwLx
	 HB4+aiVmK1fkoZcuBjsyuJniCx2HQ32b90NKuHRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0869/1611] net/sched: act_ct: fix nf_connlabels leak on two error paths
Date: Tue, 21 Jul 2026 17:16:25 +0200
Message-ID: <20260721152534.938313889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f9cb8f7474ed3e..9bf27c02ea45d0 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1293,7 +1293,8 @@ static int tcf_ct_fill_params(struct net *net,
 	if (tb[TCA_CT_ZONE]) {
 		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
 			NL_SET_ERR_MSG_MOD(extack, "Conntrack zones isn't enabled.");
-			return -EOPNOTSUPP;
+			err = -EOPNOTSUPP;
+			goto err;
 		}
 
 		tcf_ct_set_key_val(tb,
@@ -1306,7 +1307,8 @@ static int tcf_ct_fill_params(struct net *net,
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



