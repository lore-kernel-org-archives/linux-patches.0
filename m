Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97071330B00;
	Fri, 17 Oct 2025 15:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715785; cv=none; b=OyAChrOb3Co0iomL3ubGFfSyk61UpsfAWvI1v7QlvkEPKmmcfzLvB5XuSy0mfIULg6vYARhlkkkSE7AOlYvflMTQ1YYdyT25ge5aRTAgc6h5bIo/jia02ZweD2Y2I0ZKzsl0eoDWeqSEpVdCAvL2KrLrbInWhzk3yNkQfQNzAQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715785; c=relaxed/simple;
	bh=sxlcdors31Uz2Q5KBbHhHzEdvG+c69bTWeezF0cDpVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXfyTkQc8hPTk2reSo0BB5mag1PKXqKn5hUth0Q5AWfw+1+1A2Dk1pxblT4NFbmwi+rRIYQiwzu2+ZmnodrMIk71/low+ikFgTUBagQEyifdnv7c5D1c/7brcpRja7vz499iPpBHJbz1Y4l2lw5jjlwmcLvFSIDe8SjicyEQoW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ca1xOpw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ca1xOpw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDAAC4CEE7;
	Fri, 17 Oct 2025 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715785;
	bh=sxlcdors31Uz2Q5KBbHhHzEdvG+c69bTWeezF0cDpVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ca1xOpw6EN8DayZzvkVMOY4afs1hhB3mKN5ZQvi2n9QyfN28k217/T78rtee9vvYE
	 q6iOaXhm3u9MFK7QmSGXWwi0UIO/4dAuEtYg0PrKRLLnWa3A95F35Etdoz8N9uOhEH
	 Gf8oXuuSbJ7wrgO9eGo44Y8OXP9u30I5Xu1Txj+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.17 335/371] media: iris: Fix missing LAST flag handling during drain
Date: Fri, 17 Oct 2025 16:55:10 +0200
Message-ID: <20251017145214.202673260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 8172f57746d68e5c3c743f725435d75c5a4db1ac upstream.

Improve drain handling by ensuring the LAST flag is attached to final
capture buffer when drain response is received from the firmware.

Previously, the driver failed to attach the V4L2_BUF_FLAG_LAST flag when
a drain response was received from the firmware, relying on userspace to
mark the next queued buffer as LAST. This update fixes the issue by
checking the pending drain status, attaching the LAST flag to the
capture buffer received from the firmware (with EOS attached), and
returning it to the V4L2 layer correctly.

Fixes: d09100763bed ("media: iris: add support for drain sequence")
Cc: stable@vger.kernel.org
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # X1E80100
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # x1e80100-crd
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c | 4 +---
 drivers/media/platform/qcom/iris/iris_state.c             | 2 +-
 drivers/media/platform/qcom/iris/iris_state.h             | 1 +
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
index 8d1ce8a19a45..2a9645883383 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
@@ -416,8 +416,6 @@ static void iris_hfi_gen1_session_ftb_done(struct iris_inst *inst, void *packet)
 			inst->flush_responses_pending++;
 
 		iris_inst_sub_state_change_drain_last(inst);
-
-		return;
 	}
 
 	if (iris_split_mode_enabled(inst) && pkt->stream_id == 0) {
@@ -462,7 +460,7 @@ static void iris_hfi_gen1_session_ftb_done(struct iris_inst *inst, void *packet)
 		timestamp_us = (timestamp_us << 32) | timestamp_lo;
 	} else {
 		if (pkt->stream_id == 1 && !inst->last_buffer_dequeued) {
-			if (iris_drc_pending(inst)) {
+			if (iris_drc_pending(inst) || iris_drain_pending(inst)) {
 				flags |= V4L2_BUF_FLAG_LAST;
 				inst->last_buffer_dequeued = true;
 			}
diff --git a/drivers/media/platform/qcom/iris/iris_state.c b/drivers/media/platform/qcom/iris/iris_state.c
index a21238d2818f..d1dc1a863da0 100644
--- a/drivers/media/platform/qcom/iris/iris_state.c
+++ b/drivers/media/platform/qcom/iris/iris_state.c
@@ -252,7 +252,7 @@ bool iris_drc_pending(struct iris_inst *inst)
 		inst->sub_state & IRIS_INST_SUB_DRC_LAST;
 }
 
-static inline bool iris_drain_pending(struct iris_inst *inst)
+bool iris_drain_pending(struct iris_inst *inst)
 {
 	return inst->sub_state & IRIS_INST_SUB_DRAIN &&
 		inst->sub_state & IRIS_INST_SUB_DRAIN_LAST;
diff --git a/drivers/media/platform/qcom/iris/iris_state.h b/drivers/media/platform/qcom/iris/iris_state.h
index e718386dbe04..b09fa54cf17e 100644
--- a/drivers/media/platform/qcom/iris/iris_state.h
+++ b/drivers/media/platform/qcom/iris/iris_state.h
@@ -141,5 +141,6 @@ int iris_inst_sub_state_change_drc_last(struct iris_inst *inst);
 int iris_inst_sub_state_change_pause(struct iris_inst *inst, u32 plane);
 bool iris_allow_cmd(struct iris_inst *inst, u32 cmd);
 bool iris_drc_pending(struct iris_inst *inst);
+bool iris_drain_pending(struct iris_inst *inst);
 
 #endif
-- 
2.51.0



