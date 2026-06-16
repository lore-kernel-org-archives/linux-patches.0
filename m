Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F43043C8;
	Tue, 16 Jun 2026 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632589; cv=none; b=KOsYQJqB2dJUKihJUfel3bXwEW4NsxxAfS3KNvWF8jkMhNO7Qlv/i08I+mf9A8VDYNRfL5BZOXnTWIY4v/ElYjezFBBegA1IJfZYwJDrDf3SiHtTxTzTn+VMJ5ZrGF0LU3+OitdGCpKdW7RH3CruSrl3MtfmXc99I4X1bZxeYoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632589; c=relaxed/simple;
	bh=3/afSunTpEHLDU15gmxGSA4G4ROIPXrhNQqgLBvsaoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUwXM/ChgXqr3Aelx8oa8LWg+nFLM+oM/qs00zSM0d6XHLqLz3Syc0dyqwKxL0cpXyEBKhU1Wi+W+5lvkBaM60gXc/LGV3eNBjqPTTcQLTupKc2FkAXOHg+nMKrm3kP5YjLFhpykEG9fjmOBu+duArfXyIUCtHH5tTXtZ9vOo7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1r2LN+F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1r2LN+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C6F1F000E9;
	Tue, 16 Jun 2026 17:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632587;
	bh=5SV2sqebCVJZSpWiLBlM32jWYg6/JDFMUG/uF8hEmWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1r2LN+FIVzLkzgHGOVZoZyPNnncqw3KJa0n2YXkkbT/FYCUdoE7VB0VTEMofFIDn
	 bbZ6CLHVfoqeojONsRZmbtBDCsdIkJ9Xb6oHJKnhA9qh7et/toChUlH6MaqmeNx7u8
	 xON3Uo0XNtzejQGLhPlig6OjFEnPC76rQ/Jotp1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/522] net: hsr: defer node table free until after RCU readers
Date: Tue, 16 Jun 2026 20:29:45 +0530
Message-ID: <20260616145146.443216927@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit aaec7096f9961eb223b5b149abe9495525c205d9 ]

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
[ replaced `list_del`+`call_rcu(hsr_free_node_rcu)` with `list_del_rcu`+`kfree_rcu(node, rcu_head)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_framereg.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -121,8 +121,10 @@ void hsr_del_nodes(struct list_head *nod
 	struct hsr_node *node;
 	struct hsr_node *tmp;
 
-	list_for_each_entry_safe(node, tmp, node_db, mac_list)
-		kfree(node);
+	list_for_each_entry_safe(node, tmp, node_db, mac_list) {
+		list_del_rcu(&node->mac_list);
+		kfree_rcu(node, rcu_head);
+	}
 }
 
 void prp_handle_san_frame(bool san, enum hsr_port_type port,


