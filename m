Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AE32472B6;
	Mon, 13 Apr 2026 16:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097984; cv=none; b=AXG5rZUPjpKUdhBOvew1e5gSa/3yZDIXXlA+W/QG9JjGUz+9UwIoSVHaOFqDQdYon1PleL3pAT/p3M8/W+vvj45LbwPnYU7e5dxqZ12Qyz4YIRCn9EhZfl7XlLd1VTG1LKfgElaylFYQclvl+mlnT34cDaxy7mx1SDZaQ6lj1FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097984; c=relaxed/simple;
	bh=JslFtTdg6BPttSqIHAJSOpkdYUOt92ZvVb7rCwUKMSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYS3ohg38IQojXYObYVNPvOEEwWooqNq8FJrBoxmWZctCFoovLMweI3wneUW4pVJDJ3BWytTtzRq/Ee3IwqPhISusgz0QM0EpCSZSLC2u/+z41hehycm5IZFgHIbM0egFq6qXXLGgkhx/dlJzOBKmG2AaPuys+7w83B4X1IP6v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUPmDi8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUPmDi8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84662C2BCAF;
	Mon, 13 Apr 2026 16:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097983;
	bh=JslFtTdg6BPttSqIHAJSOpkdYUOt92ZvVb7rCwUKMSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUPmDi8NZbMw7lrOk4HLVBoxd4IHeLixVoXh8ri8OPyE/csVgdd+XmHhM68EULV4M
	 6IJtsaAmTgoX132Y/NGx9ZAM42k4WXY6U+qjniRNWdPUI8Fq2xiaerhLMLSLSOyrmz
	 ZIRrQb8TIEj3yqlIVmLGRlls8Lx8K6xZM35NQCw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Barrera <ivan.d.barrera@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 349/570] RDMA/irdma: Clean up unnecessary dereference of event->cm_node
Date: Mon, 13 Apr 2026 17:58:00 +0200
Message-ID: <20260413155843.561119826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Barrera <ivan.d.barrera@intel.com>

[ Upstream commit b415399c9a024d574b65479636f0d4eb625b9abd ]

The cm_node is available and the usage of cm_node and event->cm_node
seems arbitrary. Clean up unnecessary dereference of event->cm_node.

Fixes: 146b9756f14c ("RDMA/irdma: Add connection manager")
Signed-off-by: Ivan Barrera <ivan.d.barrera@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/cm.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/cm.c b/drivers/infiniband/hw/irdma/cm.c
index d2c6a1bcf1de9..8a99a040917f7 100644
--- a/drivers/infiniband/hw/irdma/cm.c
+++ b/drivers/infiniband/hw/irdma/cm.c
@@ -4171,21 +4171,21 @@ static void irdma_cm_event_handler(struct work_struct *work)
 		irdma_cm_event_reset(event);
 		break;
 	case IRDMA_CM_EVENT_CONNECTED:
-		if (!event->cm_node->cm_id ||
-		    event->cm_node->state != IRDMA_CM_STATE_OFFLOADED)
+		if (!cm_node->cm_id ||
+		    cm_node->state != IRDMA_CM_STATE_OFFLOADED)
 			break;
 		irdma_cm_event_connected(event);
 		break;
 	case IRDMA_CM_EVENT_MPA_REJECT:
-		if (!event->cm_node->cm_id ||
+		if (!cm_node->cm_id ||
 		    cm_node->state == IRDMA_CM_STATE_OFFLOADED)
 			break;
 		irdma_send_cm_event(cm_node, cm_node->cm_id,
 				    IW_CM_EVENT_CONNECT_REPLY, -ECONNREFUSED);
 		break;
 	case IRDMA_CM_EVENT_ABORTED:
-		if (!event->cm_node->cm_id ||
-		    event->cm_node->state == IRDMA_CM_STATE_OFFLOADED)
+		if (!cm_node->cm_id ||
+		    cm_node->state == IRDMA_CM_STATE_OFFLOADED)
 			break;
 		irdma_event_connect_error(event);
 		break;
@@ -4195,7 +4195,7 @@ static void irdma_cm_event_handler(struct work_struct *work)
 		break;
 	}
 
-	irdma_rem_ref_cm_node(event->cm_node);
+	irdma_rem_ref_cm_node(cm_node);
 	kfree(event);
 }
 
-- 
2.53.0



