Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416734C10C4;
	Thu, 17 Sep 2026 15:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659157; cv=none; b=lMVSRLmiTyNydifSb5RFS4gGxJ+/AS1mLLS8XHoS7WKFO3kNoFP5xI5aTBDB2M6h75TM4TaZy8HJ2kOik1pvEHTytxqwA0DAs7Go2kXy5TOVCKWA6PuUXeJ6ZybbtaWdIxDNqmTHUV9G/+BhR2ItrMVoUmoue2MV1LpDExR6EyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659157; c=relaxed/simple;
	bh=W5dobtXqN/SOadVbskOeu21Eex1OOMDbYzqswbP9rAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTFfoUc/HAG2fNoA1+d0rAREjuNlZ7xhfednJutEwn3ayMEolt89VXjkEQfxmxvm6wDanj9cbLJlqwfmTGa2FG0Q/AcZBkAEPSmgNsJAGR735TZYVRgKI9l9wenKgyKvm3YD0HixcQbKCv0vN8TF9da6GZ45/BYYLFbzAvEyc5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLHo9s5K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLHo9s5K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF331F00899;
	Thu, 17 Sep 2026 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659150;
	bh=FvFRPjxW72fGstZqAdIiQVyGlCokUZAaOjDGSjPTE0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tLHo9s5Klu3HwVhbegCDYrEP67CHXj5N6UWFoABUUn+7hbZjtDuGIJrWxZM29utTd
	 Kgs8uAjFAzhNk1HjicWt5NEbGBj4P7MvjDnBbcBSFkSkx4DvF0GJvubH4mDiufRanT
	 Dg8lPM4Zs+sfr1VLq9mehKWf+MVu3njnnh5P1hpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 123/733] ASoC: ab8500: Skip missing DMIC GPIOs on AB8505
Date: Thu, 17 Sep 2026 16:07:11 +0100
Message-ID: <20260917151354.073333606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 711178754287db3fd0f7accff3c2a7575f8873b7 ]

GPIO27, GPIO29 and GPIO31 provide the digital microphone clock
outputs on AB8500, but these GPIOs do not exist on AB8505. The shared
codec driver nevertheless accesses their direction register while
setting up every AB8505 codec.

Identify the parent MFD device and leave the nonexistent GPIOs
untouched on AB8505.

Fixes: 679d7abdc754 ("ASoC: codecs: Add AB8500 codec-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260831-ab8500-codec-fixes-v1-6-f85024e717e3@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ab8500-codec.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
index 11142d15df450..e1a0e35836e6c 100644
--- a/sound/soc/codecs/ab8500-codec.c
+++ b/sound/soc/codecs/ab8500-codec.c
@@ -1540,6 +1540,8 @@ static int ab8500_audio_init_audioblock(struct snd_soc_component *component)
 static int ab8500_audio_setup_mics(struct snd_soc_component *component,
 			struct amic_settings *amics)
 {
+	struct device *dev = component->dev;
+	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
 	u8 value8;
 	unsigned int value;
@@ -1548,20 +1550,21 @@ static int ab8500_audio_setup_mics(struct snd_soc_component *component,
 
 	dev_dbg(component->dev, "%s: Enter.\n", __func__);
 
-	/* Set DMic-clocks to outputs */
-	status = abx500_get_register_interruptible(component->dev, AB8500_MISC,
-						AB8500_GPIO_DIR4_REG,
-						&value8);
-	if (status < 0)
-		return status;
-	value = value8 | GPIO27_DIR_OUTPUT | GPIO29_DIR_OUTPUT |
-		GPIO31_DIR_OUTPUT;
-	status = abx500_set_register_interruptible(component->dev,
-						AB8500_MISC,
-						AB8500_GPIO_DIR4_REG,
-						value);
-	if (status < 0)
-		return status;
+	/* Set DMic-clocks to outputs; these GPIOs do not exist on AB8505. */
+	if (!is_ab8505(ab8500)) {
+		status = abx500_get_register_interruptible(dev, AB8500_MISC,
+							   AB8500_GPIO_DIR4_REG,
+							   &value8);
+		if (status < 0)
+			return status;
+		value = value8 | GPIO27_DIR_OUTPUT | GPIO29_DIR_OUTPUT |
+			GPIO31_DIR_OUTPUT;
+		status = abx500_set_register_interruptible(dev, AB8500_MISC,
+							   AB8500_GPIO_DIR4_REG,
+							   value);
+		if (status < 0)
+			return status;
+	}
 
 	/* Attach regulators to AMic DAPM-paths */
 	dev_dbg(component->dev, "%s: Mic 1a regulator: %s\n", __func__,
-- 
2.53.0



