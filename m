Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B11A1A6160;
	Tue, 30 Jul 2024 16:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356954; cv=none; b=ka/EZZ7NpLtMPzVeQaGCXov41uBLQEQTvGP3anfBek3en9z8I4WlRSS4GyLSa3ErXbTtqzoJVqnMY/N+HXMqAyHXv42RcCTo0z+fTA38ZYJH9dBUUU7I6iPGq2Ib3t7zCpxaK71EFA8IZeWDz8QKt8QVxAidwpJslfC82lJXLLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356954; c=relaxed/simple;
	bh=qVeNAqc/4T7PhbP8FoIzg9WiwDJyCWxD9NCPpIZqGi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NcT4i35N/wvwV08iAuQ/RwA2aCaEl+O3OLbpr9uGQn93AaTIbZKefbQDZ4KuYaWrayAEZtokyTIUHOYKPt7zSpWROGif6pTstUfeVWg9EYoOk+HVY98FpFUkhXx3h9dBfGmO3ev4lPTMAuB20zlGLKCG4tzendMED/24yWjX3+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWYZmHM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWYZmHM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E79C32782;
	Tue, 30 Jul 2024 16:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356954;
	bh=qVeNAqc/4T7PhbP8FoIzg9WiwDJyCWxD9NCPpIZqGi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWYZmHM7eniBNFoj4RRB+7v33Lj3m5i9ZzohIJj1YNizmVtUUfMhmSIjnZlCUEZUW
	 zUM+KtnFzySDlrFJTtzjbWpNHrzh4C8Iw4BckE4Uu479xIbJzEWWNnv+U6UH3yvyCg
	 gc9M3Cx8032lB09O4xYZViNmq9/RYISR6eijwd/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Natalenko <oleksandr@natalenko.name>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/568] media: uvcvideo: Add quirk for invalid dev_sof in Logitech C920
Date: Tue, 30 Jul 2024 17:45:11 +0200
Message-ID: <20240730151647.848334411@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Natalenko <oleksandr@natalenko.name>

[ Upstream commit 85fbe91a7c9210bb30638846b551fa5d3cb7bc4c ]

Similarly to Logitech C922, C920 seems to also suffer from a firmware
bug that breaks hardware timestamping.

Add a quirk for this camera model too.

Before applying the quirk:

```
100 (4) [-] none 100 200717 B 212.919114 213.079004 33.727 fps ts mono/SoE
101 (5) [-] none 101 200889 B 213.003703 213.114996 11.822 fps ts mono/SoE
102 (6) [-] none 102 200926 B 213.035571 213.146999 31.379 fps ts mono/SoE
103 (7) [-] none 103 200839 B 213.067424 213.179003 31.394 fps ts mono/SoE
104 (0) [-] none 104 200692 B 213.293180 213.214991 4.430 fps ts mono/SoE
105 (1) [-] none 105 200937 B 213.322374 213.247001 34.254 fps ts mono/SoE
106 (2) [-] none 106 201013 B 213.352228 213.279005 33.496 fps ts mono/SoE
…
```

After applying the quirk:

```
154 (2) [-] none 154 192417 B 42.199823 42.207788 27.779 fps ts mono/SoE
155 (3) [-] none 155 192040 B 42.231834 42.239791 31.239 fps ts mono/SoE
156 (4) [-] none 156 192213 B 42.263823 42.271822 31.261 fps ts mono/SoE
157 (5) [-] none 157 191981 B 42.299824 42.303827 27.777 fps ts mono/SoE
158 (6) [-] none 158 191953 B 42.331835 42.339811 31.239 fps ts mono/SoE
159 (7) [-] none 159 191904 B 42.363824 42.371813 31.261 fps ts mono/SoE
160 (0) [-] none 160 192210 B 42.399834 42.407801 27.770 fps ts mono/SoE
```

Fixes: 5d0fd3c806b9 ("[media] uvcvideo: Disable hardware timestamps by default")
Signed-off-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://lore.kernel.org/r/20240325142611.15550-1-oleksandr@natalenko.name
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 664a1b7314197..68bf41147a619 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2580,7 +2580,8 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceClass	= USB_CLASS_VIDEO,
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
-	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_RESTORE_CTRLS_ON_INIT) },
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_RESTORE_CTRLS_ON_INIT
+					       | UVC_QUIRK_INVALID_DEVICE_SOF) },
 	/* Logitech HD Pro Webcam C922 */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
2.43.0



