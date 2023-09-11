Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F10F9E1
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B489CC433C8;
	Mon, 11 Sep 2023 15:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445598;
	bh=TOcK9ayqp5H/7lAOEPAo+TdmxmjSXynnjpjnfqsTRVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EGfrKy9OfEeEMu6gxYqaGLLWKj6CGqsM40kw0p2gl3t/c6TLKR2Ihlg/qoIEiKBRa
	 4D+Dfx7Tmf/QTCfZLe7LmaZu12JRrZGDTjhuafre6Ppq+AL6AX78sdKLrMc35NAaCT
	 698i2r40iMwzAsTL8ENaUE6OaZTLrPzAdwLHmdXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/600] media: amphion: reinit vpu if reqbufs output 0
Date: Mon, 11 Sep 2023 15:47:18 +0200
Message-ID: <20230911134645.631921207@linuxfoundation.org>
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
index c08b5a2bfc1df..8edb313cd6358 100644
--- a/drivers/media/platform/amphion/vdec.c
+++ b/drivers/media/platform/amphion/vdec.c
@@ -1407,9 +1407,7 @@ static void vdec_release(struct vpu_inst *inst)
 {
 	if (inst->id != VPU_INST_NULL_ID)
 		vpu_trace(inst->dev, "[%d]\n", inst->id);
-	vpu_inst_lock(inst);
 	vdec_stop(inst, true);
-	vpu_inst_unlock(inst);
 }
 
 static void vdec_cleanup(struct vpu_inst *inst)
diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index a74953191c221..e5c8e1a753ccd 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -404,6 +404,11 @@ static int vpu_vb2_queue_setup(struct vb2_queue *vq,
 	for (i = 0; i < cur_fmt->num_planes; i++)
 		psize[i] = cur_fmt->sizeimage[i];
 
+	if (V4L2_TYPE_IS_OUTPUT(vq->type) && inst->state == VPU_CODEC_STATE_SEEK) {
+		vpu_trace(inst->dev, "reinit when VIDIOC_REQBUFS(OUTPUT, 0)\n");
+		call_void_vop(inst, release);
+	}
+
 	return 0;
 }
 
@@ -688,9 +693,9 @@ int vpu_v4l2_close(struct file *file)
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



