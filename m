Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C69277636;
	Tue, 23 Jan 2024 02:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975543; cv=none; b=T5af4hFv2l3efN8YtvuwBQVlo38monUKk/yKHhIR4hDvVHqBXrN0S8TSkUHpMkV6DvBonAxfV61N1Tj1C70ZRmtbjoOML4rWRJySASBvbY26Du3LuvybjCRS0pn82F/RBMNRGA8yZkivd04t0hUsQRwjQG3GOO2HJDb69azB6g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975543; c=relaxed/simple;
	bh=dXF0GNEGTdyE8O8M1jSSzui8TwY41Mo3uhGh4XDdBAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmAI3GqgbuuPVvqEdXCV+xRztnDnx5RbQ3pLYuxEtrOnXpN6CKlguBSfNEG+1lN90i8hEQk4S5GFCc6049FsxCifTI8tbBca6OoiR8WWGk43o84sx5Q00HUoE3RM71rE6nl8D5j19aJI88fXlpDsDd27cC3hOkVOlXLkaBI3m8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vy4SO4O/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vy4SO4O/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBB2C433C7;
	Tue, 23 Jan 2024 02:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975542;
	bh=dXF0GNEGTdyE8O8M1jSSzui8TwY41Mo3uhGh4XDdBAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vy4SO4O/sy5MXxbExX7UKRMyksVP8NPzBIijmMUSRiZFLh4A16zD3S2/zv8iJM/EU
	 nn/qp7UXeAXtD67cCg3ximAlJHTHMsEUy+NkiM4GL1tj/3Tq3RCb35jlpohZNaHNHy
	 AgppBa/jKqK7OZPbIL2oht8QWQt2EsrMIJIuviTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregory Price <gregory.price@memverge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 471/583] base/node.c: initialize the accessor list before registering
Date: Mon, 22 Jan 2024 15:58:42 -0800
Message-ID: <20240122235826.399625393@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 493d533f8375..4d588f4658c8 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -868,11 +868,15 @@ int __register_one_node(int nid)
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
@@ -881,7 +885,6 @@ int __register_one_node(int nid)
 			register_cpu_under_node(cpu, nid);
 	}
 
-	INIT_LIST_HEAD(&node_devices[nid]->access_list);
 	node_init_caches(nid);
 
 	return error;
-- 
2.43.0



