Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 761FD2F360C;
	Fri, 21 Nov 2025 13:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731170; cv=none; b=ID/2aj8Rr/xNaHErNJQBc5J8uNsFvSQqBwjf8jPRs9tzQKSj2TQJjswMI1voHr+sdCwmvQaDRYEHT7pQsWXz/TM+77vUkW9GCtoe41iF6Tr2WS0bm9o8T6Ck+uEdLbEmHNlTFIjrbjNph1t/lRYqPNAeu7gOMw+NR4CTPOK0SVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731170; c=relaxed/simple;
	bh=VmCcJ+a3extd72GdlIWYPYqvoBKg84fV8h+BQoYCcBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb4l5ZqJ0m8Bla8a5Apx1GFhezgO1sU3mNtAws0NOxcN8HpZ9R17imKlDghhOt4NErQL73WayJXFgq1U9Oo4iVO20MFPGLPuLNinddmgsiKXhN5dNVdabb8dHoeVkHKWYIw6EVieP/8hlBknbljO9hVmzqKl7CFjL8EigLHOK/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMTtg983; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMTtg983"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8116C4CEF1;
	Fri, 21 Nov 2025 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731170;
	bh=VmCcJ+a3extd72GdlIWYPYqvoBKg84fV8h+BQoYCcBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMTtg983qXY3vmq6pWvhc45F7Vg6jpZ2uBHpf2raZ85iweitLZfoKNvfOKzaghsK8
	 A/BIYu1pGznSnQu+zAj52Zh/djdk/JH2KSgGhP4lqK52EzLb9RaliqGd4liiIA4xqa
	 HKNyBXo1E1CA5Tq3/d1A1jZR844Ixlmj/Tr0lsdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 113/247] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Fri, 21 Nov 2025 14:11:00 +0100
Message-ID: <20251121130158.639182720@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haein Lee <lhi0729@kaist.ac.kr>

[ Upstream commit 632108ec072ad64c8c83db6e16a7efee29ebfb74 ]

In snd_usb_create_streams(), for UAC version 3 devices, the Interface
Association Descriptor (IAD) is retrieved via usb_ifnum_to_if(). If this
call fails, a fallback routine attempts to obtain the IAD from the next
interface and sets a BADD profile. However, snd_usb_mixer_controls_badd()
assumes that the IAD retrieved from usb_ifnum_to_if() is always valid,
without performing a NULL check. This can lead to a NULL pointer
dereference when usb_ifnum_to_if() fails to find the interface descriptor.

This patch adds a NULL pointer check after calling usb_ifnum_to_if() in
snd_usb_mixer_controls_badd() to prevent the dereference.

This issue was discovered by syzkaller, which triggered the bug by sending
a crafted USB device descriptor.

Fixes: 17156f23e93c ("ALSA: usb: add UAC3 BADD profiles support")
Signed-off-by: Haein Lee <lhi0729@kaist.ac.kr>
Link: https://patch.msgid.link/vwhzmoba9j2f.vwhzmob9u9e2.g6@dooray.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index cf296decefefc..f2058eb71fc8d 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3080,6 +3080,8 @@ static int snd_usb_mixer_controls_badd(struct usb_mixer_interface *mixer,
 	int i;
 
 	assoc = usb_ifnum_to_if(dev, ctrlif)->intf_assoc;
+	if (!assoc)
+		return -EINVAL;
 
 	/* Detect BADD capture/playback channels from AS EP descriptors */
 	for (i = 0; i < assoc->bInterfaceCount; i++) {
-- 
2.51.0



