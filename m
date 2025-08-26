Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF933431FE;
	Tue, 26 Aug 2025 13:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216648; cv=none; b=hoDS+L9a+QIqQ7DgUAxniCuQzsxCXnNaFfbBGwQxvk2H9B496yRf4ma7eMnaM5u88QAUUF9z0jw1koVXBDE4ze/s5CyBbK1Mq03eqRMBqHC1+VaLYOFMsC3wBcUrfsSkfWw9eYHuOIKCjlfvBudJb2dDeZFhSSIayf8+IARZ0SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216648; c=relaxed/simple;
	bh=K0wbHUL/VIIOOZw8nTaIZtrjPPknmWCEEhxZ8AibgfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njqE0MIAEuEezuDIizCW52RN4xtaNiWSNMZ4c1RKVEnOrtqMgOk5ByYtXJTMgUC4BDZ5OFEoyx5NAHr+5qqRwiLHOMj6szow6MYluVM5kHuORxd9GWydlDDmyzTprKKNPW5X8K2r6WZAffu0N4e6aWM8mJ8GZXAPj3TJVCANWMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxPa29Bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxPa29Bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EBBC4CEF1;
	Tue, 26 Aug 2025 13:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216648;
	bh=K0wbHUL/VIIOOZw8nTaIZtrjPPknmWCEEhxZ8AibgfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rxPa29Bbl6iZZUF2TE3O2VXl0Q7tRMkdhtTY6IEF+KWtdxVaeTucl5SwVNR8cXTIR
	 Y7Wd6HpuXnhpCmbEvXTWSS/AzQWd6BA8nNhI6LX8YL7jd608U5KdT5xJFzxu97fOtP
	 H2rMr2MQgRTgoYu/O0ZbB0ZIgyIc9X7t15wWYmfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 490/644] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:09:41 +0200
Message-ID: <20250826110958.635596035@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


