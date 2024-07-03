Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A515181311;
	Wed,  3 Jul 2024 11:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004756; cv=none; b=ELyujbnnN+MzQ3swCzaraJMCo9qwI7ptrhq/oFKFGe6ZTRWDaKGtDCEhagHXK22vZ9ZUEF/t46dSOLJQXWd6iTjpmSglPEqKy1iz0mNP88dYoeKs+gMRKTdfAU2j+8hoGZaaJXBPNcQohGbEw5MHB4XaUrQZ3gEe1+hHewtKGaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004756; c=relaxed/simple;
	bh=6hlsm7OXjB/EigtCB3COzUGW/W+rehQ2+xlcqHzCCa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EOCe8VKQgsS+Q4zlcyjpXMjGV8F59co9um0ZHOvSKBf8DqB0WNOMCtRmoDStlulWwBkXs9SvbkwDUuU5d2aX6ZcCRJMZMM2flleYPgd803wZBXAIQOvSdxAtNn3R90MwE6RgaUVvm4AYj3LdqTKMAn4cG6cROI73Fm4TxPsWHW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2R3aTC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2R3aTC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98A6C4AF0B;
	Wed,  3 Jul 2024 11:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004756;
	bh=6hlsm7OXjB/EigtCB3COzUGW/W+rehQ2+xlcqHzCCa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2R3aTC19fwaYMGi7XbnKrOrOTAo9vJ4TRA2+CUEmD3CsSmbxusvRokiF4+NkM8DM
	 P3VnpcHUvGAf+2GSpPvqD7CfAqPh9CreX6O2Fg9QVaAGe486gpGm+0S/7yVd62L97K
	 aJxKtMZzV9NtgeD0ridzeFtmd6H23lO/4gLfcy2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Oz Shlomo <ozsh@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/290] net/sched: act_ct: set net pointer when creating new nf_flow_table
Date: Wed,  3 Jul 2024 12:38:49 +0200
Message-ID: <20240703102909.773245610@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit fc54d9065f90dd25063883f404e6ff9a76913e73 ]

Following patches in series use the pointer to access flow table offload
debug variables.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 88c67aeb1407 ("sched: act_ct: add netns into the key of tcf_ct_flow_table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 2d41d866de3e3..155426d5a48f6 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -275,7 +275,7 @@ static struct nf_flowtable_type flowtable_ct = {
 	.owner		= THIS_MODULE,
 };
 
-static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
+static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 {
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
@@ -300,6 +300,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
+	write_pnet(&ct_ft->nf_ft.net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
@@ -1291,7 +1292,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
-	err = tcf_ct_flow_table_get(params);
+	err = tcf_ct_flow_table_get(net, params);
 	if (err)
 		goto cleanup_params;
 
-- 
2.43.0



