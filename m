Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497811E485;
	Tue,  8 Oct 2024 12:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390737; cv=none; b=oo3zTmwDOO0hOw/vCQg6zhr5Nht8ynKZH9RncS5DBr4ROjp3IJwu1aybc6iu3gNT4WwPe0AoG8DM2r/B08xrEaBiN6ZKSUSlHzbxq03yPIpfmzC+Q448Y5CJtHH6mY8fMztQJHrbelVho6Tai+p3fLmMR5jUjQ6vf0VMtgrBFxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390737; c=relaxed/simple;
	bh=hBD7rkl2FzGDJYFLNMvBmpw7LuIIOyQ8r7W1I/1ZKZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBQPwsfaUNNYyNUingc+HfzIF0rBMnLLVfTn09Ns2y2bhGXwWg/mY5Zu/CAeX+7OfkDrVeAvZDDTr6DeifumIH6fRo8Jn1J2KgnjSq9MdwPP1xhc1sw/vRoiMmaRPd9Oz5B7o8hbbEWyV9fzSEYaRTjdhBjHh/91cm5LRidZeR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xzuz+4vG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xzuz+4vG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5766C4CEC7;
	Tue,  8 Oct 2024 12:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390737;
	bh=hBD7rkl2FzGDJYFLNMvBmpw7LuIIOyQ8r7W1I/1ZKZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xzuz+4vGB+sURg3EzCVnfMpy/TFwuQL6TgZOR1MQKvnF7T0c5LuNqdvrGSxVaaBJM
	 ZRFj50d19lqM01H0S//OqtWvDWt9KJoQ71yZVaXgvTmgyQ7LKPHyRuzSbefQJtnTC8
	 n0FGzFgF7H8jaOc3N+yAnmFL0q4uCuKThwQzXhss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 360/482] scripts/gdb: add iteration function for rbtree
Date: Tue,  8 Oct 2024 14:07:03 +0200
Message-ID: <20241008115702.589707243@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Ying Lee <kuan-ying.lee@canonical.com>

commit 0c77e103c45fa1b119f5d3bb4625eee081c1a6cf upstream.

Add inorder iteration function for rbtree usage.

This is a preparation patch for the next patch to fix the gdb mounts
issue.

Link: https://lkml.kernel.org/r/20240723064902.124154-3-kuan-ying.lee@canonical.com
Fixes: 2eea9ce4310d ("mounts: keep list of mounts in an rbtree")
Signed-off-by: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gdb/linux/rbtree.py | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/gdb/linux/rbtree.py b/scripts/gdb/linux/rbtree.py
index fe462855eefd..fcbcc5f4153c 100644
--- a/scripts/gdb/linux/rbtree.py
+++ b/scripts/gdb/linux/rbtree.py
@@ -9,6 +9,18 @@ from linux import utils
 rb_root_type = utils.CachedType("struct rb_root")
 rb_node_type = utils.CachedType("struct rb_node")
 
+def rb_inorder_for_each(root):
+    def inorder(node):
+        if node:
+            yield from inorder(node['rb_left'])
+            yield node
+            yield from inorder(node['rb_right'])
+
+    yield from inorder(root['rb_node'])
+
+def rb_inorder_for_each_entry(root, gdbtype, member):
+    for node in rb_inorder_for_each(root):
+        yield utils.container_of(node, gdbtype, member)
 
 def rb_first(root):
     if root.type == rb_root_type.get_type():
-- 
2.46.2



