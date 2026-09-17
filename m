Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65984F85CA;
	Thu, 17 Sep 2026 17:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666878; cv=none; b=Q6P+vqHcXmj/3BkAsIF4ZLm4SG9UFBDkjjkEtNGsDl6UTa69FEn/OjV2cACEwUf49vC2VrhAo+qAyY2TbMcYMDQzpNX3bhnYWESBGkqKwzSgnvof5yyvVZqkFgsPf2zUrOwqUGsQJ2u3OnqVW8M+GLYfC2pI6hWnlWZ7yAWE6vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666878; c=relaxed/simple;
	bh=WhzDPwbunecHHsvIcnOIRQo9kT9QiPNShckkS4am/ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IlhSW1403mGhZ3nXYfprAlg/AKJ5On78T0SEOliAe1XEzC2DAws7wPffCP8mrd4ZZTJib0/h5Obxi5v7kJ1lFr3W/OIIuze43JC0y2p2Av3XTnt07eG6ra9auMpMRdke9t8nBOHU73owwlZrmQbPvg7kd8LPbiVcIxt2TH4h6Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KWiXk/NN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWiXk/NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927551F000FF;
	Thu, 17 Sep 2026 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666876;
	bh=0P2CQZ8fj0xwSdpiXeV+veIbiRpRzt+KavyvoDbw6GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KWiXk/NNaP8MmUPsLNA7R4VCFKWzBHf2/s4YSbTY6n8WU2GhWojWjcdubHbOpIyUS
	 VeZDyUd0pB8tILxhBXNBBgjCgoDDWyvEXUthh+ycjGnyDNbeGrUMe5HTO3vVWlTISX
	 ll+JlFdbbA5sGw7d/dHq3jzsbjhcCNHoRcSHKjVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1155/1250] media: chips-media: wave5: Add timeout while stop_streaming
Date: Thu, 17 Sep 2026 16:15:50 +0100
Message-ID: <20260917151623.570703929@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted timeout polling to the older decoder’s report_queue_count condition. ]
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
 #include <linux/pm_runtime.h>
 #include "wave5-helper.h"
 
@@ -1490,25 +1491,24 @@ static void wave5_vpu_dec_stop_streaming
 {
 	struct vpu_instance *inst = vb2_get_drv_priv(q);
 	struct v4l2_m2m_ctx *m2m_ctx = inst->v4l2_fh.m2m_ctx;
-	bool check_cmd = TRUE;
+	unsigned long timeout;
 
 	dev_dbg(inst->dev->dev, "%s: type: %u\n", __func__, q->type);
 	pm_runtime_resume_and_get(inst->dev->dev);
 
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
@@ -59,6 +59,7 @@
 //  application specific configuration
 #define VPU_ENC_TIMEOUT                 60000
 #define VPU_DEC_TIMEOUT                 60000
+#define VPU_DEC_STOP_TIMEOUT            300
 
 // for WAVE encoder
 #define USE_SRC_PRP_AXI         0


