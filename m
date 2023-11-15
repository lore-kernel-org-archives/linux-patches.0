Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29967381D1
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkNTjazD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB290C433C8;
	Wed, 15 Nov 2023 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078438;
	bh=b4ShBSPw2nmT1sdTjTP6FL8RQpca81WqAgkTMa8ORhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkNTjazDdydIB7GH81f8A9D1ADiC96Cp/XofzEAu1cK/rVkThDwG22ZZaDlq1zP6Y
	 MqGvhioxOb9FJo3nztUP/nl6FZcdv/vd5h7NeCnS/pIUYxdS4JBzDfAHfXtig2fkWE
	 m0FaOLshT5XTvq30InLNG0aQ+qDhdlK7h+Lm21pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 321/379] media: amphion: handle firmware debug message
Date: Wed, 15 Nov 2023 14:26:36 -0500
Message-ID: <20231115192704.142815210@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 6496617b2b06d7004a5cbd53d48f19567d6b018c ]

decoder firmware may notify host some debug message,
it can help analyze the state of the firmware in case of error

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_defs.h    |  1 +
 drivers/media/platform/amphion/vpu_helpers.c |  1 +
 drivers/media/platform/amphion/vpu_malone.c  |  1 +
 drivers/media/platform/amphion/vpu_msgs.c    | 31 ++++++++++++++++----
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_defs.h b/drivers/media/platform/amphion/vpu_defs.h
index 667637eedb5d4..7320852668d64 100644
--- a/drivers/media/platform/amphion/vpu_defs.h
+++ b/drivers/media/platform/amphion/vpu_defs.h
@@ -71,6 +71,7 @@ enum {
 	VPU_MSG_ID_TIMESTAMP_INFO,
 	VPU_MSG_ID_FIRMWARE_XCPT,
 	VPU_MSG_ID_PIC_SKIPPED,
+	VPU_MSG_ID_DBG_MSG,
 };
 
 enum VPU_ENC_MEMORY_RESOURSE {
diff --git a/drivers/media/platform/amphion/vpu_helpers.c b/drivers/media/platform/amphion/vpu_helpers.c
index 2e78666322f02..66fdb0baea746 100644
--- a/drivers/media/platform/amphion/vpu_helpers.c
+++ b/drivers/media/platform/amphion/vpu_helpers.c
@@ -454,6 +454,7 @@ const char *vpu_id_name(u32 id)
 	case VPU_MSG_ID_UNSUPPORTED: return "unsupported";
 	case VPU_MSG_ID_FIRMWARE_XCPT: return "exception";
 	case VPU_MSG_ID_PIC_SKIPPED: return "skipped";
+	case VPU_MSG_ID_DBG_MSG: return "debug msg";
 	}
 	return "<unknown>";
 }
diff --git a/drivers/media/platform/amphion/vpu_malone.c b/drivers/media/platform/amphion/vpu_malone.c
index c2f4fb12c3b64..6b37453eef76c 100644
--- a/drivers/media/platform/amphion/vpu_malone.c
+++ b/drivers/media/platform/amphion/vpu_malone.c
@@ -726,6 +726,7 @@ static struct vpu_pair malone_msgs[] = {
 	{VPU_MSG_ID_UNSUPPORTED, VID_API_EVENT_UNSUPPORTED_STREAM},
 	{VPU_MSG_ID_FIRMWARE_XCPT, VID_API_EVENT_FIRMWARE_XCPT},
 	{VPU_MSG_ID_PIC_SKIPPED, VID_API_EVENT_PIC_SKIPPED},
+	{VPU_MSG_ID_DBG_MSG, VID_API_EVENT_DBG_MSG_DEC},
 };
 
 static void vpu_malone_pack_fs_alloc(struct vpu_rpc_event *pkt,
diff --git a/drivers/media/platform/amphion/vpu_msgs.c b/drivers/media/platform/amphion/vpu_msgs.c
index d0ead051f7d18..b74a407a19f22 100644
--- a/drivers/media/platform/amphion/vpu_msgs.c
+++ b/drivers/media/platform/amphion/vpu_msgs.c
@@ -23,6 +23,7 @@
 struct vpu_msg_handler {
 	u32 id;
 	void (*done)(struct vpu_inst *inst, struct vpu_rpc_event *pkt);
+	u32 is_str;
 };
 
 static void vpu_session_handle_start_done(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
@@ -154,7 +155,7 @@ static void vpu_session_handle_error(struct vpu_inst *inst, struct vpu_rpc_event
 {
 	char *str = (char *)pkt->data;
 
-	if (strlen(str))
+	if (*str)
 		dev_err(inst->dev, "instance %d firmware error : %s\n", inst->id, str);
 	else
 		dev_err(inst->dev, "instance %d is unsupported stream\n", inst->id);
@@ -180,6 +181,21 @@ static void vpu_session_handle_pic_skipped(struct vpu_inst *inst, struct vpu_rpc
 	vpu_inst_unlock(inst);
 }
 
+static void vpu_session_handle_dbg_msg(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
+{
+	char *str = (char *)pkt->data;
+
+	if (*str)
+		dev_info(inst->dev, "instance %d firmware dbg msg : %s\n", inst->id, str);
+}
+
+static void vpu_terminate_string_msg(struct vpu_rpc_event *pkt)
+{
+	if (pkt->hdr.num == ARRAY_SIZE(pkt->data))
+		pkt->hdr.num--;
+	pkt->data[pkt->hdr.num] = 0;
+}
+
 static struct vpu_msg_handler handlers[] = {
 	{VPU_MSG_ID_START_DONE, vpu_session_handle_start_done},
 	{VPU_MSG_ID_STOP_DONE, vpu_session_handle_stop_done},
@@ -193,9 +209,10 @@ static struct vpu_msg_handler handlers[] = {
 	{VPU_MSG_ID_PIC_DECODED, vpu_session_handle_pic_decoded},
 	{VPU_MSG_ID_DEC_DONE, vpu_session_handle_pic_done},
 	{VPU_MSG_ID_PIC_EOS, vpu_session_handle_eos},
-	{VPU_MSG_ID_UNSUPPORTED, vpu_session_handle_error},
-	{VPU_MSG_ID_FIRMWARE_XCPT, vpu_session_handle_firmware_xcpt},
+	{VPU_MSG_ID_UNSUPPORTED, vpu_session_handle_error, true},
+	{VPU_MSG_ID_FIRMWARE_XCPT, vpu_session_handle_firmware_xcpt, true},
 	{VPU_MSG_ID_PIC_SKIPPED, vpu_session_handle_pic_skipped},
+	{VPU_MSG_ID_DBG_MSG, vpu_session_handle_dbg_msg, true},
 };
 
 static int vpu_session_handle_msg(struct vpu_inst *inst, struct vpu_rpc_event *msg)
@@ -219,8 +236,12 @@ static int vpu_session_handle_msg(struct vpu_inst *inst, struct vpu_rpc_event *m
 		}
 	}
 
-	if (handler && handler->done)
-		handler->done(inst, msg);
+	if (handler) {
+		if (handler->is_str)
+			vpu_terminate_string_msg(msg);
+		if (handler->done)
+			handler->done(inst, msg);
+	}
 
 	vpu_response_cmd(inst, msg_id, 1);
 
-- 
2.42.0



