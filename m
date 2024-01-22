Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA0F131748;
	Tue, 23 Jan 2024 00:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969455; cv=none; b=quiYnUHEnepou4568KbFikSPm62raYdyVVg0iUzIJXp1PPoTPqlKDSWglXMLgtnzIZkrzVuKLF29UrLwZBbq2YDzwE0q34okdyO1NhqJpLMl4gl9ByS51d+0vTP2aZCnISWoxs82bKS+2ajXm2K1Z7yCk0B0JYwtXalW479tHF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969455; c=relaxed/simple;
	bh=7u0E+sD0Pi1a0D+hFZItmijN3JIGgxZVQRSMMPFkhTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcgkYJqBOWjmAct/HnYlLzTRSg/g3UFd8PR+GH6iqu/uStjvOzrIWN+JFUQUqhFmAUODx3mPAI31DBP4Y2rpqKvHswDYhHc61OLLZen3I5UfI4OwEQiVDa4gkly5XoEEXGgbJYbMznmtzVSixbHYnhFt6c1ZL+0jhukc+q4dSoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3Y6DBKa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3Y6DBKa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F78C433F1;
	Tue, 23 Jan 2024 00:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969455;
	bh=7u0E+sD0Pi1a0D+hFZItmijN3JIGgxZVQRSMMPFkhTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3Y6DBKaML9LvDCam6txXzv49fg6YGn6mdnS8RTA5I8nV6NIRdzEZx1fxRSEt/Sv6
	 DYg7opxdci0iZ7lp2dQaBmJuT+/juH3h/KiPzIdkx2cP2DTv01RIvrCrQZqLYxFpKX
	 YxRPErDziOMYooUtOhUI+5Wm5jMPDj0atPlLblvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 256/641] media: visl: Hook the (TRY_)DECODER_CMD stateless ioctls
Date: Mon, 22 Jan 2024 15:52:40 -0800
Message-ID: <20240122235825.931503878@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit 3907f6ef8e0d55a88cdb0f7238363d24e26790ca ]

The (TRY_)DECODER_CMD ioctls are used to support flushing when holding
capture buffers is supported. This is the case of this driver but the
ioctls were never hooked to the ioctl ops.

Add them to correctly support flushing.

Fixes: 0c078e310b6d ("media: visl: add virtual stateless decoder driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/visl/visl-video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/test-drivers/visl/visl-video.c b/drivers/media/test-drivers/visl/visl-video.c
index 7cac6a6456eb..9303a3e118d7 100644
--- a/drivers/media/test-drivers/visl/visl-video.c
+++ b/drivers/media/test-drivers/visl/visl-video.c
@@ -525,6 +525,9 @@ const struct v4l2_ioctl_ops visl_ioctl_ops = {
 	.vidioc_streamon		= v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff		= v4l2_m2m_ioctl_streamoff,
 
+	.vidioc_decoder_cmd		= v4l2_m2m_ioctl_stateless_decoder_cmd,
+	.vidioc_try_decoder_cmd		= v4l2_m2m_ioctl_stateless_try_decoder_cmd,
+
 	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
-- 
2.43.0



