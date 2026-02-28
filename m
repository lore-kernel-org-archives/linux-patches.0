Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0A6340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301001; cv=none; b=mJy944FH/CKQfmKXgv6iQJiepmLJPBbyVkHGfGKrpb2UjxDEXDXU52z3DD9XcUGgfYzIW5Tjf+bnpYwP3Gzj+45F8ONlTKv1UJyVtuvi3WIZG0+aKOkVI4gtey/wVBc7JOBAmeQ/a/8Fb3yBI92j2sAz7WDFPU3180oNOgBwJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301001; c=relaxed/simple;
	bh=hFQSfyc2sFzPu99hh9iKoECuRF196fks64pjmsKHxFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9farmZQOtI4ZmXnzy2rZht6vu5HewR5Fg0hVB0aJBpzsVAxO7sZUbeK3PSP8Ioz1CbmHrRKPojS7ChPosVErrhaBsmHJ3UCFzNV+D6+mClhAGQeTi3joSWsNsUyQS+lSxyIc5agp28BOoL9GzBDGDEI4+C2Xo5XND2zxcQjDf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crjHSMUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crjHSMUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2BBC116D0;
	Sat, 28 Feb 2026 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301001;
	bh=hFQSfyc2sFzPu99hh9iKoECuRF196fks64pjmsKHxFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crjHSMUbrSFNSR25zfleFxXWvD3Ck8OEvmRi1oFF2PqhwCP1wnviVpVDQoXZAffeG
	 DErjdJSOF4wrHNJK70s+p5hQgvn59f9RBhJcgcAt0ArFBhRy5rDKC+2T+dQxzZKBdn
	 lVOE2dd+KBWa/hZNEN373PrzvnWq4blFb1nX6oNZWJzzVYD2mKrE6RoNtcn8oaLMcX
	 zH/9E+7/PyIP8pt0v3Vy7x7C8N/MUFKgvPzao8bxJLRg2UCBQBdgf0XfEPixlA+4I+
	 9GuuPsQGDo/uXK8RkqMQf0ySSpfu0+w6tNIoFit3jqYNNn5GpEGCPMZ9KUN70y/1ZI
	 8Iuc+3bKQu5iQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Brandon Brnich <b-brnich@ti.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 134/752] media: chips-media: wave5: Process ready frames when CMD_STOP sent to Encoder
Date: Sat, 28 Feb 2026 12:37:25 -0500
Message-ID: <20260228174750.1542406-134-sashal@kernel.org>
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

[ Upstream commit 5da0380de41439ed64ed9a5218850db38544e315 ]

CMD_STOP being sent to encoder before last job is executed by device_run
can lead to an occasional dropped frame. Ensure that remaining ready
buffers are drained by making a call to v4l2_m2m_try_schedule.

Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
index a11f0f7c7d7b0..a254830e4009e 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -649,6 +649,8 @@ static int wave5_vpu_enc_encoder_cmd(struct file *file, void *fh, struct v4l2_en
 
 		m2m_ctx->last_src_buf = v4l2_m2m_last_src_buf(m2m_ctx);
 		m2m_ctx->is_draining = true;
+
+		v4l2_m2m_try_schedule(m2m_ctx);
 		break;
 	case V4L2_ENC_CMD_START:
 		break;
-- 
2.51.0

