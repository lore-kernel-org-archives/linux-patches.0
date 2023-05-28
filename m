Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD915611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1E2C4339B;
	Sun, 28 May 2023 19:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301756;
	bh=KNq5JtC9wo1nRstONVa73mKF2Mfy53I6/vwzRgCCcQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o46WJ4HAEBT6mt234CcgiYnIEMA7Hb0EpTqzZPiI4F7U7Ui0TBWQ4NEKYK5KRaa0A
	 DzXiX/BAgU91TjqbezvHsBShb0Yd91RCgbzV1crx646QdY+CZwTJr/r2mmhhccg60C
	 wlC/xMGdGwVa/GSIk6Bsp7QkEH+M3MSgMcBHWnPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/161] netfilter: conntrack: fix possible bug_on with enable_hooks=1
Date: Sun, 28 May 2023 20:08:50 +0100
Message-Id: <20230528190837.288895261@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e72eeab542dbf4f544e389e64fa13b82a1b6d003 ]

I received a bug report (no reproducer so far) where we trip over

712         rcu_read_lock();
713         ct_hook = rcu_dereference(nf_ct_hook);
714         BUG_ON(ct_hook == NULL);  // here

In nf_conntrack_destroy().

First turn this BUG_ON into a WARN.  I think it was triggered
via enable_hooks=1 flag.

When this flag is turned on, the conntrack hooks are registered
before nf_ct_hook pointer gets assigned.
This opens a short window where packets enter the conntrack machinery,
can have skb->_nfct set up and a subsequent kfree_skb might occur
before nf_ct_hook is set.

Call nf_conntrack_init_end() to set nf_ct_hook before we register the
pernet ops.

Fixes: ba3fbe663635 ("netfilter: nf_conntrack: provide modparam to always register conntrack hooks")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/core.c                    | 6 ++++--
 net/netfilter/nf_conntrack_standalone.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 451b2df998ea7..c35f45afd394d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -577,9 +577,11 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
 
 	rcu_read_lock();
 	ct_hook = rcu_dereference(nf_ct_hook);
-	BUG_ON(ct_hook == NULL);
-	ct_hook->destroy(nfct);
+	if (ct_hook)
+		ct_hook->destroy(nfct);
 	rcu_read_unlock();
+
+	WARN_ON(!ct_hook);
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 43c3c3be6defc..1e3dbed9d7840 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1180,11 +1180,12 @@ static int __init nf_conntrack_standalone_init(void)
 	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
 #endif
 
+	nf_conntrack_init_end();
+
 	ret = register_pernet_subsys(&nf_conntrack_net_ops);
 	if (ret < 0)
 		goto out_pernet;
 
-	nf_conntrack_init_end();
 	return 0;
 
 out_pernet:
-- 
2.39.2



