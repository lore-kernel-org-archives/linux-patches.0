Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826005FB86;
	Tue, 13 Feb 2024 17:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845102; cv=none; b=t4WsrcZJ62LKzLqpKvlmGy+n7w8HP1iK64V1cz3uPmvr1mTsRJOaoTPYJwZB9fQoz7HWX7QZsJTWrTEFxEYjg9y7Tv65OmdjDMwAv977h0NE5pn5U8BWYZ7lOd9hrDTvVOJzsj8ccef+gx5zPe0ihoU7kdH66uzVZT1mS+Hi/qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845102; c=relaxed/simple;
	bh=z2x7bwmHJW25lWJoQgnOYxeScBq6qND1bdQYAZVQIAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BrpoLZtIoLbLAp3hfv4jGB6+jWT2cbgpakQlTsw5DjGXzNkWIvsIOY9rL0HWlKDOd+FZVU5S9aIFTCyqUTZ8OVtbQEkkq4mM95yzMRZxYJbfCQxdH6bqiSVQeqHS/Og6mgOds3MStGKysk16v+uobh6MocmaC4YZhzkuPZ5zyYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dINi2t8i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dINi2t8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC69AC433F1;
	Tue, 13 Feb 2024 17:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845102;
	bh=z2x7bwmHJW25lWJoQgnOYxeScBq6qND1bdQYAZVQIAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dINi2t8i+b+yHByWaI6svIjv4i26wwQDzRXuRKix1NAV4/YNm6lLXv8N/p6zU+kOm
	 QPYo1MWXk/ausGsm2XnhHJcvfUITg5+gmMWGCBLejyXH8EP2xNgSD8xrb5zY1JG7Hp
	 eoaRlww5rOFRv2PzNORgpFyiP/KPTCU/LeHYBx50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 47/64] ALSA: usb-audio: add quirk for RODE NT-USB+
Date: Tue, 13 Feb 2024 18:21:33 +0100
Message-ID: <20240213171846.218957890@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171844.702064831@linuxfoundation.org>
References: <20240213171844.702064831@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit 7822baa844a87cbb93308c1032c3d47d4079bb8a upstream.

The RODE NT-USB+ is marketed as a professional usb microphone, however the
usb audio interface is a mess:

[    1.130977] usb 1-5: new full-speed USB device number 2 using xhci_hcd
[    1.503906] usb 1-5: config 1 has an invalid interface number: 5 but max is 4
[    1.503912] usb 1-5: config 1 has no interface number 4
[    1.519689] usb 1-5: New USB device found, idVendor=19f7, idProduct=0035, bcdDevice= 1.09
[    1.519695] usb 1-5: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.519697] usb 1-5: Product: RØDE NT-USB+
[    1.519699] usb 1-5: Manufacturer: RØDE
[    1.519700] usb 1-5: SerialNumber: 1D773A1A
[    8.327495] usb 1-5: 1:1: cannot get freq at ep 0x82
[    8.344500] usb 1-5: 1:2: cannot get freq at ep 0x82
[    8.365499] usb 1-5: 2:1: cannot get freq at ep 0x2

Add QUIRK_FLAG_GET_SAMPLE_RATE to work around the broken sample rate get.
I have asked Rode support to fix it, but they show no interest.

Signed-off-by: Sean Young <sean@mess.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240124151524.23314-1-sean@mess.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2181,6 +2181,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x1bcf, 0x2283, /* NexiGo N930AF FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
+		   QUIRK_FLAG_GET_SAMPLE_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */


