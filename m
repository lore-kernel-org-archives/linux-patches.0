Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2091C07DB;
	Tue, 15 Oct 2024 13:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997622; cv=none; b=BqBoUa0yQYWpw8UGGoInXlmfHhjNsT07ib4FurqTPFLbsAHY8bSsbtJ/5WELsApWEjbusM3BMsYOqfl4+JtxfkO+o02ZOFlEzBw9zwTC54BQcjcfxHfssvc4+8qoRRYnrlRAWivikmvoYbRhdQRSahJmgR7FTukyUB1dHEUMLMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997622; c=relaxed/simple;
	bh=7q0wNtusEFXPbKkdwrArKo0UHVD1V1iIbWHqEJErusw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7PHKtXvkKvM4jO9ttQftKNdcdStb3ZTAkQgEYzxULt1e3EkS4gtwwgLlt54MV9ItYN/OKq56L0xI2zf9zDQytnoJgoMfo4PG/DvGWkFTTrmSqwj6zxxVI/4kezM2de9EuAU6A2x/3U3Pxy3XFj6+ZgNhdt93xVtyVZpYOUYmFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eRRHWB9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eRRHWB9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA61C4CECF;
	Tue, 15 Oct 2024 13:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997622;
	bh=7q0wNtusEFXPbKkdwrArKo0UHVD1V1iIbWHqEJErusw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eRRHWB9WsCp34ZCVKZkhvPfDkVewEAZNiVeJvPxJc/+iZXUnppiBgHNbQodvFyYxS
	 pVnH4ftNf0v9Vh0q83MqdjbVbcou0qVZPm0NjB8ZeOTy7/w4bSpSXMw4ccg8rGbkxp
	 m2x1Sd+hzU5+5aVLaeyqPCjEPfyE6hkDEirvKnas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 206/518] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Tue, 15 Oct 2024 14:41:50 +0200
Message-ID: <20241015123924.935805972@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 642c89c475419b4d0c0d90e29d9c1a0e4351f379 ]

Documentation of list_del_rcu() warns callers to not immediately free
the deleted list item. While it seems not necessary to use the
RCU-variant of list_del() here in the first place, doing so seems to
require calling kfree_rcu() on the deleted item as well.

Fixes: 3f0465a9ef02 ("netfilter: nf_tables: dynamically allocate hooks per net_device in flowtables")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9e2695bedd2ce..2bd1c7e7edc37 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7625,7 +7625,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
 		flowtable->data.type->setup(&flowtable->data, hook->ops.dev,
 					    FLOW_BLOCK_UNBIND);
 		list_del_rcu(&hook->list);
-		kfree(hook);
+		kfree_rcu(hook, rcu);
 	}
 	kfree(flowtable->name);
 	module_put(flowtable->data.type->owner);
-- 
2.43.0



