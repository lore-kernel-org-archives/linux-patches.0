Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395C5227599;
	Tue, 26 Aug 2025 11:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207390; cv=none; b=kbiy7g5mFOT338g4Nxrp/lBOKeOO6hAMjL4iIt5Eik8NxhlXxf9RVk+ilE4tIAhM7X0/vKb1njHNkfWOInKhkfgOaPsr96ZJsAOFdZTQUwoNkMaxYpOt2dswj1dnodvCeOWHqpoPIlLhvRdHPrt7R0ODgBapU9WYMG5+LYsalcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207390; c=relaxed/simple;
	bh=DBi5jl8VQqrPqemps7QJA8IXAC6MAoagbCsQef70DUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmRsKgov1QlL2NhjtinhpoEeqqf0vl0H/egwuwIepMvfVGguwmTOwkC1UlePVyqdiE43bXGszf14RwncImmMLXphR39owjaqULrVaCAF4r75zxLl75lu9dAekwI86qVbnzOgKr83twW2+RaNuxk/XcYzMkOu7sgOxuHolCWQKB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c9JNWCrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c9JNWCrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80034C4CEF1;
	Tue, 26 Aug 2025 11:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207389;
	bh=DBi5jl8VQqrPqemps7QJA8IXAC6MAoagbCsQef70DUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9JNWCrYUEYAVkCfIln2coSwME0UYQtTPIb+2mvfdhzmUixayj4SWg3Tk5DZlJBst
	 MEnnQovz9VzyzFAF8HpTobqiEabKYr3KFRtdsud+50gdnfpacIjh2QtQmJi7i3db2z
	 uklwTp7E2/w5CMU94N6tOukB8JsoRm7fwd0u5Fss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 164/457] media: iris: Track flush responses to prevent premature completion
Date: Tue, 26 Aug 2025 13:07:28 +0200
Message-ID: <20250826110941.427887088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dikshita Agarwal <quic_dikshita@quicinc.com>

commit 9bf58db157139abcd60e425e5718c8e6a917f9dc upstream.

Currently, two types of flush commands are queued to the firmware,
the first flush queued as part of sequence change, does not wait for a
response, while the second flush queued as part of stop, expects a
completion response before proceeding further.

Due to timing issue, the flush response corresponding to the first
command could arrive after the second flush is issued. This casuses the
driver to incorrectly assume that the second flush has completed,
leading to the premature signaling of flush_completion.

To address this, introduce a counter to track the number of pending
flush responses and signal flush completion only when all expected
responses are received.

Cc: stable@vger.kernel.org
Fixes: 11712ce70f8e ("media: iris: implement vb2 streaming ops")
Reviewed-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c  |    4 ++-
 drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c |   17 +++++++++-----
 drivers/media/platform/qcom/iris/iris_instance.h          |    2 +
 3 files changed, 16 insertions(+), 7 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_command.c
@@ -208,8 +208,10 @@ static int iris_hfi_gen1_session_stop(st
 		flush_pkt.flush_type = flush_type;
 
 		ret = iris_hfi_queue_cmd_write(core, &flush_pkt, flush_pkt.shdr.hdr.size);
-		if (!ret)
+		if (!ret) {
+			inst->flush_responses_pending++;
 			ret = iris_wait_for_session_response(inst, true);
+		}
 	}
 
 	return ret;
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
@@ -207,7 +207,8 @@ static void iris_hfi_gen1_event_seq_chan
 		flush_pkt.shdr.hdr.pkt_type = HFI_CMD_SESSION_FLUSH;
 		flush_pkt.shdr.session_id = inst->session_id;
 		flush_pkt.flush_type = HFI_FLUSH_OUTPUT;
-		iris_hfi_queue_cmd_write(inst->core, &flush_pkt, flush_pkt.shdr.hdr.size);
+		if (!iris_hfi_queue_cmd_write(inst->core, &flush_pkt, flush_pkt.shdr.hdr.size))
+			inst->flush_responses_pending++;
 	}
 
 	iris_vdec_src_change(inst);
@@ -408,7 +409,9 @@ static void iris_hfi_gen1_session_ftb_do
 		flush_pkt.shdr.hdr.pkt_type = HFI_CMD_SESSION_FLUSH;
 		flush_pkt.shdr.session_id = inst->session_id;
 		flush_pkt.flush_type = HFI_FLUSH_OUTPUT;
-		iris_hfi_queue_cmd_write(core, &flush_pkt, flush_pkt.shdr.hdr.size);
+		if (!iris_hfi_queue_cmd_write(core, &flush_pkt, flush_pkt.shdr.hdr.size))
+			inst->flush_responses_pending++;
+
 		iris_inst_sub_state_change_drain_last(inst);
 
 		return;
@@ -564,7 +567,6 @@ static void iris_hfi_gen1_handle_respons
 	const struct iris_hfi_gen1_response_pkt_info *pkt_info;
 	struct device *dev = core->dev;
 	struct hfi_session_pkt *pkt;
-	struct completion *done;
 	struct iris_inst *inst;
 	bool found = false;
 	u32 i;
@@ -625,9 +627,12 @@ static void iris_hfi_gen1_handle_respons
 			if (shdr->error_type != HFI_ERR_NONE)
 				iris_inst_change_state(inst, IRIS_INST_ERROR);
 
-			done = pkt_info->pkt == HFI_MSG_SESSION_FLUSH ?
-				&inst->flush_completion : &inst->completion;
-			complete(done);
+			if (pkt_info->pkt == HFI_MSG_SESSION_FLUSH) {
+				if (!(--inst->flush_responses_pending))
+					complete(&inst->flush_completion);
+			} else {
+				complete(&inst->completion);
+			}
 		}
 		mutex_unlock(&inst->lock);
 
--- a/drivers/media/platform/qcom/iris/iris_instance.h
+++ b/drivers/media/platform/qcom/iris/iris_instance.h
@@ -27,6 +27,7 @@
  * @crop: structure of crop info
  * @completion: structure of signal completions
  * @flush_completion: structure of signal completions for flush cmd
+ * @flush_responses_pending: counter to track number of pending flush responses
  * @fw_caps: array of supported instance firmware capabilities
  * @buffers: array of different iris buffers
  * @fw_min_count: minimnum count of buffers needed by fw
@@ -57,6 +58,7 @@ struct iris_inst {
 	struct iris_hfi_rect_desc	crop;
 	struct completion		completion;
 	struct completion		flush_completion;
+	u32				flush_responses_pending;
 	struct platform_inst_fw_cap	fw_caps[INST_FW_CAP_MAX];
 	struct iris_buffers		buffers[BUF_TYPE_MAX];
 	u32				fw_min_count;


