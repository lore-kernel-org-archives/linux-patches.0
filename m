Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAEE2F2371;
	Tue, 17 Jun 2025 16:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176268; cv=none; b=A7sTq95mofHebqnF5Yb+N/CmnXpNtZ4IvdRX9aIOt755HnQm+F44AUpHEOP5AfsM9dEkcz/9EX1xUPksRdV+jk9nl89z4o6TPMyfLDcv4UfuygCltiLcq8Psmof0Zj+JubZrGwStEZeP7eJQRO4JXmUdMxQh35kmsPGrS8PTD4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176268; c=relaxed/simple;
	bh=YpTL3RNBnA5lAvblWv67rgAZtw7mlbB5W1YuKAyE9hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/FOP29sNglyhxPInq8IfVAAbsBxX6Q9E/gM7mOYAbPn+33RtWpGOQjVPELExEb+532BwgNqVdexBKvpHqq1EGS08sAM+dBAX4ZXJWyijjEMCS+IGXB+SHxpLxaeQFn9Ju4jGMSd0IgylG2wdLUlTzvLcsm4s0WK8OIKDAF5qTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrgxOTit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrgxOTit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31F9C4CEE3;
	Tue, 17 Jun 2025 16:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176268;
	bh=YpTL3RNBnA5lAvblWv67rgAZtw7mlbB5W1YuKAyE9hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrgxOTit1TmE5ecr6JDK6I3hEfh3+Ghr3asNdLGZdvQ3YosDGSsKEv7l28Qz4gsP/
	 XTyoV5z0JiTSEdfL1mSCpsgpRvSNAfRkKHHaU53rHaGhCo9AOZcSpbaiutrsRmI+Jy
	 XWTETk9zytqZyTxq85u8rZnrshyE3Fh87ioIRi50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/512] octeontx2-pf: QOS: Refactor TC_HTB_LEAF_DEL_LAST callback
Date: Tue, 17 Jun 2025 17:22:58 +0200
Message-ID: <20250617152428.220669573@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 35acc07bd9648..5765bac119f0e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -1638,6 +1638,7 @@ static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, bool force
 	if (!node->is_static)
 		dwrr_del_node = true;
 
+	WRITE_ONCE(node->qid, OTX2_QOS_QID_INNER);
 	/* destroy the leaf node */
 	otx2_qos_disable_sq(pfvf, qid);
 	otx2_qos_destroy_node(pfvf, node);
@@ -1682,9 +1683,6 @@ static int otx2_qos_leaf_del_last(struct otx2_nic *pfvf, u16 classid, bool force
 	}
 	kfree(new_cfg);
 
-	/* update tx_real_queues */
-	otx2_qos_update_tx_netdev_queues(pfvf);
-
 	return 0;
 }
 
-- 
2.39.5



