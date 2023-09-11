Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85024C8A
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A892C433C8;
	Mon, 11 Sep 2023 14:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443846;
	bh=dr8C2c8JleVUZd4cXnMecdEpH+nUJZeBamfBIY0tc0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSAraXEN4zoR0jZ/Xsh0B5dVuesvRIW/s3aSuFEaOl/Ue3Fu1DgGYtcxXDImb2/80
	 Dt4PxoJjIgmjzDxLTjMuUP3/LWLJALKB06UdUR5Qx2iM4IILbUtmSZx2H8uTkmBv49
	 sWJgvwhuWBiSCtwh6zJ1rwzspYyvxewGzyyw1mC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 495/737] media: amphion: reinit vpu if reqbufs output 0
Date: Mon, 11 Sep 2023 15:45:54 +0200
Message-ID: <20230911134704.402649149@linuxfoundation.org>
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

[ Upstream commit 73e3f09292a0492a3fe0f87a8170a74f12624c5e ]

according to v4l2 stateful decoder document 4.5.1.3. State Machine,
the state should change from seek to initialization
if call VIDIOC_REQBUFS(OUTPUT, 0).

so reinit the vpu decoder if reqbufs output 0

Fixes: 6de8d628df6e ("media: amphion: add v4l2 m2m vpu decoder stateful driver")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Tested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vdec.c     | 2 --
 drivers/media/platform/amphion/vpu_v4l2.c | 7 ++++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/amphion/vdec.c b/drivers/media/platform/amphion/vdec.c
index 6515f3cdb7a74..56c4deea4494d 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -1453,9 +1453,7 @@ static void vdec_release(struct vpu_inst *inst)
 {
 	if (inst->id != VPU_INST_NULL_ID)
 		vpu_trace(inst->dev, "[%d]\n", inst->id);
-	vpu_inst_lock(inst);
 	vdec_stop(inst, true);
-	vpu_inst_unlock(inst);
 }
 
 static void vdec_cleanup(struct vpu_inst *inst)
diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index 810e93d2c954a..8c9028df3bf42 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -489,6 +489,11 @@ static int vpu_vb2_queue_setup(struct vb2_queue *vq,
 	for (i = 0; i < cur_fmt->mem_planes; i++)
 		psize[i] = vpu_get_fmt_plane_size(cur_fmt, i);
 
+	if (V4L2_TYPE_IS_OUTPUT(vq->type) && inst->state == VPU_CODEC_STATE_SEEK) {
+		vpu_trace(inst->dev, "reinit when VIDIOC_REQBUFS(OUTPUT, 0)\n");
+		call_void_vop(inst, release);
+	}
+
 	return 0;
 }
 
@@ -773,9 +778,9 @@ int vpu_v4l2_close(struct file *file)
 		v4l2_m2m_ctx_release(inst->fh.m2m_ctx);
 		inst->fh.m2m_ctx = NULL;
 	}
+	call_void_vop(inst, release);
 	vpu_inst_unlock(inst);
 
-	call_void_vop(inst, release);
 	vpu_inst_unregister(inst);
 	vpu_inst_put(inst);
 
-- 
2.40.1



