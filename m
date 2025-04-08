Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B603267B15;
	Tue,  8 Apr 2025 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114304; cv=none; b=grW3Y+X4aECpLptoYlFx1aGrPvLoDYi53YFgB66QWRK/8SSIl4TjX9StXVzAKDVReaBrjJ17R+5J61hCm81RhxBcLl/XCZxllJqwhhBAbk5xy8wMlCz/93/Mx+dnpAlyJj17pj8/hbzWrTV/COLS16DpdQpBsAxcDkWgkmt7sYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114304; c=relaxed/simple;
	bh=J/9L1xtrijV1osU5N+x1PKy1aJTfQpTnst4QJ9v1jZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3F0fN5EmdZnBm9DkK0wfQAb+pyeIy/GVi+HtH3PPGZpZ38cvqE1oEvcKkP0OE3Kbvl3BSDEsH9f6WuM13CTXBmZ4eue3UnxlVe1Yxa8E6eGDA6E8/7FLI45FoWZ/gUmqYdwyVa6riFwrSttyTrlLC9a7mZZ8jRxi+F87OUh5Ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JB4szu+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JB4szu+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D2BBC4CEE5;
	Tue,  8 Apr 2025 12:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114304;
	bh=J/9L1xtrijV1osU5N+x1PKy1aJTfQpTnst4QJ9v1jZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB4szu+hDmNfhuz6zTxI0OIeZEDF88+Y94518+OX+3Ql0eshxp3Hu9qE3IE2bXEsV
	 honUDFk06+yMtKOiP5/iOVGVDi1daa9fC5zE4K8KA20idvqg8B8JN+ZY2O4GpuA5g7
	 tioVYm6uNaO5iYKxKcYiBDDUG9zgZf3LAybfOAPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivia Mackintosh <livvy@base.nu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 058/499] ALSA: usb-audio: separate DJM-A9 cap lvl options
Date: Tue,  8 Apr 2025 12:44:30 +0200
Message-ID: <20250408104852.684096889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivia Mackintosh <livvy@base.nu>

[ Upstream commit 38e94cefbf45c1edc5b751ab90a3088f7c6fac1a ]

Mixer quicks for the Pioneer DJM-A9 mixer was added in 5289d00 with
additional capture level values added to the common DJM array of values.

This breaks the existing DJM mixers however as alsa-utils relies on
enumeration of the actual mixer options based on the value array which
results in error when storing state.

This commit just separates the A9 values into a separate array and
references them in the corresponding mixer control.

Fixes: 5289d0069639 ("ALSA: usb-audio: Add Pioneer DJ/AlphaTheta DJM-A9 Mixer")
Signed-off-by: Olivia Mackintosh <livvy@base.nu>
Link: https://patch.msgid.link/20250316153323.16381-1-livvy@base.nu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 9b0bf626cd028..04cb160d5a5df 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3687,8 +3687,7 @@ static const char *snd_djm_get_label(u8 device_idx, u16 wvalue, u16 windex)
 
 // common DJM capture level option values
 static const u16 snd_djm_opts_cap_level[] = {
-	0x0000, 0x0100, 0x0200, 0x0300, 0x400, 0x500 };
-
+	0x0000, 0x0100, 0x0200, 0x0300 };
 
 // DJM-250MK2
 static const u16 snd_djm_opts_250mk2_cap1[] = {
@@ -3830,6 +3829,8 @@ static const struct snd_djm_ctl snd_djm_ctls_750mk2[] = {
 
 
 // DJM-A9
+static const u16 snd_djm_opts_a9_cap_level[] = {
+	0x0000, 0x0100, 0x0200, 0x0300, 0x0400, 0x0500 };
 static const u16 snd_djm_opts_a9_cap1[] = {
 	0x0107, 0x0108, 0x0109, 0x010a, 0x010e,
 	0x111, 0x112, 0x113, 0x114, 0x0131, 0x132, 0x133, 0x134 };
@@ -3843,7 +3844,7 @@ static const u16 snd_djm_opts_a9_cap5[] = {
 	0x0501, 0x0502, 0x0503, 0x0505, 0x0506, 0x0507, 0x0508, 0x0509, 0x050a, 0x050e };
 
 static const struct snd_djm_ctl snd_djm_ctls_a9[] = {
-	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Capture Level", a9_cap_level, 0, SND_DJM_WINDEX_CAPLVL),
 	SND_DJM_CTL("Master Input",  a9_cap1, 3, SND_DJM_WINDEX_CAP),
 	SND_DJM_CTL("Ch1 Input",     a9_cap2, 2, SND_DJM_WINDEX_CAP),
 	SND_DJM_CTL("Ch2 Input",     a9_cap3, 2, SND_DJM_WINDEX_CAP),
-- 
2.39.5



