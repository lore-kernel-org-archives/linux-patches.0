Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFC3437111;
	Tue, 21 Jul 2026 22:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671834; cv=none; b=hAjNoEX5rqne8nnZKE9DN0BohjstxvJQSbWJkgWh3W8CrP0EaCAgoI4/50uDTqtzb1tXJYXuwtVf4GhillECMJuzTJjg90b4VBRGNmAQD7rFP9ToarKAftIyWnuQSCFAPQaYWaH92e5Nku0Tj/7lM+mGA3QNVjmWBcSyrpc068c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671834; c=relaxed/simple;
	bh=hDS084RcWAO9L3nPVV9ihv1P+gsQcYHvOQylxfKD5mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OInCrrkj9cqCPrZR2EzP51RCmuXE4aprPXT9fdkNkV3zVdpVkjx0KWkvJsVR5ZV8FLUg6C8yhP4IWpUAi4KVztEz6LKl1xyC0f/hEF7kxjJUqoCkwD3LA0uCTe3+nSmSLQC8+i82FHYDzGcM5HlD+8vP6f6Do7jb7UPV7B0pqjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vdCLe+3q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vdCLe+3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FF11F000E9;
	Tue, 21 Jul 2026 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671833;
	bh=PToHKlqWkqQ5IaUnZZRWHbhrEZlNiXQY/9Yc22LVFmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdCLe+3qQS1jynDUjHfIj/W5sxfS11pigI+8R0Fp+edLTA6U00GGeIAjiksYffnuQ
	 CZk8uZaFkVuQiE10WM7rsq7/0YapVnQsScvhe4Vl/pzVsVTmdPnz6PjMqqQ8skEhyW
	 YEzWusw/0KvcI49Mo4zUj6r17KZYmbuwlP/zsMVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/843] netfilter: nf_conncount: callers must hold rcu read lock
Date: Tue, 21 Jul 2026 17:19:54 +0200
Message-ID: <20260721152414.106172019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c5480a345c9f6..527a181c842c67 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -2088,10 +2088,10 @@ static int ovs_ct_limit_get_zone_limit(struct net *net,
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



