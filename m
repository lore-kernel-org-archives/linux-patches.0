Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D024B36B072;
	Tue,  6 Jan 2026 17:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722130; cv=none; b=Ii8fiW9Xm4AeyH5G2lUUg8TqDyIsBhibPLSD0sLZmi69sYYYm31jbPI3cNsQsFk8wQW6FxJupZicCe/RWMO5vBAZCjnMX3XNKMhZ6PEu7aXYRlzuA68L0uuc920IJ5C2ugmAlkGFOTcwG64UPFFE/R961wMdgRfv8HPyN7Rs/bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722130; c=relaxed/simple;
	bh=wM/O6xrhMKz1vtQiBRO9isZl4BZYtvNeh3gsyN5gu8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWadhvcuZQu7iZZxw/ckixUA0hO04ptzUKqD9zhSTh+b1oCfCcDYFAGGEdAGvjEiTsgwYSgoVyemjXnFGYn1IR4bilMmsnXuN3M37CnQVBhLBV5mflni4xJGLY/pIUozf8nkLYXKEhjG/rUTIfyzv8JOt40cejroygxkYD9cc/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3hWcYY6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3hWcYY6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388D1C116C6;
	Tue,  6 Jan 2026 17:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722130;
	bh=wM/O6xrhMKz1vtQiBRO9isZl4BZYtvNeh3gsyN5gu8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3hWcYY642LM53Avu2aEPzR8pqkdidJEZSb4+g2bu1VtBgjXaWbFp4jnlHptkCASN
	 GJd3BTjrLy2Tdht1FQmqN6Xu3xU4Zf+eDBAFLo9yE+/CXqmPvcDVbnglVzsnmYLE5D
	 wblM7RcNLiWLRc1QfHWKPNSDv4XycWBcTDZLga2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 175/312] media: iris: Refine internal buffer reconfiguration logic for resolution change
Date: Tue,  6 Jan 2026 18:04:09 +0100
Message-ID: <20260106170554.165118173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>

commit aec75e355c633e4b0967c99580bd8ef93e0cdc98 upstream.

Improve the condition used to determine when input internal buffers need
to be reconfigured during streamon on the capture port. Previously, the
check relied on the INPUT_PAUSE sub-state, which was also being set
during seek operations. This led to input buffers being queued multiple
times to the firmware, causing session errors due to duplicate buffer
submissions.

This change introduces a more accurate check using the FIRST_IPSC and
DRC sub-states to ensure that input buffer reconfiguration is triggered
only during resolution change scenarios, such as streamoff/on on the
capture port. This avoids duplicate buffer queuing during seek
operations.

Fixes: c1f8b2cc72ec ("media: iris: handle streamoff/on from client in dynamic resolution change")
Cc: stable@vger.kernel.org
Reported-by: Val Packett <val@packett.cool>
Closes: https://gitlab.freedesktop.org/gstreamer/gstreamer/-/issues/4700
Signed-off-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_common.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_common.c
+++ b/drivers/media/platform/qcom/iris/iris_common.c
@@ -91,12 +91,14 @@ int iris_process_streamon_input(struct i
 int iris_process_streamon_output(struct iris_inst *inst)
 {
 	const struct iris_hfi_command_ops *hfi_ops = inst->core->hfi_ops;
-	bool drain_active = false, drc_active = false;
 	enum iris_inst_sub_state clear_sub_state = 0;
+	bool drain_active, drc_active, first_ipsc;
 	int ret = 0;
 
 	iris_scale_power(inst);
 
+	first_ipsc = inst->sub_state & IRIS_INST_SUB_FIRST_IPSC;
+
 	drain_active = inst->sub_state & IRIS_INST_SUB_DRAIN &&
 		inst->sub_state & IRIS_INST_SUB_DRAIN_LAST;
 
@@ -108,7 +110,8 @@ int iris_process_streamon_output(struct
 	else if (drain_active)
 		clear_sub_state = IRIS_INST_SUB_DRAIN | IRIS_INST_SUB_DRAIN_LAST;
 
-	if (inst->domain == DECODER && inst->sub_state & IRIS_INST_SUB_INPUT_PAUSE) {
+	/* Input internal buffer reconfiguration required in case of resolution change */
+	if (first_ipsc || drc_active) {
 		ret = iris_alloc_and_queue_input_int_bufs(inst);
 		if (ret)
 			return ret;


