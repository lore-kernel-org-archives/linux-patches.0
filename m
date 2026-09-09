Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16889577E32;
	Wed,  9 Sep 2026 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964071; cv=none; b=ksfGWA7W181HFLeX9Gu6E74Kg4aufqRvQhyGa3gNkUsLG2e/nKacowhy8WpBfD8BiA1VYWHIpauAMdqXmcnHkoJH5HMUhzYXoN7TC/sdI7Ba86PRaPc7VImuhJ+mLyiN3az4vVPGZ2Ilkcns7S6z99pSoShaMzfUO/5grVFHhoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964071; c=relaxed/simple;
	bh=QJUkKn4bgWk1zFpSC+XH5rFNdOIbq3W+TlkwvLBl5LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKTCBWQFxo9xgjSGLNDK/zlI/hTEkFoJLFbDBiixuBfjxQtjsGN6JYBQj/EfS7/FLuLbgtOkVv47zNlMCs+6hA2fb6HQ8sIde6JO5WsY788h9RAJf5hEFp+NjHL0USl7XlTj+ufUyDosS+PvuJjejEp9qHoQbIc5IwwEBH45ccQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etWhfb+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etWhfb+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0831F00A3D;
	Wed,  9 Sep 2026 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964070;
	bh=ENhk59FaI5I/WDB7Lh+H+TgKxZLhCi4R9E/YMJSPMt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=etWhfb+rjqxDu205YurF5GN2kyTyvyX4UrvdX+1/chUft1VRkO1sepzF86bimoGVz
	 bx59E67Xo7ehAaaOi/z2OUgZVVlMjSnnaZes/BcEDW+LKslIRF987fW/BAAEb0c8nV
	 UlvuMyUsjM/P0yKbHyrULDSkq2+y4WkBtFJqRHQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 296/583] media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common
Date: Wed,  9 Sep 2026 15:39:41 +0200
Message-ID: <20260909134248.287612191@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


