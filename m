Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DEE627F7;
	Tue, 23 Jan 2024 00:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971082; cv=none; b=Ua+qRojYVUCrNJfYEVblQV8jx0yRGi6wMo9ilk2BE4QpW21h17zo2H3l3xMstiWFCaf9+Bn28INqiYO2SNBtR8JPZeAg2OVw7LhVmhOzKicNGLDhNCSZiSqmVbN2aoKJDsF8sk+9O/c0EzmNLb5P/8wJUaT+ckwGcMSN/k6lLTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971082; c=relaxed/simple;
	bh=T+OOGixbI8xiM5GjiE1dT8gvmuMYnudW46nu3Io9nvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJQ6jD77Fb1Ki7C0oDG0o3Q+5JwYcGMeKY/KNQ4ySMT255AlKrP54LVihoALDuWKeSMsqHEOB+DqAi+9DPnHXkvGwQCXq+bG7OiSJ+RLltPsO9BPlqP/X8C3Tvb1HkDB8K4X5UCy04gA5Vvehi11YvtEBEvbRqOwrygmb0eIA7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QN2/VQvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QN2/VQvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3774C433F1;
	Tue, 23 Jan 2024 00:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971082;
	bh=T+OOGixbI8xiM5GjiE1dT8gvmuMYnudW46nu3Io9nvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QN2/VQvbjtTURmtFrqz5XmYAsaKuzRwZ5Kfzgtm5mvDJdSpgsriukcS2hrurN4qJ1
	 mKDJ227lhfN5lfRZGcv1sX5fVvHXGdDU7Sr1iLItp2QUT89Fmjm5oz9oYe8S8qOqCw
	 H/yXNmj/8+KYLWJ7kzhInL/SGS1R3YCmUSagFtCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/417] media: verisilicon: Hook the (TRY_)DECODER_CMD stateless ioctls
Date: Mon, 22 Jan 2024 15:55:36 -0800
Message-ID: <20240122235757.669289680@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 6c0d9e12b1d12bbd95484e4b99f63feeb423765f ]

The (TRY_)DECODER_CMD ioctls are used to support flushing when holding
capture buffers is supported. This is the case of this driver but the
ioctls were never hooked to the ioctl ops.

Add them to correctly support flushing.

Fixes: 340ce50f75a6 ("media: hantro: Enable HOLD_CAPTURE_BUF for H.264")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_drv.c  | 2 ++
 drivers/media/platform/verisilicon/hantro_v4l2.c | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 08840ba313e7..69a2442f3122 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -813,6 +813,8 @@ static int hantro_add_func(struct hantro_dev *vpu, unsigned int funcid)
 
 	if (funcid == MEDIA_ENT_F_PROC_VIDEO_ENCODER) {
 		vpu->encoder = func;
+		v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
 	} else {
 		vpu->decoder = func;
 		v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index 30e650edaea8..b2da48936e3f 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -759,6 +759,9 @@ const struct v4l2_ioctl_ops hantro_ioctl_ops = {
 	.vidioc_g_selection = vidioc_g_selection,
 	.vidioc_s_selection = vidioc_s_selection,
 
+	.vidioc_decoder_cmd = v4l2_m2m_ioctl_stateless_decoder_cmd,
+	.vidioc_try_decoder_cmd = v4l2_m2m_ioctl_stateless_try_decoder_cmd,
+
 	.vidioc_try_encoder_cmd = v4l2_m2m_ioctl_try_encoder_cmd,
 	.vidioc_encoder_cmd = vidioc_encoder_cmd,
 };
-- 
2.43.0



