Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081A11420D3;
	Tue, 27 Feb 2024 14:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043890; cv=none; b=Pv/MTgrQ5cqhWLSlI7RjsNIhZ9tAFHH++ydvQGqhd4Rt6H/VoCNUNCA95xKuOgxLDE5gb+IFq7ZoHVAMjgJNa6Tdl49MjH+N6EFkwn+JNEujzWN43Wk6mBFEI+iE94BEyVqSGkZ0xGjNFXhcIOy8UkLI5d6i657vV7Wvhc5esJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043890; c=relaxed/simple;
	bh=Zp7FXOI0ABAhrsWBWg+O/Tqq5/geZjzZExgrHPgDSFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUkE+8oXlTvyb43gYJSmlMGIww5rZAzm370qX0FVW+FKGChSV4oQm3X/0bKmhr3n3CRWUfYE1FRaDEdYjepo5F8jL0nmfcuoXf7fsYOLOfXFnnnBgHIJa0rM73TYVc95mLYzVcGREHgTIDyEmoR8W4ChfNwTnwusRCBR0M3v+dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HL7LjpUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HL7LjpUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC07C433B2;
	Tue, 27 Feb 2024 14:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043889;
	bh=Zp7FXOI0ABAhrsWBWg+O/Tqq5/geZjzZExgrHPgDSFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HL7LjpUvQQdHaCb9OQ2hvi+728sGsA1EHgukAZf3bbtYCUmveLytSxoPmYCAR/OKq
	 Mz+RgS/T7kfzXGVFv62VjMB82bKwUlTRv+v0Kj5NnX96oPL3a0PwgwPgYhcfnzj5vu
	 SMB6vECNsiAO86aBk+PSAzOUBiT4A9OmZHrWJZf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/84] ALSA: hda/realtek - Enable micmute LED on and HP system
Date: Tue, 27 Feb 2024 14:27:10 +0100
Message-ID: <20240227131554.274706982@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 3e0650ab26e2010ee312311612e40e076ed1feca ]

Though the system uses DMIC, headset mic still uses the HDA, let's use
GPIO 0x1 to control the micmute LED.

The micmute LED GPIO has a different polarity to the mute LED GPIO, we
can use the newly added micmute_led_polarity to indicate that.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20200430083255.5093-2-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d8ee1b1ee7e3d..893b9fde59ac0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4326,7 +4326,11 @@ static void alc269_fixup_hp_gpio_led(struct hda_codec *codec,
 static void alc285_fixup_hp_gpio_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
-	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x00);
+	struct alc_spec *spec = codec->spec;
+
+	spec->micmute_led_polarity = 1;
+
+	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x01);
 }
 
 static void alc286_fixup_hp_gpio_led(struct hda_codec *codec,
-- 
2.43.0



