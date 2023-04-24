Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DBD87C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5376C433D2;
	Mon, 24 Apr 2023 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342793;
	bh=VSVe3wCuYswIOk7rHrXb0nQdR5rTlsfIH0YCLcwz5kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inFp/VDkeCEkNp/MqYLHF97SFkwqb9ctdhLz0zZv5bKsVIGPJ8FazjA5jGMidweoE
	 lVYkGBwy5bsJe8F1HurSxD8KaI/Y7vGRZTbocNjErMwKJMPHJvICzqKLEAdqMqI50w
	 fvqhHg06IEYmDhAWOeZ2wjX/9GlvnYslPA4EZ1q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Zhang <zhangpeng.00@bytedance.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 60/98] maple_tree: fix a potential memory leak, OOB access, or other unpredictable bug
Date: Mon, 24 Apr 2023 15:17:23 +0200
Message-Id: <20230424131136.191537070@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Zhang <zhangpeng.00@bytedance.com>

commit 1f5f12ece722aacea1769fb644f27790ede339dc upstream.

In mas_alloc_nodes(), "node->node_count = 0" means to initialize the
node_count field of the new node, but the node may not be a new node.  It
may be a node that existed before and node_count has a value, setting it
to 0 will cause a memory leak.  At this time, mas->alloc->total will be
greater than the actual number of nodes in the linked list, which may
cause many other errors.  For example, out-of-bounds access in
mas_pop_node(), and mas_pop_node() may return addresses that should not be
used.  Fix it by initializing node_count only for new nodes.

Also, by the way, an if-else statement was removed to simplify the code.

Link: https://lkml.kernel.org/r/20230411041005.26205-1-zhangpeng.00@bytedance.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/maple_tree.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1293,26 +1293,21 @@ static inline void mas_alloc_nodes(struc
 	node = mas->alloc;
 	node->request_count = 0;
 	while (requested) {
-		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->node_count) {
-			unsigned int offset = node->node_count;
-
-			slots = (void **)&node->slot[offset];
-			max_req -= offset;
-		} else {
-			slots = (void **)&node->slot;
-		}
-
+		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
+		slots = (void **)&node->slot[node->node_count];
 		max_req = min(requested, max_req);
 		count = mt_alloc_bulk(gfp, max_req, slots);
 		if (!count)
 			goto nomem_bulk;
 
+		if (node->node_count == 0) {
+			node->slot[0]->node_count = 0;
+			node->slot[0]->request_count = 0;
+		}
+
 		node->node_count += count;
 		allocated += count;
 		node = node->slot[0];
-		node->node_count = 0;
-		node->request_count = 0;
 		requested -= count;
 	}
 	mas->alloc->total = allocated;


