Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE50015747D;
	Tue,  2 Sep 2025 13:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819701; cv=none; b=cOIybNPQJVsqQlwttGWMrQ0Wivtbw4JkfSRhmtLRh5dMnqrahPSBcH5rfSJnXAX01j/SHB6n8cuIfZcn6H3ik/Uh02eyFFxUFlBZ8yRLrYBe57Wokt1E18FA3QxVK8sMSHEZQUCNClQdWvIBgbwhu2HItrn58vRw8CeBh8sAGJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819701; c=relaxed/simple;
	bh=oeLtV8h3zRmxIj/k4cmgO7T4nwfa8MG9LUmKPq116E8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXlkj4RIOqfWHdRzdcsyn5tLA34cnn7TZLe8q4Rvz3iQXinxg/kjTPhyRQ0YJUyFno/zXfgU+2hWFin3AA3o2LoZpP5ArcBjvK4LHPRgoFPo+FZgH6Zw+vXYFrubMHfYm+5KZ6yEyt8EAOTaRQUq/GQvrO5nbKfG25eIqyEGMgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xThu3nxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xThu3nxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20720C4CEF5;
	Tue,  2 Sep 2025 13:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819701;
	bh=oeLtV8h3zRmxIj/k4cmgO7T4nwfa8MG9LUmKPq116E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xThu3nxlPAijNXjpKGorlqtxAdstjMvce93Z2ZNvJRuxDODUmK2wZSWSfvhhxZ/n/
	 sDfZU8CPZS1UubN17NONJMpg3Ljkjhil9U8eGHmHGX/BFuq0wnpWcD8sBhqb4Yk2h9
	 D0BmR4B7ZNOA7RN389lu3kYUYIJ5eoFnbEVovl7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+942297eecf7d2d61d1f1@syzkaller.appspotmail.com,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 096/142] net: rose: include node references in rose_neigh refcount
Date: Tue,  2 Sep 2025 15:19:58 +0200
Message-ID: <20250902131951.946336599@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takamitsu Iwai <takamitz@amazon.co.jp>

[ Upstream commit da9c9c877597170b929a6121a68dcd3dd9a80f45 ]

Current implementation maintains two separate reference counting
mechanisms: the 'count' field in struct rose_neigh tracks references from
rose_node structures, while the 'use' field (now refcount_t) tracks
references from rose_sock.

This patch merges these two reference counting systems using 'use' field
for proper reference management. Specifically, this patch adds incrementing
and decrementing of rose_neigh->use when rose_neigh->count is incremented
or decremented.

This patch also modifies rose_rt_free(), rose_rt_device_down() and
rose_clear_route() to properly release references to rose_neigh objects
before freeing a rose_node through rose_remove_node().

These changes ensure rose_neigh structures are properly freed only when
all references, including those from rose_node structures, are released.
As a result, this resolves a slab-use-after-free issue reported by Syzbot.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+942297eecf7d2d61d1f1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=942297eecf7d2d61d1f1
Signed-off-by: Takamitsu Iwai <takamitz@amazon.co.jp>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250823085857.47674-4-takamitz@amazon.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_route.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index 8efb9033c057c..1adee1fbc2ed1 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -178,6 +178,7 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 			}
 		}
 		rose_neigh->count++;
+		rose_neigh_hold(rose_neigh);
 
 		goto out;
 	}
@@ -187,6 +188,7 @@ static int __must_check rose_add_node(struct rose_route_struct *rose_route,
 		rose_node->neighbour[rose_node->count] = rose_neigh;
 		rose_node->count++;
 		rose_neigh->count++;
+		rose_neigh_hold(rose_neigh);
 	}
 
 out:
@@ -322,6 +324,7 @@ static int rose_del_node(struct rose_route_struct *rose_route,
 	for (i = 0; i < rose_node->count; i++) {
 		if (rose_node->neighbour[i] == rose_neigh) {
 			rose_neigh->count--;
+			rose_neigh_put(rose_neigh);
 
 			if (rose_neigh->count == 0) {
 				rose_remove_neigh(rose_neigh);
@@ -430,6 +433,7 @@ int rose_add_loopback_node(const rose_address *address)
 	rose_node_list  = rose_node;
 
 	rose_loopback_neigh->count++;
+	rose_neigh_hold(rose_loopback_neigh);
 
 out:
 	spin_unlock_bh(&rose_node_list_lock);
@@ -461,6 +465,7 @@ void rose_del_loopback_node(const rose_address *address)
 	rose_remove_node(rose_node);
 
 	rose_loopback_neigh->count--;
+	rose_neigh_put(rose_loopback_neigh);
 
 out:
 	spin_unlock_bh(&rose_node_list_lock);
@@ -500,6 +505,7 @@ void rose_rt_device_down(struct net_device *dev)
 				memmove(&t->neighbour[i], &t->neighbour[i + 1],
 					sizeof(t->neighbour[0]) *
 						(t->count - i));
+				rose_neigh_put(s);
 			}
 
 			if (t->count <= 0)
@@ -543,6 +549,7 @@ static int rose_clear_routes(void)
 {
 	struct rose_neigh *s, *rose_neigh;
 	struct rose_node  *t, *rose_node;
+	int i;
 
 	spin_lock_bh(&rose_node_list_lock);
 	spin_lock_bh(&rose_neigh_list_lock);
@@ -553,8 +560,12 @@ static int rose_clear_routes(void)
 	while (rose_node != NULL) {
 		t         = rose_node;
 		rose_node = rose_node->next;
-		if (!t->loopback)
+
+		if (!t->loopback) {
+			for (i = 0; i < rose_node->count; i++)
+				rose_neigh_put(t->neighbour[i]);
 			rose_remove_node(t);
+		}
 	}
 
 	while (rose_neigh != NULL) {
@@ -1189,7 +1200,7 @@ static int rose_neigh_show(struct seq_file *seq, void *v)
 			   (rose_neigh->loopback) ? "RSLOOP-0" : ax2asc(buf, &rose_neigh->callsign),
 			   rose_neigh->dev ? rose_neigh->dev->name : "???",
 			   rose_neigh->count,
-			   refcount_read(&rose_neigh->use) - 1,
+			   refcount_read(&rose_neigh->use) - rose_neigh->count - 1,
 			   (rose_neigh->dce_mode) ? "DCE" : "DTE",
 			   (rose_neigh->restarted) ? "yes" : "no",
 			   ax25_display_timer(&rose_neigh->t0timer) / HZ,
@@ -1294,6 +1305,7 @@ void __exit rose_rt_free(void)
 	struct rose_neigh *s, *rose_neigh = rose_neigh_list;
 	struct rose_node  *t, *rose_node  = rose_node_list;
 	struct rose_route *u, *rose_route = rose_route_list;
+	int i;
 
 	while (rose_neigh != NULL) {
 		s          = rose_neigh;
@@ -1307,6 +1319,8 @@ void __exit rose_rt_free(void)
 		t         = rose_node;
 		rose_node = rose_node->next;
 
+		for (i = 0; i < t->count; i++)
+			rose_neigh_put(t->neighbour[i]);
 		rose_remove_node(t);
 	}
 
-- 
2.50.1



