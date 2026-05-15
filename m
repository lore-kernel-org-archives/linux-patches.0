Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA573FF1D1;
	Fri, 15 May 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860245; cv=none; b=Ytat31AcbTh6OcY953bU6NovrhkhRoSZVCT/0ep7AhmM+tQ48xQQPCCjSfek7rlDPC2yL+KAichMLThIp7WC89UlRosKyyn8W0c8EHlC+879jEDgXipvxJ08Z374uPJelu1iPI2Qd3ln6IHXLBmhmX35TGGSPs+sIrX6W1V0hMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860245; c=relaxed/simple;
	bh=YQ69Gp1ahuela7vBIf2o3miE7qq3XcKWC3oKEamnlH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ1Odo/rtjE3M+JiC4Q7IGg+tefSwQKvOdXmEbPk3tAEvTvMb3cjtLZkfNTlTBoPbfr9pPfB9e3YpyUvM+r2VPzvAm9qHf/v9i2Rlda3k5BHMw5NfTlSxOFze2kszOwMQV7grkA+iJ1y4SmwXKxbQW0//ITXKuA/rl4j5mcsTYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6sz3ScA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6sz3ScA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780F1C2BCB0;
	Fri, 15 May 2026 15:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860244;
	bh=YQ69Gp1ahuela7vBIf2o3miE7qq3XcKWC3oKEamnlH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6sz3ScA31fezjozw57B6gyc+4ETvJxcKQNqU02M0WHAKQbd6itySlGfjUVfC8Dhc
	 48sNtCAA9iezA3L0MfgVGT49RvpnztybaaxNWLXPyBEShe+5j0hRTG+w2C4Vc46h4Q
	 MzmnN5jtjsDgRGni0IzMorA+auCLwQ3+p0FQIReE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 003/144] media: nxp: imx8-isi: Reduce minimum queued buffers from 2 to 0
Date: Fri, 15 May 2026 17:47:09 +0200
Message-ID: <20260515154653.554783112@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@nxp.com>

commit 2f38622d0f85f317be9e6b131da6cd511db94fd2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -1416,7 +1416,7 @@ int mxc_isi_video_register(struct mxc_is
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mxc_isi_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_queued_buffers = 2;
+	q->min_queued_buffers = 0;
 	q->lock = &video->lock;
 	q->dev = pipe->isi->dev;
 


