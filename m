Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722C33FF1BD;
	Fri, 15 May 2026 16:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862335; cv=none; b=rJpN5z2pXVl5bePBaF2UuDMx/RjfJsjsQCDEktda0B/qWYz6rWRtnY1BcIw1fGDwqTAxpvrzv39xch+RuKJhyKltM7bjwKuGfuljJgIVKVNV1Ylkb1DjNBk6Y/SG70C4rdQhe0OTLUYlFKxp1tKPjEhoi9/EOqQNV2qMa+Keg3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862335; c=relaxed/simple;
	bh=JI8KR+GV0u4o6qiD/RkyAzRi2abWmG/mB90OCO5RKVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPdIuz2vVpwlCCC1LydSqn14jYt47jHTQRkaJPvGEGe7b+gFH5EPJBJRQ3CgYp7H9sf21M7sikKiKG4YBJLBMwqeZtqQAKQXUNBiZ4zJtVD6LfoVGdnTPzP+6frkvUnQTfmXCFc2Kmd047lLFxgQFcEc+ww+FPbZtmnMLQZQVOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W+67j09Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W+67j09Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0339DC2BCB0;
	Fri, 15 May 2026 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862335;
	bh=JI8KR+GV0u4o6qiD/RkyAzRi2abWmG/mB90OCO5RKVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W+67j09Q5tXDJbS0FWPh1Xqokr6rSCJq15Co59dxePXO9c/D2zviSw0hZEFxrxVZh
	 7gzX+jNKlN+duBdlU+HNnuc2LhIhXmSysutmCGCdc2n6vgvjmYVtbm5tQIEd54la5w
	 ASaOLeWXDfRfrYsxW8WztLyR71QAfmPhYeEeiqMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 010/201] media: nxp: imx8-isi: Reduce minimum queued buffers from 2 to 0
Date: Fri, 15 May 2026 17:47:08 +0200
Message-ID: <20260515154658.760304540@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1410,7 +1410,7 @@ int mxc_isi_video_register(struct mxc_is
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->buf_struct_size = sizeof(struct mxc_isi_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
-	q->min_queued_buffers = 2;
+	q->min_queued_buffers = 0;
 	q->lock = &video->lock;
 	q->dev = pipe->isi->dev;
 


