Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D733F374C4;
	Tue,  8 Apr 2025 11:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110466; cv=none; b=iIULULSgQ0ur4fs9ntUM0gs/ZpY4+TcUwBBvOhWd9ZaQDB9VdOm7FpVcyKi2M3UuQmrAs0IPPMIDk6RKjJO/KVlgLDRiaMJAx+l6ygnDjfxbLlyQhU0acfR0hRnx89IN0Y730dHwbuh/xk3HA6XFjwXAXgv1sPAfyci1r/dnJdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110466; c=relaxed/simple;
	bh=iP8zetmk5KMfwjLyMn6EVMswa8pB1VsYnhMX7oJKCv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfGnAmJv++3ELjWUiN9zK75E2n/YsCLNyMs4RobnS7oR2nvBhAz0DY81mCqspsyEuAUKDFt2Pe3qGVMe4GwgVao9DSU1M+jP333BksPle+SsY6muwdcld113oX+axb3q3tlJD0G57pqryUXG1iqF8KFwf57nZX+RMjkgOeFlvtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbWBRPJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbWBRPJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8D8EC4CEE7;
	Tue,  8 Apr 2025 11:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110466;
	bh=iP8zetmk5KMfwjLyMn6EVMswa8pB1VsYnhMX7oJKCv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MbWBRPJkP9qcsXlwXJTkmpAbF0roHp12/uelS38R3LpvCAfAFqZKJOFcDW6SZZSPc
	 emV52t5qMkgMI+9sL9tQGjqXgOw/5VrfmyFC5nl0eoTcv02qtmE3JR58AaeuR0UCj8
	 R8mK2+WUE9LnEvt9pLBk3TBTB+lQzCkF5Lr8CFaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivia Mackintosh <livvy@base.nu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 073/731] ALSA: usb-audio: separate DJM-A9 cap lvl options
Date: Tue,  8 Apr 2025 12:39:30 +0200
Message-ID: <20250408104915.969222245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 3d36d22f8e9e6..62b28e9d83c7a 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3688,8 +3688,7 @@ static const char *snd_djm_get_label(u8 device_idx, u16 wvalue, u16 windex)
 
 // common DJM capture level option values
 static const u16 snd_djm_opts_cap_level[] = {
-	0x0000, 0x0100, 0x0200, 0x0300, 0x400, 0x500 };
-
+	0x0000, 0x0100, 0x0200, 0x0300 };
 
 // DJM-250MK2
 static const u16 snd_djm_opts_250mk2_cap1[] = {
@@ -3831,6 +3830,8 @@ static const struct snd_djm_ctl snd_djm_ctls_750mk2[] = {
 
 
 // DJM-A9
+static const u16 snd_djm_opts_a9_cap_level[] = {
+	0x0000, 0x0100, 0x0200, 0x0300, 0x0400, 0x0500 };
 static const u16 snd_djm_opts_a9_cap1[] = {
 	0x0107, 0x0108, 0x0109, 0x010a, 0x010e,
 	0x111, 0x112, 0x113, 0x114, 0x0131, 0x132, 0x133, 0x134 };
@@ -3844,7 +3845,7 @@ static const u16 snd_djm_opts_a9_cap5[] = {
 	0x0501, 0x0502, 0x0503, 0x0505, 0x0506, 0x0507, 0x0508, 0x0509, 0x050a, 0x050e };
 
 static const struct snd_djm_ctl snd_djm_ctls_a9[] = {
-	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Capture Level", a9_cap_level, 0, SND_DJM_WINDEX_CAPLVL),
 	SND_DJM_CTL("Master Input",  a9_cap1, 3, SND_DJM_WINDEX_CAP),
 	SND_DJM_CTL("Ch1 Input",     a9_cap2, 2, SND_DJM_WINDEX_CAP),
 	SND_DJM_CTL("Ch2 Input",     a9_cap3, 2, SND_DJM_WINDEX_CAP),
-- 
2.39.5



