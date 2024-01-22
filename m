Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B0662A0F;
	Tue, 23 Jan 2024 00:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971130; cv=none; b=A9yN+ZVdPuAC1lhDosN017K4f7eFOKMndhDueOPoBOSCPp5RvxfWTMn7hBTGtfoWY77WcPH7MfPhrXYdHxrCTeG/NwGnfCEZr/p0bIxCU20Gqksw+PZ0aikDFRyHJB6b1auf5P4fOvAdmfj/jTTX9kz/OF2lIIVeLaMtj1BLtPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971130; c=relaxed/simple;
	bh=4/4+US68vJiWJt1tfkE0R2/V7jdtxifGgcRzsFZhSTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFo0+/i15xwZSkJH+lAcXi4UBSnT5Wi4vU/0ddBFmYDq2SlhB0RJyS/h041QMbocUJZoXeTZBmrejIQoxD3ZeJ6keitmnxyrbjS+RrPz0KUQdfKpZCY3DQu/muIbTy3R5ifpLOfSKJn7HtGyHqh3CsXmV5yGDooghhFXf0cJvWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rh3qdb5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rh3qdb5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B99C43390;
	Tue, 23 Jan 2024 00:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971130;
	bh=4/4+US68vJiWJt1tfkE0R2/V7jdtxifGgcRzsFZhSTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rh3qdb5avVJ/U9mfTNIhqa1oq6Vpt8rF5uW5G8nKp99Rjj9P1svXt3VT3w/tnAydM
	 tC8k86ACDW/LC9hE2WHUdMCErlPxVy7hrPVDpeF7c8PRW97mSuPygXcvZ5sK4goLrt
	 1wzC3ELxXYYW8yDHtC/j84U1We1TLmN6S0rksfpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 169/417] media: rkvdec: Hook the (TRY_)DECODER_CMD stateless ioctls
Date: Mon, 22 Jan 2024 15:55:37 -0800
Message-ID: <20240122235757.706525484@linuxfoundation.org>
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

[ Upstream commit 1fb7b5ab62113b29ce331464048d8c39e58fd08a ]

The (TRY_)DECODER_CMD ioctls are used to support flushing when holding
capture buffers is supported. This is the case of this driver but the
ioctls were never hooked to the ioctl ops.

Add them to correctly support flushing.

Fixes: ed7bb87d3d03 ("media: rkvdec: Enable capture buffer holding for H264")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index a9bd1e71ea48..d16cf4115d03 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -461,6 +461,9 @@ static const struct v4l2_ioctl_ops rkvdec_ioctl_ops = {
 
 	.vidioc_streamon = v4l2_m2m_ioctl_streamon,
 	.vidioc_streamoff = v4l2_m2m_ioctl_streamoff,
+
+	.vidioc_decoder_cmd = v4l2_m2m_ioctl_stateless_decoder_cmd,
+	.vidioc_try_decoder_cmd = v4l2_m2m_ioctl_stateless_try_decoder_cmd,
 };
 
 static int rkvdec_queue_setup(struct vb2_queue *vq, unsigned int *num_buffers,
-- 
2.43.0



