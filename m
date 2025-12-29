Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D51A33066C;
	Mon, 29 Dec 2025 16:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025775; cv=none; b=uNekLEV8JGbLoUqQaaYVo00tY2f7ccgGBRkIoRxpI2R58dp2ihQ4acHpfqXqWUTuA4IXXAa0GVS/9piMMldcfiHu28JAnnLN/SZcof12O+/QFYAsDjRfGJdzcKiboYJINikjzn8KvvB21g1cBE0jRkZopzsyw+hSr4MuUNkJ8tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025775; c=relaxed/simple;
	bh=aBX9AlHySrUGZGqRzYrkaI9zT33U1ELD16J+KQAb1jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFaU/5UF3NIg8L3/e4Lve0PebqVdRy7E/aWw5KanemcC2X2Ixbw6y7LaUaYSkUyqTAP9Yr30fWG0umCPHfdlmxKT2Tipm9S6dhbV2/9gL8GIBlvvHjLsIVzWx3T1/w+4SIxJKDT790ho+6TlmB5xGGz1nyFeJ/srikoHA4k7DOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgIXLyOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgIXLyOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9861C4CEF7;
	Mon, 29 Dec 2025 16:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025775;
	bh=aBX9AlHySrUGZGqRzYrkaI9zT33U1ELD16J+KQAb1jI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgIXLyOKW0M7QRBBePVfzr3/y/tEGh2E4u0jLCaErhchuEyd5d/2xNWM2vjr7TUw4
	 6fq5X96baCbQx4TMs7+JDB5EBl0cdRRFcELzfoPnUyfO7dAD8532XkNMD6XhjwK6kQ
	 dDl5btvSiTWSKUo0ThOSERc97ilwkSOawOEVQe2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>,
	Wangao Wang <wangao.wang@oss.qualcomm.com>,
	Vikash Garodia <vikash.garodia@oss.qualcomm.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 332/430] media: iris: Add sanity check for stop streaming
Date: Mon, 29 Dec 2025 17:12:14 +0100
Message-ID: <20251229160736.544949593@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Wangao Wang <wangao.wang@oss.qualcomm.com>

commit ad699fa78b59241c9d71a8cafb51525f3dab04d4 upstream.

Add sanity check in iris_vb2_stop_streaming. If inst->state is
already IRIS_INST_ERROR, we should skip the stream_off operation
because it would still send packets to the firmware.

In iris_kill_session, inst->state is set to IRIS_INST_ERROR and
session_close is executed, which will kfree(inst_hfi_gen2->packet).
If stop_streaming is called afterward, it will cause a crash.

Fixes: 11712ce70f8e5 ("media: iris: implement vb2 streaming ops")
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Dikshita Agarwal <dikshita.agarwal@oss.qualcomm.com>
Signed-off-by: Wangao Wang <wangao.wang@oss.qualcomm.com>
Reviewed-by: Vikash Garodia <vikash.garodia@oss.qualcomm.com>
[bod: remove qcom from patch title]
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/iris/iris_vb2.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/media/platform/qcom/iris/iris_vb2.c
+++ b/drivers/media/platform/qcom/iris/iris_vb2.c
@@ -231,6 +231,8 @@ void iris_vb2_stop_streaming(struct vb2_
 		return;
 
 	mutex_lock(&inst->lock);
+	if (inst->state == IRIS_INST_ERROR)
+		goto exit;
 
 	if (!V4L2_TYPE_IS_OUTPUT(q->type) &&
 	    !V4L2_TYPE_IS_CAPTURE(q->type))
@@ -241,10 +243,10 @@ void iris_vb2_stop_streaming(struct vb2_
 		goto exit;
 
 exit:
-	iris_helper_buffers_done(inst, q->type, VB2_BUF_STATE_ERROR);
-	if (ret)
+	if (ret) {
+		iris_helper_buffers_done(inst, q->type, VB2_BUF_STATE_ERROR);
 		iris_inst_change_state(inst, IRIS_INST_ERROR);
-
+	}
 	mutex_unlock(&inst->lock);
 }
 


