Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99DE2F1FEF;
	Fri, 21 Nov 2025 13:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733338; cv=none; b=ZbHi8+jmsPrXSl1GSfrqF5qvk+GWyuUwQoMJhYdisgc1jSDRzAv9aqrhEx5VuKsgWVkIxz80NzfWzzCWP86PAcwlmbCHLmMxbN7fKFpXXKBSoex8vM5Ppu7Efb4KFQ+MvcRVhOqQaf9M4dW0AUz6mZC0vxipZTMPa7f8yDNmrOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733338; c=relaxed/simple;
	bh=WSG7OhIDVYCoL2sr0+evi6NL0RFP3J5wJHE1OIQA5v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnnjPOZFPhleMqgdcK49x9US15F64+Z9Olhh5PfzLea9yehqi/cIkN6uP7Vmxj5EitkDWmM1ZdR87Wr8O7KrpKAAXOnRBZ3P/0fuRuJhORFwuD0fwNrE9hHYDjEFC3Y1rGFXFClTWCc+8Xz4OCzq06KHER29HBqKT18cr7nHDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AHLj21B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AHLj21B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4E2C16AAE;
	Fri, 21 Nov 2025 13:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733338;
	bh=WSG7OhIDVYCoL2sr0+evi6NL0RFP3J5wJHE1OIQA5v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AHLj21BaN3Ax4l3Bzl6cRqoUKopY7LJHDZa0Mueu0mMUicNs7Cui60v8q6vnRddV
	 CvcVo9c+LEp/Nabbmt+2zVzXlJxJOLh7lBOqe4MmdhSSYh5AJz4dStmMtt9sNpTDFh
	 9WIrb34NKL7BP9rv+zCHVJFEAHLCfTH0afnMNdWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 435/529] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Fri, 21 Nov 2025 14:12:14 +0100
Message-ID: <20251121130246.491887143@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cc051756a4220..787cdeddbdf44 100644
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



