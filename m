Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7473D34A336;
	Tue, 26 Aug 2025 13:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214559; cv=none; b=j6TSFP6NvMw0A7BQcqug/wMGzbds4RkxY2xnI7wO0tQtLymvSFyqC40d6zUfR8PXCh0iZLIYrlDFk06P7mPwHZjSZiHqejmbkQ+QeUUL4W2+oFx377VXhgkqflFKoRbKvVqAdP5KxSoFpPUGML+UiMtOTOvu45y2HuvJeL3wSkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214559; c=relaxed/simple;
	bh=txjcL6GgXemDNY2BAURbtxqFBDW7vpuWgN/+Ua8PjTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJuSETA1eznRKGdddRpM/2lAZUmmuiEWbEWMznIibuXqicNGVJPkgjZ3q6B/5a4H+NXeg4NzSZpTKbgjxdBapyEiWAh8WBrI9bfbZKQk5Wpxs62n4G1FW2MDOKNeeD4ilVotyf0dQ6SnK0g4pvsyO+fddgRadASuunR9EwptFbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9iJ0e5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9iJ0e5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 069C3C4CEF1;
	Tue, 26 Aug 2025 13:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214559;
	bh=txjcL6GgXemDNY2BAURbtxqFBDW7vpuWgN/+Ua8PjTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R9iJ0e5v7mnvZw5i2W3fIyaYq6ZFrIceHz7nGE1KQxq7m4Qc8xrF0GmGPIGuobBNP
	 dcbgkNKU3aRjYRXcknPdgTHz9dDywYHjq7LSMyhcQFUK6/PYTeYqjJug0dUu+msud0
	 91u5y91rdXmjtNvWM/2JQRQVDhNNbgNVIGIBDm64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Escande <nico.escande@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/482] neighbour: add support for NUD_PERMANENT proxy entries
Date: Tue, 26 Aug 2025 13:06:46 +0200
Message-ID: <20250826110934.594921049@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

From: Nicolas Escande <nico.escande@gmail.com>

[ Upstream commit c7d78566bbd30544a0618a6ffbc97bc0ddac7035 ]

As discussesd before in [0] proxy entries (which are more configuration
than runtime data) should stay when the link (carrier) goes does down.
This is what happens for regular neighbour entries.

So lets fix this by:
  - storing in proxy entries the fact that it was added as NUD_PERMANENT
  - not removing NUD_PERMANENT proxy entries when the carrier goes down
    (same as how it's done in neigh_flush_dev() for regular neigh entries)

[0]: https://lore.kernel.org/netdev/c584ef7e-6897-01f3-5b80-12b53f7b4bf4@kernel.org/

Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250617141334.3724863-1-nico.escande@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/neighbour.h |  1 +
 net/core/neighbour.c    | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index ccc4a0f8b4ad..93aecfaa7628 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -180,6 +180,7 @@ struct pneigh_entry {
 	netdevice_tracker	dev_tracker;
 	u32			flags;
 	u8			protocol;
+	bool			permanent;
 	u32			key[];
 };
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index bcc3950638b9..92dc1f1788de 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -55,7 +55,8 @@ static void __neigh_notify(struct neighbour *n, int type, int flags,
 			   u32 pid);
 static void neigh_update_notify(struct neighbour *neigh, u32 nlmsg_pid);
 static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
-				    struct net_device *dev);
+				    struct net_device *dev,
+				    bool skip_perm);
 
 #ifdef CONFIG_PROC_FS
 static const struct seq_operations neigh_stat_seq_ops;
@@ -444,7 +445,7 @@ static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
 {
 	write_lock_bh(&tbl->lock);
 	neigh_flush_dev(tbl, dev, skip_perm);
-	pneigh_ifdown_and_unlock(tbl, dev);
+	pneigh_ifdown_and_unlock(tbl, dev, skip_perm);
 	pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
 			   tbl->family);
 	if (skb_queue_empty_lockless(&tbl->proxy_queue))
@@ -845,7 +846,8 @@ int pneigh_delete(struct neigh_table *tbl, struct net *net, const void *pkey,
 }
 
 static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
-				    struct net_device *dev)
+				    struct net_device *dev,
+				    bool skip_perm)
 {
 	struct pneigh_entry *n, **np, *freelist = NULL;
 	u32 h;
@@ -853,12 +855,15 @@ static int pneigh_ifdown_and_unlock(struct neigh_table *tbl,
 	for (h = 0; h <= PNEIGH_HASHMASK; h++) {
 		np = &tbl->phash_buckets[h];
 		while ((n = *np) != NULL) {
+			if (skip_perm && n->permanent)
+				goto skip;
 			if (!dev || n->dev == dev) {
 				*np = n->next;
 				n->next = freelist;
 				freelist = n;
 				continue;
 			}
+skip:
 			np = &n->next;
 		}
 	}
@@ -2023,6 +2028,7 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 		pn = pneigh_lookup(tbl, net, dst, dev, 1);
 		if (pn) {
 			pn->flags = ndm_flags;
+			pn->permanent = !!(ndm->ndm_state & NUD_PERMANENT);
 			if (protocol)
 				pn->protocol = protocol;
 			err = 0;
-- 
2.39.5



