Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D5728ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7C1C433D2;
	Mon, 12 Dec 2022 13:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852545;
	bh=YSVbyQ65vNQgobC8rJaKgghnzqGEtKPpWMESo2BLjbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDxEISxqhdaG2mR29NH9uq53Zx5VSDH9nXt8IU971WxB1qsDpCATjLG7iFdrs75wO
	 KJyx4VN1t+Ry9+xKRGcXqYOPIPMngAZmbdfU+bs3BShSnlnd8GX4w2verxZA/s3Hgl
	 YjgxD9vVYMWztPJ78w2wTyjSw4cqJfhmaxQexA84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Florian Westphal <fw@strlen.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 103/157] inet: ping: use hlist_nulls rcu iterator during lookup
Date: Mon, 12 Dec 2022 14:17:31 +0100
Message-Id: <20221212130938.976364067@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c25b7a7a565e5eeb2459b37583eea67942057511 ]

ping_lookup() does not acquire the table spinlock, so iteration should
use hlist_nulls_for_each_entry_rcu().

Spotted during code review.

Fixes: dbca1596bbb0 ("ping: convert to RCU lookups, get rid of rwlock")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/r/20221129140644.28525-1-fw@strlen.de
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .clang-format      | 1 +
 include/net/ping.h | 3 ---
 net/ipv4/ping.c    | 7 ++++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/.clang-format b/.clang-format
index 1247d54f9e49..8d01225bfcb7 100644
--- a/.clang-format
+++ b/.clang-format
@@ -535,6 +535,7 @@ ForEachMacros:
   - 'perf_hpp_list__for_each_sort_list_safe'
   - 'perf_pmu__for_each_hybrid_pmu'
   - 'ping_portaddr_for_each_entry'
+  - 'ping_portaddr_for_each_entry_rcu'
   - 'plist_for_each'
   - 'plist_for_each_continue'
   - 'plist_for_each_entry'
diff --git a/include/net/ping.h b/include/net/ping.h
index e4ff3911cbf5..9233ad3de0ad 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -16,9 +16,6 @@
 #define PING_HTABLE_SIZE 	64
 #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
 
-#define ping_portaddr_for_each_entry(__sk, node, list) \
-	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
-
 /*
  * gid_t is either uint or ushort.  We want to pass it to
  * proc_dointvec_minmax(), so it must not be larger than MAX_INT
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b83c2bd9d722..3b2420829c23 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -48,6 +48,11 @@
 #include <net/transp_v6.h>
 #endif
 
+#define ping_portaddr_for_each_entry(__sk, node, list) \
+	hlist_nulls_for_each_entry(__sk, node, list, sk_nulls_node)
+#define ping_portaddr_for_each_entry_rcu(__sk, node, list) \
+	hlist_nulls_for_each_entry_rcu(__sk, node, list, sk_nulls_node)
+
 struct ping_table {
 	struct hlist_nulls_head	hash[PING_HTABLE_SIZE];
 	spinlock_t		lock;
@@ -191,7 +196,7 @@ static struct sock *ping_lookup(struct net *net, struct sk_buff *skb, u16 ident)
 		return NULL;
 	}
 
-	ping_portaddr_for_each_entry(sk, hnode, hslot) {
+	ping_portaddr_for_each_entry_rcu(sk, hnode, hslot) {
 		isk = inet_sk(sk);
 
 		pr_debug("iterate\n");
-- 
2.35.1



