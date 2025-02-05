Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FB9DF59;
	Wed,  5 Feb 2025 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767815; cv=none; b=hiljLPpKSgAZv9GUmmWzT74I/FGhyLx+C6lPpFcNwY7J2dyx7rrLMDv2zch23UGu010u0ANuryezMVgf+c3cskXU42WL0+gpa81JVUELRFB0fG1m+voxdSxpmPsBRl0FvG+GchX1R+cTbAC7s6UBxJ5zn8Aojr85dNmj8H/PY04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767815; c=relaxed/simple;
	bh=YwCgwQNASA+a6F5fI34fBM7rBy01vJ9bdFxSNpLmxs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEGMolBTko/k1cCYhNQu8ouGf3hMe7dGGpNOUNlZiP9rfNMmfM9QsICcUfUD0ie63+3RWZZapZurvIl2IorghOUgvpw7on9Qt2jwaHTDusvtJtZhLeKOYMpO4FCje74b5QkL81a12yWKQxGMUP7AMBLH0NaY0VrImo3ZqvOxVnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWsoaYBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWsoaYBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC472C4CED1;
	Wed,  5 Feb 2025 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767815;
	bh=YwCgwQNASA+a6F5fI34fBM7rBy01vJ9bdFxSNpLmxs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWsoaYBOA8f88DyZGjD6J9aFteIPZm44VFdEtyIPI9MCE52tWxylmA8V99KaOZMi+
	 lYu1J87+ZIsfrp4zC2pGzo8lS+HIX7Ue11X6LW2zyHOJdEERS0mE5RvLT4PoXGHCiv
	 FO/USR3eLQwaQ0envDVPQrG6duisqv9zDFmDaV7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 457/623] media: nxp: imx8-isi: fix v4l2-compliance test errors
Date: Wed,  5 Feb 2025 14:43:19 +0100
Message-ID: <20250205134513.698903176@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c0ba34ea82fd7..8654150728a86 100644
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



