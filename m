Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 502B84C8A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:49:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7287BC433C7;
	Mon, 11 Sep 2023 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443792;
	bh=idLXzkRPSHaRBpiJDkuPcznMRVc/x353scXWBKj7XS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAaPYa8Q4y2oWDrYm+JkRZDSbQd0oFTUEBccK+ZkkjqU19lhYSCDOBN9/7y+yKV5D
	 NWCCZwsVZT/+TonhNIM62qc9Wwk+4tOw607kw6YKlkl7bSjQBJlmAtk8zy5Rzu83MH
	 1a3T3tEY7BDVkF8MkFoQT5OAedtycgwmeFG4E6Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 503/737] media: amphion: fix UNINIT issues reported by coverity
Date: Mon, 11 Sep 2023 15:46:02 +0200
Message-ID: <20230911134704.621035317@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit c224d0497a31ea2d173e1ea16af308945bff9037 ]

using uninitialized value may introduce risk

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_msgs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_msgs.c b/drivers/media/platform/amphion/vpu_msgs.c
index f9eb488d1b5e2..d0ead051f7d18 100644
--- a/drivers/media/platform/amphion/vpu_msgs.c
+++ b/drivers/media/platform/amphion/vpu_msgs.c
@@ -32,7 +32,7 @@ static void vpu_session_handle_start_done(struct vpu_inst *inst, struct vpu_rpc_
 
 static void vpu_session_handle_mem_request(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
 {
-	struct vpu_pkt_mem_req_data req_data;
+	struct vpu_pkt_mem_req_data req_data = { 0 };
 
 	vpu_iface_unpack_msg_data(inst->core, pkt, (void *)&req_data);
 	vpu_trace(inst->dev, "[%d] %d:%d %d:%d %d:%d\n",
@@ -80,7 +80,7 @@ static void vpu_session_handle_resolution_change(struct vpu_inst *inst, struct v
 
 static void vpu_session_handle_enc_frame_done(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
 {
-	struct vpu_enc_pic_info info;
+	struct vpu_enc_pic_info info = { 0 };
 
 	vpu_iface_unpack_msg_data(inst->core, pkt, (void *)&info);
 	dev_dbg(inst->dev, "[%d] frame id = %d, wptr = 0x%x, size = %d\n",
@@ -90,7 +90,7 @@ static void vpu_session_handle_enc_frame_done(struct vpu_inst *inst, struct vpu_
 
 static void vpu_session_handle_frame_request(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
 {
-	struct vpu_fs_info fs;
+	struct vpu_fs_info fs = { 0 };
 
 	vpu_iface_unpack_msg_data(inst->core, pkt, &fs);
 	call_void_vop(inst, event_notify, VPU_MSG_ID_FRAME_REQ, &fs);
@@ -107,7 +107,7 @@ static void vpu_session_handle_frame_release(struct vpu_inst *inst, struct vpu_r
 		info.type = inst->out_format.type;
 		call_void_vop(inst, buf_done, &info);
 	} else if (inst->core->type == VPU_CORE_TYPE_DEC) {
-		struct vpu_fs_info fs;
+		struct vpu_fs_info fs = { 0 };
 
 		vpu_iface_unpack_msg_data(inst->core, pkt, &fs);
 		call_void_vop(inst, event_notify, VPU_MSG_ID_FRAME_RELEASE, &fs);
@@ -122,7 +122,7 @@ static void vpu_session_handle_input_done(struct vpu_inst *inst, struct vpu_rpc_
 
 static void vpu_session_handle_pic_decoded(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
 {
-	struct vpu_dec_pic_info info;
+	struct vpu_dec_pic_info info = { 0 };
 
 	vpu_iface_unpack_msg_data(inst->core, pkt, (void *)&info);
 	call_void_vop(inst, get_one_frame, &info);
@@ -130,7 +130,7 @@ static void vpu_session_handle_pic_decoded(struct vpu_inst *inst, struct vpu_rpc
 
 static void vpu_session_handle_pic_done(struct vpu_inst *inst, struct vpu_rpc_event *pkt)
 {
-	struct vpu_dec_pic_info info;
+	struct vpu_dec_pic_info info = { 0 };
 	struct vpu_frame_info frame;
 
 	memset(&frame, 0, sizeof(frame));
-- 
2.40.1



