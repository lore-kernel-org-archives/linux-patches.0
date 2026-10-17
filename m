Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEC3E38654F;
	Sat, 17 Oct 2026 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256162; cv=none; b=FOzFyRfY2DR16JU9+NDM8ltpyuPxrXdd0TWLzZTWNWsg6RF6gTfZLuR3yKhqbqUpKObuLagA49XjhF3fcny144ZoR0WTqi49mRW4Q3njNzFGic4jyEOOHxwW9sK5PaVULb+Df4mPy00452mCneN9C1nwPFPbWCUp4M7A5y836RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256162; c=relaxed/simple;
	bh=AEh4SP9qw07NXGvhzcsEQkBjQoIDUX7hFgbtXjQin94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5RGA9JVTuRNrXPhfTTH9WMOx8hW23nx+nShBbzbUDJiYrnn7/urenWbBeOo3iPGY2YIzmxzH29BXTwK853u1pVoJP3QWr+mRSM+GI2wRp1uVWtSIgHnUc5BSiyvoWX8wWi3sY8R3ED6tbgWOz70NBDfSAxDB0KK3aeUSv9BKvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylEC3shN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylEC3shN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417411F000C5;
	Sat, 17 Oct 2026 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256160;
	bh=Wr7JQDJa3R81eSt2VgknHUsA+hKGfVEtJRZjWIe9Jvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylEC3shNk4MWicKnqbe4r82s4GFNE0gD6ikqBitLODpltomKovtThFCffgDyEhzds
	 ohtHpxserTkHIyno0V2N+Ewq0nQgrJmWshnO3VKnz0FiCnQqp/L57WVJrsSr6d4/On
	 LfgVGxXzpzLnJpiOsHCHx687KY6asfChf0q39KEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arinzon <darinzon@amazon.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0144/1674] net: ena: Remove autopolling mode
Date: Sat, 17 Oct 2026 17:40:16 +0200
Message-ID: <20261017160434.856181044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Dr. David Alan Gilbert <linux@treblig.org>

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
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 25 +++++------------------
 drivers/net/ethernet/amazon/ena/ena_com.h | 14 -------------
 2 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 276f6a8631fb1..a7b98c0b5f285 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -763,25 +763,16 @@ static int ena_com_wait_and_process_admin_cq_interrupts(struct ena_comp_ctx *com
 
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
@@ -1658,12 +1649,6 @@ void ena_com_set_admin_polling_mode(struct ena_com_dev *ena_dev, bool polling)
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
diff --git a/drivers/net/ethernet/amazon/ena/ena_com.h b/drivers/net/ethernet/amazon/ena/ena_com.h
index 3c5081d9d25d6..bb33fe209eec0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.h
+++ b/drivers/net/ethernet/amazon/ena/ena_com.h
@@ -227,9 +227,6 @@ struct ena_com_admin_queue {
 	/* Indicate if the admin queue should poll for completion */
 	bool polling;
 
-	/* Define if fallback to polling mode should occur */
-	bool auto_polling;
-
 	u16 curr_cmd_id;
 
 	/* Indicate that the ena was initialized and can
@@ -484,17 +481,6 @@ bool ena_com_get_admin_running_state(struct ena_com_dev *ena_dev);
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
-- 
2.53.0



