Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080EB1946C8;
	Fri,  9 Jan 2026 12:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960386; cv=none; b=VQFKEuUCmugA2VnNJMFGIqN0b4i2KOczrDt1U52ePvitcQd78z7MNsjBAGVrLsqhM30lMQFNRSy2xy2TswKGdMOWmegg+E1USdArYlbzXiYDnwlcmZYdCKCYn8Yzp1K6wCi/H1U8qQI89c+ufFX1+fIjJVsjHzA77AVO7h2V6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960386; c=relaxed/simple;
	bh=Lmg2KYA9IN7CeA9e97X7okti4DtqO4Xmwv6knAmlW8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1OGuulOhQQeO0DRWBLlTOCRYEKslhL9/0UcEK6HcpubAKxfDCD7+wJFM/r/xCiZgAym05YpIwZcTmto/+1B3XOHf9N3cRh8Hj8nvQD4oIS/9ncs/1fEo2CtgwjJT+B6q0R0TsggkM9AJglwva5yTi10Kbgc2eU1ewa0MaXvDJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y31f5QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y31f5QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827A3C16AAE;
	Fri,  9 Jan 2026 12:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960385;
	bh=Lmg2KYA9IN7CeA9e97X7okti4DtqO4Xmwv6knAmlW8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y31f5QZdOxvJcSm3VH3CLElscnl60hnV4efBvKCqERoWIo0ADJ7zFH7i3rCVSPeC
	 E4GyFwSof0TbxpPy7ZzfgDft4ZmTP4Mgdi9FnYH93CNdo31EwCPxRJfZK8coIDagSK
	 iZKwDPCwDh+v63g6EtuwMobMuw2HoqeYC2A5JoBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"DARKNAVY (@DarkNavyOrg)" <vr@darknavy.com>,
	Shipei Qu <qu@darknavy.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 384/737] ALSA: usb-mixer: us16x08: validate meter packet indices
Date: Fri,  9 Jan 2026 12:38:43 +0100
Message-ID: <20260109112148.446008305@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Shipei Qu <qu@darknavy.com>

[ Upstream commit 5526c1c6ba1d0913c7dfcbbd6fe1744ea7c55f1e ]

get_meter_levels_from_urb() parses the 64-byte meter packets sent by
the device and fills the per-channel arrays meter_level[],
comp_level[] and master_level[] in struct snd_us16x08_meter_store.

Currently the function derives the channel index directly from the
meter packet (MUB2(meter_urb, s) - 1) and uses it to index those
arrays without validating the range. If the packet contains a
negative or out-of-range channel number, the driver may write past
the end of these arrays.

Introduce a local channel variable and validate it before updating the
arrays. We reject negative indices, limit meter_level[] and
comp_level[] to SND_US16X08_MAX_CHANNELS, and guard master_level[]
updates with ARRAY_SIZE(master_level).

Fixes: d2bb390a2081 ("ALSA: usb-audio: Tascam US-16x08 DSP mixer quirk")
Reported-by: DARKNAVY (@DarkNavyOrg) <vr@darknavy.com>
Closes: https://lore.kernel.org/tencent_21C112743C44C1A2517FF219@qq.com
Signed-off-by: Shipei Qu <qu@darknavy.com>
Link: https://patch.msgid.link/20251217024630.59576-1-qu@darknavy.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_us16x08.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/usb/mixer_us16x08.c b/sound/usb/mixer_us16x08.c
index 20ac32635f1f..d05cb54de788 100644
--- a/sound/usb/mixer_us16x08.c
+++ b/sound/usb/mixer_us16x08.c
@@ -656,17 +656,25 @@ static void get_meter_levels_from_urb(int s,
 	u8 *meter_urb)
 {
 	int val = MUC2(meter_urb, s) + (MUC3(meter_urb, s) << 8);
+	int ch = MUB2(meter_urb, s) - 1;
+
+	if (ch < 0)
+		return;
 
 	if (MUA0(meter_urb, s) == 0x61 && MUA1(meter_urb, s) == 0x02 &&
 		MUA2(meter_urb, s) == 0x04 && MUB0(meter_urb, s) == 0x62) {
-		if (MUC0(meter_urb, s) == 0x72)
-			store->meter_level[MUB2(meter_urb, s) - 1] = val;
-		if (MUC0(meter_urb, s) == 0xb2)
-			store->comp_level[MUB2(meter_urb, s) - 1] = val;
+		if (ch < SND_US16X08_MAX_CHANNELS) {
+			if (MUC0(meter_urb, s) == 0x72)
+				store->meter_level[ch] = val;
+			if (MUC0(meter_urb, s) == 0xb2)
+				store->comp_level[ch] = val;
+		}
 	}
 	if (MUA0(meter_urb, s) == 0x61 && MUA1(meter_urb, s) == 0x02 &&
-		MUA2(meter_urb, s) == 0x02 && MUB0(meter_urb, s) == 0x62)
-		store->master_level[MUB2(meter_urb, s) - 1] = val;
+		MUA2(meter_urb, s) == 0x02 && MUB0(meter_urb, s) == 0x62) {
+		if (ch < ARRAY_SIZE(store->master_level))
+			store->master_level[ch] = val;
+	}
 }
 
 /* Function to retrieve current meter values from the device.
-- 
2.51.0



