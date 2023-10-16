Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314821A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djCfytIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F79C433C9;
	Mon, 16 Oct 2023 08:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446358;
	bh=lChw5twFn5K9onv4h2HMtZ7EXvTcbsp0FWPRBCTDHIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djCfytItkZkLXRaH0fmBH7yxFf7zCjhfZOqZsBoL7dLj6g0D6ZPpFP5n8BxZb9C4H
	 jp6/7wsMNu7nefBBUpid3m/Rghfuil/DYa4VQFer/UkCugBFFZNvBxG5iHIhH1JSOX
	 9Is/fXsR+f03fU3dIrIwqYWlcCbcGbW0anVCCbIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Skevis <xristos.thes@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 019/131] ALSA: usb-audio: Fix microphone sound on Nexigo webcam.
Date: Mon, 16 Oct 2023 10:40:02 +0200
Message-ID: <20231016084000.544990387@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christos Skevis <xristos.thes@gmail.com>

commit 4a63e68a295187ae3c1cb3fa0c583c96a959714f upstream.

I own an external usb Webcam, model NexiGo N930AF, which had low mic volume and
inconsistent sound quality. Video works as expected.

(snip)
[  +0.047857] usb 5-1: new high-speed USB device number 2 using xhci_hcd
[  +0.003406] usb 5-1: New USB device found, idVendor=1bcf, idProduct=2283, bcdDevice=12.17
[  +0.000007] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  +0.000004] usb 5-1: Product: NexiGo N930AF FHD Webcam
[  +0.000003] usb 5-1: Manufacturer: SHENZHEN AONI ELECTRONIC CO., LTD
[  +0.000004] usb 5-1: SerialNumber: 20201217011
[  +0.003900] usb 5-1: Found UVC 1.00 device NexiGo N930AF FHD Webcam (1bcf:2283)
[  +0.025726] usb 5-1: 3:1: cannot get usb sound sample rate freq at ep 0x86
[  +0.071482] usb 5-1: 3:2: cannot get usb sound sample rate freq at ep 0x86
[  +0.004679] usb 5-1: 3:3: cannot get usb sound sample rate freq at ep 0x86
[  +0.051607] usb 5-1: Warning! Unlikely big volume range (=4096), cval->res is probably wrong.
[  +0.000005] usb 5-1: [7] FU [Mic Capture Volume] ch = 1, val = 0/4096/1

Set up quirk cval->res to 16 for 256 levels,
Set GET_SAMPLE_RATE quirk flag to stop trying to get the sample rate.
Confirmed that happened anyway later due to the backoff mechanism, after 3 failures

All audio stream on device interfaces share the same values,
apart from wMaxPacketSize and tSamFreq :

(snip)
Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        3
      bAlternateSetting       3
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0
      iInterface              0
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           8
        bDelay                  1 frames
        wFormatTag         0x0001 PCM
      AudioStreaming Interface Descriptor:
        bLength                11
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            1 Discrete
        tSamFreq[ 0]        44100
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x86  EP 6 IN
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x005c  1x 92 bytes
        bInterval               4
        bRefresh                0
        bSynchAddress           0
        AudioStreaming Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay         0x0000
(snip)

Based on the usb data about manufacturer, SPCA2281B3 is the most likely controller IC
Manufacturer does not provide link for datasheet nor detailed specs.
No way to confirm if the firmware supports any other way of getting the sample rate.

Testing patch provides consistent good sound recording quality and volume range.

(snip)
[  +0.045764] usb 5-1: new high-speed USB device number 2 using xhci_hcd
[  +0.106290] usb 5-1: New USB device found, idVendor=1bcf, idProduct=2283, bcdDevice=12.17
[  +0.000006] usb 5-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  +0.000004] usb 5-1: Product: NexiGo N930AF FHD Webcam
[  +0.000003] usb 5-1: Manufacturer: SHENZHEN AONI ELECTRONIC CO., LTD
[  +0.000004] usb 5-1: SerialNumber: 20201217011
[  +0.043700] usb 5-1: set resolution quirk: cval->res = 16
[  +0.002585] usb 5-1: Found UVC 1.00 device NexiGo N930AF FHD Webcam (1bcf:2283)

Signed-off-by: Christos Skevis <xristos.thes@gmail.com>
Link: https://lore.kernel.org/r/20231006155330.399393-1-xristos.thes@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer.c  |    7 +++++++
 sound/usb/quirks.c |    2 ++
 2 files changed, 9 insertions(+)

--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1204,6 +1204,13 @@ static void volume_control_quirks(struct
 			cval->res = 16;
 		}
 		break;
+	case USB_ID(0x1bcf, 0x2283): /* NexiGo N930AF FHD Webcam */
+		if (!strcmp(kctl->id.name, "Mic Capture Volume")) {
+			usb_audio_info(chip,
+				"set resolution quirk: cval->res = 16\n");
+			cval->res = 16;
+		}
+		break;
 	}
 }
 
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2175,6 +2175,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
+	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


