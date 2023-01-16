Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390006FA3
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB50C433F2;
	Mon, 16 Jan 2023 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886982;
	bh=3kxkkP2sI8X+p+wWn5He7TTs4Cdki1DVWwPMBK0W8KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i1ICBx7LfSy0C6F/2zaadBEGyzLwZpkFr/yxNZRu2mRBRAadU0fkVgXU2IMH95eN3
	 jPEtR4oq24AiMsfepYElVnEv8T/JrnPRj4ZkUa0x4fNYh5AmGUB6irerMD99DcQH5Z
	 VuWfnJvqMF9g/9zPhLiVU1n3ghL4b+SZ/1SOnJbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Maloy <jon.maloy@ericsson.com>,
	Hoang Le <hoang.h.le@dektech.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 635/658] tipc: eliminate checking netns if node established
Date: Mon, 16 Jan 2023 16:52:03 +0100
Message-Id: <20230116154938.538566611@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit d408bef4bfa60bac665b6e7239269570039a968b ]

Currently, we scan over all network namespaces at each received
discovery message in order to check if the sending peer might be
present in a host local namespaces.

This is unnecessary since we can assume that a peer will not change its
location during an established session.

We now improve the condition for this testing so that we don't perform
any redundant scans.

Fixes: f73b12812a3d ("tipc: improve throughput between nodes in netns")
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c244c092f1ed ("tipc: fix unexpected link reset due to discovery messages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/node.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 3136e2a777fd..81fe8d051ba4 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -472,10 +472,6 @@ static struct tipc_node *tipc_node_create(struct net *net, u32 addr,
 				 tipc_bc_sndlink(net),
 				 &n->bc_entry.link)) {
 		pr_warn("Broadcast rcv link creation failed, no memory\n");
-		if (n->peer_net) {
-			n->peer_net = NULL;
-			n->peer_hash_mix = 0;
-		}
 		kfree(n);
 		n = NULL;
 		goto exit;
@@ -1068,6 +1064,9 @@ void tipc_node_check_dest(struct net *net, u32 addr,
 	if (sign_match && addr_match && link_up) {
 		/* All is fine. Do nothing. */
 		reset = false;
+		/* Peer node is not a container/local namespace */
+		if (!n->peer_hash_mix)
+			n->peer_hash_mix = hash_mixes;
 	} else if (sign_match && addr_match && !link_up) {
 		/* Respond. The link will come up in due time */
 		*respond = true;
@@ -1393,11 +1392,8 @@ static void node_lost_contact(struct tipc_node *n,
 
 	/* Notify publications from this node */
 	n->action_flags |= TIPC_NOTIFY_NODE_DOWN;
-
-	if (n->peer_net) {
-		n->peer_net = NULL;
-		n->peer_hash_mix = 0;
-	}
+	n->peer_net = NULL;
+	n->peer_hash_mix = 0;
 	/* Notify sockets connected to node */
 	list_for_each_entry_safe(conn, safe, conns, list) {
 		skb = tipc_msg_create(TIPC_CRITICAL_IMPORTANCE, TIPC_CONN_MSG,
-- 
2.35.1



