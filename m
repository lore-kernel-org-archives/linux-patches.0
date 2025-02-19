Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DA72AE74;
	Wed, 19 Feb 2025 09:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957396; cv=none; b=D6oTl3PZmi6ri6WhqS8T0hatuZVQW/2vdGmdFWiWCWjth/Wskyiya4/XxUt8OOYTmjRx4MIA4aENAX8qbz8P2LRPSD5J4Gl9zeGRteiERp7dOEnz+FlNIMnnaPWeepsb4DGTpiX9+3TawSB4LxjHPAIO12eRl7h5TON05skohVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957396; c=relaxed/simple;
	bh=8hakwSRMZ6Vi6Zr2a+GJ7lgXS8ypx9uKSp3t+HCjmpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t1mvs0aNlytHCGTXrx+2D2eUqOV9YOpSIWw3eedNtw6hSIlfmlKqAo91yIphojSvHAcjSHYzYsn9fY7XNj1z9nNwzWfCPr/1cDI6yg7VDp28Fs1GBigCIoFv4ooVkSngROSsdJKVMrTG4c2HqGlKXuNjkgm2cFCJ1AV/1Y/cozM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEZZZQno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEZZZQno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C92C4CEE7;
	Wed, 19 Feb 2025 09:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957396;
	bh=8hakwSRMZ6Vi6Zr2a+GJ7lgXS8ypx9uKSp3t+HCjmpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XEZZZQnocFI+rwMiD0aAyMYmPF2dQHOktHPdU3Kv9kGtmTEwAzO05kNSOGJJG0hVJ
	 no/yuxYNFNrLlFSNc6NQylhyfYlzUDmxb8XGS0zuvPLsXhgyKknMvLH+O2Ihk3pmNT
	 1gMJBcc1VV8+QUFvrFRDUc277VmMx25mO4r/sr+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 511/578] usb: gadget: f_midi: fix MIDI Streaming descriptor lengths
Date: Wed, 19 Feb 2025 09:28:35 +0100
Message-ID: <20250219082713.085273523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -999,11 +999,11 @@ static int f_midi_bind(struct usb_config
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


