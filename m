Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D29630CDB1;
	Wed,  3 Dec 2025 16:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778166; cv=none; b=pemxyWAYd5Lpc9ZKrnha7DGxYY0el/XjqGqDlu5NtDeCljStCI2YYRdJ3csYxWxjvDp6T0HLS4kDYKD0TXrn5NItrKpgaBWB9cfAgsUfcbbMkzkXDs7LihA18KLpUlv4nhKs7fiJc0f/cxHxMRxF+ikq/J1sRWg/zhqEeiFMrpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778166; c=relaxed/simple;
	bh=OywTpRZJ32oqjklvRqQXgNR+6tEHfKsWjUqwF/MAi/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDsZGkWvWjzE5/X6sVF6e+rz6Ry/e+iure2vVjEJ+zK0+yGHCoEcGulQ938rLVsR3KVMNLFTjPEf56KPsJn9N3E1MdhJdy2GLhyPUoqbvypZ1L/XPBLHjtZ96/9hv2wxXz7p7IpkDOC4v7lrEh+qnmu0Gk09fZLoartITDibAsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqZ4qi3+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqZ4qi3+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E62DC4CEF5;
	Wed,  3 Dec 2025 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778165;
	bh=OywTpRZJ32oqjklvRqQXgNR+6tEHfKsWjUqwF/MAi/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qqZ4qi3+//4UepumCxSYeO79/Hz+Et3p446AggILaOjNHwbSH/gChNGdhHTbZhDAl
	 58a+boloDTUkS/OXNdOC3lzaqwovzzN1oqIHWOCi/lbc6LpXzKl61F0GDFBOFxhyvq
	 WnLvurQlPieNrqx1QO5R8fs7BgZlD0oaT1rdffPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haein Lee <lhi0729@kaist.ac.kr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 263/392] ALSA: usb-audio: Fix NULL pointer dereference in snd_usb_mixer_controls_badd
Date: Wed,  3 Dec 2025 16:26:53 +0100
Message-ID: <20251203152423.844550681@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5163d5e7682e7..de80240d9ed58 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -3071,6 +3071,8 @@ static int snd_usb_mixer_controls_badd(struct usb_mixer_interface *mixer,
 	int i;
 
 	assoc = usb_ifnum_to_if(dev, ctrlif)->intf_assoc;
+	if (!assoc)
+		return -EINVAL;
 
 	/* Detect BADD capture/playback channels from AS EP descriptors */
 	for (i = 0; i < assoc->bInterfaceCount; i++) {
-- 
2.51.0



