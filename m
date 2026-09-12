Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AAB42882B;
	Sat, 12 Sep 2026 11:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213808; cv=none; b=CW5Ki6ZUL/IrLZH0KifzFJM9d3LUCh7Bqa5taQ496he/Syt/KJwTo7tNfy0xjvJCyimpzo+j7q6w7eQunQkpkfFvfGlD8sGiGbsjMIglsfsHAxf4zJTUY5ocdLR9deal3AVKsHHpzYVpYSxZxkceUovzpd4o+4xfFoGup2xGBa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213808; c=relaxed/simple;
	bh=ark0R5/tF3O6opGovMdVzLCExHsfPO5mbEEHGgzdaFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbPzwcELkC/lwaBB6Oeg8t3K23ld+g8sgGpKaN4R6iUmb3h9P0XwnW5wLnvHiRIwV1wB8x1u9tyWNXeUKDq4anz6eLV1PyxgujE0dcYsi8I8R2Lz7VqTIMZl0jeOei8Pj6SYiEZZCvnmTWeBc5NWOUvs9tXQ+BHWDRWroPGjV1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUPzepgj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUPzepgj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A081F000FF;
	Sat, 12 Sep 2026 11:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213807;
	bh=iUGEyx/4egtRFGo0lT2rkHUCvlaoSCXboYo6wuhoTdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUPzepgjZe984IMBWW47p3bHBY59+imaSbpFSEiLR+3+RmfPYtihAE1gHgEN3sybT
	 mR1LvOrNvF0OMWc1ZQhe0VhyfDIU9NJn37QyrOQCuPskT6CdXOuQ07Z9g/UBV8kbYl
	 dXNIzjJ00NuuXWWDLsvIqKUyJcd/pzE3DzkBW0bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0198/1376] media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common
Date: Sat, 12 Sep 2026 08:43:44 +0200
Message-ID: <20260912065611.961469080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -506,8 +506,8 @@ vdec_try_fmt_common(struct amvdec_sessio
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


