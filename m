Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8972270545;
	Wed, 20 May 2026 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303063; cv=none; b=GzmrESvlf1QEvnnuzPFIPanEKRHrZGGJiU0OXay8Q7krSszBXsodVbGXnWSadzFk/UT2oIMCGKeB7oYtytswHgnV/vK1k7deZddayfm+bpStjlMl3UzeHRMEHpXuEbGCA0jAmGVWIuSlaY84PpQrYYmeSqZDmImKg04lBj5c+Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303063; c=relaxed/simple;
	bh=qT9pjsLA1dV81KCPWtjsWdhEiOXfBlc64IDngt95/rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sp1Z6msKKptJiQgZuC2R14EB3SrtjfCH6G3HVnR5pEHQZBW1dOsxxTMc2VeORXCFkDXLxc5m3oHDuZFacG7PkX/7pkoHz81czIpKM/ySmWSaudmbLwNEX0tNCVsbUQ+NuSyqqrci2+nODYf6ViXxuY6lksmJQ6qwNt0a1fUZFXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07Xdyex8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07Xdyex8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5684F1F000E9;
	Wed, 20 May 2026 18:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303061;
	bh=y+iunH6z4ka0SRqPRbNTRqBIrkLIGZghOkNF+OqGVl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07Xdyex8dleg+bUhI+mzbor9yCTqxhhR7H5z+xj6iwZrL+P+U39FivUI3PIhgtsbA
	 tmLWYteNWX1L4tUqHSyq5tCaO6FhEd5lm9FPaxZYeWgmOp0BGISv7d7fk+STwxvEdZ
	 J65B63+HL3T7sW/2+ZbVgPNFYjl3oRNvf/o8qrlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 504/508] media: nxp: imx8-isi: Reduce minimum queued buffers from 2 to 0
Date: Wed, 20 May 2026 18:25:27 +0200
Message-ID: <20260520162109.521774630@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Guoniu Zhou <guoniu.zhou@nxp.com>

[ Upstream commit 2f38622d0f85f317be9e6b131da6cd511db94fd2 ]

Fix a hang issue when capturing a single frame with applications like cam
in libcamera. It would hang waiting for the driver to complete the buffer,
but streaming never starts because min_queued_buffers was set to 2.

The ISI module uses a ping-pong buffer mechanism that requires two buffers
to be programmed at all times. However, when fewer than 2 user buffers are
available, the driver use internal discard buffers to fill the remaining
slot(s). Reduce minimum queued buffers from 2 to 0 allows streaming to
start without any queued buffers.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260312-isi_min_buffers-v2-1-d5ea1c79ad81@nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ renamed `min_queued_buffers` to `min_buffers_needed` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -1456,7 +1456,7 @@ int mxc_isi_video_register(struct mxc_is
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mxc_isi_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_buffers_needed = 2;
+	q->min_buffers_needed = 0;
 	q->lock = &video->lock;
 	q->dev = pipe->isi->dev;
 


