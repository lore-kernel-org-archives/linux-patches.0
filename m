Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8E5219A7E;
	Mon, 18 Aug 2025 13:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524119; cv=none; b=qxXRMzanewdXxecQM3pVHpRH5uCocSYpyCqV9nKjVCBWXgSJyU0fSnTLDWGVJIP+/C2MKYhdRMRf1KaZDwuLgP+ovzPhUuFJpHQjZzFoOJaaLxEX+WmEYiyPccF7xX+8hZG+JDAHRBBTf9bjzUZGp5zmQ9NqsdGo5HW9vv5ZUAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524119; c=relaxed/simple;
	bh=ynsWwtNCSodI8gv01lME90OJc90A2o94THvQ1T9xK9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+Jzczv5yML21GpGwSF6yWw1Vnp4AwfswQCFK4o3Uz1ExYdf1K2GKLj3vzcQA7QgBgrDc/otSi4nJIijKUWrjNhSAup2F8rIt+m97rgiJsJoxf2jqNAxtAF4g0F/u8r12mKySaVhPuKOmDL6AfaWxRorpBd+TVymya69YKQP89E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oq2MMLPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oq2MMLPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C7FC113D0;
	Mon, 18 Aug 2025 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524118;
	bh=ynsWwtNCSodI8gv01lME90OJc90A2o94THvQ1T9xK9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oq2MMLPCGL7mA3OI7/nEDa2HD1rWx6vs6RHV3Fo8AAX+lfwWXYvyy9hr9QxrI9ClE
	 ZK3ca9DyHceBjAmntxMS/2XejvHdPa7OMlwZ0q5/dHHwhk3ChrbBuQznjZMbuV3R22
	 K1RBH4wTKPqsJeIN7b6aDKigjpBaSsH1rOxUp8Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 374/515] media: raspberrypi: cfe: Fix min_reqbufs_allocation
Date: Mon, 18 Aug 2025 14:46:00 +0200
Message-ID: <20250818124512.813323883@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 57b5a302b5d529db96ddc52fbccec005092ebb3d ]

The driver checks if "vq->max_num_buffers + *nbuffers < 3", but
vq->max_num_buffers is (by default) 32, so the check is never true. Nor
does the check make sense.

The original code in the BSP kernel was "vq->num_buffers + *nbuffers <
3", but got mangled along the way to upstream. The intention was to make
sure that at least 3 buffers are allocated.

Fix this by removing the bad lines and setting q->min_reqbufs_allocation
to three.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/raspberrypi/rp1-cfe/cfe.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c b/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
index 69a5f23e7954..9af9efc0d7e7 100644
--- a/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
+++ b/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
@@ -1025,9 +1025,6 @@ static int cfe_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	cfe_dbg(cfe, "%s: [%s] type:%u\n", __func__, node_desc[node->id].name,
 		node->buffer_queue.type);
 
-	if (vq->max_num_buffers + *nbuffers < 3)
-		*nbuffers = 3 - vq->max_num_buffers;
-
 	if (*nplanes) {
 		if (sizes[0] < size) {
 			cfe_err(cfe, "sizes[0] %i < size %u\n", sizes[0], size);
@@ -1999,6 +1996,7 @@ static int cfe_register_node(struct cfe_device *cfe, int id)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &node->lock;
 	q->min_queued_buffers = 1;
+	q->min_reqbufs_allocation = 3;
 	q->dev = &cfe->pdev->dev;
 
 	ret = vb2_queue_init(q);
-- 
2.39.5



