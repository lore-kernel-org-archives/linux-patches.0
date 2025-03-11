Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A1625C715;
	Tue, 11 Mar 2025 15:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706047; cv=none; b=KUWjuGwBa8K8oAqLbpaJj46kddGyS/Q9jkGiM+1ADsqsrpNuEmB/Wjl6WgCgTwzgQrejlDVR5qxNOWthfEUoigjN2hGLlMoXlBZTpHVNnaSh5+sMMcxuVsW/G8WILutzKmXndQiiW6tqqGgSqvF2XdQ8f7XrqW4ef48hluyTw/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706047; c=relaxed/simple;
	bh=K3A8zh6il/7/SFbBERNtvccNJ4T72aOgFn2EuMuj5Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sgo8wl0tRStfA8NvhmAIG5nevknqD8Ibk7tqu3b+mQJmNO2OdfHr/g4oMYyPtRc1vb1Y3fHnQ0oVb86jGbuAniK7YARXth44FClinN1hSUmqwAiCp0afWh/juy8nXRWBRmAMU9rpi8LEK296n5X9kQqzdMfwnhpnM2mwbhUenjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwo6hpjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwo6hpjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B28C4CEE9;
	Tue, 11 Mar 2025 15:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706047;
	bh=K3A8zh6il/7/SFbBERNtvccNJ4T72aOgFn2EuMuj5Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwo6hpjIypYCE0rVU2YH0Z2Qmx9Xd6pkqTe8J62u5kFkPThvC++ewSkrCnq6l7bUa
	 s4xJLhZiExGGFM0ANTfVkrfQPsasRHZayoNoOi8wzBNhBZIL5rcohKNKUKsih2oe6u
	 s5zlDPwAFAu0lBPLQIcIalb+VnLGaEifwj78G760=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 243/328] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Tue, 11 Mar 2025 16:00:13 +0100
Message-ID: <20250311145724.573160954@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 174448badb4409491bfba2e6b46f7aa078741c5e ]

Headset MIC will no function when power_save=0.

Fixes: 1fd50509fe14 ("ALSA: hda/realtek: Update ALC225 depop procedure")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219743
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/0474a095ab0044d0939ec4bf4362423d@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 069515b065386..755a93ad65500 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3658,6 +3658,7 @@ static void alc225_init(struct hda_codec *codec)
 				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
 		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
 		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	}
 }
-- 
2.39.5



