Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323A910FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E589C433D2;
	Wed,  7 Jun 2023 20:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169719;
	bh=CvlLElXcjYvRll3uPwyHPnhAE3elD3zjxI3Cf/MS8Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hsrz7dl5Ids9QNy1jnqWJCKJPbSldJK0tUVwD4ubnB4We89091Y7xpQqOoRcg7CyZ
	 iL11mFoJYq9E6Xp+U1LTfbXdvtUAcNmRkW53Mcb4bHmJ1+QW/9GQtzlucmF1edJ+7i
	 iDdl69QIucIiajL0dEZV8SQowAhiKYW7Bx20c3JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 187/286] media: uvcvideo: Dont expose unsupported formats to userspace
Date: Wed,  7 Jun 2023 22:14:46 +0200
Message-ID: <20230607200929.381197988@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 81f3affa19d6ab0c32aef46b053838219eef7e71 ]

When the uvcvideo driver encounters a format descriptor with an unknown
format GUID, it creates a corresponding struct uvc_format instance with
the fcc field set to 0. Since commit 50459f103edf ("media: uvcvideo:
Remove format descriptions"), the driver relies on the V4L2 core to
provide the format description string, which the V4L2 core can't do
without a valid 4CC. This triggers a WARN_ON.

As a format with a zero 4CC can't be selected, it is unusable for
applications. Ignore the format completely without creating a uvc_format
instance, which fixes the warning.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217252
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2180107

Fixes: 50459f103edf ("media: uvcvideo: Remove format descriptions")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 7aefa76a42b31..d631ce4f9f7bb 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -251,14 +251,17 @@ static int uvc_parse_format(struct uvc_device *dev,
 		/* Find the format descriptor from its GUID. */
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
-		if (fmtdesc != NULL) {
-			format->fcc = fmtdesc->fcc;
-		} else {
+		if (!fmtdesc) {
+			/*
+			 * Unknown video formats are not fatal errors, the
+			 * caller will skip this descriptor.
+			 */
 			dev_info(&streaming->intf->dev,
 				 "Unknown video format %pUl\n", &buffer[5]);
-			format->fcc = 0;
+			return 0;
 		}
 
+		format->fcc = fmtdesc->fcc;
 		format->bpp = buffer[21];
 
 		/*
@@ -675,7 +678,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 	interval = (u32 *)&frame[nframes];
 
 	streaming->format = format;
-	streaming->nformats = nformats;
+	streaming->nformats = 0;
 
 	/* Parse the format descriptors. */
 	while (buflen > 2 && buffer[1] == USB_DT_CS_INTERFACE) {
@@ -689,7 +692,10 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 				&interval, buffer, buflen);
 			if (ret < 0)
 				goto error;
+			if (!ret)
+				break;
 
+			streaming->nformats++;
 			frame += format->nframes;
 			format++;
 
-- 
2.39.2



