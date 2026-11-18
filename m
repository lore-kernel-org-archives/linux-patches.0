Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023145;
	b=yx0RDpqyJN7ayUMgogmu/0j7irXtCZNpV+QZbAnEkm4nqtaEyyLtPzpYV8GETCcIoyYf
	 V2b4zVEiokR5xGbVRFwO/rN1WLm0l9x7iXOqIoTA2nigZHFd+4/pF5tfWhAmUBMmRi+p5
	 3kbaxOtnHJiJS4i/f9uMdcI3K2wCA6RKI8yt4fwZA/tIXrXTbBBmZxsRFtKdWtv5tYmq2
	 E9gG3NYZjt/xPv0PzVw1joJcLsmoXF0Ve90NQItVnshApqkUdh6qlaMiI5NDUMbcT7pjj
	 307hL1nCx3lhZqowdC1sQFyWZ6l4Jrc7x6FRJ/i33NGCkPcbDQa2pq0BckskZflOT9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m+aXDHHydfjkXCN5H4JkdikbMjoctxxn61KBM5mKUW8=;
	b=TZyU9gD9T8AJ+gr6bUywM4I9iHpMYz18bdr2yQFWKpFRP4M6x+I6krg0stfRyLLgFuZT
	 uI4g7l/NwIlzSBiFTSC8BKUffxmCk07QzFHtIx/aP0F8mAuaaQjPGdLGLnw8b4pIbP5py
	 n0viMFLAM3zWSFL4F+mGKBYVgnlBnTEkm5QqJGmsM6XOzkNF5lvJCeBv70cG5SmZDQjQT
	 b910G4TMAMLkY7OtsIRk4O3488PC/GoV0yPzNAXUO28Xf0CZONsKbnAqHq+GfbCwRM/HT
	 F9pzRCIbqGMqENZwuMMTytbOawKZb/fkYkC2Ey7weFUwXzlZtEsQ7K+rD5Z+9dpI9ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+IMYNzY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9588606A32C;
	Wed, 18 Nov 2026 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U+IMYNzY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F981F000C4;
	Wed, 18 Nov 2026 17:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023145;
	bh=m+aXDHHydfjkXCN5H4JkdikbMjoctxxn61KBM5mKUW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+IMYNzY3VivWXVWTSrCZI00wZspc/8OuBr3Ol7rqQelqpYGDC6ifBUN4XK+chbXH
	 7yNzURablXrqssG+wMDGjiEsZqBGSU8CTWMWq24xJqHD85liBw8HS5Gp8lbftjftXf
	 mgqE3aWyhSrwIgCJz8Xud27qgpe21s24DSkVSmWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0265/2151] drivers/base/node: fix UAF on device_register() failure
Date: Wed, 18 Nov 2026 15:33:20 +0100
Message-ID: <20261118150131.462327406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 6d7e9bc51d8f2d73b3403c759c769f880082f9ae ]

node_init_node_access() frees the access node with kfree() if
device_register() fails. After device_register() the embedded device is
initialized and must be released with put_device() so that
node_access_release() can free it.

Fixes: 08d9dbe72b1f ("node: Link memory nodes to their compute nodes")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260907024732.1452228-1-gonglinkai@kylinos.cn
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 83aeb0518e1da..1a1139a953ced 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -167,20 +167,19 @@ static struct node_access_nodes *node_init_node_access(struct node *node,
 	dev->parent = &node->dev;
 	dev->release = node_access_release;
 	dev->groups = node_access_node_groups;
-	if (dev_set_name(dev, "access%u", access))
-		goto free;
+	if (dev_set_name(dev, "access%u", access)) {
+		kfree(access_node);
+		return NULL;
+	}
 
-	if (device_register(dev))
-		goto free_name;
+	if (device_register(dev)) {
+		put_device(dev);
+		return NULL;
+	}
 
 	pm_runtime_no_callbacks(dev);
 	list_add_tail(&access_node->list_node, &node->access_list);
 	return access_node;
-free_name:
-	kfree_const(dev->kobj.name);
-free:
-	kfree(access_node);
-	return NULL;
 }
 
 #ifdef CONFIG_HMEM_REPORTING
-- 
2.53.0



