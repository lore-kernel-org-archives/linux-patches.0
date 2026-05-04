Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202E43A7F4C;
	Mon,  4 May 2026 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903789; cv=none; b=UWrkzkRpL+7MtgTePFDY8JGKg2zigt6H8cEnHR9IqMULgUwp6/cEb+xNUeYAfInN5hB9PEwMZJjsEQcptNM/3GaY6ShcK2NsXiv1M8dJMXffOh+VWF/4GHHukz1KacTqqLH71fU6MrMjPXiLolkE8FzmPX8NleGEVGOisqlKnXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903789; c=relaxed/simple;
	bh=b4z+z6WjvYcD7d5MhgEe9bV9xHSm4wHSM2o5GOvl/lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7Y2HWlxrABGf6gpI+0yN+p3VVAQSO1G5g1dsvl3NYCNZ0/IYsdVp87aQXGS4eb1TMljR2OPK3FyGjhIc4WLEi/KbNvsoMknDyppKzmgU+1nB6cgzVOuy2zDSan6hLi4ulUNmF8gdx+FpJe1RFeo6eTxRtX9kmTS8S5iWquGYKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FE5vf98N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FE5vf98N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A224DC2BCB8;
	Mon,  4 May 2026 14:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903789;
	bh=b4z+z6WjvYcD7d5MhgEe9bV9xHSm4wHSM2o5GOvl/lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FE5vf98NF43RlyVyo0rJwqQ1LrTz+VmqT4CBxWyP6y1Tl73aSZRoOZBGiRJWHsPqK
	 kpKGRFXIzYo1MlFxQ9kclelg0mk4mNiypZVwqEOQDosiMxRLsVJVQFqdoCCsYRsj+t
	 n0TjGvoyZU+JJ6bWq5PNsTwcGNXfBjiL+qsO02l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 063/275] ALSA: aoa: Skip devices with no codecs in i2sbus_resume()
Date: Mon,  4 May 2026 15:50:03 +0200
Message-ID: <20260504135145.275340338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit fd7df93013c5118812e63a52635dc6c3a805a1de upstream.

In i2sbus_resume(), skip devices with an empty codec list, which avoids
using an uninitialized 'sysclock_factor' in the 32-bit format path in
i2sbus_pcm_prepare().

In i2sbus_pcm_prepare(), replace two list_for_each_entry() loops with a
single list_first_entry() now that the codec list is guaranteed to be
non-empty by all callers.

Fixes: f3d9478b2ce4 ("[ALSA] snd-aoa: add snd-aoa")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://patch.msgid.link/20260310102921.210109-3-thorsten.blum@linux.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/aoa/soundbus/i2sbus/core.c |    3 +++
 sound/aoa/soundbus/i2sbus/pcm.c  |   16 +++++-----------
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -408,6 +408,9 @@ static int i2sbus_resume(struct macio_de
 	int err, ret = 0;
 
 	list_for_each_entry(i2sdev, &control->list, item) {
+		if (list_empty(&i2sdev->sound.codec_list))
+			continue;
+
 		/* reset i2s bus format etc. */
 		i2sbus_pcm_prepare_both(i2sdev);
 
--- a/sound/aoa/soundbus/i2sbus/pcm.c
+++ b/sound/aoa/soundbus/i2sbus/pcm.c
@@ -411,6 +411,9 @@ static int i2sbus_pcm_prepare(struct i2s
 	/* set stop command */
 	command->command = cpu_to_le16(DBDMA_STOP);
 
+	cii = list_first_entry(&i2sdev->sound.codec_list,
+			       struct codec_info_item, list);
+
 	/* ok, let's set the serial format and stuff */
 	switch (runtime->format) {
 	/* 16 bit formats */
@@ -418,13 +421,7 @@ static int i2sbus_pcm_prepare(struct i2s
 	case SNDRV_PCM_FORMAT_U16_BE:
 		/* FIXME: if we add different bus factors we need to
 		 * do more here!! */
-		bi.bus_factor = 0;
-		list_for_each_entry(cii, &i2sdev->sound.codec_list, list) {
-			bi.bus_factor = cii->codec->bus_factor;
-			break;
-		}
-		if (!bi.bus_factor)
-			return -ENODEV;
+		bi.bus_factor = cii->codec->bus_factor;
 		input_16bit = 1;
 		break;
 	case SNDRV_PCM_FORMAT_S32_BE:
@@ -438,10 +435,7 @@ static int i2sbus_pcm_prepare(struct i2s
 		return -EINVAL;
 	}
 	/* we assume all sysclocks are the same! */
-	list_for_each_entry(cii, &i2sdev->sound.codec_list, list) {
-		bi.sysclock_factor = cii->codec->sysclock_factor;
-		break;
-	}
+	bi.sysclock_factor = cii->codec->sysclock_factor;
 
 	if (clock_and_divisors(bi.sysclock_factor,
 			       bi.bus_factor,


