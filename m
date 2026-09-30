Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CD95328D4;
	Wed, 30 Sep 2026 17:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790006; cv=none; b=l4PskG8ssXC/nOu5CWvhA/RGRgWcmwBQSauvI3dZQdwb3sVIwBLmxe32er+gxMWy8+sdb9Xhj3QY1YIJ2BRodPQ3q4wkF4yJ5ceVDH7nMHIMPtqpxYAlP12/jLDkGeiEXV0dOwRie8r4LQZFMYx5wHMERXJuaKp2C+1o5bI5bnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790006; c=relaxed/simple;
	bh=G+E/GaL+Ajv8F9zEcDb6h6vDkueQa63Y+61iSoWYnis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NvAXcRkKbIV9+FAD1Ly0MEzL9bDsMSV4DBip7aLcp2tuPo34ujFLKjJx8MP1/zc00/K51Av1Iz8+dV0Ir/+LMolGOElpj8WMqrWX+UY5/bJqZuRI3UQ+b175DWI6y9zTmKRkxtfjMyr4b4X0mwgjsKNmtulrymSJgCC96pWOtgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzz/dYfI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzz/dYfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0B61F000FF;
	Wed, 30 Sep 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790005;
	bh=y2Jr+kF7DSSGfq/laC+RqIcgiSNA3a/R00cWGXdLpzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzz/dYfIg8EhmlBoQvgvcXqmwQGmdtAfWQxDBi+OTEdguLtg01OiEOluq8YNOErHG
	 L6554tPsu0vgNn9WpsPrIf84uaCHdUMWNZqzNSEQfM2T0LgfPQjPWVWnH5iLHNfH57
	 IeweLzhmwhM3dAXwuXWgwyZC54/QAGcyeUeRdI+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 676/877] media: chips-media: wave5: Add timeout while stop_streaming
Date: Wed, 30 Sep 2026 17:26:27 +0200
Message-ID: <20260930152429.260677492@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

[ Upstream commit 2ae7faed2e60d6d07d9efdd962d20dcb15330ced ]

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
[ adapted the stop loop to use 6.12’s existing report_queue_count condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c   |   12 ++++++------
 drivers/media/platform/chips-media/wave5/wave5-vpuconfig.h |    1 +
 2 files changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2021-2023 CHIPS&MEDIA INC
  */
 
+#include <linux/delay.h>
 #include "wave5-helper.h"
 
 #define VPU_DEC_DEV_NAME "C&M Wave5 VPU decoder"
@@ -1567,24 +1568,23 @@ static void wave5_vpu_dec_stop_streaming
 {
 	struct vpu_instance *inst = vb2_get_drv_priv(q);
 	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
-	bool check_cmd = TRUE;
+	unsigned long timeout;
 
 	dev_dbg(inst->dev->dev, "%s: type: %u\n", __func__, q->type);
 
-	while (check_cmd) {
+	timeout = jiffies + msecs_to_jiffies(VPU_DEC_STOP_TIMEOUT);
+	while (true) {
 		struct queue_status_info q_status;
-		struct dec_output_info dec_output_info;
 
 		wave5_vpu_dec_give_command(inst, DEC_GET_QUEUE_STATUS, &q_status);
 
 		if (q_status.report_queue_count == 0)
 			break;
 
-		if (wave5_vpu_wait_interrupt(inst, VPU_DEC_TIMEOUT) < 0)
+		if (time_after(jiffies, timeout))
 			break;
 
-		if (wave5_vpu_dec_get_output_info(inst, &dec_output_info))
-			dev_dbg(inst->dev->dev, "there is no output info\n");
+		usleep_range(1000, 2000);
 	}
 
 	v4l2_m2m_update_stop_streaming_state(m2m_ctx, q);
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuconfig.h
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuconfig.h
@@ -40,6 +40,7 @@
 //  application specific configuration
 #define VPU_ENC_TIMEOUT                 60000
 #define VPU_DEC_TIMEOUT                 60000
+#define VPU_DEC_STOP_TIMEOUT            300
 
 // for WAVE encoder
 #define USE_SRC_PRP_AXI         0


