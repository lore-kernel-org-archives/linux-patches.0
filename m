Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B94132BF5A;
	Thu, 28 May 2026 19:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998097; cv=none; b=bRzFgbLhGP2AuWrpK9hJhrOhIJBr/AR4n+1x+IHE9upwEZWHqGEqhJdOaiMSFROO57D7vVELf8yCR9sLxPsU0ZPjewtLzErbRrCX3IBAdaFVa6igIIC5JdONCJXAmH6j2D8W7+BG4kUTPNeXAhmZD9+RJRKnKt1UUwJlzzFG/go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998097; c=relaxed/simple;
	bh=T51HgvWcr5FriukbdEuBvpTZQAutBdkmka2vfyPLgH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaUG/Qbg0oF71bjdH85IQgf49wAA2q0YPKs7gY1yzdhkIJjV7i7aROEldpbAgDetsYfNE57ADQYZO+a+oVM9B3wB/NjDIR588Ie11fGJ5mSNLbumm5/ArXasfvDvtczCjYVpMX0ax967UDXzXMU4K7BM77wRC7tsN+hmArlHsLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1DYWszS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1DYWszS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062351F000E9;
	Thu, 28 May 2026 19:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998096;
	bh=mNBt7CvuQnrIToCmZxcUNXIxw6VN//rIhMo0InpeyHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1DYWszSvAOHks6wUaTfMaRtZGlUxQL4eFygHxpae5db46Zj0ohics2VPp9O27GCv
	 Tg+ykIGcY/ZgnjhV1oTiobzQ9kqW/LVINlGawor65s9vO8XW1IoaOOjtHMF997L7Qs
	 /L9vArImKusuUW2QmShCMYgL6nLmnCNVDYCNk0Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 053/461] net: hsr: defer node table free until after RCU readers
Date: Thu, 28 May 2026 21:43:02 +0200
Message-ID: <20260528194648.443931901@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit aaec7096f9961eb223b5b149abe9495525c205d9 upstream.

HSR node-list and node-status generic-netlink operations run under
rcu_read_lock(). They walk hsr->node_db through hsr_get_next_node() and
hsr_get_node_data(), but RTM_DELLINK teardown removes the same node table
with plain list_del() and frees each node immediately.

That lets a generic-netlink reader hold a struct hsr_node pointer across
hsr_dellink(). In a KASAN build, widening the reader window after
hsr_get_next_node() obtains the node reproduces a slab-use-after-free
when the reader copies node->macaddress_A; the freeing stack is
hsr_del_nodes() from hsr_dellink().

Use list_del_rcu() and defer the free through the existing
hsr_free_node_rcu() callback. This matches the lifetime rule used by the
HSR prune paths, which already delete nodes with list_del_rcu() and
call_rcu().

Fixes: b9a1e627405d ("hsr: implement dellink to clean up resources")
Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260513233838.3064715-2-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_framereg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -163,8 +163,8 @@ void hsr_del_nodes(struct list_head *nod
 	struct hsr_node *tmp;
 
 	list_for_each_entry_safe(node, tmp, node_db, mac_list) {
-		list_del(&node->mac_list);
-		hsr_free_node(node);
+		list_del_rcu(&node->mac_list);
+		call_rcu(&node->rcu_head, hsr_free_node_rcu);
 	}
 }
 


