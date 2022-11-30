Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245A979C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB1AC433D7;
	Wed, 30 Nov 2022 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834174;
	bh=+aAj8DqxD8MpJkGpAoauxx8CvUD8Kx3cZ7VXAqb4eFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itz7+DNswoJvss2e05nctl8+frTz/1BUzycjkRv5ps7KxBQmDNCVyTid5/s21Cl/a
	 o9qSaKClKfqF5wYeozm4HnRd3bBYhySlEtHWVbvNqRf5nT2d3rR3xKd9tLj5tVWvlY
	 Y5HGQ2AyJM33PUOykj76GkFfrAARXjBbhdmcAhrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 139/289] ipv4: Fix error return code in fib_table_insert()
Date: Wed, 30 Nov 2022 19:22:04 +0100
Message-Id: <20221130180547.288795207@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 568fe84940ac0e4e0b2cd7751b8b4911f7b9c215 ]

In fib_table_insert(), if the alias was already inserted, but node not
exist, the error code should be set before return from error handling path.

Fixes: a6c76c17df02 ("ipv4: Notify route after insertion to the routing table")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Link: https://lore.kernel.org/r/20221120072838.2167047-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_trie.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 452ff177e4da..f26d5ac117d6 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1381,8 +1381,10 @@ int fib_table_insert(struct net *net, struct fib_table *tb,
 
 	/* The alias was already inserted, so the node must exist. */
 	l = l ? l : fib_find_node(t, &tp, key);
-	if (WARN_ON_ONCE(!l))
+	if (WARN_ON_ONCE(!l)) {
+		err = -ENOENT;
 		goto out_free_new_fa;
+	}
 
 	if (fib_find_alias(&l->leaf, new_fa->fa_slen, 0, 0, tb->tb_id, true) ==
 	    new_fa) {
-- 
2.35.1



