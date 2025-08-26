Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B331238C0B;
	Tue, 26 Aug 2025 13:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213599; cv=none; b=abV43O3cMk9ZCIFnguo7S27W7S+Pr3j42ETs0TkwIuekHogbgWUFFCrYGzY3imuP4V6B2EFNdUkH4iBpvOlNiUWG+YnlbXQBn506WL/JZUdxNq/Bq8Xp96S/n63xLkgAoJ+H/LMGOc6H+HwUCWgbd2hJ2GxuRBDBAlEWmsFEKJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213599; c=relaxed/simple;
	bh=G8vWxrj2OuBIopLpXu/zVSQ0quls3LaZtZgMszWf49U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjUEBH37KptzVAmqOntR/AbJ2WszEObztRPelJlhxn24m3Mu1V8LHy8n8GNI0pWYb2gjXyxmfiUiUOipivLPyzqKPQ74zIlfdkKWlDHyrCHehgs9DDfsy6mPg6K/Jok+3j18r7IdP6z9J1F67U3VEoA8pU8Mb3tqWEXnCAcDZ14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTjqf5Gr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTjqf5Gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF45CC4CEF1;
	Tue, 26 Aug 2025 13:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213599;
	bh=G8vWxrj2OuBIopLpXu/zVSQ0quls3LaZtZgMszWf49U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTjqf5GrTSoki7y14d9etsIEUJreYHOvM7YrYScvoNHwZXx8MKFwlPuXpvc+AkAJm
	 C6SfVSlpdQm7C0QaZngDmhPQyeZYCVBiGY3MKiGv5Vx/sMX1x2ehEVXalDaxzsjJ1x
	 suHtxXNpwaUcJqvabCgNwpC2sAv9zApgCP1bGWx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 407/587] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:09:16 +0200
Message-ID: <20250826111003.282456430@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Ludwig Disterhof <ludwig@disterhof.eu>

commit 7e40e0bb778907b2441bff68d73c3eb6b6cd319f upstream.

When an program is streaming (ffplay) and another program (qv4l2)
changes the TV standard from NTSC to PAL, the kernel crashes due to trying
to copy to unmapped memory.

Changing from NTSC to PAL increases the resolution in the usbtv struct,
but the video plane buffer isn't adjusted, so it overflows.

Fixes: 0e0fe3958fdd13d ("[media] usbtv: Add support for PAL video source")
Cc: stable@vger.kernel.org
Signed-off-by: Ludwig Disterhof <ludwig@disterhof.eu>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
[hverkuil: call vb2_is_busy instead of vb2_is_streaming]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/usbtv/usbtv-video.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -73,6 +73,10 @@ static int usbtv_configure_for_norm(stru
 	}
 
 	if (params) {
+		if (vb2_is_busy(&usbtv->vb2q) &&
+		    (usbtv->width != params->cap_width ||
+		     usbtv->height != params->cap_height))
+			return -EBUSY;
 		usbtv->width = params->cap_width;
 		usbtv->height = params->cap_height;
 		usbtv->n_chunks = usbtv->width * usbtv->height


