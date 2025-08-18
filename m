Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C492264CA;
	Mon, 18 Aug 2025 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524073; cv=none; b=Y0hkswEwJkpZ6XyWYjk1pqs7Wyyya/001pFkXiwdmpkk4R7HOeYPygJLKXnDHK0IHKl4rLclmadqxtH89+ic61wcbRQCfW9ppLfs9TJbkOQLFQHuUzQ3lLQZhBxBA9HFx8Yc3C00i1yWN/pGfw23KZ18CzLoEj76x+xAzE2rCpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524073; c=relaxed/simple;
	bh=INcNFjN724wyWkPz/0osijymn9icJhY2sQYozGnbdTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZash4ucx+iRFu5kbhYa+AqhtAgnV7xdqAabkkAH67aY7r8Gn3MCHLhWBK5b1wUPamMRj8BJPUDlKaISYVIlpVzMSu8BFwJM6VNoKBeIfYNTdUtQkx3hbZjtDZEsF2rrbWJvaAXaTfk8hiXITGcY/R30CiNSRprlk5CF2nXtguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIrkzhM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIrkzhM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C61C4CEEB;
	Mon, 18 Aug 2025 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524073;
	bh=INcNFjN724wyWkPz/0osijymn9icJhY2sQYozGnbdTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIrkzhM5M5d5E/JJZOE68TSsJIxhHGXTiTBtnFoCEiy8hMs/MAeluerbjHPiViAVB
	 XR2Y00pplJGxQP0XBYNt/5bfZxTgfEip0Hr95aqZzuPZcHJOUxBYGp6j4fGIxF0sa7
	 V9rzF91ZRJb3zoP54S7FvWIXzSwc3wRkTSvK3jMo=
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
Subject: [PATCH 6.15 358/515] media: iris: Add handling for corrupt and drop frames
Date: Mon, 18 Aug 2025 14:45:44 +0200
Message-ID: <20250818124512.193202136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



