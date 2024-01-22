Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815AF133435;
	Tue, 23 Jan 2024 01:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971887; cv=none; b=Ha9zGyVbDr5XGm1L5qx9ipI97S4eXm4cu6mq9Mb2Sm2inkOdG0CeQAXjHNcyJ47EGtDgyX5kGlB+E3Hxvg8yWobZhtaqVqgn9iJxLOysxRrcqPdB24Gwu4qw4lCUlNAx/yLtfgoBWNDE8CSKPJVdAcgZuuHF8JqIldvlXCRMzak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971887; c=relaxed/simple;
	bh=9GrjlRiWWpiQJMgTwDV76Ocd8Iv1pxOY8jRyQAVPjLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T51qEHz73ovo8CC3Cq3Y/tUcSPBHjp9CqIwbcWSWl+NMxim/8OZYlADhoAzwsZg+PqyMxLOBM+iMYMTG4kRpY/HSWeOiDC/QTGiqwqzD/ePbx5eSEo0VJyVU7LKX4oQWpdoaKGXdz8gARVyMEvVqQu4G0b5vpdIKsijIJoGcLfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1vhuZJK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1vhuZJK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20129C433F1;
	Tue, 23 Jan 2024 01:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971887;
	bh=9GrjlRiWWpiQJMgTwDV76Ocd8Iv1pxOY8jRyQAVPjLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1vhuZJKPdqYAOwhaUKNAXTv4nJCa2i2zFnwen1WVXTcEkuE0VzyokzRINk1bLYqT
	 sfQgRQHi/5Bhe57sqSPiJRGXqGNArYwbuhM0i6pQqndT5DkTT0gjS+fmQERE6b1Q2Q
	 R55y4jn8rcXhV/fAHvYuUk5mbbC7NEb+1RIIW8/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gregory.price@memverge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 342/417] base/node.c: initialize the accessor list before registering
Date: Mon, 22 Jan 2024 15:58:30 -0800
Message-ID: <20240122235803.642421722@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price <gourry.memverge@gmail.com>

[ Upstream commit 48b5928e18dc27e05cab3dc4c78cd8a15baaf1e5 ]

The current code registers the node as available in the node array
before initializing the accessor list.  This makes it so that
anything which might access the accessor list as a result of
allocations will cause an undefined memory access.

In one example, an extension to access hmat data during interleave
caused this undefined access as a result of a bulk allocation
that occurs during node initialization but before the accessor
list is initialized.

Initialize the accessor list before making the node generally
available to the global system.

Fixes: 08d9dbe72b1f ("node: Link memory nodes to their compute nodes")
Signed-off-by: Gregory Price <gregory.price@memverge.com>
Link: https://lore.kernel.org/r/20231030044239.971756-1-gregory.price@memverge.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index faf3597a96da..a4141b57b147 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -859,11 +859,15 @@ int __register_one_node(int nid)
 {
 	int error;
 	int cpu;
+	struct node *node;
 
-	node_devices[nid] = kzalloc(sizeof(struct node), GFP_KERNEL);
-	if (!node_devices[nid])
+	node = kzalloc(sizeof(struct node), GFP_KERNEL);
+	if (!node)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&node->access_list);
+	node_devices[nid] = node;
+
 	error = register_node(node_devices[nid], nid);
 
 	/* link cpu under this node */
@@ -872,7 +876,6 @@ int __register_one_node(int nid)
 			register_cpu_under_node(cpu, nid);
 	}
 
-	INIT_LIST_HEAD(&node_devices[nid]->access_list);
 	node_init_caches(nid);
 
 	return error;
-- 
2.43.0



