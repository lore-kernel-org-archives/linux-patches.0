Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DA01DFE25;
	Wed, 19 Feb 2025 08:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954201; cv=none; b=GXaiW0/YIxdbxeSFYa5xt40w0h8V0D++50fTsrpGbhhb+nLwvI6Ftn2EtQ5R+Oh9NpYBeVBFStNfztWQet6ZiquGSHbhq7dA632bz754u2MaUA6ZzRo97qE557n/tTW8lsa1QG+iv4kSvEsTDQdbMMHCmXjkc0BSSsEorsJ1NfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954201; c=relaxed/simple;
	bh=pcAz1j2KQweEEkzaN6AQwbAEcfIzvCCDgnLHj86UtJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0FhKIg5gi/mS2O9p483FwhfQ8XgQzyyrTuxTehAyzsLjnZQH7rZKq0tuJbTS77IQNP4pwcVyu2YmDcQsLGXLPNmWQ98SYyiJsr1NYC+FPZpQd9d9Jm9FUMXG+UuDJqh8OwNTYk1NeYfqKlmQwA1UXkzcqt+Yc4fN2eSoqqusuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdNVRolo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdNVRolo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CBBC4CED1;
	Wed, 19 Feb 2025 08:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954200;
	bh=pcAz1j2KQweEEkzaN6AQwbAEcfIzvCCDgnLHj86UtJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdNVRoloJb1uTOMcEV88prKae5h+tWzBDOXBWSrQ2QxaGjJFwvZzVKJP9GE4vP+2R
	 Fp94iUU6wSQPXUTmKoIf4FCa8H8s3LonqnxTVsQbywnKFoMO/pJiSHv9cyf0pnAfNp
	 QTYkFaqrngkNl7AfVBtNrqw1yqYrxAyX5SMO7ECE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvarasu Ganesan <selvarasu.g@samsung.com>
Subject: [PATCH 6.13 128/274] usb: gadget: f_midi: Fixing wMaxPacketSize exceeded issue during MIDI bind retries
Date: Wed, 19 Feb 2025 09:26:22 +0100
Message-ID: <20250219082614.622056854@linuxfoundation.org>
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

From: Selvarasu Ganesan <selvarasu.g@samsung.com>

commit 9e8b21410f310c50733f6e1730bae5a8e30d3570 upstream.

The current implementation sets the wMaxPacketSize of bulk in/out
endpoints to 1024 bytes at the end of the f_midi_bind function. However,
in cases where there is a failure in the first midi bind attempt,
consider rebinding. This scenario may encounter an f_midi_bind issue due
to the previous bind setting the bulk endpoint's wMaxPacketSize to 1024
bytes, which exceeds the ep->maxpacket_limit where configured dwc3 TX/RX
FIFO's maxpacket size of 512 bytes for IN/OUT endpoints in support HS
speed only.

Here the term "rebind" in this context refers to attempting to bind the
MIDI function a second time in certain scenarios. The situations where
rebinding is considered include:

 * When there is a failure in the first UDC write attempt, which may be
   caused by other functions bind along with MIDI.
 * Runtime composition change : Example : MIDI,ADB to MIDI. Or MIDI to
   MIDI,ADB.

This commit addresses this issue by resetting the wMaxPacketSize before
endpoint claim. And here there is no need to reset all values in the usb
endpoint descriptor structure, as all members except wMaxPacketSize and
bEndpointAddress have predefined values.

This ensures that restores the endpoint to its expected configuration,
and preventing conflicts with value of ep->maxpacket_limit. It also
aligns with the approach used in other function drivers, which treat
endpoint descriptors as if they were full speed before endpoint claim.

Fixes: 46decc82ffd5 ("usb: gadget: unconditionally allocate hs/ss descriptor in bind operation")
Cc: stable@vger.kernel.org
Signed-off-by: Selvarasu Ganesan <selvarasu.g@samsung.com>
Link: https://lore.kernel.org/r/20250118060134.927-1-selvarasu.g@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -907,6 +907,15 @@ static int f_midi_bind(struct usb_config
 
 	status = -ENODEV;
 
+	/*
+	 * Reset wMaxPacketSize with maximum packet size of FS bulk transfer before
+	 * endpoint claim. This ensures that the wMaxPacketSize does not exceed the
+	 * limit during bind retries where configured dwc3 TX/RX FIFO's maxpacket
+	 * size of 512 bytes for IN/OUT endpoints in support HS speed only.
+	 */
+	bulk_in_desc.wMaxPacketSize = cpu_to_le16(64);
+	bulk_out_desc.wMaxPacketSize = cpu_to_le16(64);
+
 	/* allocate instance-specific endpoints */
 	midi->in_ep = usb_ep_autoconfig(cdev->gadget, &bulk_in_desc);
 	if (!midi->in_ep)


