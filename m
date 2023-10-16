Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670B917725
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFGGwIFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7771C433C9;
	Mon, 16 Oct 2023 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445814;
	bh=45Qu/UZ6qaRFfb0CfUw32eXejFL689pHWy3cKnA+UKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFGGwIFAjnpeCqQ5vivj55W+YIffiSRWkJN8YhHJIE/+Obz7K1ChuNvjiO50oFQUT
	 gXIzGKguOAHW7x/mviqfuHMAMPXW3QClb/GHoIuJqaZUHe2LJzsyyNLcqy8uNfWsho
	 zHix8lm4ap3AYVNr0+py/3oEtLOFvXLlB4VBWpYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WhaleChang <whalechang@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 015/102] ALSA: usb-audio: Fix microphone sound on Opencomm2 Headset
Date: Mon, 16 Oct 2023 10:40:14 +0200
Message-ID: <20231016083954.093784205@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: WhaleChang <whalechang@google.com>

commit 6a83d6f3bb3c329a73e3483651fb77b78bac1878 upstream.

When a Opencomm2 Headset is connected to a Bluetooth USB dongle,
the audio playback functions properly, but the microphone does not work.

In the dmesg logs, there are messages indicating that the init_pitch
function fails when the capture process begins.

The microphone only functions when the ep pitch control is not set.

Toggling the pitch control off bypasses the init_piatch function
and allows the microphone to work.

Signed-off-by: WhaleChang <whalechang@google.com>
Link: https://lore.kernel.org/r/20231006044852.4181022-1-whalechang@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1725,7 +1725,11 @@ void snd_usb_audioformat_attributes_quir
 		/* mic works only when ep packet size is set to wMaxPacketSize */
 		fp->attributes |= UAC_EP_CS_ATTR_FILL_MAX;
 		break;
-
+	case USB_ID(0x3511, 0x2b1e): /* Opencomm2 UC USB Bluetooth dongle */
+		/* mic works only when ep pitch control is not set */
+		if (stream == SNDRV_PCM_STREAM_CAPTURE)
+			fp->attributes &= ~UAC_EP_CS_ATTR_PITCH_CONTROL;
+		break;
 	}
 }
 


