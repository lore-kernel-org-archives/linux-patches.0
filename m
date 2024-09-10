Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C02188CDC;
	Tue, 10 Sep 2024 10:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964995; cv=none; b=E0rPfXMEBkgTm1ImiiF5i67B8wUwR6bGLRpoZLTa6eSErC6LiKM3lqPllPiYVjbWEOAuYQ8wpuLoiUksl9UfO4k/zKyGAyXoa9C2dPX2uBsWKCr2d0+l1ZNcqfY9/EPidvnioxgbeoaD9GyWTisYKbYLYJKF5ZGfTRjFXDAafwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964995; c=relaxed/simple;
	bh=lpB++LjPRoEVDrUS5hjUKhplS2QNFyxePjd6dG7ZoDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cbq3n3ps7cBMBWJTfBIWQjvr/bGFXvtXxdEUdt7MAtU4NNsb5sidbE3KAR0cI1Dfm920XNekBZjKwSm6NF1IMbZ1QmKimZUefab6X9b35eaHDwBLLcZXeeNIrepSjgNEhuQ6iVqBFHp6UbIAoCJbTwQk+pQ+pXXcXa1qJCw1JUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNyPDA92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNyPDA92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227C2C4CEC3;
	Tue, 10 Sep 2024 10:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964995;
	bh=lpB++LjPRoEVDrUS5hjUKhplS2QNFyxePjd6dG7ZoDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNyPDA929Uo+/2HLmtrLwTjk7a7Oja9Ys9vWhKkwv3a13oCJGGN7lXnok/KN1r0KN
	 HPYuYjsjxtL46pqSmLgS+TFrBGJ4CGpYVSL8UkcrtSFhI1PkX14RXbl7iU0EK/imWn
	 bl67Vpja9QaXSEda/hHDpn6KylC77FCwYfljSP7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/186] netfilter: nf_conncount: fix wrong variable type
Date: Tue, 10 Sep 2024 11:33:17 +0200
Message-ID: <20240910092558.735977154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



