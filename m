Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B40188CCA;
	Wed, 19 Feb 2025 08:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955023; cv=none; b=kjJz4mNT47QYEeFhJreIkxDhwx15tep8wJbYwDZGpljAtLyDNw0Zngn3fCr/vQ9F+H8MJ0eODlgCZw2mHCNSCQqUToVJQmFITgLjusNQce1Z71ccawvnhRrHn4FKNvDQz+cJj+oKe0VJRmkF94Kc6RVVGOa6UuJp921AzNrjCh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955023; c=relaxed/simple;
	bh=YSh8F0L2zwPNHCNoeDg6xTt6OVRhZa+zapV6Dzjth3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxHvo4nhfYeXL5C5elY254B+kNVuovfvP1wQCAcVpktIrGgO6DPYpK14gUXjZxO4djpecCrOZgvyXkjIJkCjvouFfvkDI1T+gA8LxJ0+jzkqH6jP9ZtjCr1nQfITPKIn6FRBzXxnSe0RfNLz7H6IIq8RECF1Ljncr7sjIA6xjJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llfXnbX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llfXnbX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795F6C4CEE7;
	Wed, 19 Feb 2025 08:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955022;
	bh=YSh8F0L2zwPNHCNoeDg6xTt6OVRhZa+zapV6Dzjth3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llfXnbX6viabmjBa8KIs3uMscA8V03JeRyhsFzYmPWMYljLuK7ucAcUSX2CaKIGrl
	 53YKWL6MVMn/Hy9YO7rzgMDWOIDRtS+4oXR87JVE4gsYAvNletwKZZKjre3PsRyEEa
	 dUhKaWC5JB11s8nKpbKYi286Nuc1KlQ5pnsJZ324=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvarasu Ganesan <selvarasu.g@samsung.com>
Subject: [PATCH 6.12 109/230] usb: gadget: f_midi: Fixing wMaxPacketSize exceeded issue during MIDI bind retries
Date: Wed, 19 Feb 2025 09:27:06 +0100
Message-ID: <20250219082605.954882809@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


