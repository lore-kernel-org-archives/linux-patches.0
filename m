Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0D41F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19CFC433C9;
	Tue,  1 Aug 2023 09:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882116;
	bh=UYaElANgHIMJMp7wt646gtwuPHJpgPH0Jro33rgN+1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WV5rRqXqAHHMqN2jtz7ByQdn2TbbXnKdFlB2bvS0KWcyoEj0Qp0eXp5XxXvKpYLuI
	 2n2mMPWH1cr2N4wOrKZZXthwelpYnn4nrBMzisBQuncNPfRX2V0sXSxd/EC/vVH3Bn
	 J+7gYok2GR4h6F49Gy1NsqkLUQQgPHpTux6T6I/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <lb@semihalf.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.15 118/155] USB: quirks: add quirk for Focusrite Scarlett
Date: Tue,  1 Aug 2023 11:20:30 +0200
Message-ID: <20230801091914.430534688@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
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
@@ -436,6 +436,10 @@ static const struct usb_device_id usb_qu
 	/* novation SoundControl XL */
 	{ USB_DEVICE(0x1235, 0x0061), .driver_info = USB_QUIRK_RESET_RESUME },
 
+	/* Focusrite Scarlett Solo USB */
+	{ USB_DEVICE(0x1235, 0x8211), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },


