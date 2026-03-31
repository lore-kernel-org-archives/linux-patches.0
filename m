Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40284410D00;
	Tue, 31 Mar 2026 16:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974431; cv=none; b=F7OE5Qy0nJ2d4aRIgQ7rCtOMFV+SV4rbMdMHP/OXWJguKAR/LIBNwZa6LntUBTEWskn6VvoCUOwlup7nw1DirrrFW/UCCrN5j2zpMAki/oncgeQCiaRZ+PrUZeDGJzGqwKscBYs7zgJIWQF0Oyq/DjJfisM0u3B8W0gydrdqzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974431; c=relaxed/simple;
	bh=SYpxNVNRHX2Zeia6vFfEPP8r2+ix8sOkEPJJzKBEFDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktWa943wAeL3EixXwSlGySu9JIV40C3dQsEa0DrlPqNztF57sy3PxHaC3tWxPjmPHPOZ5+wbMLCv6oPi40USsj4//E4DoP3aXEq706JdDA4m2dm5nGOa425vOgnW15GSDx/K8nIb4ePFmKYdIURqvcWrVy+b3kUnSU1vlQcCMBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxF97rNs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxF97rNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBE1C19423;
	Tue, 31 Mar 2026 16:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974431;
	bh=SYpxNVNRHX2Zeia6vFfEPP8r2+ix8sOkEPJJzKBEFDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxF97rNs9OL18luUwv7s2K/BjHgB1VVMXZgyue0tlejA03fxoZo+T/+yHR3klHaMJ
	 xmQCPhmMBtxJ/IrhmGQ1K4sY8EjpflSOvuIdiBoQeMjmp6ZPRy7hANxIiPlHvyDq8o
	 lcXqJnRPc3FUOp/cJBEw8PtP6mDh4W16AC2lL0jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/175] RDMA/irdma: Return EINVAL for invalid arp index error
Date: Tue, 31 Mar 2026 18:21:07 +0200
Message-ID: <20260331161732.822573552@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit 7221f581eefa79ead06e171044f393fb7ee22f87 ]

When rdma_connect() fails due to an invalid arp index, user space rdma core
reports ENOMEM which is confusing. Modify irdma_make_cm_node() to return the
correct error code.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index 00e63a46a50ee..122b4cffc8dc7 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -2239,11 +2239,12 @@ irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
 	int oldarpindex;
 	int arpindex;
 	struct net_device *netdev = iwdev->netdev;
+	int ret;
 
 	/* create an hte and cm_node for this instance */
 	cm_node = kzalloc(sizeof(*cm_node), GFP_ATOMIC);
 	if (!cm_node)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/* set our node specific transport info */
 	cm_node->ipv4 = cm_info->ipv4;
@@ -2346,8 +2347,10 @@ irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
 			arpindex = -EINVAL;
 	}
 
-	if (arpindex < 0)
+	if (arpindex < 0) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	ether_addr_copy(cm_node->rem_mac,
 			iwdev->rf->arp_table[arpindex].mac_addr);
@@ -2358,7 +2361,7 @@ irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
 err:
 	kfree(cm_node);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static void irdma_destroy_connection(struct irdma_cm_node *cm_node)
@@ -3019,8 +3022,8 @@ static int irdma_create_cm_node(struct irdma_cm_core *cm_core,
 
 	/* create a CM connection node */
 	cm_node = irdma_make_cm_node(cm_core, iwdev, cm_info, NULL);
-	if (!cm_node)
-		return -ENOMEM;
+	if (IS_ERR(cm_node))
+		return PTR_ERR(cm_node);
 
 	/* set our node side to client (active) side */
 	cm_node->tcp_cntxt.client = 1;
@@ -3217,9 +3220,9 @@ void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf)
 		cm_info.cm_id = listener->cm_id;
 		cm_node = irdma_make_cm_node(cm_core, iwdev, &cm_info,
 					     listener);
-		if (!cm_node) {
+		if (IS_ERR(cm_node)) {
 			ibdev_dbg(&cm_core->iwdev->ibdev,
-				  "CM: allocate node failed\n");
+				  "CM: allocate node failed ret=%ld\n", PTR_ERR(cm_node));
 			refcount_dec(&listener->refcnt);
 			return;
 		}
-- 
2.53.0



