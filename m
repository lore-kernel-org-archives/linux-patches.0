Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B7537C902;
	Thu, 20 Aug 2026 15:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238532; cv=none; b=qAbzcOqIW2ITlLSmSKxgO9ZqTa8OYEf3pNoDrKh5F2tEjInsSHHyZ6+9SI7yLelRInsSUBUdYdwiaS6ebki91Pp4mexQ+G+Ec2lh0lkJstKDEIZQjlzVDEPv7xDWtUZGSdt6AdNCOaCYbKQSe6WEUVKrRxsyhd0o48llrF8W0BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238532; c=relaxed/simple;
	bh=+GIps0YWkmK8cnkXUrsMDi6+CfGVZYRpsHE+aNXua4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFEpCU93/BSLLvhxOVMs+vBq+/sf178bcsloc67XJ7gAnmrDmfVlBgj2O0Q0aWg1XwsoyjjJedSxTgN3ojJ/0i0829BJfdTebB4bycakS5T5vDONzI6bvNGQm4py6l28WXsh2aQ6ffSw5x+oPPZw2YuKr7GFi04UOrfy0K/hx0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWMA48EN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWMA48EN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB141F000E9;
	Thu, 20 Aug 2026 15:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238530;
	bh=Cs5TUGF5jmJZrVQAoRNwGlUK2sHU08qtjsa8nvYSRv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWMA48EN0AyGsPIpAWYTqTLvxUxLRW+M1ffQP+Kj/OSHrvOOB+qlAVs9APU6KJrA0
	 V8khrFOHPUHg0rWglTRK2E46MJvFSFi+Nb5T/nzgXlu6/+WVfnI6SRIGtII2I9rXIF
	 LJ1+o4cmPyKBQpsUGqx3B+RnG86aZrrKhYZ7kW3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gert Burger <gertburger@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 179/228] ALSA: usb-audio: Fix mixer regression on SteelSeries Arctis Nova 5
Date: Thu, 20 Aug 2026 16:55:21 +0200
Message-ID: <20260820145250.129625140@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 885c22d259c8b245c479f3e19e9eeee54dee8b24 ]

The recent "sticky mixer" sanity check in USB-audio driver caused a
regression on SteelSeries Arctis Nova 5 (1038:2232); because the
firmware doesn't handle GET_CUR requests, some mixers are effectively
disabled, leading to the too low / soft volumes:
  usb 5-1.1: 9:0: sticky mixer values (-19712/0/256 => 0), disabling
  usb 5-1.1: 10:0: sticky mixer values (-21248/0/256 => 0), disabling

Restore the functionality by ignoring GET_CUR errors intentionally
with MIXER_GET_CUR_BROKEN quirk.

Fixes: 86aa1ea1f15c ("ALSA: usb-audio: Do not expose sticky mixers")
Reported-by: Gert Burger <gertburger@gmail.com>
Closes: https://lore.kernel.org/CAEQ1D3kdA3mkQx7ei9Kq0gwky0qroJqCLKrkvgfkqgTbeu086A@mail.gmail.com
Link: https://bbs.archlinux.org/viewtopic.php?id=314220
Link: https://patch.msgid.link/20260808152258.1948767-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 354866a806056..0c702a4d51dfa 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2356,6 +2356,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SHARE_MEDIA_DEVICE | QUIRK_FLAG_ALIGN_TRANSFER),
 	DEVICE_FLG(0x1038, 0x1294, /* SteelSeries Arctis Pro Wireless */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x1038, 0x2232, /* SteelSeries Arctis Nova 5 */
+		   QUIRK_FLAG_MIXER_GET_CUR_BROKEN),
 	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x12d1, 0x3a07, /* HUAWEI USB-C HEADSET */
-- 
2.53.0



