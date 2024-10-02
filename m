Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3121D172B;
	Wed,  2 Oct 2024 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880202; cv=none; b=f40k9v4faXByJlpVHLquTdUweExXx1iVXw0+psvwXX0gTBymZBOdA3yx+WX87qXgwqzySxFPR1o4DFWlZXAVfW0dFemda0pM6/ctXVZPvbClssJV2x78Xcf/IuiZ+Mjt9n8jEDXl50eIuJZ9KOjZuPyNRrIaYDWreDxEp20nMx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880202; c=relaxed/simple;
	bh=eKcb/qe3V8zO0g5TfZqWygzTuNtGqidhWF6Dr47bQ84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8GQ1yUuMGk0tk16GEAIVLXf+JhnRycBVjOfIgWCWXeyh3Xml6U2JLlUxbEiO2ezkBMaHR7Xdx41h0jHeGqjtSJFjbhFF91O3WVjrN1A49qAfQhDFSsVfsaUMDFgXtRVY3RrZ1ooeugAMBC2Nlqfjd4l9k7l+pB7XbllRe9K4z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXo1K1sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXo1K1sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94D6C4CEC2;
	Wed,  2 Oct 2024 14:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880202;
	bh=eKcb/qe3V8zO0g5TfZqWygzTuNtGqidhWF6Dr47bQ84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXo1K1sjNYmAQhkv36DNmWkn70I3B6JWIsF3b52H5q3SOHWSrMMJXuH6LnzUE3hpV
	 +f/KE9KGFHSS8+wrF8V2R9nHuZqHroF4KGU9SalkNL5sJme6UHzUSSLonbmxbmOC+T
	 pU+LJm6Pln6EueSvv2sHeTB3Xwd+nY2EKFr0+Xe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 379/538] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Wed,  2 Oct 2024 15:00:18 +0200
Message-ID: <20241002125807.391493967@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b6c16c5fc9ae..935e953b8e1bf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8943,7 +8943,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
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



