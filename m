Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1423C24;
	Tue, 23 Jan 2024 00:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969459; cv=none; b=IxLDFd9OgQggkRQJlsV4uKJKRDAi85h28m83J8pbV9OPkPrO/yiEST1xxXaU4WGwQX+luVIHCXgzGj8mGWUIndEK+CD+bOa0HGOccZzJzxSHef3RpUcMRa3cjad7LONkgX75zMRLJnKjbkP+gNDGryom87lplG5RlKEMh0sxgEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969459; c=relaxed/simple;
	bh=PdAMRBuZeIh8yDnAcXX34z3E9kNlJCcSevDaUdHrYXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKB1D8Rz9iGeAn2PxUliAaG0QxaAXH+Z4MOkHgnL4bb4MHoeqWPmdtlBymYZ+hDsO8zQL9/ac2hY5Io3TAJJ4dDXekONjqeQJhQXA5Z6LkFd4tDyC+7OwbDuGfxjQbR9j6klN5vOm7N6WtyagOLk8BLnf2P4053a+NouJXJ7gsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edheryGw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edheryGw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7F8C43390;
	Tue, 23 Jan 2024 00:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969458;
	bh=PdAMRBuZeIh8yDnAcXX34z3E9kNlJCcSevDaUdHrYXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edheryGwpGcMreH4vmrpe6nMu20ZgtZfEM4H8eS5EWDihEW+T5fnd59+ktET5nceG
	 T2wvO4pbUmoeQ4GNtPfSob9Lza8nkW04mz9+RH76ExOsWqr2GPfJDa3SZWZvLEtEKf
	 0//USqzzBwABFlvdeFe5Ao+dfaLMyUaM21IHkYcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 258/641] media: rkvdec: Hook the (TRY_)DECODER_CMD stateless ioctls
Date: Mon, 22 Jan 2024 15:52:42 -0800
Message-ID: <20240122235826.003283258@linuxfoundation.org>
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
index 84a41792cb4b..ac398b5a9736 100644
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



