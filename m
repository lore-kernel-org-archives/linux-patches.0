Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467735803A2;
	Wed,  9 Sep 2026 14:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964253; cv=none; b=nyTBvP8TDA+gfRzKBQinr/xwZEOb2ygqJJLdnMlmMRYcUvKJHFcuMFO28m/uZ3pYKim76gUhGtKxg33WecnPNka1Dw8dpBAiCdr9kj/5KYtmgcW37W9BJLy0nb05hxvgjxV6da0lH8zkmhvF1PHCsJ33dZZ+yFNT9SONuOrsD8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964253; c=relaxed/simple;
	bh=gO17vAFP799GTS3y94NyQkWiIyDMKCQFCuW01oWQzio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYBHLLJksbkDVqmijmNSPditwZHnCuPPMK3DTXt1cAM7boGsmuyfi5nvUqwqqKh+B+vUM4Pg25Hg2A2/eM791ZbC2qiCd2cW7nC/jotsQCWEbiYGiku9CtZoDp7R04vcgtgYKS5jQ5R6FF0qKAKPqyiAJhRLeS8S927XJf35Ex0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjqK2oz1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjqK2oz1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B01C1F00A3A;
	Wed,  9 Sep 2026 14:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964252;
	bh=g+FFf5iRA//GowNRtBP8HKjZdp08zw4SlXPHuIhlmI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zjqK2oz1BLBS4wdp4jCXDYVkERbBLC2gafHJDr2x2EcOWAhZhA1Yr9UJf4wazeIrU
	 y/8S8QyWTLTo8WPHp4ypEzw81L7lnhJjr0kIAxdPmcUQg3DQchrOXnGl6TPb39QRW5
	 kjPK1yOTrd+0aY+9HQNl2oh+104ySBwwzyydoCbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 321/583] media: chips-media: wave5: Guard bit depth check with initial_info_obtained
Date: Wed,  9 Sep 2026 15:40:06 +0200
Message-ID: <20260909134249.125809308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson Lee <jackson.lee@chipsnmedia.com>

commit 1551386934ad43d934c3bb7317929207e1edcd6a upstream.

When CAPTURE STREAMON is called before the VPU has completed sequence
initialization (initial_info_obtained == false), the initial_info fields
contain uninitialized data. The driver checks
luma_bitdepth and rejects anything other than 8-bit, so garbage values
(e.g. 15) cause STREAMON to fail spuriously.

This is reproducible with the following multi-threaded test scenario:
  1. Allocate 2 CAPTURE buffers.
  2. Call STREAMON on the CAPTURE queue.
  3. Call DQBUF, which blocks waiting for a decoded frame.
  4. A second thread calls STREAMOFF on the CAPTURE queue.
  5. The blocked DQBUF should be released, allowing graceful termination.

At step 2, STREAMON reads uninitialized luma_bitdepth and rejects the
stream, causing the test to fail.

Fix this by checking initial_info_obtained before accessing the bit
depth fields, so the validation is only performed when the sequence
info has actually been parsed by the VPU.

Fixes: 035371c9e509 ("media: chips-media: wave5: Fix timeout while testing 10bit hevc fluster")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1352,6 +1352,7 @@ static int wave5_vpu_dec_start_streaming
 	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
 		struct dec_initial_info *initial_info =
 			&inst->codec_info->dec_info.initial_info;
+		struct dec_info *p_dec_info = &inst->codec_info->dec_info;
 
 		if (inst->state == VPU_INST_STATE_STOP)
 			ret = switch_state(inst, VPU_INST_STATE_INIT_SEQ);
@@ -1359,6 +1360,7 @@ static int wave5_vpu_dec_start_streaming
 			goto return_buffers;
 
 		if (inst->state == VPU_INST_STATE_INIT_SEQ &&
+		    p_dec_info->initial_info_obtained &&
 		    inst->dev->product_code == WAVE521C_CODE) {
 			if (initial_info->luma_bitdepth != 8) {
 				dev_info(inst->dev->dev, "%s: no support for %d bit depth",
@@ -1367,7 +1369,6 @@ static int wave5_vpu_dec_start_streaming
 				goto return_buffers;
 			}
 		}
-
 	}
 	pm_runtime_put_autosuspend(inst->dev->dev);
 	return ret;


