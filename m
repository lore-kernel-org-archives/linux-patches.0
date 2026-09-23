Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F76535FBB;
	Wed, 23 Sep 2026 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174378; cv=none; b=VFaRRPkdkty1NbWmKRXmTThv+fO4hebdeN0nDD6zofZHGtijmOD37KclZ2062leYjKNYrh+0tR+E7swfE8ZMi50CVavrd8/2AI8yETPojTRier8VB9HNtF/81Tv0OjS2N41rzauqQhLH9tJIg87WH+hXdUwQg31vqhVDolJO3P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174378; c=relaxed/simple;
	bh=35DJVds/FmES1dyLC/xDhBfaQjhur36pSfzWaSBbbg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2A4UULM//yww2GcqT25EkxGMLPN1L+5I32HJU9AWMDI3saVMXoxAyyY8CCBUhYKEoVfpnOEy8dHiyfrROp3we65MU/+Wky29hWMtLJvggpBVl0bpdYxSRiWFTttQksVPfppy9ZDLJSKQN90fupZguEs/HKVErSYjcIVWsnXcS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTbTZHJy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTbTZHJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557181F000FF;
	Wed, 23 Sep 2026 14:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174376;
	bh=Fg4frf94FtZXH3113/B1CXaDy6LjpHuZxT5Yzr95bxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTbTZHJyWIlsdkVagVA0y29Jz5pT5ZGQumcibnqmgguBG/3PIyrAHOwbDggccpE9E
	 8pFNNvwPeqIbZ9THwFfV1gC6XeEy3D2unpxFDAhsm6GKOsciGULoydwytqUcckiNcC
	 WxASqQFgz3rXExsZqTs4ZUZFFgF136rPYrK7Q+4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/398] netfilter: nf_nat: unregister and release hooks on error
Date: Wed, 23 Sep 2026 16:02:48 +0200
Message-ID: <20260923140645.873863707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit cbdd39ce42530a193c56beb206a3356cb6d01016 ]

If nf_hook_entries_insert_raw() fails, the NAT hooks get never released,
resulting in a memleak.

Postpone setting nat_proto_net->nat_hook_ops when the hooks are
registered to simplify the error path to decide whether the nat hooks
need unwinding.

Fixes: 1cd472bf036c ("netfilter: nf_nat: add nat hook register functions to nf_nat")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_nat_core.c | 46 ++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index cd84f2aa08f2d..658b0f1438340 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1236,31 +1236,45 @@ int nf_nat_register_fn(struct net *net, u8 pf, const struct nf_hook_ops *ops,
 		}
 
 		ret = nf_register_net_hooks(net, nat_ops, ops_count);
-		if (ret < 0) {
-			mutex_unlock(&nf_nat_proto_mutex);
-			for (i = 0; i < ops_count; i++) {
-				priv = nat_ops[i].priv;
-				kfree_rcu(priv, rcu_head);
-			}
-			kfree_rcu(nat_ops, rcu);
-			return ret;
-		}
-
-		nat_proto_net->nat_hook_ops = nat_ops;
+		if (ret < 0)
+			goto err_free_hooks;
+	} else {
+		nat_ops = nat_proto_net->nat_hook_ops;
 	}
 
-	nat_ops = nat_proto_net->nat_hook_ops;
 	priv = nat_ops[hooknum].priv;
 	if (WARN_ON_ONCE(!priv)) {
-		mutex_unlock(&nf_nat_proto_mutex);
-		return -EOPNOTSUPP;
+		ret = -EOPNOTSUPP;
+		goto err_unregister_hooks;
 	}
 
 	ret = nf_hook_entries_insert_raw(&priv->entries, ops);
-	if (ret == 0)
-		nat_proto_net->users++;
+	if (ret)
+		goto err_unregister_hooks;
+
+	if (!nat_proto_net->nat_hook_ops)
+		nat_proto_net->nat_hook_ops = nat_ops;
+
+	nat_proto_net->users++;
 
 	mutex_unlock(&nf_nat_proto_mutex);
+
+	return 0;
+
+err_unregister_hooks:
+	if (nat_proto_net->nat_hook_ops) {
+		mutex_unlock(&nf_nat_proto_mutex);
+		return ret;
+	}
+	nf_unregister_net_hooks(net, nat_ops, ops_count);
+err_free_hooks:
+	mutex_unlock(&nf_nat_proto_mutex);
+	for (i = 0; i < ops_count; i++) {
+		priv = nat_ops[i].priv;
+		kfree_rcu(priv, rcu_head);
+	}
+	kfree_rcu(nat_ops, rcu);
+
 	return ret;
 }
 
-- 
2.53.0



