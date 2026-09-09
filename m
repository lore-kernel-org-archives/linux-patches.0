Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFB1563FCF;
	Wed,  9 Sep 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962767; cv=none; b=R4bem6lEiHAXY3WuXzd4A9Ghoe2zNZE5G/uUfHW5Li6vSVQEutHiq+g/Rl3w9JEIhPOi+se/F1sv3FGwNzhQ3zaAAYiaGokEcLy8rsQbcxc0xkh4isAcEW1PDza8CJmzp9vVwgs8EzFWQoh1MVr7eAa7+GZnunpfZc6fwfvyBN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962767; c=relaxed/simple;
	bh=NiCr7vU7zxx7BTHvGtSGLpwBw75iWilTSl6WI/tRryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhRiDQzy1KRmB2yMKP0/qMxSGnstSm1nRzdlRBCZZPkfBRtnZWozts+ZULUAoIRS/1RRJLhSF1mmeGKTpIwkB3PyXFl9oQGrm3+3kDXfTZwmfhQjsIaMTinwtQNtBN0b4IJ+L/bKXREHRnYZ6DnC9rLoa6jSF7zr43OGwg56JJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gr9yNHBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr9yNHBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AFB1F00A3A;
	Wed,  9 Sep 2026 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962765;
	bh=q84JlA149Ph+xK15TS0Hw5py3vLlpWTus9t/661H2Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gr9yNHByLyd9ZAvj1nrBxSW5dzaM4L00t7n5zfUu3mCziaRzpExvISdoXO6teW/aX
	 BoYuI9fgd5gGDuMXC84FsyNsbWg20aw0g16sS7CoN2+ouw92F8kGanuzJclqdAvtVw
	 EyXJSZIrITFS41zKMq0gf2/n9uykCetouqM0zb5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 404/556] media: vimc: fix pixel format lookup in enum_framesizes
Date: Wed,  9 Sep 2026 15:41:24 +0200
Message-ID: <20260909134244.842490819@linuxfoundation.org>
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

From: Arash Golgol <arash.golgol@gmail.com>

commit ad4c65fa30cfb00e2e06adae9a8eb407086eaa66 upstream.

vimc_capture_enum_framesizes() looks up the requested format using
vimc_pix_map_by_code(), which searches the pix map table by media
bus code (MEDIA_BUS_FMT_*).

However, v4l2_frmsizeenum::pixel_format holds a V4L2 pixel format
(V4L2_PIX_FMT_*), not a media bus code, so valid pixel formats end
up being rejected with -EINVAL.

Fix this by using vimc_pix_map_by_pixelformat() instead, which
performs the lookup by pixel format as the ioctl expects.

Fixes: 09c41a23a2e2 ("media: Revert "media: vimc: propagate pixel format in the stream"")
Cc: stable@vger.kernel.org
Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vimc/vimc-capture.c
+++ b/drivers/media/test-drivers/vimc/vimc-capture.c
@@ -175,8 +175,8 @@ static int vimc_capture_enum_framesizes(
 	if (fsize->index)
 		return -EINVAL;
 
-	/* Only accept code in the pix map table */
-	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	/* Only accept pixel_format in the pix map table */
+	vpix = vimc_pix_map_by_pixelformat(fsize->pixel_format);
 	if (!vpix)
 		return -EINVAL;
 


