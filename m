Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F78632896A;
	Wed, 17 Sep 2025 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113636; cv=none; b=iCmDqh+bRKDW3bizRIrGRWK9Un0ZcWIqdTR/kZdisdc8wjaLLHtJLUt8YOl4/sIba2W21ObSbjUyVq8UpLvzTOYm1EoiPFNXTsj9IMOu1cn+aoxsTmhqPAKUV0c2enlwnABFzJ3Xp2veCPe5WSUqu2AlrVr7wB+Yd4r9NICvf58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113636; c=relaxed/simple;
	bh=NgpCrbj0lMsZ0/MqWgkQYuyt8gmtW34I/ss9N3bxdu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONaOIY+q3EWVFQyPe+dLbT7NHxqDwUo5MJ1GKKe0mzxGxnBYkinm21dVqvLmEZN+F59asAbVNDvRNAHbePvuh3OxKYQEvct2vyR/SlqkaNA5dw9ZDLj3XA8+s2ClBTMhRyWNd3N0BVzHXnx+07r6jGsy2H/3WbTq6ewPthRDk1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1l0qvZUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l0qvZUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF24DC4CEF0;
	Wed, 17 Sep 2025 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113636;
	bh=NgpCrbj0lMsZ0/MqWgkQYuyt8gmtW34I/ss9N3bxdu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l0qvZUsNBvnO+pHH1NorvHkMogvqW4KT1Xg8GLUn68T9MuQ/8B8GBa8jP5UdAZUV
	 N+9NDS37UhDEFsVmTCcpnyy7FJuDR3aTG+0Vz8QVyiYGC9+/OSNHcVS6XF/2dy8h/w
	 9iZZn6Xo1qVQUZg+v86uJ3XNp8JXkvXffT0wtkKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 131/140] usb: gadget: midi2: Fix MIDI2 IN EP max packet size
Date: Wed, 17 Sep 2025 14:35:03 +0200
Message-ID: <20250917123347.517008483@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123344.315037637@linuxfoundation.org>
References: <20250917123344.315037637@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 116e79c679a1530cf833d0ff3007061d7a716bd9 upstream.

The EP-IN of MIDI2 (altset 1) wasn't initialized in
f_midi2_create_usb_configs() as it's an INT EP unlike others BULK
EPs.  But this leaves rather the max packet size unchanged no matter
which speed is used, resulting in the very slow access.
And the wMaxPacketSize values set there look legit for INT EPs, so
let's initialize the MIDI2 EP-IN there for achieving the equivalent
speed as well.

Fixes: 8b645922b223 ("usb: gadget: Add support for USB MIDI 2.0 function driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20250905133240.20966-1-tiwai@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi2.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_midi2.c
+++ b/drivers/usb/gadget/function/f_midi2.c
@@ -1739,9 +1739,12 @@ static int f_midi2_create_usb_configs(st
 	case USB_SPEED_HIGH:
 		midi2_midi1_ep_out_desc.wMaxPacketSize = cpu_to_le16(512);
 		midi2_midi1_ep_in_desc.wMaxPacketSize = cpu_to_le16(512);
-		for (i = 0; i < midi2->num_eps; i++)
+		for (i = 0; i < midi2->num_eps; i++) {
 			midi2_midi2_ep_out_desc[i].wMaxPacketSize =
 				cpu_to_le16(512);
+			midi2_midi2_ep_in_desc[i].wMaxPacketSize =
+				cpu_to_le16(512);
+		}
 		fallthrough;
 	case USB_SPEED_FULL:
 		midi1_in_eps = midi2_midi1_ep_in_descs;
@@ -1750,9 +1753,12 @@ static int f_midi2_create_usb_configs(st
 	case USB_SPEED_SUPER:
 		midi2_midi1_ep_out_desc.wMaxPacketSize = cpu_to_le16(1024);
 		midi2_midi1_ep_in_desc.wMaxPacketSize = cpu_to_le16(1024);
-		for (i = 0; i < midi2->num_eps; i++)
+		for (i = 0; i < midi2->num_eps; i++) {
 			midi2_midi2_ep_out_desc[i].wMaxPacketSize =
 				cpu_to_le16(1024);
+			midi2_midi2_ep_in_desc[i].wMaxPacketSize =
+				cpu_to_le16(1024);
+		}
 		midi1_in_eps = midi2_midi1_ep_in_ss_descs;
 		midi1_out_eps = midi2_midi1_ep_out_ss_descs;
 		break;


