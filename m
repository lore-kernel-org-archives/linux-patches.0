Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A151DE2A5;
	Fri, 21 Nov 2025 13:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731788; cv=none; b=JYEoLgv5zq8i9xiqBp9x7cDrkmP8Vnm8q3JRhw1U8NWvlOtvY487QNfHvtleqW09KT3zGSlcXwU70nsIi9Nh9+bJmOFYqMwj6naQZ6fFIc2VOI31sk6FYPj5C12sM5CnWjBtT8EufQqHB2i8WcAS/4Ki8zXuOAu6TGl0IX3Nhvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731788; c=relaxed/simple;
	bh=I0WTAqX+HZANFtHqToLm1uFnQgkxb1hWGW+/TKjxtKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=be5Lwq6MDOt4yqAgs26APyPnws0buEveNazdGaJPFGquEQkOh6P7YU84bPBdU7LS1gFMgDviwSeWnoXtrLQSBFFsKunN5xpPhFwK5KyYIYHe4If9aqKPK6mHrM+o2EylUtoHxvRtdmQRSFie5GukUWSoZNRy7mzewt886twNMF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cBXs5UhU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cBXs5UhU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C814C4CEF1;
	Fri, 21 Nov 2025 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731788;
	bh=I0WTAqX+HZANFtHqToLm1uFnQgkxb1hWGW+/TKjxtKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cBXs5UhU9jtgloXGwh75cuawdjzbVlfDJefLuOcQ9KI+49NGTn7EAHox+D+qeruDw
	 Qy5SSnc6vL3afdxn07WUE4nOekHd7m/dbJHVdgl8Ikp6dqZj7NcOJluOjbx5x2EKZJ
	 HCGkiiAQfB38g4mkPwXrijEsdUKCX3lXKAZNbCzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/185] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Fri, 21 Nov 2025 14:11:47 +0100
Message-ID: <20251121130146.757781339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba9c6874915a2..4853336f0e6b5 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3079,6 +3079,8 @@ static int snd_usb_mixer_controls_badd(struct usb_mixer_interface *mixer,
 	int i;
 
 	assoc = usb_ifnum_to_if(dev, ctrlif)->intf_assoc;
+	if (!assoc)
+		return -EINVAL;
 
 	/* Detect BADD capture/playback channels from AS EP descriptors */
 	for (i = 0; i < assoc->bInterfaceCount; i++) {
-- 
2.51.0



