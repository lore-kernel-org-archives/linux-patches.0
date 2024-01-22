Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3B8657D6;
	Tue, 23 Jan 2024 01:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975096; cv=none; b=LmgHQlB+SZwac0Obxg3DegqgY2WhvU4uaHSkKLxroYd2GRyKdRW5rIlgifAgwG17dxXwsKhKdx1C6T5Udu5gHv2Do5ndrq1y8kYrq0WOab5X/jdEGy6uXVbU0BJNGCCDNOD5ec/HZavrNpCyrDshyBrQw4qW8lyQzvJghy0tPlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975096; c=relaxed/simple;
	bh=H+D6oSkASw7LpeZbS+E1qQDaN+e7e6NQhp+ckvaqvjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzJQTox2cd4XTMvJc+BEs4iuAayyFP98Uz9trUdDIeOGCQhxt6FgBp1+Ck74mTGaVEzzxYHyCd+ON2JlYehPC0JDimE5WFceKIVzTzm8vASV3KhhU3Si/Tdvj/nS4g22Hke5p2ulG0d8yyiXtrA+uE6jc1ZP8sg4czwqMamjaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWBqQ49W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWBqQ49W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A74C433C7;
	Tue, 23 Jan 2024 01:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975096;
	bh=H+D6oSkASw7LpeZbS+E1qQDaN+e7e6NQhp+ckvaqvjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qWBqQ49WrjrBDpECFJD0nwMJY7ZB0pp6aaT1A8N5zP1D/mikzpxu8AYqGlnsE9kL/
	 spedCKv5pQx9RbZLIloKKG1bM93j0FCAG33zpl3WCz49Qk/Q0npBzhXoD4EjM8emCf
	 WHCASgTumV93e2RUFeFtAgixi5Bg501mjyJKx2dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/583] media: verisilicon: Hook the (TRY_)DECODER_CMD stateless ioctls
Date: Mon, 22 Jan 2024 15:54:47 -0800
Message-ID: <20240122235819.212825154@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 50ec24c753e9..1874c976081f 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -904,6 +904,8 @@ static int hantro_add_func(struct hantro_dev *vpu, unsigned int funcid)
 
 	if (funcid == MEDIA_ENT_F_PROC_VIDEO_ENCODER) {
 		vpu->encoder = func;
+		v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
+		v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
 	} else {
 		vpu->decoder = func;
 		v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
diff --git a/drivers/media/platform/verisilicon/hantro_v4l2.c b/drivers/media/platform/verisilicon/hantro_v4l2.c
index b3ae037a50f6..db145519fc5d 100644
--- a/drivers/media/platform/verisilicon/hantro_v4l2.c
+++ b/drivers/media/platform/verisilicon/hantro_v4l2.c
@@ -785,6 +785,9 @@ const struct v4l2_ioctl_ops hantro_ioctl_ops = {
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



