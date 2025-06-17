Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511222ECEA8;
	Tue, 17 Jun 2025 15:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175185; cv=none; b=Ki7ITUzBJ7tbUAU1YywEgv07QhzMuKviIiQJwnFKxJHqt+4VVHTuVBAFUku0NpC+CJsRgf+mKyu5aU19pmNh6t5ZlBs6JlPDq3ht9FB33Vtvu9a27F6FwysT/ZBJsFL/RHZOzeSAVErrngDmLTTvJci0R9WvOyvOxMk8CsLKvqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175185; c=relaxed/simple;
	bh=u6NdcmKp29GHEJYFd/PZF2wOXOc6cWRj2cdzc1xzNmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RycDyyF/4xkeLl5FTfE5qbHmHuKHYLY4iG/s6Vl1nfQbrvBrsej1/AaU+JqWd9sHGdOAFCWL/vus1cJmqiUwPjRWfHxFEgZ0nngvw3Y/0Xpl5z7dUvprbcgHjKMb84ziXeMTrAN15ZFhZVT8HoK8rcTiK79JqKtIOxXaStx2uiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JejlLfSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JejlLfSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD28EC4CEE7;
	Tue, 17 Jun 2025 15:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175185;
	bh=u6NdcmKp29GHEJYFd/PZF2wOXOc6cWRj2cdzc1xzNmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JejlLfSc6fUHqzMyh8ITEL0nu3a6HBXwHXG5oj4njNSnd5i2r5HtwAFAKHe/Vuc+l
	 5a2U1zF+RMp30wEfohiKrC9Zm3L74q4Xrp3oPjZ43jVuXd5Y7HURlYCanY5iFJWkrY
	 azMTdrre8j6+pL4bGcMw1g7OQ3MFNSbmKYuK0RfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/356] octeontx2-pf: QOS: Refactor TC_HTB_LEAF_DEL_LAST callback
Date: Tue, 17 Jun 2025 17:24:26 +0200
Message-ID: <20250617152344.311082253@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 67af4ec948e8ce3ea53a9cf614d01fddf172e56d ]

This patch addresses below issues,

1. Active traffic on the leaf node must be stopped before its send queue
   is reassigned to the parent. This patch resolves the issue by marking
   the node as 'Inner'.

2. During a system reboot, the interface receives TC_HTB_LEAF_DEL
   and TC_HTB_LEAF_DEL_LAST callbacks to delete its HTB queues.
   In the case of TC_HTB_LEAF_DEL_LAST, although the same send queue
   is reassigned to the parent, the current logic still attempts to update
   the real number of queues, leadning to below warnings

        New queues can't be registered after device unregistration.
        WARNING: CPU: 0 PID: 6475 at net/core/net-sysfs.c:1714
        netdev_queue_update_kobjects+0x1e4/0x200

Fixes: 5e6808b4c68d ("octeontx2-pf: Add support for HTB offload")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250522115842.1499666-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 37db19584c143..92861f102590f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -1560,6 +1560,7 @@ static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, bool force
 	if (!node->is_static)
 		dwrr_del_node = true;
 
+	WRITE_ONCE(node->qid, OTX2_QOS_QID_INNER);
 	/* destroy the leaf node */
 	otx2_qos_disable_sq(pfvf, qid);
 	otx2_qos_destroy_node(pfvf, node);
@@ -1604,9 +1605,6 @@ static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, bool force
 	}
 	kfree(new_cfg);
 
-	/* update tx_real_queues */
-	otx2_qos_update_tx_netdev_queues(pfvf);
-
 	return 0;
 }
 
-- 
2.39.5



