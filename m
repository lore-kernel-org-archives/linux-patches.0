Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A73549364;
	Wed,  9 Sep 2026 14:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962684; cv=none; b=bl9mlZOcucQb9qR5BZS/b6Sk/CRC3+0Al8W4BkW5SD83ClVW8RNdCARV4h2lU0ulFiIQHlutROFsv0A10OlpkTO/b9zuL0N4tYJS/vdw5tBQmHPYjgdAHkH3OgoF++2NX/BuBCzhpHXDYFBKPRHzI9/F1bsaLmMLNCiYIRdzmL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962684; c=relaxed/simple;
	bh=jp87VH1HD7Jpy/5q5ANqbnkXAtWjTl019UznN19/gvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtV4KE7UrJfWJWthESAKvPnnKAGDl5xH8jzgZJZ7auKznqd1XVcILIRDf57b449eBG7OJ9DXIlmJcr8SSUjtGISyEcuY1Th3oYEvqdcrKzNWfK7tjU2XR/FyBaj3+RE+jDHDbbF1rbAUNlCDSb+hHFGZVyA6L0xDtjdTAShhhPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QY0tvwXp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QY0tvwXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D9C1F00A3A;
	Wed,  9 Sep 2026 14:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962682;
	bh=/im/iZFwecJMHZxRG5P8dPSn1wFVROB9CW0Og8C1Ga4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QY0tvwXp4czvQNjgX4McmBjyao27FNPI9e1GiaKlXfNhG2s6LQindk9QryBU2K9At
	 28/uC6/J0HsFSlLvG3JgsLptmmnwuYxQlZrD3QBZJ1znNSc6d3kX5ANf5VCNLVvt7r
	 ndK/T10AqAt4UtZfSirxiLB289ar106LVx9n8mv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 374/556] media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common
Date: Wed,  9 Sep 2026 15:40:54 +0200
Message-ID: <20260909134243.849555026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Hewitt <christianshewitt@gmail.com>

commit 20aa934ace6917262ff579a73ec018d06a7bad1c upstream.

When VIDIOC_TRY_FMT is called with an unsupported pixel format on the
OUTPUT queue, vdec_try_fmt_common() falls back to V4L2_PIX_FMT_MPEG2.
However, if a distro has locally patched MPEG2 support out (as it has
been broken for some time) the platform format table does not contain
MPEG2 so find_format() returns NULL and the subsequent dereference of
fmt_out->max_width triggers a NULL pointer dereference.

Fix this by falling back to the first format in the platform's format
array instead of hardcoding V4L2_PIX_FMT_MPEG2. This is always valid
since every platform defines at least one format.

Fixes: 3e7f51bd9607 ("media: meson: add v4l2 m2m video decoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/meson/vdec/vdec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/meson/vdec/vdec.c
+++ b/drivers/staging/media/meson/vdec/vdec.c
@@ -504,8 +504,8 @@ vdec_try_fmt_common(struct amvdec_sessio
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
 		fmt_out = find_format(fmts, size, pixmp->pixelformat);
 		if (!fmt_out) {
-			pixmp->pixelformat = V4L2_PIX_FMT_MPEG2;
-			fmt_out = find_format(fmts, size, pixmp->pixelformat);
+			pixmp->pixelformat = fmts[0].pixfmt;
+			fmt_out = &fmts[0];
 		}
 		break;
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:


