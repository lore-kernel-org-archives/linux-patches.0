Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1890848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636F1C433D2;
	Fri, 10 Mar 2023 14:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458304;
	bh=Sfd7ALKP9WVTrFRLUUekbWVSI++kG3TJ/aPrRBnTJJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1eRNMt+ngvkWgBAqXnD3b+yLKhuhWJW2v2VKTgRkyO227AiSqdGSOvwWGZSJACFa
	 iPGfy99MYhvtSudMSODM3H6c/ScuhRPRwl3aEpTn1IAGnPjZv/fOo6kqqH1LS3BDuk
	 UgmADks7X4dcLbR+Mwbfw6LpJazW5K1mvM/gtKNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ionut_n2001@yahoo.com,
	Kees Cook <keescook@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 234/252] media: uvcvideo: Silence memcpy() run-time false positive warnings
Date: Fri, 10 Mar 2023 14:40:04 +0100
Message-Id: <20230310133726.443568621@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b839212988575c701aab4d3d9ca15e44c87e383c ]

The memcpy() in uvc_video_decode_meta() intentionally copies across the
length and flags members and into the trailing buf flexible array.
Split the copy so that the compiler can better reason about (the lack
of) buffer overflows here. Avoid the run-time false positive warning:

  memcpy: detected field-spanning write (size 12) of single field "&meta->length" at drivers/media/usb/uvc/uvc_video.c:1355 (size 1)

Additionally fix a typo in the documentation for struct uvc_meta_buf.

Reported-by: ionut_n2001@yahoo.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216810
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_video.c | 4 +++-
 include/uapi/linux/uvcvideo.h     | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index b431f06d5a1f5..1c0249df52566 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1278,7 +1278,9 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
 	if (has_scr)
 		memcpy(stream->clock.last_scr, scr, 6);
 
-	memcpy(&meta->length, mem, length);
+	meta->length = mem[0];
+	meta->flags  = mem[1];
+	memcpy(meta->buf, &mem[2], length - 2);
 	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
 
 	uvc_trace(UVC_TRACE_FRAME,
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index f80f05b3c423f..2140923661934 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -86,7 +86,7 @@ struct uvc_xu_control_query {
  * struct. The first two fields are added by the driver, they can be used for
  * clock synchronisation. The rest is an exact copy of a UVC payload header.
  * Only complete objects with complete buffers are included. Therefore it's
- * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
+ * always sizeof(meta->ns) + sizeof(meta->sof) + meta->length bytes large.
  */
 struct uvc_meta_buf {
 	__u64 ns;
-- 
2.39.2



