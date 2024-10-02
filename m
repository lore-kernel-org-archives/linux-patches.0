Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384B319F411;
	Wed,  2 Oct 2024 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878623; cv=none; b=LZrwqk1MkLxYnydLoXUEP0SSy2QIj2STkIYrWMO/1ZQG6/zyrkVccNY3yqnC0Lx6+QjMW+BnIwQs3FQoz9LtmKRsHfYE/h6U35J7ZUCGsjdCaKg51s164sXPGqU+9VnsnGVc486CDKCPgbbay8z8Hf4SvMaIL2QKw6gkRFdwVNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878623; c=relaxed/simple;
	bh=eBo8UmJfcRclzujh0RiQjdGTYunTlOJuOeUlCdpylYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZMpzaOP7pghyw8V1DhBASKTu7t/hfJ0vZB2RPxx6RggkfgbeL/8lUU+qQijyvxH+qKWJrCN9RCCDEyoPsIM/GMDMcTXLH75U61sN8xbGYJZLVIe1GVkXh/U6z0ciGlG5LhWvzlJ79chE626FXfEVhyVHDzhh5Brqst42KbTYJKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHSKYIab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHSKYIab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E30C4CECD;
	Wed,  2 Oct 2024 14:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878623;
	bh=eBo8UmJfcRclzujh0RiQjdGTYunTlOJuOeUlCdpylYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHSKYIabMNW/GlXozZ22YPl0eHQwpeewdGkjnSoTCP/8GUbz8Y27QscrfpyseAT9e
	 cb2rW/fvicWjvkR7IKoPEDKXZsA/IArBokhc7VeRmCfeTfeKCLF1GScan0lk1odJmZ
	 LnyzZGjr08vWJ+SEgp2QnRoMQ5LGDcvKdCLld/5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 445/634] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
Date: Wed,  2 Oct 2024 14:59:05 +0200
Message-ID: <20241002125828.665763808@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d4b5f23930c9f..3c19928b359c3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9137,7 +9137,7 @@ static void nf_tables_flowtable_destroy(struct nft_flowtable *flowtable)
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



