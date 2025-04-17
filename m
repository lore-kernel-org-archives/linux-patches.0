Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AE31DB148;
	Thu, 17 Apr 2025 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913307; cv=none; b=K52yQ+hBvPTOLEx2exeIzrnKatg4yWmCMpB5qJo6v1p9f+WLi3bhBNd7LCg9B5rynKUsW/7BgMsA8MSRqbdIhfgaLzHs+AOjeDimnVx6CENOXE49sSLu0+rAbFLUdt8W775TfvUnaKibYMv1YSddk0biHX4IkJRhGubXEBpNtLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913307; c=relaxed/simple;
	bh=je6ty7ChTIH8R2jlh4nUOD4hI+D5aslCov8d1fwxnT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4Z1l1ApfQk4J8Nui3AtNe98QpEl/nP+Vgu8O4JRhjsmAGm3e0MPZR3/Gab+9dEWZrBVbVs5R7rus7U37uX0jbD0FnZ3gf6nAZ8FoOy7sQcsw9dArVro80pFbdmrK6StyViS4Feq1EkG7muw2qN3RcNNx2SkRS+n6irAxeEh+cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GjRuuIV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GjRuuIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC55BC4CEE4;
	Thu, 17 Apr 2025 18:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913307;
	bh=je6ty7ChTIH8R2jlh4nUOD4hI+D5aslCov8d1fwxnT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GjRuuIVawerINPYCAh6ZdrdPahYhG4HeoeSJyDHvAWSGoMoTWtKUyDb+mpKUucc5
	 AhQdz5+ySp7iFnk7C8Dyd8gTE9VdmpcF6pqn8oZa6n2lJr+YeHnpOEeokuj+LwFN2x
	 9fI+KV4ytWDAdN4aFDIg/xaQ5sizzxWFtj2JJEXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jackson.lee" <jackson.lee@chipsnmedia.com>,
	Nas Chung <nas.chung@chipsnmedia.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 265/449] media: chips-media: wave5: Fix a hang after seeking
Date: Thu, 17 Apr 2025 19:49:13 +0200
Message-ID: <20250417175128.689150510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackson.lee <jackson.lee@chipsnmedia.com>

commit a2c75e964e51b096e9fe6adfa3eaed53594a668b upstream.

While seeking, the driver calls the flush command. Before the flush
command is sent to the VPU, the driver should handle the display buffer
flags and should get all decoded information from the VPU if the VCORE
is running.

Fixes: 9707a6254a8a ("media: chips-media: wave5: Add the v4l2 layer")
Cc: stable@vger.kernel.org
Signed-off-by: Jackson.lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nas Chung <nas.chung@chipsnmedia.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c |   17 ++++++++++++++-
 drivers/media/platform/chips-media/wave5/wave5-vpuapi.c  |   10 ++++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1369,6 +1369,16 @@ static int streamoff_output(struct vb2_q
 	struct vb2_v4l2_buffer *buf;
 	int ret;
 	dma_addr_t new_rd_ptr;
+	struct dec_output_info dec_info;
+	unsigned int i;
+
+	for (i = 0; i < v4l2_m2m_num_dst_bufs_ready(m2m_ctx); i++) {
+		ret = wave5_vpu_dec_set_disp_flag(inst, i);
+		if (ret)
+			dev_dbg(inst->dev->dev,
+				"%s: Setting display flag of buf index: %u, fail: %d\n",
+				__func__, i, ret);
+	}
 
 	while ((buf = v4l2_m2m_src_buf_remove(m2m_ctx))) {
 		dev_dbg(inst->dev->dev, "%s: (Multiplanar) buf type %4u | index %4u\n",
@@ -1376,6 +1386,11 @@ static int streamoff_output(struct vb2_q
 		v4l2_m2m_buf_done(buf, VB2_BUF_STATE_ERROR);
 	}
 
+	while (wave5_vpu_dec_get_output_info(inst, &dec_info) == 0) {
+		if (dec_info.index_frame_display >= 0)
+			wave5_vpu_dec_set_disp_flag(inst, dec_info.index_frame_display);
+	}
+
 	ret = wave5_vpu_flush_instance(inst);
 	if (ret)
 		return ret;
@@ -1459,7 +1474,7 @@ static void wave5_vpu_dec_stop_streaming
 			break;
 
 		if (wave5_vpu_dec_get_output_info(inst, &dec_output_info))
-			dev_dbg(inst->dev->dev, "Getting decoding results from fw, fail\n");
+			dev_dbg(inst->dev->dev, "there is no output info\n");
 	}
 
 	v4l2_m2m_update_stop_streaming_state(m2m_ctx, q);
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
@@ -75,6 +75,16 @@ int wave5_vpu_flush_instance(struct vpu_
 				 inst->type == VPU_INST_TYPE_DEC ? "DECODER" : "ENCODER", inst->id);
 			mutex_unlock(&inst->dev->hw_lock);
 			return -ETIMEDOUT;
+		} else if (ret == -EBUSY) {
+			struct dec_output_info dec_info;
+
+			mutex_unlock(&inst->dev->hw_lock);
+			wave5_vpu_dec_get_output_info(inst, &dec_info);
+			ret = mutex_lock_interruptible(&inst->dev->hw_lock);
+			if (ret)
+				return ret;
+			if (dec_info.index_frame_display > 0)
+				wave5_vpu_dec_set_disp_flag(inst, dec_info.index_frame_display);
 		}
 	} while (ret != 0);
 	mutex_unlock(&inst->dev->hw_lock);


