Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C84417AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14B8C433C7;
	Wed,  9 Aug 2023 11:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581030;
	bh=QhMdq6GsBUCYsRgx77tTtwmBPNjhq1VtDPdyxlTqKHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ovic7cm/I6Chq/SaR/uOPpNQulfRPBvCgzBT6lLQO7rQL3daoh9vJH7M8BMOTCaw
	 Xy4z7f94N25iWl2OQ65rzGM17kJac4MtyNkAB8vN7WUorqbalNlpvTKy+uarbOXQZL
	 qv9kgHokHze0klO1P0aYFViqAlzP2AYh5RiboSak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <lb@semihalf.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 079/201] USB: quirks: add quirk for Focusrite Scarlett
Date: Wed,  9 Aug 2023 12:41:21 +0200
Message-ID: <20230809103646.451791558@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Łukasz Bartosik <lb@semihalf.com>

commit 9dc162e22387080e2d06de708b89920c0e158c9a upstream.

The Focusrite Scarlett audio device does not behave correctly during
resumes. Below is what happens during every resume (captured with
Beagle 5000):

<Suspend>
<Resume>
<Reset>/<Chirp J>/<Tiny J>
<Reset/Target disconnected>
<High Speed>

The Scarlett disconnects and is enumerated again.

However from time to time it drops completely off the USB bus during
resume. Below is captured occurrence of such an event:

<Suspend>
<Resume>
<Reset>/<Chirp J>/<Tiny J>
<Reset>/<Chirp K>/<Tiny K>
<High Speed>
<Corrupted packet>
<Reset/Target disconnected>

To fix the condition a user has to unplug and plug the device again.

With USB_QUIRK_RESET_RESUME applied ("usbcore.quirks=1235:8211:b")
for the Scarlett audio device the issue still reproduces.

Applying USB_QUIRK_DISCONNECT_SUSPEND ("usbcore.quirks=1235:8211:m")
fixed the issue and the Scarlett audio device didn't drop off the USB
bus for ~5000 suspend/resume cycles where originally issue reproduced in
~100 or less suspend/resume cycles.

Signed-off-by: Łukasz Bartosik <lb@semihalf.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20230724112911.1802577-1-lb@semihalf.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -437,6 +437,10 @@ static const struct usb_device_id usb_qu
 	/* novation SoundControl XL */
 	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Focusrite Scarlett Solo USB */
+	{ USB_DEVICE(0x1235, 0x8211), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },


