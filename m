Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E074B525A66;
	Wed, 30 Sep 2026 17:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790479; cv=none; b=S2elNbNqhF0ssKoteW2MWYXaWe6wmYzjdMgSO08dCixIU673ZMOJnRx5iaCUu9/QQf99obzQth2r7HBdmAOOllgQnIBBBlK4Dx+iBC24b6NVWdhuGrWHD2bNurHk7C5eFFWn14tg/iqjk81v5BL5aTOoCE/7cPMzFGM77IE9KNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790479; c=relaxed/simple;
	bh=PqAHfspnbWjJddRk3kR3TiYPcXwA4foelyw51nqvkoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1W7otBJyIpgJ931wzz8zaMeS4F+aA3Wju/drlO8BAhvpYLxc+Gqj+SLPurnb9mxEra2GB1lN3ynLryk9+HZjOGm0UfuGrkOGqn4nq73ajiTq4ruEbVneuyX/Eo+U3cvI9VrOmqstQTDrG0CcsmtxNwSA8t5tNAyJWCWZQzRHT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXkO4xCx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXkO4xCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459951F000FF;
	Wed, 30 Sep 2026 17:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790477;
	bh=q1v76n9RiV+w4fqAM4mUHFnCbgHXstaFnk+jAee5cKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RXkO4xCxM8wysq4x/kNmpX2Nk7yVKfoCdLeF9vfIwS3skzTJlHtNCJF0FdcORFout
	 O+phQEoVK3M148KrrtqC0CiFTvMFVyY1netYzwHC1KEznTosLN7lg73ik/yfoPJ8lL
	 mXAR1dCMv+TCEeU80W2RLTT9WotlOxOJLqWEwesM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arinzon <darinzon@amazon.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 844/877] net: ena: Remove autopolling mode
Date: Wed, 30 Sep 2026 17:29:15 +0200
Message-ID: <20260930152432.952238275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Dr. David Alan Gilbert" <linux@treblig.org>

[ Upstream commit b356b9170815f822394667010d478d53901ff581 ]

This manually reverts
commit a4e262cde3cd ("net: ena: allow automatic fallback to polling mode")

which is unused.

(I did it manually because there are other minor comment
and function changes surrounding it).
Build tested only.

Suggested-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Link: https://patch.msgid.link/20241103194149.293456-1-linux@treblig.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9476b4468862 ("net: ena: fix MMIO read buffer leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c |   25 +++++--------------------
 drivers/net/ethernet/amazon/ena/ena_com.h |   14 --------------
 2 files changed, 5 insertions(+), 34 deletions(-)

--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -763,25 +763,16 @@ static int ena_com_wait_and_process_admi
 
 		if (comp_ctx->status == ENA_CMD_COMPLETED) {
 			netdev_err(admin_queue->ena_dev->net_device,
-				   "The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d), autopolling mode is %s\n",
-				   comp_ctx->cmd_opcode, admin_queue->auto_polling ? "ON" : "OFF");
-			/* Check if fallback to polling is enabled */
-			if (admin_queue->auto_polling)
-				admin_queue->polling = true;
+				   "The ena device sent a completion but the driver didn't receive a MSI-X interrupt (cmd %d)\n",
+				   comp_ctx->cmd_opcode);
 		} else {
 			netdev_err(admin_queue->ena_dev->net_device,
 				   "The ena device didn't send a completion for the admin cmd %d status %d\n",
 				   comp_ctx->cmd_opcode, comp_ctx->status);
 		}
-		/* Check if shifted to polling mode.
-		 * This will happen if there is a completion without an interrupt
-		 * and autopolling mode is enabled. Continuing normal execution in such case
-		 */
-		if (!admin_queue->polling) {
-			admin_queue->running_state = false;
-			ret = -ETIME;
-			goto err;
-		}
+		admin_queue->running_state = false;
+		ret = -ETIME;
+		goto err;
 	}
 
 	ret = ena_com_comp_status_to_errno(admin_queue, comp_ctx->comp_status);
@@ -1650,12 +1641,6 @@ void ena_com_set_admin_polling_mode(stru
 	ena_dev->admin_queue.polling = polling;
 }
 
-void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
-					 bool polling)
-{
-	ena_dev->admin_queue.auto_polling = polling;
-}
-
 int ena_com_mmio_reg_read_request_init(struct ena_com_dev *ena_dev)
 {
 	struct ena_com_mmio_read *mmio_read = &ena_dev->mmio_read;
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -224,9 +224,6 @@ struct ena_com_admin_queue {
 	/* Indicate if the admin queue should poll for completion */
 	bool polling;
 
-	/* Define if fallback to polling mode should occur */
-	bool auto_polling;
-
 	u16 curr_cmd_id;
 
 	/* Indicate that the ena was initialized and can
@@ -493,17 +490,6 @@ bool ena_com_get_admin_running_state(str
  */
 void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling);
 
-/* ena_com_set_admin_auto_polling_mode - Enable autoswitch to polling mode
- * @ena_dev: ENA communication layer struct
- * @polling: Enable/Disable polling mode
- *
- * Set the autopolling mode.
- * If autopolling is on:
- * In case of missing interrupt when data is available switch to polling.
- */
-void ena_com_set_admin_auto_polling_mode(struct ena_com_dev *ena_dev,
-					 bool polling);
-
 /* ena_com_admin_q_comp_intr_handler - admin queue interrupt handler
  * @ena_dev: ENA communication layer struct
  *


