Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E4F2B9A6;
	Thu,  3 Jul 2025 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554976; cv=none; b=Q7U+EwqOS4fZl+ksbjPQptFYJKPHT5BVYh8ptTZ+gtmdyztZ/3YPF9DFJWQe9f3wJTdegCMrQ13twRUcyRvMkGAoTAErQZ8abS3p1kL4v0b/0NdUAn/2h+MAxXUj60j0le7lYkafEv62OzabztZPZ6i3ecwfeuf3r5Oj9K48Vfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554976; c=relaxed/simple;
	bh=Gw80lKoGLSMmi4vR72rNesd/PYR2HWEDeQK33LpU4VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrOpWYB6PjTDZnIrfd5KB/jM5NlbmIJflkPZe5xfdya7iKFvqnBg7iDMobwWx7TZfRvLEbVDOnaixVWyBbB6kUAejtp5TSykP5wTzcEdDZ3pTe+l7EepMP/pVYsQrFAXRRQ2l2GIMUoaTuA/mfdDS29hDtdGn2HjsJ8XKezYlXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iyr7UjmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iyr7UjmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C086C4CEE3;
	Thu,  3 Jul 2025 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554976;
	bh=Gw80lKoGLSMmi4vR72rNesd/PYR2HWEDeQK33LpU4VM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iyr7UjmJVL6LDD7mE1J3YDjjIK3SDdQNSUfOMJ9indaa22fHlYVbdEPmdWaeqhm/Z
	 djxszhtWXsAMINj+TgpaX0/shPVGuPelVWR78esvpn9hX6TX13HOuig49iJhg5fTYX
	 IwsygtuarI9rVwzRaGD+lTqlK0bB43V+iLjp6Rak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Youngjun Lee <yjjuny.lee@samsung.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 138/263] ALSA: usb-audio: Fix out-of-bounds read in snd_usb_get_audioformat_uac3()
Date: Thu,  3 Jul 2025 16:40:58 +0200
Message-ID: <20250703144009.892354266@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Youngjun Lee <yjjuny.lee@samsung.com>

[ Upstream commit fb4e2a6e8f28a3c0ad382e363aeb9cd822007b8a ]

In snd_usb_get_audioformat_uac3(), the length value returned from
snd_usb_ctl_msg() is used directly for memory allocation without
validation. This length is controlled by the USB device.

The allocated buffer is cast to a uac3_cluster_header_descriptor
and its fields are accessed without verifying that the buffer
is large enough. If the device returns a smaller than expected
length, this leads to an out-of-bounds read.

Add a length check to ensure the buffer is large enough for
uac3_cluster_header_descriptor.

Signed-off-by: Youngjun Lee <yjjuny.lee@samsung.com>
Fixes: 9a2fe9b801f5 ("ALSA: usb: initial USB Audio Device Class 3.0 support")
Link: https://patch.msgid.link/20250623-uac3-oob-fix-v1-1-527303eaf40a@samsung.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/stream.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/stream.c b/sound/usb/stream.c
index c1ea8844a46fc..aa91d63749f2c 100644
--- a/sound/usb/stream.c
+++ b/sound/usb/stream.c
@@ -987,6 +987,8 @@ snd_usb_get_audioformat_uac3(struct snd_usb_audio *chip,
 	 * and request Cluster Descriptor
 	 */
 	wLength = le16_to_cpu(hc_header.wLength);
+	if (wLength < sizeof(cluster))
+		return NULL;
 	cluster = kzalloc(wLength, GFP_KERNEL);
 	if (!cluster)
 		return ERR_PTR(-ENOMEM);
-- 
2.39.5



