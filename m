Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 873EA3B19BA;
	Sat, 17 Oct 2026 17:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258739; cv=none; b=sxVbmhj6Chw2y18/ChJnBnX7Qf6GeUGWU1JLZpbhuMk7q655JrFmgiY8w5CPRzs53iMJpJn2YcWwhETvlgNc6EF+Pe2SS5EG+P9S6x9TF7Ny+8CFRaXDixFOnjtiiOHNgyhbhOpHH8ybpieGF4DUMTXaQskxv9GCCCdWHCeYCHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258739; c=relaxed/simple;
	bh=uFvnKFzY7KjskcpGeX7Cgrcu2zZ8u1v7GZmwoRCLuYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOWH9NBufnenSPHc3zUyIfTkkrsZPg2N4vgtiwgmn+aKm25pOAZDJ1Ch/otlRfY/PISd6XXiMiwAvz4EoU5nlqYot39f+f+u2SL/MkSkHsW02fkfLt06K/yhzXLb4cFfGIRhqbNdjlG74K6nejEWrvMv2JlCOeOGU1VexTbGFWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMZE65/l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMZE65/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53031F000C4;
	Sat, 17 Oct 2026 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258738;
	bh=tm6WUFC7HgSKHpmOzTF4I4/7R9NAoyqqUZMjRAkhvR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMZE65/lkWoSKLN9pl77pkS3H76/g+q99XlZkmj+y8hCuipv8evzDy8IBheSQ1eKc
	 pWvaP4k2jtcf13psj1+dEeHOjjQqTSV+VZ4/OTxY88zwOytOdE3kxVlormwgvC7fxg
	 zyitJpIFZztHzBnCMD8XLqcFzDl0kVOEEIdF+Za4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0984/1674] netfilter: nat: use kfree_rcu to release ops
Date: Sat, 17 Oct 2026 17:54:16 +0200
Message-ID: <20261017160456.380914233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6eda0d771f94267f73f57c94630aa47e90957915 ]

Florian Westphal says:

"Historically this is not an issue, even for normal base hooks: the data
path doesn't use the original nf_hook_ops that are used to register the
callbacks.

However, in v5.14 I added the ability to dump the active netfilter
hooks from userspace.

This code will peek back into the nf_hook_ops that are available
at the tail of the pointer-array blob used by the datapath.

The nat hooks are special, because they are called indirectly from
the central nat dispatcher hook. They are currently invisible to
the nfnl hook dump subsystem though.

But once that changes the nat ops structures have to be deferred too."

Update nf_nat_register_fn() to deal with partial exposition of the hooks
from error path which can be also an issue for nfnetlink_hook.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h         |  2 ++
 net/ipv4/netfilter/iptable_nat.c  |  4 ++--
 net/ipv6/netfilter/ip6table_nat.c |  4 ++--
 net/netfilter/nf_nat_core.c       | 10 ++++++----
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index cc5a2a220af8e..cef210d5ec086 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -85,6 +85,8 @@ enum nf_hook_ops_type {
 };
 
 struct nf_hook_ops {
+	struct rcu_head		rcu;
+
 	/* User fills in from here down. */
 	nf_hookfn		*hook;
 	struct net_device	*dev;
diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
index 12ca666d6e2c1..a8fe357bc6ecc 100644
--- a/net/ipv4/netfilter/iptable_nat.c
+++ b/net/ipv4/netfilter/iptable_nat.c
@@ -79,7 +79,7 @@ static int ipt_nat_register_lookups(struct net *net)
 			while (i)
 				nf_nat_ipv4_unregister_fn(net, &ops[--i]);
 
-			kfree(ops);
+			kfree_rcu(ops, rcu);
 			return ret;
 		}
 	}
@@ -100,7 +100,7 @@ static void ipt_nat_unregister_lookups(struct net *net)
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv4_ops); i++)
 		nf_nat_ipv4_unregister_fn(net, &ops[i]);
 
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 }
 
 static int iptable_nat_table_init(struct net *net)
diff --git a/net/ipv6/netfilter/ip6table_nat.c b/net/ipv6/netfilter/ip6table_nat.c
index 52d597b16b658..21957d53e9c95 100644
--- a/net/ipv6/netfilter/ip6table_nat.c
+++ b/net/ipv6/netfilter/ip6table_nat.c
@@ -81,7 +81,7 @@ static int ip6t_nat_register_lookups(struct net *net)
 			while (i)
 				nf_nat_ipv6_unregister_fn(net, &ops[--i]);
 
-			kfree(ops);
+			kfree_rcu(ops, rcu);
 			return ret;
 		}
 	}
@@ -102,7 +102,7 @@ static void ip6t_nat_unregister_lookups(struct net *net)
 	for (i = 0; i < ARRAY_SIZE(nf_nat_ipv6_ops); i++)
 		nf_nat_ipv6_unregister_fn(net, &ops[i]);
 
-	kfree(ops);
+	kfree_rcu(ops, rcu);
 }
 
 static int ip6table_nat_table_init(struct net *net)
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2fc334a442f6c..d604e21c8e0bb 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1256,9 +1256,11 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		ret = nf_register_net_hooks(net, nat_ops, ops_count);
 		if (ret < 0) {
 			mutex_unlock(&nf_nat_proto_mutex);
-			for (i = 0; i < ops_count; i++)
-				kfree(nat_ops[i].priv);
-			kfree(nat_ops);
+			for (i = 0; i < ops_count; i++) {
+				priv = nat_ops[i].priv;
+				kfree_rcu(priv, rcu_head);
+			}
+			kfree_rcu(nat_ops, rcu);
 			return ret;
 		}
 
@@ -1322,7 +1324,7 @@ void nf_nat_unregister_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		nat_proto_net->nat_hook_ops = NULL;
-		kfree(nat_ops);
+		kfree_rcu(nat_ops, rcu);
 	}
 unlock:
 	mutex_unlock(&nf_nat_proto_mutex);
-- 
2.53.0



