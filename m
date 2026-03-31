Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26F640710B;
	Tue, 31 Mar 2026 16:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975166; cv=none; b=WgqV2dqN/BFgOFNhdEpGDvg4sMEorKG/D2aaVgPQUeDxXUfI34ZM8/95f6dFEsI+Iy4nw2fajAQHIYeRzyjMulhre/qFePVW8BWWOiStt5J4yvk9Npj3HhmJKTaQlwqPaaMpduZ2MyxbLX2MpV0xstXxTrXC010dptvgWFya0To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975166; c=relaxed/simple;
	bh=ewcXxxzb3K/wqUzwc0JVAy+czjeT78aW24XOByKM1m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTCS3uke/mw1ECGpcwU5G1fG0Tt4JnhSr0c5qq1VhJu9mJ3A4TEzUs6/BsYPv5AIpNMxM+uv+s7xFe3kVvM7bqZOSZoou0bkvyNeX9itul0knTidpBbKRNsXJ+LqPdz28RnBGmbNHLxg/U/mTHQXbxzxgj5NjzNMTFjqhrQ/s2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neLssQvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neLssQvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5952CC19423;
	Tue, 31 Mar 2026 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975166;
	bh=ewcXxxzb3K/wqUzwc0JVAy+czjeT78aW24XOByKM1m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neLssQvDzRR8/KHU0ooX/SZe2EfgKjSlWRM8O1UDtBx4Ww3kyl+/Wng2Mr5kBXh4m
	 3t0XAI8+bj4yth6LOV7H1RbLF0W1K578PhlKUgIwXMI1VbbXh2xMSKB6DVIaO/H/q3
	 syDGLOwSPrXptq8VtvlAhR5FAJBOVpEv+pZJfk0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 162/342] RDMA/irdma: Return EINVAL for invalid arp index error
Date: Tue, 31 Mar 2026 18:19:55 +0200
Message-ID: <20260331161804.972482031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 128cfcf27714d..d14a381beb661 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -2241,11 +2241,12 @@ irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
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
@@ -2348,8 +2349,10 @@ irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
 			arpindex = -EINVAL;
 	}
 
-	if (arpindex < 0)
+	if (arpindex < 0) {
+		ret = -EINVAL;
 		goto err;
+	}
 
 	ether_addr_copy(cm_node->rem_mac,
 			iwdev->rf->arp_table[arpindex].mac_addr);
@@ -2360,7 +2363,7 @@ irdma_make_cm_node(struct irdma_cm_core *cm_core, struct irdma_device *iwdev,
 err:
 	kfree(cm_node);
 
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 static void irdma_destroy_connection(struct irdma_cm_node *cm_node)
@@ -3021,8 +3024,8 @@ static int irdma_create_cm_node(struct irdma_cm_core *cm_core,
 
 	/* create a CM connection node */
 	cm_node = irdma_make_cm_node(cm_core, iwdev, cm_info, NULL);
-	if (!cm_node)
-		return -ENOMEM;
+	if (IS_ERR(cm_node))
+		return PTR_ERR(cm_node);
 
 	/* set our node side to client (active) side */
 	cm_node->tcp_cntxt.client = 1;
@@ -3219,9 +3222,9 @@ void irdma_receive_ilq(struct irdma_sc_vsi *vsi, struct irdma_puda_buf *rbuf)
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



