Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EBA25F7AD;
	Tue, 11 Mar 2025 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707040; cv=none; b=pSPOU+3fkadwE44YXW8uF8gN6B6PrKS3PbtB+HdhzfWUgSseEW9CCL9A8r+8GXF/cJ6gMbPiXXd7Vt8qYhPCdSDmo9d5bfROBpV88QDVvs4TX2VAcYBQFcV8DoOW3I/iHN72GK3Dvl7cnWJ4E2ngo8G2+k7H/J4dY8Pp1eoFCSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707040; c=relaxed/simple;
	bh=KXnmrrZ8Qb5qdCvja3Bt48CJXeLfctnFGZpEfvCa+sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGTLXBQe8opFwrRxsTP0s85ogRZ44exC3ZarSyakM/F2PULSzdrzN/g8USJff3+B/B9zfxs/Q9oR6X2778+jy0uM4z1ffMBQjt2C6VyJSQ6rgDQ0SMRHXAh+rRHr28h+lUCG5PmA0AExkxeb0tMmpqW4RIp2E2arYgv9nK/dFeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Opc8Tsvt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Opc8Tsvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22324C4CEEF;
	Tue, 11 Mar 2025 15:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707040;
	bh=KXnmrrZ8Qb5qdCvja3Bt48CJXeLfctnFGZpEfvCa+sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Opc8Tsvt+dGUjVfbthe5IG8D1wtc7nw46e0aFMKNnAO6R8UD2lB8Zs9oaYW/C+qqA
	 D9lL14eakh8raovHNgMNpZ7kvW5EL+RvJaLQh68lnLoI8iXWC0DVB+musOh5elb1BD
	 U0GwEackd7DY8n7H5U+/MhUqfNk25YjY6xf4tBIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	John Keeping <jkeeping@inmusicbrands.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 254/462] usb: gadget: f_midi: fix MIDI Streaming descriptor lengths
Date: Tue, 11 Mar 2025 15:58:40 +0100
Message-ID: <20250311145808.396373078@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -997,11 +997,11 @@ static int f_midi_bind(struct usb_config
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


