Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E19D199920;
	Tue, 10 Sep 2024 10:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963594; cv=none; b=WWaQSaa/o7YjptSysxOzdQO3F76dJjU9BfCYAGsJi0RPp03Ft/87XCmtXzXu+YJzVJJ/seLdu1tXwYnMDQGaAqUjRq9dDuksVqoelidUxupX0xrLk2AWqnon7lmH7bT2TYK5r6pzn//HQYcxtzjVhUd4anJA1XZwcCKRJfdljek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963594; c=relaxed/simple;
	bh=shRqcRbwOlZROUYh2efr+CwUNu+M/OUhDaDSK0A3KB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doX0XIfBvK1/FNmcLOEleQHkBdlpMk+sq2/u0BfqBX4r6Qd1IOC6SyKWyf122j5y2rT5OzOntU1X5W0bYSlF9z35BdkwYfnkPNcpfilqCBCKZHrP2hHEeGtJPHxStj7AiB/vjdKUAMh1YPAbUN96nc7vzDICXc+40NlwkLrLmP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CibpKtCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CibpKtCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AC1C4CEC3;
	Tue, 10 Sep 2024 10:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963593;
	bh=shRqcRbwOlZROUYh2efr+CwUNu+M/OUhDaDSK0A3KB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CibpKtCfaR2YcOkfMImZ2DFFoW5zG3jvtDd8I3/ikoUdOt6JTB0ulwgl7djzii7Ox
	 7IVsnTEofQUiOFakAt/4eiDgvYFjb9edxELwC0h6/COaaXWsCHsc1DZywnruXjFdqY
	 YrG1ryV6OvXitDowF0lu4ZNvKRM1hP+0GoAhnyTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/214] media: vivid: fix wrong sizeimage value for mplane
Date: Tue, 10 Sep 2024 11:32:12 +0200
Message-ID: <20240910092603.301370344@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 0fd7c0c2c156270dceb8c15fad3120cdce03e539 ]

In several places a division by fmt->vdownsampling[p] was
missing in the sizeimage[p] calculation, causing incorrect
behavior for multiplanar formats were some planes are smaller
than the first plane.

Found by new v4l2-compliance tests.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-vid-cap.c |  5 +++--
 drivers/media/test-drivers/vivid/vivid-vid-out.c | 16 +++++++++-------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/media/test-drivers/vivid/vivid-vid-cap.c b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
index 331a3f4286d2..af0ca7366abf 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-cap.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-cap.c
@@ -113,8 +113,9 @@ static int vid_cap_queue_setup(struct vb2_queue *vq,
 		if (*nplanes != buffers)
 			return -EINVAL;
 		for (p = 0; p < buffers; p++) {
-			if (sizes[p] < tpg_g_line_width(&dev->tpg, p) * h +
-						dev->fmt_cap->data_offset[p])
+			if (sizes[p] < tpg_g_line_width(&dev->tpg, p) * h /
+					dev->fmt_cap->vdownsampling[p] +
+					dev->fmt_cap->data_offset[p])
 				return -EINVAL;
 		}
 	} else {
diff --git a/drivers/media/test-drivers/vivid/vivid-vid-out.c b/drivers/media/test-drivers/vivid/vivid-vid-out.c
index 9f731f085179..e96d3d014143 100644
--- a/drivers/media/test-drivers/vivid/vivid-vid-out.c
+++ b/drivers/media/test-drivers/vivid/vivid-vid-out.c
@@ -63,14 +63,16 @@ static int vid_out_queue_setup(struct vb2_queue *vq,
 		if (sizes[0] < size)
 			return -EINVAL;
 		for (p = 1; p < planes; p++) {
-			if (sizes[p] < dev->bytesperline_out[p] * h +
-				       vfmt->data_offset[p])
+			if (sizes[p] < dev->bytesperline_out[p] * h /
+					vfmt->vdownsampling[p] +
+					vfmt->data_offset[p])
 				return -EINVAL;
 		}
 	} else {
 		for (p = 0; p < planes; p++)
-			sizes[p] = p ? dev->bytesperline_out[p] * h +
-				       vfmt->data_offset[p] : size;
+			sizes[p] = p ? dev->bytesperline_out[p] * h /
+					vfmt->vdownsampling[p] +
+					vfmt->data_offset[p] : size;
 	}
 
 	if (vq->num_buffers + *nbuffers < 2)
@@ -127,7 +129,7 @@ static int vid_out_buf_prepare(struct vb2_buffer *vb)
 
 	for (p = 0; p < planes; p++) {
 		if (p)
-			size = dev->bytesperline_out[p] * h;
+			size = dev->bytesperline_out[p] * h / vfmt->vdownsampling[p];
 		size += vb->planes[p].data_offset;
 
 		if (vb2_get_plane_payload(vb, p) < size) {
@@ -334,8 +336,8 @@ int vivid_g_fmt_vid_out(struct file *file, void *priv,
 	for (p = 0; p < mp->num_planes; p++) {
 		mp->plane_fmt[p].bytesperline = dev->bytesperline_out[p];
 		mp->plane_fmt[p].sizeimage =
-			mp->plane_fmt[p].bytesperline * mp->height +
-			fmt->data_offset[p];
+			mp->plane_fmt[p].bytesperline * mp->height /
+			fmt->vdownsampling[p] + fmt->data_offset[p];
 	}
 	for (p = fmt->buffers; p < fmt->planes; p++) {
 		unsigned stride = dev->bytesperline_out[p];
-- 
2.43.0



