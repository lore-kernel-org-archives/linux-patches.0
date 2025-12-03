Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70143340281;
	Wed,  3 Dec 2025 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780013; cv=none; b=olFheqt6Fnn1NVaka4+dHY6Rnwj4pkdfu3DZAyg1OIpiu59pQQfkFEHZF4xiML/LcxrO1KPovjOMHJyxlAVLu+Jo3O7UviBaxQPIMfMF/ZGuExuSTAV5i7UxbhpA+NhcftiJ21YnaCdb5C36+xxOyKdKq+4hwvjKoZA0COROyto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780013; c=relaxed/simple;
	bh=PwNLt8EYJKSj3Ph+Fqx4IyEJCC1KD7Pk7H94ytI+Q3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY/3e/6Ifp3RCW3axIL1kYParxpSiK8fO0eRcYtkE8pEN4Wiydh7nH9p+FVhkkAZltdy0ibx4bmk50/y1r27yn4KmyXmcTpPkaSqXu5DjMxWfzV7UX5Dvpx6fDu1YJzwwmyZ9tIoq32J7i+zVSnbynIYKznt/IytG7dxgWE9bM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p96F2Kgk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p96F2Kgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF492C4CEF5;
	Wed,  3 Dec 2025 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780013;
	bh=PwNLt8EYJKSj3Ph+Fqx4IyEJCC1KD7Pk7H94ytI+Q3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p96F2KgkC1itq/ZYkCGrkW+ayDoIZcLsyeN/xsewJIhamop8FP26jusBt3wYgCxoX
	 5uIlgK8D4gY5DrtBnh7Zyseiie71lslEvuCF/UBrl0DliyJycirotyjaYOeqf2SFzP
	 BKJBNrntUNwrjpTcvgIBKpThKfkwLH7CSggy2aFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/568] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Wed,  3 Dec 2025 16:26:28 +0100
Message-ID: <20251203152454.831404407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d258c7324fcc7..9b34004e67131 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3081,6 +3081,8 @@ static int snd_usb_mixer_controls_badd(struct usb_mixer_interface *mixer,
 	int i;
 
 	assoc = usb_ifnum_to_if(dev, ctrlif)->intf_assoc;
+	if (!assoc)
+		return -EINVAL;
 
 	/* Detect BADD capture/playback channels from AS EP descriptors */
 	for (i = 0; i < assoc->bInterfaceCount; i++) {
-- 
2.51.0



