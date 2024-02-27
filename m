Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D58C13B2B9;
	Tue, 27 Feb 2024 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040736; cv=none; b=bmbJfgXxTTgfJh7FNwnVI1wQzRMwIRLxshW/rHnRNrubeX9cMlFdCW7EfJlensYKGH7sW+qMfBuHBSGu/GDaDF4wRxvI7useYynhMFQuRs8oaJAMWK0zdtbrQqthrd61fxnI6e8pjZ44LuncWzd9ukkiOPBZ/TpM34xSATLrsWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040736; c=relaxed/simple;
	bh=jk2cWdPrG4ezu1vRwx1utPeAIfbkxC+gIZliCx4CaWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMjoAKJJcEAtMkq9xXwy7x1nwTAwAYri0b3LU4b8KQ6EhuEjxmYULghK4K89XT0YzVtfOsoQ5tPsz8rIEtXpfE8MECEGLBAEhYSPkJylN0EXUw3TAZAWx2jC7Awf0IsO8WhVLA0rTHsFsPeDIS2Lxvqf25MLdMOYfAi7i5PEQtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8/upErf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8/upErf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7723C433F1;
	Tue, 27 Feb 2024 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040736;
	bh=jk2cWdPrG4ezu1vRwx1utPeAIfbkxC+gIZliCx4CaWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8/upErfEp86rCIKNqQgskTPvZMOzG+Yo5dHTBIAExCSEyTgRVI5D3cOeTinJCZGy
	 5apgoJBDYpr2t2ztp7K76wTeX76n86OQdZWYvuFQvZYtxHDMUal1i4LQ/5vQe+7auh
	 88FFIea5fPaM0KPkBiFnN71iaBBtXqvrXhOAo5Gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Tsoy <alexander@tsoy.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 062/334] ALSA: usb-audio: Ignore clock selector errors for single connection
Date: Tue, 27 Feb 2024 14:18:40 +0100
Message-ID: <20240227131632.569685824@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Tsoy <alexander@tsoy.me>

[ Upstream commit eaa1b01fe709d6a236a9cec74813e0400601fd23 ]

For devices with multiple clock sources connected to a selector, we need
to check what a clock selector control request has returned. This is
needed to ensure that a requested clock source is indeed selected and for
autoclock feature to work.

For devices with single clock source connected, if we get an error there
is nothing else we can do about it. We can't skip clock selector setup as
it is required by some devices. So lets just ignore error in this case.

This should fix various buggy Mackie devices:

[  649.109785] usb 1-1.3: parse_audio_format_rates_v2v3(): unable to find clock source (clock -32)
[  649.111946] usb 1-1.3: parse_audio_format_rates_v2v3(): unable to find clock source (clock -32)
[  649.113822] usb 1-1.3: parse_audio_format_rates_v2v3(): unable to find clock source (clock -32)

There is also interesting info from the Windows documentation [1] (this
is probably why manufacturers dont't even test this feature):

"The USB Audio 2.0 driver doesn't support clock selection. The driver
uses the Clock Source Entity, which is selected by default and never
issues a Clock Selector Control SET CUR request."

Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/audio/usb-2-0-audio-drivers [1]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217314
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218175
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218342
Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
Link: https://lore.kernel.org/r/20240201115308.17838-1-alexander@tsoy.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/clock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/usb/clock.c b/sound/usb/clock.c
index 33db334e65566..a676ad093d189 100644
--- a/sound/usb/clock.c
+++ b/sound/usb/clock.c
@@ -328,8 +328,16 @@ static int __uac_clock_find_source(struct snd_usb_audio *chip,
 			if (chip->quirk_flags & QUIRK_FLAG_SKIP_CLOCK_SELECTOR)
 				return ret;
 			err = uac_clock_selector_set_val(chip, entity_id, cur);
-			if (err < 0)
+			if (err < 0) {
+				if (pins == 1) {
+					usb_audio_dbg(chip,
+						      "%s(): selector returned an error, "
+						      "assuming a firmware bug, id %d, ret %d\n",
+						      __func__, clock_id, err);
+					return ret;
+				}
 				return err;
+			}
 		}
 
 		if (!validate || ret > 0 || !chip->autoclock)
-- 
2.43.0



