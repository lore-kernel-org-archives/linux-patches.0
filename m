Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63EA3B19DB;
	Sat, 12 Sep 2026 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237737; cv=none; b=RkpDu/C6Vd/maacVJDIS+J5J6aJeuO82quw8Vi2DcBw0fgNwU2pAZq5/Nv5N8vcaXtl7/ADRzzZL3MuoT8NyqYHbpIiTmLqhGPuo2hJm35Lin4UBDPQ/E+C/HR/DZB8gC7TFbsT0XKtDdxErHZsxVkkw6hqdXCCKKI2DOJjn9wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237737; c=relaxed/simple;
	bh=l2fdxeXH+xgr9T/DFzS0U2Y9cNHplAPxikGfHOqiXyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXT1+BIxKCgMODpTTGGbhNvDm83UiBWlT86tGBZIh9Xl0sC9XnIVdh6HKhd1Pp8aicPzOa0Z9vvZupLuILufDoewcXTEfDhitvSDOjAfk0vUJC3MlLckQ0FkVoswMXHXqgzBqwLjMS+MEBE5tr5EDF3UiTCZz2P2rceZS2KgGfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLXpYQqX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLXpYQqX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622011F000FF;
	Sat, 12 Sep 2026 18:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237735;
	bh=vTW8quKnpeu7yJITewaykFJQw4Kb92tq+dSlRlZGZRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLXpYQqXiO881KsKPaE4vSXUJf4uxG/5tvkTdMFymuo9nCJ+bTLDoyixQbaUCQHlF
	 CmwBn3IYoZXfCdDxQ941/PMNetalslC7UbbDBSqfr042o4/nVsddtPBd7+23dq+3yS
	 D8a6HMfKed3CxinX9R8Hp6XUsWOE+ipZo8TFWHmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 320/935] media: meson: vdec: fix NULL pointer deref in vdec_try_fmt_common
Date: Sat, 12 Sep 2026 08:55:50 +0200
Message-ID: <20260912065534.143843913@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


