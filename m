Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035EB2F8EAE;
	Sat, 12 Sep 2026 14:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221783; cv=none; b=jJcb5TVI/CmgJq4pTJ6/5yAbpkHAOZaWXtwoZhoTVnsMNPaW8Gi+qRM290fomZmK2/+TJlE9127avAFfB515HQMgoJSg/NHd8cjR1Zzps7sOnm1i30b1LbE8FLQBD9q/9pDZCOXQgvtnho9NU8TSOhPlGKzXstmx0ParCmCVNII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221783; c=relaxed/simple;
	bh=o6oO4C6CYgGtWG1dHH2pBHA5cDB1rnd1d/Bq5cKMPjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orOulpLPd+AvhgN++JtiaBn9oDJZTcZdKuqVgtut3QcAwPwQ2MgVP6mCTY5+LUXnPS2/yCDgQ8d5oYrSxS4f/fr+edScg4gxTXdKSV4aUlFlepYvSXmANQMatvkzOS5P2tp9IAUJXOiil5TN/O8aQa0jDxwrOpRnSankqUyBbsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ya0DwR1y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ya0DwR1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35511F00898;
	Sat, 12 Sep 2026 14:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221781;
	bh=N+Ijg6XVu4Mfqedv9ohem8WtHe/t2g5Pt8oRKWBiUG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ya0DwR1yKFeTB4FjsB2kjvC/gD7rw9ZeFBVyFeQBhecF2Ai+Q1bEmhi/aebL+vLye
	 7myOC1X7XMva23GOiNP61uBzlFWvpm72Z+pexgRu+a0hc+vS/cDGloGDYPZfnYQLzI
	 +FsKPiyTAypYxFF+KjEXR7+1zon8qOAGFZJB3cPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0454/1424] media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common
Date: Sat, 12 Sep 2026 08:48:06 +0200
Message-ID: <20260912065617.451124224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -505,8 +505,8 @@ vdec_try_fmt_common(struct amvdec_sessio
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


