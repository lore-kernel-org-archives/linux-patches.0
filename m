Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28568320399;
	Mon, 18 Aug 2025 14:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525856; cv=none; b=q/rWV+LK9oN4FlQOSRl+tVVVb7DP4rdeIEPXgUezso1M60Mk4cnLo7pmNfKPKv/0Wh3mrX7a+6Z+SUUAGIA3J1X60Jka8y0vf9s4mcSyrKpdT12rfK7GnaeArL5rrSwDRwJSe7OP465f+CcIm2KGSjz9Sv2klh19tMrXbY27BB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525856; c=relaxed/simple;
	bh=NbyJV8dZbY2uHQVq4Bm1AUjhS5+DaUc4cQIOvEEg3Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVAbQ1OwZADpJW4fSvbex+kB9wR/WACZVYm44c0qCeZNui2Gv3e+d0p2mFzrExQhGFNxegl0HT6cWEzT77pZ1OuiWC+IFBG7TBLIIjTMZMFmDZxoRNPPxSgDx5Zd250k3Pbl71bumpDCfze6//Syvf65pHczRZe+2GKfg/cydJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ro+LIAr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ro+LIAr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C41CC19421;
	Mon, 18 Aug 2025 14:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525856;
	bh=NbyJV8dZbY2uHQVq4Bm1AUjhS5+DaUc4cQIOvEEg3Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ro+LIAr/Nl1NJPPkGhpQnv4fSMzWRiVujokATs0Ue8yEnzo5vtza+92/JS3I+Niyu
	 yrpjWSRbkVlqK+36uIL23H3VBLOgTwBg6aIOacbE/Vy+3xRRpo7+4AmlgFHe75OpFk
	 Dho30WHIwdr6Ml47rk2woSXFnfAVoYrq1QnLJD2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vikash Garodia <quic_vgarodia@quicinc.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.16 387/570] media: iris: Add handling for corrupt and drop frames
Date: Mon, 18 Aug 2025 14:46:14 +0200
Message-ID: <20250818124520.751969194@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

[ Upstream commit b791dcfcba3a0c46fb3e2decab31d2340c5dc313 ]

Firmware attach DATACORRUPT/DROP buffer flags for the frames which
needs to be dropped, handle it by setting VB2_BUF_STATE_ERROR for these
buffers before calling buf_done.

Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Acked-by: Vikash Garodia <quic_vgarodia@quicinc.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-HDK
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-HDK
Signed-off-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Tested-by: Vikash Garodia <quic_vgarodia@quicinc.com> # on sa8775p-ride
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/iris/iris_buffer.c        | 11 ++++++++---
 .../media/platform/qcom/iris/iris_hfi_gen1_defines.h  |  2 ++
 .../media/platform/qcom/iris/iris_hfi_gen1_response.c |  6 ++++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/qcom/iris/iris_buffer.c b/drivers/media/platform/qcom/iris/iris_buffer.c
index e5c5a564fcb8..7dd5730a867a 100644
--- a/drivers/media/platform/qcom/iris/iris_buffer.c
+++ b/drivers/media/platform/qcom/iris/iris_buffer.c
@@ -593,10 +593,13 @@ int iris_vb2_buffer_done(struct iris_inst *inst, struct iris_buffer *buf)
 
 	vb2 = &vbuf->vb2_buf;
 
-	if (buf->flags & V4L2_BUF_FLAG_ERROR)
+	if (buf->flags & V4L2_BUF_FLAG_ERROR) {
 		state = VB2_BUF_STATE_ERROR;
-	else
-		state = VB2_BUF_STATE_DONE;
+		vb2_set_plane_payload(vb2, 0, 0);
+		vb2->timestamp = 0;
+		v4l2_m2m_buf_done(vbuf, state);
+		return 0;
+	}
 
 	vbuf->flags |= buf->flags;
 
@@ -616,6 +619,8 @@ int iris_vb2_buffer_done(struct iris_inst *inst, struct iris_buffer *buf)
 			v4l2_m2m_mark_stopped(m2m_ctx);
 		}
 	}
+
+	state = VB2_BUF_STATE_DONE;
 	vb2->timestamp = buf->timestamp;
 	v4l2_m2m_buf_done(vbuf, state);
 
diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h b/drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h
index 9f246816a286..93b5f838c290 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_defines.h
@@ -117,6 +117,8 @@
 #define HFI_FRAME_NOTCODED				0x7f002000
 #define HFI_FRAME_YUV					0x7f004000
 #define HFI_UNUSED_PICT					0x10000000
+#define HFI_BUFFERFLAG_DATACORRUPT			0x00000008
+#define HFI_BUFFERFLAG_DROP_FRAME			0x20000000
 
 struct hfi_pkt_hdr {
 	u32 size;
diff --git a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
index b72d503dd740..91d95eed68aa 100644
--- a/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
+++ b/drivers/media/platform/qcom/iris/iris_hfi_gen1_response.c
@@ -481,6 +481,12 @@ static void iris_hfi_gen1_session_ftb_done(struct iris_inst *inst, void *packet)
 	buf->attr |= BUF_ATTR_DEQUEUED;
 	buf->attr |= BUF_ATTR_BUFFER_DONE;
 
+	if (hfi_flags & HFI_BUFFERFLAG_DATACORRUPT)
+		flags |= V4L2_BUF_FLAG_ERROR;
+
+	if (hfi_flags & HFI_BUFFERFLAG_DROP_FRAME)
+		flags |= V4L2_BUF_FLAG_ERROR;
+
 	buf->flags |= flags;
 
 	iris_vb2_buffer_done(inst, buf);
-- 
2.39.5



