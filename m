Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C9B34B1A6;
	Tue, 21 Jul 2026 22:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673789; cv=none; b=S5o0W/8H90hl3XsLspNuX9jyJYWNEG0NkpOZZMS86Ki1FDfOlAYrIzrT4Gtcqd3mTiCWxWzCexhixQePF+/zDBr9YmmjsMP6kBcb/xzgoro2dxCsdGL1r7w35M5m/b2ZqJozOpV/gQtk8ORDd61B1CdodryxDuGdwU1PU7kK728=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673789; c=relaxed/simple;
	bh=LRFlpLFgZcWNluY10gjNAZNv04UjHBWU0yaKU/xuRwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er6iqY3WeMDNYdO+2FvFe3vJlTqr80Njw+mgBaxEa16nDNOFxFNUVtODCX/94OoxjfWbD691GFznhG0GcXrEipaz4+TRzaDcvC3znPY8wEvzT2q5nXHHsbxsqFJUHxYp2ZDn7gq9pF7L6EVJZcxqY1YCCzl1Hm8RGRXCEJcWG2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zt9JcyNS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zt9JcyNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4923F1F000E9;
	Tue, 21 Jul 2026 22:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673787;
	bh=yjbmfMA2WrdwAWQmxhlMWU2oKMpvFDsq6a0u7IB+UWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zt9JcyNSJgR0AqqeXV0/2YJ/Eo+xMjR5739hLYYbwz0e6gAL2nn+zmE4Ax6E4/zpx
	 wMZ6TCZX6AKuIMsx6jCcgEFzn2QrBfII3GymQvUAI2I7AueYi84Z+hZPEp4ZlvyTaJ
	 PReu/RvH2ksXQD4QcbAolLsLPpqzpWLlMVxj4qwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/699] netfilter: nf_conncount: callers must hold rcu read lock
Date: Tue, 21 Jul 2026 17:20:27 +0200
Message-ID: <20260721152401.747875700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 64d7d5abe2160bba369b4a8f06bdf5630573bab0 ]

rcu_derefence_raw() should not have been used here, it concealed this bug.
Its used because struct rb_node lacks __rcu annotated pointers, so plain
rcu_derefence causes sparse warnings.

The major tradeoff is that rcu_derefence_raw() doesn't warn when the caller
isn't in a rcu read section.

Extend the rcu read lock scope accordingly and cause sparse warnings,
those warnings are the lesser evil.

Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Closes: https://sashiko.dev/#/patchset/20260603230610.7900-1-fw%40strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 6 +++---
 net/openvswitch/conntrack.c  | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index ae9ad439449fa5..b9265a8cdb2bc4 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -499,7 +499,7 @@ count_tree(struct net *net,
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
 
-	parent = rcu_dereference_raw(root->rb_node);
+	parent = rcu_dereference(root->rb_node);
 	while (parent) {
 		int diff;
 
@@ -507,9 +507,9 @@ count_tree(struct net *net,
 
 		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
-			parent = rcu_dereference_raw(parent->rb_left);
+			parent = rcu_dereference(parent->rb_left);
 		} else if (diff > 0) {
-			parent = rcu_dereference_raw(parent->rb_right);
+			parent = rcu_dereference(parent->rb_right);
 		} else {
 			int ret;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 2a106d03a2011a..50a345ccd94309 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2076,10 +2076,10 @@ static int ovs_ct_limit_get_zone_limit(struct net *net,
 		} else {
 			rcu_read_lock();
 			limit = ct_limit_get(info, zone);
-			rcu_read_unlock();
 
 			err = __ovs_ct_limit_get_zone_limit(
 				net, info->data, zone, limit, reply);
+			rcu_read_unlock();
 			if (err)
 				return err;
 		}
-- 
2.53.0



