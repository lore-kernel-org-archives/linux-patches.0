Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B640931E10D;
	Tue,  2 Sep 2025 13:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820469; cv=none; b=Nex30w/Hb7Dvq9ks6057FonQcfhrh5nbUaf2kta2X9sSIJD/ohzA9/mR0R2fZZFcjpKkyJ3oMfmkQ/W+xPcHkSSEfUdYtws61ZfY9EEPSHbMXO76i929EZn0g+JCqf0DZVq0txIa6e5p8IEVsW0lBiW84WO4Tg2rsito9OEG5d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820469; c=relaxed/simple;
	bh=kw98HOM/SqDdClixjSLm8sgfG2klZA0kNWSRXSXwvao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2tqRBbqaAF85wrR91t3UxWrnoPhidK/v9ste8dhZ3PAlFROqgN0EcfBWlMGDmNGQoMk2trayGcg8XQF1G0vguRiHLyZbgkH9QM7ONmgk9nc0DqPYMR8XGFPYwhLvEACokseOLAYPyyizuu1W0aajbVIIllk0PlJO9fRxzfmHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEnL3TpY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEnL3TpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29CCAC4CEF5;
	Tue,  2 Sep 2025 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820469;
	bh=kw98HOM/SqDdClixjSLm8sgfG2klZA0kNWSRXSXwvao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEnL3TpY4GNXD1p+ewB8C0UoQ/rhzc+6hQgFSjavtkshjGDeNROinJ/0KKEExjOgr
	 J++FG0+A9tbo1cWm4fpdIL+6mKCp+AWZfMHd8v7CaIpNXgiUbI5KhoBDS8QK7hVBX+
	 Vs6wUJuafX/vJUCP2Pd9BgTDypuBEJCrgFJeHJ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+942297eecf7d2d61d1f1@syzkaller.appspotmail.com,
	Takamitsu Iwai <takamitz@amazon.co.jp>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 32/50] net: rose: include node references in rose_neigh refcount
Date: Tue,  2 Sep 2025 15:21:23 +0200
Message-ID: <20250902131931.796443126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 42460da0854d5..6acbb795c506d 100644
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



