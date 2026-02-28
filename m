Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C73332AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301249; cv=none; b=VwtDsGeICzh92JmZCBSnP5q5wICeyJ0y6qXfE3QStj3wAUg4YS7QNJw/yT+k+pGa/WV4wGyTBV9ZksQtGQ51t/S4V/Achej0877ASekHTQqIKSVf275oh2lc5wMvZ6XUiM+6vBxUgG+OXm5jFO8BU2wDQc0E9iRn+6F4PJMCy7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301249; c=relaxed/simple;
	bh=KC4k2oJe8InnAy4iSiJf0CgxbA7L6xle0i7Jgq9Ivr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sX+ZXgX/5hQ7bfjHhSuAAtksKv76QZ07qBeaoh4iqis+0Zeb8T50d/YywoaZYFSkKEzzk3/4YxFANBmNqcPl10Yv71GdSCu0mQoDjEXXyRztUZM51dBUEAAYKtJbAmGAjJ9qeV5GFnRxu222syp5/oLtNbxiCueG1u/68zNAF8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m8HpIIWd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m8HpIIWd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D903AC19423;
	Sat, 28 Feb 2026 17:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301249;
	bh=KC4k2oJe8InnAy4iSiJf0CgxbA7L6xle0i7Jgq9Ivr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8HpIIWdRnOqoqR2zPtZ/LJ6NKehG/nVV7z9DFE0KjB2CraVSI4pG3mQnVr30VoNU
	 LiDFveWZ2r/7KqbM7R7bcnV7JcvITPQeXd25vHEoa6G1x+3u5W4SCVZ6sKZzp/0Gc1
	 R1Lzb7d3lY9wfj2/l7bp8/A+mnU0jsP+IH4cV0a2rQXQTeaW6ZNa5HhgCk4u/sagri
	 UBV7aOYuWmfjBm1H9RbaOo4I6ZUhgsKZiBfT7FnvTUjixpWvZZC5+a39CWiXkD2YrG
	 btsa4naNGSGDxVgdVRr7eXIdBTP/Kliy3Skm+m5/v2Eo6Lc5GZPJQuK8m+xAwG4KlS
	 T/cNikQUiJIYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Tung Nguyen <tung.quang.nguyen@est.tech>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 431/752] tipc: fix duplicate publication key in tipc_service_insert_publ()
Date: Sat, 28 Feb 2026 12:42:22 -0500
Message-ID: <20260228174750.1542406-431-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Tung Nguyen <tung.quang.nguyen@est.tech>

[ Upstream commit 3aa677625c8fad39989496c51bcff3872c1f16f1 ]

TIPC uses named table to store TIPC services represented by type and
instance. Each time an application calls TIPC API bind() to bind a
type/instance to a socket, an entry is created and inserted into the
named table. It looks like this:

named table:
key1, entry1 (type, instance ...)
key2, entry2 (type, instance ...)

In the above table, each entry represents a route for sending data
from one socket to the other. For all publications originated from
the same node, the key is UNIQUE to identify each entry.
It is calculated by this formula:
key = socket portid + number of bindings + 1 (1)

where:
 - socket portid: unique and calculated by using linux kernel function
                  get_random_u32_below(). So, the value is randomized.
 - number of bindings: the number of times a type/instance pair is bound
                       to a socket. This number is linearly increased,
                       starting from 0.

While the socket portid is unique and randomized by linux kernel, the
linear increment of "number of bindings" in formula (1) makes "key" not
unique anymore. For example:
- Socket 1 is created with its associated port number 20062001. Type 1000,
instance 1 is bound to socket 1:
key1: 20062001 + 0 + 1 = 20062002

Then, bind() is called a second time on Socket 1 to by the same type 1000,
instance 1:
key2: 20062001 + 1 + 1 = 20062003

Named table:
key1 (20062002), entry1 (1000, 1 ...)
key2 (20062003), entry2 (1000, 1 ...)

- Socket 2 is created with its associated port number 20062002. Type 1000,
instance 1 is bound to socket 2:
key3: 20062002 + 0 + 1 = 20062003

TIPC looks up the named table and finds out that key2 with the same value
already exists and rejects the insertion into the named table.
This leads to failure of bind() call from application on Socket 2 with error
message EINVAL "Invalid argument".

This commit fixes this issue by adding more port id checking to make sure
that the key is unique to publications originated from the same port id
and node.

Fixes: 218527fe27ad ("tipc: replace name table service range array with rb tree")
Signed-off-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260220050541.237962-1-tung.quang.nguyen@est.tech
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/name_table.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/tipc/name_table.c b/net/tipc/name_table.c
index e74940eab3a47..7f42fb6a8481f 100644
--- a/net/tipc/name_table.c
+++ b/net/tipc/name_table.c
@@ -348,7 +348,8 @@ static bool tipc_service_insert_publ(struct net *net,
 
 	/* Return if the publication already exists */
 	list_for_each_entry(_p, &sr->all_publ, all_publ) {
-		if (_p->key == key && (!_p->sk.node || _p->sk.node == node)) {
+		if (_p->key == key && _p->sk.ref == p->sk.ref &&
+		    (!_p->sk.node || _p->sk.node == node)) {
 			pr_debug("Failed to bind duplicate %u,%u,%u/%u:%u/%u\n",
 				 p->sr.type, p->sr.lower, p->sr.upper,
 				 node, p->sk.ref, key);
@@ -388,7 +389,8 @@ static struct publication *tipc_service_remove_publ(struct service_range *r,
 	u32 node = sk->node;
 
 	list_for_each_entry(p, &r->all_publ, all_publ) {
-		if (p->key != key || (node && node != p->sk.node))
+		if (p->key != key || p->sk.ref != sk->ref ||
+		    (node && node != p->sk.node))
 			continue;
 		list_del(&p->all_publ);
 		list_del(&p->local_publ);
-- 
2.51.0

