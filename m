Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6991DE2A6;
	Wed, 19 Feb 2025 08:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954288; cv=none; b=MJK9sFlIdLEN8dC1ajAPOOCGXjGXHX9eUfgjKThNNFRO2UD+c2mY+izJLS796xAWEwBFBddHJF2iSFRGsrtq2uHZ5hOrELOXxlXyJ3XKo2rdWHu4FULd2+e/+VPavLK06NLCa5H1urxMSCT5p1lnBFMxMagwDEdCWbzHI/1S2l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954288; c=relaxed/simple;
	bh=1+KSkHZ6xFs7xjkz0HiTRwfvfBFEzRVxltx34HerpBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUsLwHHZxM/DJcAG7kZHxpL1z9JgWoZgMoYOzANQvXZ9+5Xu9QUvnD5mgowhvl9qtfBpmc58vAd/xhdGk/hBpAkqwP5AoJAo5bSJ/Lja3z5M1S1Idzqoe40br61KcvZg6PU7cHYPYiRF9Yv/T9ZZbz0uJZT3yAoSvbuVbnSHXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/Z6tATq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/Z6tATq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39BCCC4CEE6;
	Wed, 19 Feb 2025 08:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954287;
	bh=1+KSkHZ6xFs7xjkz0HiTRwfvfBFEzRVxltx34HerpBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/Z6tATqbP62I96YJv5/ckMBR3BHpHaHMbnpCkSzEknw9cMZ45bRruwK4m9prZQiY
	 gjB0yVTiu58Ct2Yu+QHudL17RGpIIKoR9YDoUnMq+byGliP/eFWAt6pufCxC7SpZ3n
	 9bJbqYytl1hUiGIC+WtRVxx17YBAAu1YmjZKHOec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 139/274] usb: gadget: f_midi: fix MIDI Streaming descriptor lengths
Date: Wed, 19 Feb 2025 09:26:33 +0100
Message-ID: <20250219082615.045354760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Keeping <jkeeping@inmusicbrands.com>

commit da1668997052ed1cb00322e1f3b63702615c9429 upstream.

While the MIDI jacks are configured correctly, and the MIDIStreaming
endpoint descriptors are filled with the correct information,
bNumEmbMIDIJack and bLength are set incorrectly in these descriptors.

This does not matter when the numbers of in and out ports are equal, but
when they differ the host will receive broken descriptors with
uninitialized stack memory leaking into the descriptor for whichever
value is smaller.

The precise meaning of "in" and "out" in the port counts is not clearly
defined and can be confusing.  But elsewhere the driver consistently
uses this to match the USB meaning of IN and OUT viewed from the host,
so that "in" ports send data to the host and "out" ports receive data
from it.

Cc: stable <stable@kernel.org>
Fixes: c8933c3f79568 ("USB: gadget: f_midi: allow a dynamic number of input and output ports")
Signed-off-by: John Keeping <jkeeping@inmusicbrands.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20250130195035.3883857-1-jkeeping@inmusicbrands.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1009,11 +1009,11 @@ static int f_midi_bind(struct usb_config
 	}
 
 	/* configure the endpoint descriptors ... */
-	ms_out_desc.bLength = USB_DT_MS_ENDPOINT_SIZE(midi->in_ports);
-	ms_out_desc.bNumEmbMIDIJack = midi->in_ports;
+	ms_out_desc.bLength = USB_DT_MS_ENDPOINT_SIZE(midi->out_ports);
+	ms_out_desc.bNumEmbMIDIJack = midi->out_ports;
 
-	ms_in_desc.bLength = USB_DT_MS_ENDPOINT_SIZE(midi->out_ports);
-	ms_in_desc.bNumEmbMIDIJack = midi->out_ports;
+	ms_in_desc.bLength = USB_DT_MS_ENDPOINT_SIZE(midi->in_ports);
+	ms_in_desc.bNumEmbMIDIJack = midi->in_ports;
 
 	/* ... and add them to the list */
 	endpoint_descriptor_index = i;


