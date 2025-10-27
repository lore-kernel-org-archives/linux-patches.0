Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2938A31D75C;
	Mon, 27 Oct 2025 19:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593405; cv=none; b=mxM8FvxCwnu0B3BAPJOuu0nKFC8IOT6KdNXRLMUQrMIkd/Lhn1hFzZ+xvpQtU2JfV+ocNReRI5VB9I/ziPysqewIh2ZKQc2TI+Gx6JsMaOHh857BjIP10btryPkJem0R3KwWDaPTQBydjvuEu/tz56j0UY6vZVxk+8rtqJylRu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593405; c=relaxed/simple;
	bh=IlrtNquIwspPCMI2YkvImEVsP34gPhtiGNXJnmrJ0q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jGN+wgGj4wONz1lnMDKXWIqCy59oKC475UsGnYtTylqNxlrVrU5F8oLVL7cEwCjU0QngyF3IQzrxPOFOmw7Z9IykLQA0aw9F1x93V+wYMgPakoZUVozT9RJ63XwLQR42umuvnAB8mR6WBWYMKUY8iJgLyz5aZnxnimry74mcGOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZfZwpN0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZfZwpN0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1FCC113D0;
	Mon, 27 Oct 2025 19:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593405;
	bh=IlrtNquIwspPCMI2YkvImEVsP34gPhtiGNXJnmrJ0q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfZwpN0WmDN27vsTnkuz1MVyH8wREa7Zt5M0tOheL7fvd6MZ1BOkAXr6Hc6PTRzN/
	 LAuFv3RAAV8vFW+41GwSZOA2GTjtnJwbkKmL5v4R0hXS4Lpbh9ypAEQQHtxRIfh/sp
	 11TDtyiZ4aPECgH0dCpQqSyMFDojoZPtg+VRFeVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 124/184] include: trace: Fix inflight count helper on failed initialization
Date: Mon, 27 Oct 2025 19:36:46 +0100
Message-ID: <20251027183518.283408610@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 289ce7e9a5e1a52ac7e522a3e389dc16be08d7a4 ]

Add a check to the scmi_inflight_count() helper to handle the case
when the SCMI debug subsystem fails to initialize.

Fixes: f8e656382b4a ("include: trace:  Add tracepoint support for inflight xfer count")
Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Message-Id: <20251014115346.2391418-2-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h | 8 +++++---
 drivers/firmware/arm_scmi/driver.c | 7 +++++--
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 21c0b95027c64..7c35c95fddbaf 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -333,10 +333,12 @@ static inline void scmi_inc_count(struct scmi_debug_info *dbg, int stat)
 	}
 }
 
-static inline void scmi_dec_count(atomic_t *arr, int stat)
+static inline void scmi_dec_count(struct scmi_debug_info *dbg, int stat)
 {
-	if (IS_ENABLED(CONFIG_ARM_SCMI_DEBUG_COUNTERS))
-		atomic_dec(&arr[stat]);
+	if (IS_ENABLED(CONFIG_ARM_SCMI_DEBUG_COUNTERS)) {
+		if (dbg)
+			atomic_dec(&dbg->counters[stat]);
+	}
 }
 
 enum scmi_bad_msg {
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 56419285c0bfd..1cd15412024cd 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -594,7 +594,7 @@ scmi_xfer_inflight_register_unlocked(struct scmi_xfer *xfer,
 	/* Set in-flight */
 	set_bit(xfer->hdr.seq, minfo->xfer_alloc_table);
 	hash_add(minfo->pending_xfers, &xfer->node, xfer->hdr.seq);
-	scmi_inc_count(info->dbg->counters, XFERS_INFLIGHT);
+	scmi_inc_count(info->dbg, XFERS_INFLIGHT);
 
 	xfer->pending = true;
 }
@@ -803,7 +803,7 @@ __scmi_xfer_put(struct scmi_xfers_info *minfo, struct scmi_xfer *xfer)
 			hash_del(&xfer->node);
 			xfer->pending = false;
 
-			scmi_dec_count(info->dbg->counters, XFERS_INFLIGHT);
+			scmi_dec_count(info->dbg, XFERS_INFLIGHT);
 		}
 		hlist_add_head(&xfer->node, &minfo->free_xfers);
 	}
@@ -3407,6 +3407,9 @@ int scmi_inflight_count(const struct scmi_handle *handle)
 	if (IS_ENABLED(CONFIG_ARM_SCMI_DEBUG_COUNTERS)) {
 		struct scmi_info *info = handle_to_scmi_info(handle);
 
+		if (!info->dbg)
+			return 0;
+
 		return atomic_read(&info->dbg->counters[XFERS_INFLIGHT]);
 	} else {
 		return 0;
-- 
2.51.0



