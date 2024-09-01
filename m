Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142DD183CD4;
	Sun,  1 Sep 2024 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208755; cv=none; b=BRDU1zoPaLNUTw3cr9jrx7kdoHDIQe/gy1NkfKF4ZhzjzsV8L3+O1zMvWUAiV7blNJigTb7NHCQ0HZg5JPAuretWTnsQvtHdhoncEkIbfGM3vxpnmS+2wHgcGqmx5NJm9T5vzmDJ+7TVo1JF++kv1qzdV3dp5FeGLfnkj73WnW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208755; c=relaxed/simple;
	bh=eByzupeC/SpFF9eA8nn65XSWnVt/tceeNfVI+nclvkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLNUZqb+NVXdRRdvqicRCwm+WVVbUdATSXyyTjftDU5+JyBvFgRRYwnxjJfYaCWBBXtR4ZMO2+nEYOPjEDHvOlU11I/Rj+on04FA4QFKekvhOSbfnF7I8RdE4qdc/TrMnRCv0sX1omysloOvc4gA4uGR8Q6Oo4M8aiXrmlSC99E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DY4JtOM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DY4JtOM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827F4C4CEC4;
	Sun,  1 Sep 2024 16:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208754;
	bh=eByzupeC/SpFF9eA8nn65XSWnVt/tceeNfVI+nclvkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DY4JtOM6+h1hGd2qVaRuvBuvE7mfh8/ZIW9ky/ZzOREGQVXM5XkI+bTCWBjc7YInu
	 svRimLzYoIIb0fxxQeJxrjT0avCEfczvugLJDvKjmVzhBXmzu/Y0KBmD24eb6VUUW9
	 HCwR0d/lR83kQkuh/puYYSCI+7EQfSzX16DAyT4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parsa Poorshikhian <parsa.poorsh@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 030/134] ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7
Date: Sun,  1 Sep 2024 18:16:16 +0200
Message-ID: <20240901160811.240278535@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parsa Poorshikhian <parsa.poorsh@gmail.com>

[ Upstream commit ef9718b3d54e822de294351251f3a574f8a082ce ]

Fix noise from speakers connected to AUX port when no sound is playing.
The problem occurs because the `alc_shutup_pins` function includes
a 0x10ec0257 vendor ID, which causes noise on Lenovo IdeaPad 3 15IAU7 with
Realtek ALC257 codec when no sound is playing.
Removing this vendor ID from the function fixes the bug.

Fixes: 70794b9563fe ("ALSA: hda/realtek: Add more codec ID to no shutup pins list")
Signed-off-by: Parsa Poorshikhian <parsa.poorsh@gmail.com>
Link: https://patch.msgid.link/20240810150939.330693-1-parsa.poorsh@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 77034c31fa120..dddf3f55cb13b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -520,7 +520,6 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
-	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



