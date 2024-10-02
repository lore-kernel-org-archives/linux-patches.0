Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C761D0799;
	Wed,  2 Oct 2024 13:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876595; cv=none; b=u/3fm08YLvG/S3WezYfwRXfFJChtGkWbmZpm1tgEyInSbbLDHSTsib0AcipPGhhICX2TCY1XxhZEetX7stiG3KKcMUoWvSBkco8G9Y5sIcCcZLgohZ/UmE8u7NMJbwW8ZEsMpd5cCBTP0+d6jsWpFHSLRT6Tmbjw7NmPBMWbxuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876595; c=relaxed/simple;
	bh=3mtgjqTfdUrbgp+9Y8eIJeFDhMP3WbYZd+C+WcIXep8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYqbLRy4HJReueqDQmHYx1PMLtMFjlmIyG2WYAwmuOIGtsSVGCyKWlotvDRioc6AQzlVh4uwJEy/c1Jk9eofFi+v5VmlfGGpsRsSxVlLbTTVj2jlSxyQAtOkbcjUMWy6sZQs0HuTLogvvPx/12OAJ+GnsdTzYRszCUui08/vBII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnsT9YUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnsT9YUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B115C4CEC5;
	Wed,  2 Oct 2024 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876594;
	bh=3mtgjqTfdUrbgp+9Y8eIJeFDhMP3WbYZd+C+WcIXep8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnsT9YUDZ5H9ZW8DjZ9NGdV2rcKV0mnw2jVAE6Not37KzWsta4SUvoc72ZFTYfDpp
	 vC4Yrs50khfmiprDlXmikl9lF4doNJ0s1iWOKYGzgpgKFUEHf0l+qiLJ9N7t6OjvCA
	 CHneGg3DFbYYokWTCWxWhdJznMf1l6UR65CzS+Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 490/695] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Wed,  2 Oct 2024 14:58:08 +0200
Message-ID: <20241002125842.028788160@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9e57c68f0803f..4ceb3e0798dee 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9185,7 +9185,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
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



