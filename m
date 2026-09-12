Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0507D33E347;
	Sat, 12 Sep 2026 14:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221877; cv=none; b=QInJRd5C39QRoezmUV0JbFWsUAx+nXzKdyO/J+GpedHzxqUVYTIF7XRxRFRJVewYeylj4E8KXH5Gx+x84ZesD8j+W+pzIIWLZJNRB2jhpRQkF+MFWsEumiPXTf02xndhYnT9u5VZXRmuCo24enpYrxlxgBt/Gt6kS/u4w6kmo60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221877; c=relaxed/simple;
	bh=zYoeRhfxrjaqReYHJY0Y5lltI5OFF0Vi+J1DRTP/t/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lASMEwYaTjaDmnwKUoCjdsNIOQHmpTuNcu+IGUb55FUN044/mHTNA/QL+m9/uPqfyedn7sJhMSVgCxoPt4ReYhci54f7NRr2mTj8kWjwe+YXE7wrOUQfa/ABlRNrrUW5nZgWjZ8CEaYkR+Xmm9b3V6ej5Msqj1XiKnjPENWKCK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp2WcphI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp2WcphI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DD31F000FF;
	Sat, 12 Sep 2026 14:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221875;
	bh=wrWmB40FF1Q6YdkvHji/hEnVSf1Oe7VjR+NvaFgA+80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xp2WcphIuArMkz0q+Oas+v71HFbvcOKWQqGWqBygmkQGMuoKZ9y8AjzIGbIdULwYZ
	 Qmru4t4U6mP0i8rUw3pTg5SUx5kbaTB/CLq3Jqf6KTXQVem4LpokjqYBolfZmJ15oK
	 jW2+I89R3oynAbGzts8GIfimrCBUFbv3KpAE/IPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0471/1424] media: vimc: fix pixel format lookup in enum_framesizes
Date: Sat, 12 Sep 2026 08:48:23 +0200
Message-ID: <20260912065617.835799006@linuxfoundation.org>
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
@@ -177,8 +177,8 @@ static int vimc_capture_enum_framesizes(
 	if (fsize->index)
 		return -EINVAL;
 
-	/* Only accept code in the pix map table */
-	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	/* Only accept pixel_format in the pix map table */
+	vpix = vimc_pix_map_by_pixelformat(fsize->pixel_format);
 	if (!vpix)
 		return -EINVAL;
 


