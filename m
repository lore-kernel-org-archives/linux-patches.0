Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D980B52ED5E;
	Wed,  9 Sep 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962790; cv=none; b=t0Q0yK43o/LQRKUEr8uC9R2JhiHDtlPT5HiZEJ22+ojm3EiJg9/hFygib5oOpbhHf9v9RKg6YA9+6FWsSY6vmieEVvckq3twSCxyMKeUJCdeunUibY2gASY1JUGhoa7Ez90sLtCNq/HeP2SdH+zUS70ACmzueOP8dAfnXBZvnbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962790; c=relaxed/simple;
	bh=S8QR0hPGEcCxJQyAosEKxOx3MsTHj0fEps5/gbt7k1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elz5lWDje+t2hwUZBOv/HB+B7WVDHq3F6tgaJKDDh6pFI1LX1NRuEIfy4bwSVO7LA6nethQ/J0qvt+B+/vqmjnm7GpZK3IkmVyneckuzDTELDsnj6zW56LW3afXYwnD92T65dHr2qivaV1FPiNOlU9E8rjVjzOLkqrWmxV+jc1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWAxrZ4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWAxrZ4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3F51F00A3A;
	Wed,  9 Sep 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962788;
	bh=hXhmECwJLBAQFFi1HuNdHDdXA3HnLPi1eSd3LsyR6TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zWAxrZ4yLKpZKM+pBuAp0ai7e+3MLtiAdIrI8lwWb7dXDuEe1fj7i09y8VAJBYSm9
	 s4nkIOZe1HTrEEMyiRnHQ+PDrsxfBXoIspbUSAhlON+LbSGEM46eAPovvWyvW/4uBP
	 M+24D/HxgJjjJH/rJBNtPAff37GnId0j8d2lNudM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 412/556] media: chips-media: wave5: Add timeout while stop_streaming
Date: Wed,  9 Sep 2026 15:41:32 +0200
Message-ID: <20260909134245.106006530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit 2ae7faed2e60d6d07d9efdd962d20dcb15330ced upstream.

When stop_streaming is called, an infinite loop may occur in some cases.
Add a bounded poll of the queue status: loop until the queues drain,
sleeping briefly between polls, and bail out once VPU_DEC_STOP_TIMEOUT
elapses.

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c   |   15 +++++++------
 drivers/media/platform/chips-media/wave5/wave5-vpuconfig.h |    2 -
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2021-2023 CHIPS&MEDIA INC
  */
 
+#include <linux/delay.h>
 #include <linux/pm_runtime.h>
 #include "wave5-helper.h"
 
@@ -1537,15 +1538,15 @@ static void wave5_vpu_dec_stop_streaming
 {
 	struct vpu_instance *inst = vb2_get_drv_priv(q);
 	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
-
-	bool check_cmd = TRUE;
+	unsigned long timeout;
 
 	dev_dbg(inst->dev->dev, "%s: type: %u\n", __func__, q->type);
 	pm_runtime_resume_and_get(inst->dev->dev);
 	inst->empty_queue = true;
-	while (check_cmd) {
+
+	timeout = jiffies + msecs_to_jiffies(VPU_DEC_STOP_TIMEOUT);
+	while (true) {
 		struct queue_status_info q_status;
-		struct dec_output_info dec_output_info;
 
 		wave5_vpu_dec_give_command(inst, DEC_GET_QUEUE_STATUS, &q_status);
 		if ((inst->state == VPU_INST_STATE_STOP ||
@@ -1554,8 +1555,10 @@ static void wave5_vpu_dec_stop_streaming
 			q_status.report_queue_count == 0)
 			break;
 
-		if (wave5_vpu_dec_get_output_info(inst, &dec_output_info))
-			dev_dbg(inst->dev->dev, "there is no output info\n");
+		if (time_after(jiffies, timeout))
+			break;
+
+		usleep_range(1000, 2000);
 	}
 
 	v4l2_m2m_update_stop_streaming_state(m2m_ctx, q);
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuconfig.h
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuconfig.h
@@ -59,7 +59,7 @@
 //  application specific configuration
 #define VPU_ENC_TIMEOUT                 60000
 #define VPU_DEC_TIMEOUT                 60000
-#define VPU_DEC_STOP_TIMEOUT            10
+#define VPU_DEC_STOP_TIMEOUT            300
 
 // for WAVE encoder
 #define USE_SRC_PRP_AXI         0


