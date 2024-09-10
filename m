Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630CA18661A;
	Tue, 10 Sep 2024 09:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961638; cv=none; b=AE5vcgmqINKJZnlY+kBopO8fSb8FFQZAjHBnCrD4Vlfc0CgtIi8mwnNh/nIAdxFJQKMIO8Hw/6ZyTla8DEuTcQs9kyoyi17DlLxczv0kmL8M1AB9J893fYuK0i1YZjCMvia9D0iBzlzv2x2R8w4jsl9QhQcjwPNrAjpD2n5dFhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961638; c=relaxed/simple;
	bh=zIcx71Of1X0rSo8ITddKuUBtd7aPVJmX0xYbw5Z8HCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mIgii8UiAd3MIsPK/5Dg+VEsxsCZKqv4/cuzY9Zo/mLjMPw8jnh4qklPtDgkrfhvzwsVD8TW5Np8isuYvzSs1hZESN8XKZ/V/yQgfAGdbDLpFyqNhl6I3OotLjM69dhEUKhf0M4E3Fx9C7s+f2lw9N1M+FFrCOqXt7FpOivYfU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0oHKUfpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0oHKUfpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849C0C4CEC3;
	Tue, 10 Sep 2024 09:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961637;
	bh=zIcx71Of1X0rSo8ITddKuUBtd7aPVJmX0xYbw5Z8HCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0oHKUfpqqvmJjZdjqeEgAbVYoP6sJBPJ8x/tE6R+zDM9M8PrXU3mON7Odz7pn6hjN
	 ZlMWzo8rWhynxj8MFAriAGR8yXsY8UQmJnA5uDrMeEX+flHRc6pRWP6wVPmRmAwwvi
	 Okiq6aYcvDv0huxrU7Ltb11OaeBfSWfwMOtY7R8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunjian Wang <wangyunjian@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 110/375] netfilter: nf_conncount: fix wrong variable type
Date: Tue, 10 Sep 2024 11:28:27 +0200
Message-ID: <20240910092626.094809981@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index 8715617b02fe..34ba14e59e95 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -321,7 +321,6 @@ insert_tree(struct net *net,
 	struct nf_conncount_rb *rbconn;
 	struct nf_conncount_tuple *conn;
 	unsigned int count = 0, gc_count = 0;
-	u8 keylen = data->keylen;
 	bool do_gc = true;
 
 	spin_lock_bh(&nf_conncount_locks[hash]);
@@ -333,7 +332,7 @@ insert_tree(struct net *net,
 		rbconn = rb_entry(*rbnode, struct nf_conncount_rb, node);
 
 		parent = *rbnode;
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			rbnode = &((*rbnode)->rb_left);
 		} else if (diff > 0) {
@@ -378,7 +377,7 @@ insert_tree(struct net *net,
 
 	conn->tuple = *tuple;
 	conn->zone = *zone;
-	memcpy(rbconn->key, key, sizeof(u32) * keylen);
+	memcpy(rbconn->key, key, sizeof(u32) * data->keylen);
 
 	nf_conncount_list_init(&rbconn->list);
 	list_add(&conn->node, &rbconn->list.head);
@@ -403,7 +402,6 @@ count_tree(struct net *net,
 	struct rb_node *parent;
 	struct nf_conncount_rb *rbconn;
 	unsigned int hash;
-	u8 keylen = data->keylen;
 
 	hash = jhash2(key, data->keylen, conncount_rnd) % CONNCOUNT_SLOTS;
 	root = &data->root[hash];
@@ -414,7 +412,7 @@ count_tree(struct net *net,
 
 		rbconn = rb_entry(parent, struct nf_conncount_rb, node);
 
-		diff = key_diff(key, rbconn->key, keylen);
+		diff = key_diff(key, rbconn->key, data->keylen);
 		if (diff < 0) {
 			parent = rcu_dereference_raw(parent->rb_left);
 		} else if (diff > 0) {
-- 
2.43.0



