Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6972C202C48;
	Tue, 30 Sep 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244521; cv=none; b=cs1srPvC4FGIhOyW2lfDW+QBZkJdzSCTtM4iC4/3kgevDt/nyLh1z/e1oxj0Zl0I6RIcZXMEsDvd208OUBfLJkwc/N637ivIZXKrRDLklwqDQGG8t4p69FOmT2TGKzfBLIw2IttOU54jZeVQ2Ao4GhalADEgAHI9cbLj1QENOd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244521; c=relaxed/simple;
	bh=6ECXi6fsh/GgTvKrVBbAtTN3e9/29/oNvZ/S59Ul5SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksV0nEsNvumOfTNkdulPAEX3iTYyuOGcI3t1iGlaytiQ+H0ACCbLdvKzTR9sj6vcsTxJ9EkdjBcyDxYYRIp5eKkDAhocE9nZkP1QwqiX1KO5MudlgzaH5mUfVhlWBXdTQLYm2VBOu8wlMbv5tm636vy5/y7IyJAMPcIeUfTH+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnZEzRRa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnZEzRRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A04C4CEF0;
	Tue, 30 Sep 2025 15:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244521;
	bh=6ECXi6fsh/GgTvKrVBbAtTN3e9/29/oNvZ/S59Ul5SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnZEzRRauNfSbSUbGvbSYZxUY+r7janE0cfHcQ6U5Pf9KBo+BXK22eIqLrwGurbt5
	 VS603o45I3pfY8tl6x0GPYvpzPobPL5fodYOKwgMejLdXYAuxqal2n+BCYjSBT757D
	 4S9bjDGcAQhAVnFZWHPZAlrT/sU0M0X8ItnqD4oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	qaqland <anguoli@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 033/143] ALSA: usb-audio: Add mute TLV for playback volumes on more devices
Date: Tue, 30 Sep 2025 16:45:57 +0200
Message-ID: <20250930143832.563369182@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: qaqland <anguoli@uniontech.com>

[ Upstream commit 2cbe4ac193ed7172cfd825c0cc46ce4a41be4ba1 ]

Applying the quirk of that, the lowest Playback mixer volume setting
mutes the audio output, on more devices.

Suggested-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Signed-off-by: qaqland <anguoli@uniontech.com>
Link: https://patch.msgid.link/20250829-sound_quirk-v1-1-745529b44440@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 8bc1e247cdf1a..766db7d00cbc9 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2199,6 +2199,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x0556, 0x0014, /* Phoenix Audio TMX320VC */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0572, 0x1b08, /* Conexant Systems (Rockwell), Inc. */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x0572, 0x1b09, /* Conexant Systems (Rockwell), Inc. */
 		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x05a3, 0x9420, /* ELP HD USB Camera */
@@ -2243,6 +2245,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0b0e, 0x0349, /* Jabra 550a */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x0bda, 0x498a, /* Realtek Semiconductor Corp. */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0c45, 0x636b, /* Microdia JP001 USB Camera */
@@ -2259,6 +2263,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x12d1, 0x3a07, /* Huawei Technologies Co., Ltd. */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */
@@ -2349,6 +2355,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x2a70, 0x1881, /* OnePlus Technology (Shenzhen) Co., Ltd. BE02T */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x2b53, 0x0023, /* Fiero SC-01 (firmware v1.0.0 @ 48 kHz) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0024, /* Fiero SC-01 (firmware v1.0.0 @ 96 kHz) */
@@ -2365,6 +2373,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x534d, 0x0021, /* MacroSilicon MS2100/MS2106 */
-- 
2.51.0



