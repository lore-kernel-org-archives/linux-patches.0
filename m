Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0163B3C15;
	Tue, 21 Jul 2026 20:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666182; cv=none; b=gOUwlWuVBnPcGvVJ11Sybg9eOJ2vstYGKN9Pm030Sr21idwQs3Sr1DjgpkWnKzAjR+AtgLVduuwQgwbuOH24j2oL0YSERqB27qShlRQDY1uLDHLzvbgThyYwsLctt5YhvZBFqamC0YjMChj0JIa582TJ8FTTvdprZyGcZwf9UCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666182; c=relaxed/simple;
	bh=AjlZzvGZIn0clQ0EudJugUNHzQKN8J/pIX3Fv01UYOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfJTB2HMtfnLfpFDrLI30e+yV3MRncgcOXxOZ/bor4NoiYe79/+T653S4UCi9rFqokyBJgqFWMBk2xnyHJ/E4KvRLwzSTyd+ISROpESqhGJNv/RN+76tNZ9x77w7UCtqJFStbKduQNlNjgSfP6mzoWBeNCZdAS7WqgOyAJoDz30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0bAR0Rq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0bAR0Rq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD94D1F000E9;
	Tue, 21 Jul 2026 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666180;
	bh=xccaUWX7JJfzANskAbELS5ho97JeQJn87vosq4sTJ0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0bAR0RqtCPSmxpDduS/3aNkXp4D3+Guz3PHjGfhs3EAmqYcqdd4hUqgE9CJolgB8
	 9TO3OgVxuPvMp2T4Zoo4wuZ/curcaIb8jY989Db8ezocokCZ6i+ynHNpca941+bjak
	 kbNjG+n52D0E2Lr7g1Ogto24fXbKu9q2RdEAJw8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0584/1266] netfilter: nf_conncount: callers must hold rcu read lock
Date: Tue, 21 Jul 2026 17:17:01 +0200
Message-ID: <20260721152454.934277265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 32485b36773755..82ffb1ac86b0cb 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1774,10 +1774,10 @@ static int ovs_ct_limit_get_zone_limit(struct net *net,
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



