Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3A7188CC1;
	Tue, 10 Sep 2024 09:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961034; cv=none; b=N9ZmBnN3QZSR4X4XAHJZelvK4J+EMXmAjrxs3vVpa+S6q/anLGbnc/a9zhoD/DwiX9SVFYd4XDzvRPrtmN33VpnYk3XUyxLl7f67hsLYLX6ivAja1t38VWblwuq6qrtr/CudGMQyfRu9A8+RzCQBKCl3H15TJkaT+7QIo4Hkc1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961034; c=relaxed/simple;
	bh=CeidDjqvh8AE7DiULYlFgfxAEN0q8MSoGx9+9aP4bK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYYwMGFq+LSf2lMS+Y9B86MeEt+3hCh9pPMIoe9AS/1NtXNkXKEtXLxyGZMkgtMptw23V16B4WEM2olBzQ+2+A7nun5IKnwS6xBuWzoJhIiiaPfo4rqPafB7JkxUBBtGNz0x9FxctVzRKidgMdGTT/Qh8GYzQ8uDb2xI2Quy3tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXKLKDGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXKLKDGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B036C4CEC3;
	Tue, 10 Sep 2024 09:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961033;
	bh=CeidDjqvh8AE7DiULYlFgfxAEN0q8MSoGx9+9aP4bK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXKLKDGnF5L6f+tnKN6IJwM4Hm7ocmfC5sd8RP4s6BHNguI44A7B1udKJ2TBvXUPZ
	 wWmHO4zlP7RYzTvCGpkhuGiEP9933TT3qIkQI4E7EflvqCK+uhJhwCpoWsUA5rof2n
	 9sgF1h5aOHvoN0cUPZ/Y1E7+HI28v2KoyJCq4/8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 30/96] netfilter: nf_conncount: fix wrong variable type
Date: Tue, 10 Sep 2024 11:31:32 +0200
Message-ID: <20240910092542.817712898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7554c56b2e63..d189ca7c2c02 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -309,7 +309,6 @@ insert_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
 	unsigned int count = 0, gc_count = 0;
-	u8 keylen = data->keylen;
 	bool do_gc = true;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
@@ -321,7 +320,7 @@ insert_tree(struct net *net,
 		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
 
 		parent = *rbnode;
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			rbnode = &((*rbnode)->rb_left);
 		} else if (diff > 0) {
@@ -366,7 +365,7 @@ insert_tree(struct net *net,
 
 	conn->tuple = *tuple;
 	conn->zone = *zone;
-	memcpy(rbconn->key, key, sizeof(u32) * keylen);
+	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
 	nf_conncount_list_init(&rbconn->list);
 	list_add(&conn->node, &rbconn->list.head);
@@ -391,7 +390,6 @@ count_tree(struct net *net,
 	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
-	u8 keylen = data->keylen;
 
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
@@ -402,7 +400,7 @@ count_tree(struct net *net,
 
 		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
 
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
 		} else if (diff > 0) {
-- 
2.43.0



