Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084E23203AD;
	Mon, 18 Aug 2025 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525931; cv=none; b=jCEF55oh1ldg1IPjwPADwtqbevV6KxNlVpL0Mhcz6DyLcU2JM0uo+7l0bJ+KqaCIyCCZ3UUpwtWbjxU063erdjUMP4cW/qykU3MnUGLCMRl+xdSiJDCj4ti/OZNIGrcZfqsz1HxFzqalx805OKm29RoY0ZDM2JBf0QZHRc4wq3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525931; c=relaxed/simple;
	bh=Xf+6kIWTCESetOdvUxKvLz48M5D0Sb3EJ2TFL9k5Tv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgmdlGb4vJ6pLTk7MPecbHH/pX7yyL0dAXmFUPcfXXG4QBIXbGLI99U9fR7I5GcIiq14f/T6DwmzZMj0PFaSCJTDV7JyLORW3F2oDWincntLpUdtrCbWO/qT4G4AaNgVXu//Q3b3lzxT/hVUvz0J9/Rcj4cYygTuUuEbSvGzOi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+hnSdOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+hnSdOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BE4C4CEF1;
	Mon, 18 Aug 2025 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525930;
	bh=Xf+6kIWTCESetOdvUxKvLz48M5D0Sb3EJ2TFL9k5Tv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+hnSdOplY+D7QIl/9TwBVeTLzfu9V4gYPMJUeQG07ZLTo20R+dz67wfYtFzH6fCh
	 rQ/KN88pg4L32RdiW2w1lMnkCLFXRsqQ2403YxUg9ht2WWnQ8CAKRKxeLnYjtLT1Zl
	 lfTfdceEFzYq2gW9zJt98l+l/qVXbD7LpIWVCWuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 407/570] media: raspberrypi: cfe: Fix min_reqbufs_allocation
Date: Mon, 18 Aug 2025 14:46:34 +0200
Message-ID: <20250818124521.528355462@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index fcadb2143c88..62dca76b468d 100644
--- a/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
+++ b/drivers/media/platform/raspberrypi/rp1-cfe/cfe.c
@@ -1024,9 +1024,6 @@ static int cfe_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
 	cfe_dbg(cfe, "%s: [%s] type:%u\n", __func__, node_desc[node->id].name,
 		node->buffer_queue.type);
 
-	if (vq->max_num_buffers + *nbuffers < 3)
-		*nbuffers = 3 - vq->max_num_buffers;
-
 	if (*nplanes) {
 		if (sizes[0] < size) {
 			cfe_err(cfe, "sizes[0] %i < size %u\n", sizes[0], size);
@@ -1998,6 +1995,7 @@ static int cfe_register_node(struct cfe_device *cfe, int id)
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->lock = &node->lock;
 	q->min_queued_buffers = 1;
+	q->min_reqbufs_allocation = 3;
 	q->dev = &cfe->pdev->dev;
 
 	ret = vb2_queue_init(q);
-- 
2.39.5



