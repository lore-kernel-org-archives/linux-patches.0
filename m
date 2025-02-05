Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD27158D96;
	Wed,  5 Feb 2025 14:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765734; cv=none; b=cvYYwOJobHh9CHNWaNrew9ZnWbkAj7tpifBaoAaeg42eRl1lZ0Ytfw0YnlGp9m4IZQbzTR3AWllPND21vI3dnaYZ4RDKfvI3kAAayCsdtlvcBCG4RqVjvJ0glQ8CveY+KT9qPphMBBozuqHgjVq5MwpoHKD3tNb+bfYPyyHr4eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765734; c=relaxed/simple;
	bh=9KsoTer+z4PtAd66NSDPJo1tqs33o60fve+27smN2yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEWXZLLbdgXuZxpCU53dw0YWhvKiXEgCvQQicfQuURuJC6+X48O/IxTGqgFZfkauQW1g7nwKFT095yRMdavL8LMC6Rmusv3fm3h9DT61nJHzIbQ3BUh88UxekpxBxK3qXfj8FcJ1mULTk4MSopZ5nUx0GnAcvsIfvC9gaSaFj1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jinQMgd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jinQMgd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D4CC4CEE8;
	Wed,  5 Feb 2025 14:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765734;
	bh=9KsoTer+z4PtAd66NSDPJo1tqs33o60fve+27smN2yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jinQMgd10oqbpTSWdAKWG8wqYzsl3ZB3j5Gq/zECytwiR1tUWhi8C08TSwxG1Atq1
	 2s4Q2BhuGNQ1KdoBWN7gIvV9Jr9EJb3TqJRS2QlrltcgGvhMF9RspdNZIoOZFGhXzj
	 RPjgu1m3G9tTae06hXOfPsKkB1rvYxyUr/JsJhtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/393] media: nxp: imx8-isi: fix v4l2-compliance test errors
Date: Wed,  5 Feb 2025 14:43:33 +0100
Message-ID: <20250205134431.563171752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

[ Upstream commit 7b12ab055edef2f51733d155617a401a05237bcc ]

Running the v4l2-compliance (1.27.0-5208, SHA: af114250d48d) on the m2m
device fails on the MMAP streaming tests, with the following messages:

fail: v4l2-test-buffers.cpp(240): g_field() == V4L2_FIELD_ANY
fail: v4l2-test-buffers.cpp(1508): buf.qbuf(node)

Apparently, the driver does not properly set the field member of
vb2_v4l2_buffer struct, returning the default V4L2_FIELD_ANY value which
is against the guidelines.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240924103304.124085-1-laurentiu.palcu@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
index 10840c9a0912b..111be77eca1ca 100644
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -861,6 +861,7 @@ int mxc_isi_video_buffer_prepare(struct mxc_isi_dev *isi, struct vb2_buffer *vb2
 				 const struct mxc_isi_format_info *info,
 				 const struct v4l2_pix_format_mplane *pix)
 {
+	struct vb2_v4l2_buffer *v4l2_buf = to_vb2_v4l2_buffer(vb2);
 	unsigned int i;
 
 	for (i = 0; i < info->mem_planes; i++) {
@@ -875,6 +876,8 @@ int mxc_isi_video_buffer_prepare(struct mxc_isi_dev *isi, struct vb2_buffer *vb2
 		vb2_set_plane_payload(vb2, i, size);
 	}
 
+	v4l2_buf->field = pix->field;
+
 	return 0;
 }
 
-- 
2.39.5



