Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC56D3B6354;
	Fri, 15 May 2026 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861689; cv=none; b=n968lQsOI/Uqzwd2v2w8rj4jDbJQ9DustqldvPpyERo25/lgIgurqwP03n6NLPLPg+Tlx2YnY62VvwbPJQOOvsCZmDy+zkG4gTYA9ugcP9jd7YCU1pfoC5Kq4hSYFoi0w/bjg2gBHbI1jpzLLb5Y9qhYnwygo++QFLCkgOTLd04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861689; c=relaxed/simple;
	bh=EYB3wKvFX4IFpL76lPcwQ1fkxbHVacE5+7hCFlWX9Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4vuhlQ8RFQUcWwDnxgxHXQPMthOifIujPOSB8M8rY3JzN4zc884BdW61B6+tU4FYtCdtiWohKYJq1HCFNSf9XG0xbr2qBOPjSHYL70AtnP3EPK7LqFza4HnnMEJyIjvBYZqopH8Ybk2Li7vcwBnbuBsWkiO/hLmk79oWHqqxnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/7hxx3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/7hxx3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A72C2BCB0;
	Fri, 15 May 2026 16:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861688;
	bh=EYB3wKvFX4IFpL76lPcwQ1fkxbHVacE5+7hCFlWX9Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/7hxx3OhoOaSTGxawTzgYzIpjZARRbR9i6H4fiig+fMbHleTmbIExKnI6QTrmaRh
	 YdRTXRBzqEbghSG11J/cy8NrVdo/B6odQ07jVDKFiJOD00emTZEnUq4NSzQAi7qUOn
	 XD37FO1UhlI/qrOJ0tbM0C3u+H4bpOlZr1tuFMDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 383/474] ALSA: aoa: Skip devices with no codecs in i2sbus_resume()
Date: Fri, 15 May 2026 17:48:12 +0200
Message-ID: <20260515154723.323133896@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit fd7df93013c5118812e63a52635dc6c3a805a1de ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/aoa/soundbus/i2sbus/core.c |    3 +++
 sound/aoa/soundbus/i2sbus/pcm.c  |   16 +++++-----------
 2 files changed, 8 insertions(+), 11 deletions(-)

--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -411,6 +411,9 @@ static int i2sbus_resume(struct macio_de
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


