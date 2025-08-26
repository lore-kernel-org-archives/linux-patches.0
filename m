Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C358301486;
	Tue, 26 Aug 2025 11:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207324; cv=none; b=iP7Hh907C+bKMUgy9AFRZDTiZxqBE4W0+EbAJZi8Nn1D/8AwcDDWtPjfoxVaFuUo36ccLcZ0tOvsq9yjVXURZGS/oxU+MQ7vDMUzvVzHH+gwsAQ79iLjkoLSTt1AE0rLsyTaD+mbxeCob94wot8C7M9tk//3ccMVuDXGNDQuy1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207324; c=relaxed/simple;
	bh=lUWbbZhT+YRRFbQwP/9f9/SSfGAOtqHYO0XhoDV/Fxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WpuNoSEqHeNSinrhvnvPMAxqcZIBLUAHohmvrvf6YmwjR73x4tGlOTi1eEjgL+0zXrPoi8sjRJEOho18u66ukC5Z7Ovv7S9b2ieO8fupWqUTtoYZ51fug1+Pa96SpmpbLtW1PxX4PKNtc+NuYhHOUdsC3WfYlUXvmD3sRN+8Ass=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhzM/OV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhzM/OV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ECE4C4CEF1;
	Tue, 26 Aug 2025 11:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207323;
	bh=lUWbbZhT+YRRFbQwP/9f9/SSfGAOtqHYO0XhoDV/Fxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhzM/OV4o9T4C5vfI4yykbSX78tr9nQ+O8sc/lYsVUYUQ0UITcgrEgsAvw1YZ8fLt
	 vG5yOOe7JpSFWtMIzcSzv0eVG7L+gqebNGzMPI9MDT6fgdn5GF1Ls80/kQ47+rqu48
	 HnYAyN3NuSWQfORTidv8jvwDK5+sbkf2LQ8aI2C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 137/457] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:07:01 +0200
Message-ID: <20250826110940.759349217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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


