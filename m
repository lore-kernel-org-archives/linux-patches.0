Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B61B199941;
	Tue, 10 Sep 2024 10:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963588; cv=none; b=mHnUW10nRSFq9pVrgQHTbfmyPFK8J/yQaxN48MNGfsLBHj2pZJChCv/WF2P28igFdCHBQK/2pKZYFFFFueAPOLHlH0pDdtfwEisUIcg8u5SG4pFuybywVRmnUQygvvawoL95XVg+8v08WCj6jSs8i+PPnPY+9M9sQCC9trztjno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963588; c=relaxed/simple;
	bh=K/W4cWDg7mFWJnKHmH9C53LT0dv1Zk+MB12X/Wo6tpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol6eFP5ca08o9eqhEqPg9DENvGwzvEXt5E9vkOVdvh+TcOB9JpkBzK31cjSY9vdEJwl3la2aN39o8Ym8YQqwkQnxduTI8tSvpmSi2uPqKMU0OVJG6Org21kLbvwwjWov6j7za/kDMoNANwrymgB0FjtGIO1oTPbRL5UE1IgW1tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08Ym72aC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08Ym72aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AD1C4CEC3;
	Tue, 10 Sep 2024 10:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963587;
	bh=K/W4cWDg7mFWJnKHmH9C53LT0dv1Zk+MB12X/Wo6tpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08Ym72aC+gGUuk9tbeg6TBxehd7U8k6OkbKx7UbLAPPRy6p0HDnetuU2To+7ffXif
	 6Je/FF0riIS1pTb/uYwICWTACx8pddurRw78liMb8lCF7TRSnILqBvFVOB/poewtFG
	 aYWFFZZg1Q5+0FsfclMHCzmgXrO9j4vUXfGUhcLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 108/214] netfilter: nf_conncount: fix wrong variable type
Date: Tue, 10 Sep 2024 11:32:10 +0200
Message-ID: <20240910092603.218896198@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 0b88d1654d556264bcd24a9cb6383f0888e30131 ]

Now there is a issue is that code checks reports a warning: implicit
narrowing conversion from type 'unsigned int' to small type 'u8' (the
'keylen' variable). Fix it by removing the 'keylen' variable.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 82f36beb2e76..0ce12a33ffda 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -310,7 +310,6 @@ insert_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
 	unsigned int count = 0, gc_count = 0;
-	u8 keylen = data->keylen;
 	bool do_gc = true;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
@@ -322,7 +321,7 @@ insert_tree(struct net *net,
 		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
 
 		parent = *rbnode;
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			rbnode = &((*rbnode)->rb_left);
 		} else if (diff > 0) {
@@ -367,7 +366,7 @@ insert_tree(struct net *net,
 
 	conn->tuple = *tuple;
 	conn->zone = *zone;
-	memcpy(rbconn->key, key, sizeof(u32) * keylen);
+	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
 	nf_conncount_list_init(&rbconn->list);
 	list_add(&conn->node, &rbconn->list.head);
@@ -392,7 +391,6 @@ count_tree(struct net *net,
 	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
-	u8 keylen = data->keylen;
 
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
@@ -403,7 +401,7 @@ count_tree(struct net *net,
 
 		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
 
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
 		} else if (diff > 0) {
-- 
2.43.0



