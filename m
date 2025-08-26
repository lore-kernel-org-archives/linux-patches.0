Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1EF34AAF8;
	Tue, 26 Aug 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219237; cv=none; b=Q1UxkDPFTi5sfu3D3HlS+DbBMaMD+NbD/onmPLQoyHxpFxGDNnC75+eRvRESJdBAhLb8qlf5x4fu6VFvkU8ZmY9tMamMdbnfuGuEICoJkA+XaSpMvTdYElFKnmCSa21WaGIWcu89r3zRq5khtuqv135b6UeoOOvnBPF3a08m6W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219237; c=relaxed/simple;
	bh=pxPzXMhy/WdPbf7/OitDRUO5o+pRit7qw8HUHwYZV3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvbObQ7z0om1FS/KM2EAdybhVlHKcYH7AfVSjp/+UQ2K2jV9gnYwM6IB/sdTM4skdNY0/6ut5VAHF2HrQXVjITnYtUG59b0IXfnk7U8dJ3RH+g+tUHVg2NKlmFiGYCEe/PD5O8RXjwB3yKrGIX8Firf+YMdVivWho/4WyTow1xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jO+IMw/I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jO+IMw/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F9E2C4CEF1;
	Tue, 26 Aug 2025 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219237;
	bh=pxPzXMhy/WdPbf7/OitDRUO5o+pRit7qw8HUHwYZV3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jO+IMw/IXJUdslKnbZW+FPpzqT/LYNDGfLMQppFu51miUbEWzLeDLDJj+zb530Fw8
	 gBT9GSDcKS9NMS/b9pnQeL4rIQeKZYvtIm8d6nL35Uk29G47NXJzjp4aqVuAY/7gB5
	 WoWRmwinIlWMIcjF7voYkx3w+Jylv65XBJ3PGtbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ludwig Disterhof <ludwig@disterhof.eu>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 305/403] media: usbtv: Lock resolution while streaming
Date: Tue, 26 Aug 2025 13:10:31 +0200
Message-ID: <20250826110915.244060855@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


