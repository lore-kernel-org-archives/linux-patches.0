Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817D91097C
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03147C433C8;
	Mon, 11 Sep 2023 15:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445609;
	bh=pOYDOzjoVardfd6S4obBJIeYyq5ax8M8LMu6d93QtgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGi+Tif9hjMa88S7mRZyrdBA9aKKgIjrpFIrDy7lxlS0XXqJ5pwyOXZH8suwbSB1j
	 IVE8J0ass9KJzlBLxbrRDV1flY2xxxghvouaCRUoekzYNroY5pTWyNc+/Fl0KpXTuL
	 AfmMCoZASWFaSatfSX2nkk+xb0n0kqpCRaPLr1ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 409/600] media: amphion: fix CHECKED_RETURN issues reported by coverity
Date: Mon, 11 Sep 2023 15:47:22 +0200
Message-ID: <20230911134645.750430208@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

[ Upstream commit b237b058adbc7825da9c8f358f1ff3f0467d623a ]

calling "vpu_cmd_send/vpu_get_buffer_state/vpu_session_alloc_fs"
without checking return value

Fixes: 9f599f351e86 ("media: amphion: add vpu core driver")
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c     |  5 ++++-
 drivers/media/platform/amphion/vpu_cmds.c |  3 ++-
 drivers/media/platform/amphion/vpu_dbg.c  | 11 +++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index b4cdd23c38af2..dc35a87e628ec 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -957,6 +957,7 @@ static int vdec_response_frame_abnormal(struct vpu_inst *inst)
 {
 	struct vdec_t *vdec = inst->priv;
 	struct vpu_fs_info info;
+	int ret;
 
 	if (!vdec->req_frame_count)
 		return 0;
@@ -964,7 +965,9 @@ static int vdec_response_frame_abnormal(struct vpu_inst *inst)
 	memset(&info, 0, sizeof(info));
 	info.type = MEM_RES_FRAME;
 	info.tag = vdec->seq_tag + 0xf0;
-	vpu_session_alloc_fs(inst, &info);
+	ret = vpu_session_alloc_fs(inst, &info);
+	if (ret)
+		return ret;
 	vdec->req_frame_count--;
 
 	return 0;
diff --git a/drivers/media/platform/amphion/vpu_cmds.c b/drivers/media/platform/amphion/vpu_cmds.c
index 647d94554fb5d..7e137f276c3b1 100644
--- a/drivers/media/platform/amphion/vpu_cmds.c
+++ b/drivers/media/platform/amphion/vpu_cmds.c
@@ -306,7 +306,8 @@ static void vpu_core_keep_active(struct vpu_core *core)
 
 	dev_dbg(core->dev, "try to wake up\n");
 	mutex_lock(&core->cmd_lock);
-	vpu_cmd_send(core, &pkt);
+	if (vpu_cmd_send(core, &pkt))
+		dev_err(core->dev, "fail to keep active\n");
 	mutex_unlock(&core->cmd_lock);
 }
 
diff --git a/drivers/media/platform/amphion/vpu_dbg.c b/drivers/media/platform/amphion/vpu_dbg.c
index bf8aded76e141..f105da82d92f9 100644
--- a/drivers/media/platform/amphion/vpu_dbg.c
+++ b/drivers/media/platform/amphion/vpu_dbg.c
@@ -50,6 +50,13 @@ static char *vpu_stat_name[] = {
 	[VPU_BUF_STATE_ERROR] = "error",
 };
 
+static inline const char *to_vpu_stat_name(int state)
+{
+	if (state <= VPU_BUF_STATE_ERROR)
+		return vpu_stat_name[state];
+	return "unknown";
+}
+
 static int vpu_dbg_instance(struct seq_file *s, void *data)
 {
 	struct vpu_inst *inst = s->private;
@@ -141,7 +148,7 @@ static int vpu_dbg_instance(struct seq_file *s, void *data)
 		num = scnprintf(str, sizeof(str),
 				"output [%2d] state = %10s, %8s\n",
 				i, vb2_stat_name[vb->state],
-				vpu_stat_name[vpu_get_buffer_state(vbuf)]);
+				to_vpu_stat_name(vpu_get_buffer_state(vbuf)));
 		if (seq_write(s, str, num))
 			return 0;
 	}
@@ -156,7 +163,7 @@ static int vpu_dbg_instance(struct seq_file *s, void *data)
 		num = scnprintf(str, sizeof(str),
 				"capture[%2d] state = %10s, %8s\n",
 				i, vb2_stat_name[vb->state],
-				vpu_stat_name[vpu_get_buffer_state(vbuf)]);
+				to_vpu_stat_name(vpu_get_buffer_state(vbuf)));
 		if (seq_write(s, str, num))
 			return 0;
 	}
-- 
2.40.1



