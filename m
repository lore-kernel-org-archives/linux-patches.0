Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DB1338F51;
	Tue, 26 Aug 2025 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219177; cv=none; b=M6kHuYfEGXEB0gMNss6I9x6NgPsA6k9GOSVUljIAARXTta09dgYZRx9t1XuRJnDKKPY8oxeHAGj9MbuDYAaEAhwBvarP3lLugOUKS+d6P6gweS6TwspfT5asw61ITioMpIDNry4r7LiNvOgBc4BhxGwmOffyN1Zuw8CqDfH1Tdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219177; c=relaxed/simple;
	bh=0e6dNxri774Li+pmpGMg0HxMZFBE3LNJv5i1JnOehpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI0IvkPBEELyJtNd18LCpJP7ifF5Wrf8y222094rCx9tbzptvzVMKfcwDuNsArAXK3NoCSsEZYsOk0cQIKDMF3eStdzLIuK5D0Ugw09j25g2jo9WkRZ+MCT2Ap6DkvitPiqXqY6VD+QQ1N8AjsUUXQCR1SoSewkvuD6wIf0ovoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtBBJT40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtBBJT40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64386C4CEF1;
	Tue, 26 Aug 2025 14:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219177;
	bh=0e6dNxri774Li+pmpGMg0HxMZFBE3LNJv5i1JnOehpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtBBJT40mwGU9b9gxjpAYzdSJO4RnigMQjqXXv3us4dRD8KlFfqpTgflvEFvyfykX
	 Yo8TN4sNNFfVuWaMdenekvVI/HmB9WQq0DSl6VcEvJgvoN/XyU/I7fn/E0bL6bD1hD
	 4tie77o/JCXs5cenmrTDkfsQm/jEgWc3ckhWNIuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.4 281/403] media: uvcvideo: Do not mark valid metadata as invalid
Date: Tue, 26 Aug 2025 13:10:07 +0200
Message-ID: <20250826110914.568962503@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

commit bda2859bff0b9596a19648f3740c697ce4c71496 upstream.

Currently, the driver performs a length check of the metadata buffer
before the actual metadata size is known and before the metadata is
decided to be copied. This results in valid metadata buffers being
incorrectly marked as invalid.

Move the length check to occur after the metadata size is determined and
is decided to be copied.

Cc: stable@vger.kernel.org
Fixes: 088ead255245 ("media: uvcvideo: Add a metadata device node")
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://lore.kernel.org/r/20250707-uvc-meta-v8-1-ed17f8b1218b@chromium.org
Signed-off-by: Hans de Goede <hansg@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_video.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1309,12 +1309,6 @@ static void uvc_video_decode_meta(struct
 	if (!meta_buf || length == 2)
 		return;
 
-	if (meta_buf->length - meta_buf->bytesused <
-	    length + sizeof(meta->ns) + sizeof(meta->sof)) {
-		meta_buf->error = 1;
-		return;
-	}
-
 	has_pts = mem[1] & UVC_STREAM_PTS;
 	has_scr = mem[1] & UVC_STREAM_SCR;
 
@@ -1335,6 +1329,12 @@ static void uvc_video_decode_meta(struct
 				  !memcmp(scr, stream->clock.last_scr, 6)))
 		return;
 
+	if (meta_buf->length - meta_buf->bytesused <
+	    length + sizeof(meta->ns) + sizeof(meta->sof)) {
+		meta_buf->error = 1;
+		return;
+	}
+
 	meta = (struct uvc_meta_buf *)((u8 *)meta_buf->mem + meta_buf->bytesused);
 	local_irq_save(flags);
 	time = uvc_video_get_time();


