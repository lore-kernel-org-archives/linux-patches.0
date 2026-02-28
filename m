Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77F6355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301000; cv=none; b=Isw+C5OGG001WQV+TdZdGY7ikD1SMcc95WZAOFmNx48mLqX+EKco01dO5C03U1rb/ieWIP9J3oqfdgzpPVs4i+ZhmU+DlTTYO39rSDmqYERt+6DYaoQ5APSJ1ozcV+MJ5VE3ngVDisGAk2cvuCUpm2lbmruiT6TbIZdim4RwA8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301000; c=relaxed/simple;
	bh=hXFZmuqxr72Et5WWnpswSxvsRGJlQHJGxp3QLH3btng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiThePkwMKgrfe/lCjjrGBLgJBTbFe/5yD+h8vaUaUcVlmbVLAolYWrsknEkRZGYQRfGeoppfrH22z+yJ414u/4gMAnYtSza7dBDw28KXtA7P7FilMCX3ozQv0ouZDg5qT3Hfw2IbfNnCyeAR2Zb7L1yDcJuhVwdAsA5BVU/RH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fasyhepY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fasyhepY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E913DC19425;
	Sat, 28 Feb 2026 17:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301000;
	bh=hXFZmuqxr72Et5WWnpswSxvsRGJlQHJGxp3QLH3btng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fasyhepYk7/2dB5dffJSy4uJk7sLYNMRhwGUSVA6ej0/sdKmsdCuS2Et5EBBJf4e7
	 7+Fu/mGaxnzfHyYaJ/uRuK7QFSn/5CyGNHGybqqvyncBH8ujxs2He1LkmZPBgY29pH
	 fJNqwIcQArMQTqaznhwdhiLHSD9Gly9MqdG7ClM5vnJkG8pY1Bgt+XAXzpAgYMa5NQ
	 gKDpxqEMoIeupy76ZS52Tey7YlsFz+lhBML8ciJk7suVunBSYhRbzMVRFyjnZa2/xE
	 UNBRPR6j4FNphwBn/DZQsVuqYDe1zz11y6j6aLeDhIUF7Ii2Nf5c3u4usY5/4S74Gn
	 KlT0X6PMssXGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brandon Brnich <b-brnich@ti.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/752] media: chips-media: wave5: Fix conditional in start_streaming
Date: Sat, 28 Feb 2026 12:37:24 -0500
Message-ID: <20260228174750.1542406-133-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Brandon Brnich <b-brnich@ti.com>

[ Upstream commit b4e26c6fc1b3c225caf80d4a95c6f9fcbe959e17 ]

When STREAMON(CAP) is called after STREAMON(OUT), the driver was failing to
switch states from VPU_INST_STATE_OPEN to VPU_INST_STATE_INIT_SEQ and
VPU_INST_STATE_PIC_RUN because the capture queue streaming boolean had not
yet been set to true. This led to a hang in the encoder since the state
was stuck in VPU_INST_STATE_OPEN. During the second call to
start_streaming, the sequence initialization and frame buffer allocation
should occur.

Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
index 94fb5d7c87021..a11f0f7c7d7b0 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -1367,7 +1367,8 @@ static int wave5_vpu_enc_start_streaming(struct vb2_queue *q, unsigned int count
 		if (ret)
 			goto return_buffers;
 	}
-	if (inst->state == VPU_INST_STATE_OPEN && m2m_ctx->cap_q_ctx.q.streaming) {
+	if (inst->state == VPU_INST_STATE_OPEN &&
+	    (m2m_ctx->cap_q_ctx.q.streaming || q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)) {
 		ret = initialize_sequence(inst);
 		if (ret) {
 			dev_warn(inst->dev->dev, "Sequence not found: %d\n", ret);
-- 
2.51.0

