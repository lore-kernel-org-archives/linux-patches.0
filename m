Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA0513BAFA;
	Wed,  3 Jul 2024 11:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005786; cv=none; b=c61BFJrW3GGvyU4HCi8fbVMDG4a39YsF7Faa2T6nX+ffGKDKcuv3QGXpt1SpP1+gw0MOyFm5J4QNchlUcouWWfqUhGz+Fs1/248Ng8HeFDC9kFAU75ZRzpA6iINsVCjf4ztzqI2hqiA4zDomyi9MurPQBma/eQIohmH4gcDU3To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005786; c=relaxed/simple;
	bh=aLb/4LjILvNQyFS03flh55qZt4GrdYxoVoU33Hk5IqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnPUOzuuXOvVnr2ESYm2bHG2GVDQ/Pc6Z1xZwHPq+XaZYOYSqcHXLliTOJtBvGygBKnWf6T+m16odS3evrNANH+ASKqG3tXoptshiHoCewqrCoOjcg6POM4rwByGTt7Y0/Bg4bsY8dx4jsvShgp+qKbkWmBI3pXFzxAwtaBw6iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOpRJ05/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOpRJ05/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C70C2BD10;
	Wed,  3 Jul 2024 11:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005786;
	bh=aLb/4LjILvNQyFS03flh55qZt4GrdYxoVoU33Hk5IqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOpRJ05/gOkTRc8XfNsD5IQFpAfsIUc1TP5lTaU8rKT+gXphRRkeL4lTQZfHMCSA4
	 ybbVUXaT4Ic7BAhG1aQkIbvmMZHRVE6u/OX4pznvncgl1xmARLwCLO7rFW7mJk3J02
	 q5vuDI1dUdPnJ0ML2+DZe7m6zfn3dGGw+Wutsi8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Oz Shlomo <ozsh@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 196/356] net/sched: act_ct: set net pointer when creating new nf_flow_table
Date: Wed,  3 Jul 2024 12:38:52 +0200
Message-ID: <20240703102920.518800242@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b4c42b257ae7c..0307b4366db10 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -276,7 +276,7 @@ static struct nf_flowtable_type flowtable_ct = {
 	.owner		= THIS_MODULE,
 };
 
-static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
+static int tcf_ct_flow_table_get(struct net *net, struct tcf_ct_params *params)
 {
 	struct tcf_ct_flow_table *ct_ft;
 	int err = -ENOMEM;
@@ -302,6 +302,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
 	err = nf_flow_table_init(&ct_ft->nf_ft);
 	if (err)
 		goto err_init;
+	write_pnet(&ct_ft->nf_ft.net, net);
 
 	__module_get(THIS_MODULE);
 out_unlock:
@@ -1304,7 +1305,7 @@ static int tcf_ct_init(struct net *net, struct nlattr *nla,
 	if (err)
 		goto cleanup;
 
-	err = tcf_ct_flow_table_get(params);
+	err = tcf_ct_flow_table_get(net, params);
 	if (err)
 		goto cleanup_params;
 
-- 
2.43.0



