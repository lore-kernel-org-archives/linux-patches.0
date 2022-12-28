Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4090C1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC215C433D2;
	Wed, 28 Dec 2022 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241905;
	bh=Xk66tH2iV0OR8+SvTwybRbAg4iABqr6V7kiaqrqBaCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zX6t+1AfVDoPDneypdizLh3YWeP6sfUDRIdThPRK84VEPZTpF4O2POkn/FhaLgAR3
	 acUR49f5in5s1WGNZMSAbd17+TyMIgYzZRMjH20jlU/hxwTZsf98iLzn24LEY3YyFc
	 SmGZbukc/fv/qKxLb/lE268oPSwIlWd9b+tL9WGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0342/1073] media: amphion: apply vb2_queue_error instead of setting manually
Date: Wed, 28 Dec 2022 15:32:10 +0100
Message-Id: <20221228144337.295732275@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Qian <ming.qian@nxp.com>

[ Upstream commit 9d175a81e28f260916a0a13f457dd8b940eafb4e ]

vb2_queue_error is help to set the error of vb2_queue,
don't need to set it manually

Fixes: 3cd084519c6f ("media: amphion: add vpu v4l2 m2m support")
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/amphion/vpu_v4l2.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/amphion/vpu_v4l2.c b/drivers/media/platform/amphion/vpu_v4l2.c
index b779e0ba916c..4b714fab4c6b 100644
--- a/drivers/media/platform/amphion/vpu_v4l2.c
+++ b/drivers/media/platform/amphion/vpu_v4l2.c
@@ -65,18 +65,11 @@ unsigned int vpu_get_buffer_state(struct vb2_v4l2_buffer *vbuf)
 
 void vpu_v4l2_set_error(struct vpu_inst *inst)
 {
-	struct vb2_queue *src_q;
-	struct vb2_queue *dst_q;
-
 	vpu_inst_lock(inst);
 	dev_err(inst->dev, "some error occurs in codec\n");
 	if (inst->fh.m2m_ctx) {
-		src_q = v4l2_m2m_get_src_vq(inst->fh.m2m_ctx);
-		dst_q = v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx);
-		src_q->error = 1;
-		dst_q->error = 1;
-		wake_up(&src_q->done_wq);
-		wake_up(&dst_q->done_wq);
+		vb2_queue_error(v4l2_m2m_get_src_vq(inst->fh.m2m_ctx));
+		vb2_queue_error(v4l2_m2m_get_dst_vq(inst->fh.m2m_ctx));
 	}
 	vpu_inst_unlock(inst);
 }
-- 
2.35.1



