Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8F30EF7B;
	Mon, 13 Oct 2025 15:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367818; cv=none; b=ajdQc74sdX6oAvpUCkSI3dhExygNHaJ6vT3iJkNOKs+HNA+Q+f/Y6th8/he31tEkgxlBCuYBz/YB4r3vOm487UaDxd8tXo04JgEFE9rSHUKroV3KL6ahFhF2oDDH4R4z3GEWcKoSk+KCsAjgI5cL19LD1LiZXOJ8apEXpLNy5wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367818; c=relaxed/simple;
	bh=SzBjNUP20MTtHshH5dVadKh+/e8iLEDQIW+SMkEo8Cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpEOKST9VAG5DmjAyTqpuJEf48ywbKk1NHEtOHivt3MmZtWAKq0aTfl4SxJZ1QwhplP7rwESnrB4NJx7kbpj5jmUKILpzxaG51rmHS/+sm5fOaKr8t3WS2Nfs9WZQ+BLZ7T6oJ4lQYL1ioqsNUe3t4qNaqoy/vrBucCPVp4Y8D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDzo4bNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDzo4bNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C30C4CEE7;
	Mon, 13 Oct 2025 15:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367818;
	bh=SzBjNUP20MTtHshH5dVadKh+/e8iLEDQIW+SMkEo8Cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDzo4bNuVsCpEcvClAawsF2vzj6Kh8Au/82hhExime1IsIQVx0dBTGxQxgSz75S57
	 rKLjbebKVRU7/6XWEv69eytNLH+MAQcHSMNEkRVvSRKZHlIHhvK5tTqQfNB7ItUTHs
	 u5O99I80ezfCdLDclm6lT997x0AUq4rYVowvBj1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/196] ASoC: Intel: bytcht_es8316: Fix invalid quirk input mapping
Date: Mon, 13 Oct 2025 16:44:52 +0200
Message-ID: <20251013144318.969432343@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b20eb0e8de383116f1e1470d74da2a3c83c4e345 ]

When an invalid value is passed via quirk option, currently
bytcht_es8316 driver just ignores and leaves as is, which may lead to
unepxected results like OOB access.

This patch adds the sanity check and corrects the input mapping to the
certain default value if an invalid value is passed.

Fixes: 249d2fc9e55c ("ASoC: Intel: bytcht_es8316: Set card long_name based on quirks")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20250902171826.27329-2-tiwai@suse.de>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcht_es8316.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 7a30d2d36f199..fbd7e1f0783fd 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -46,7 +46,8 @@ enum {
 	BYT_CHT_ES8316_INTMIC_IN2_MAP,
 };
 
-#define BYT_CHT_ES8316_MAP(quirk)		((quirk) & GENMASK(3, 0))
+#define BYT_CHT_ES8316_MAP_MASK			GENMASK(3, 0)
+#define BYT_CHT_ES8316_MAP(quirk)		((quirk) & BYT_CHT_ES8316_MAP_MASK)
 #define BYT_CHT_ES8316_SSP0			BIT(16)
 #define BYT_CHT_ES8316_MONO_SPEAKER		BIT(17)
 #define BYT_CHT_ES8316_JD_INVERTED		BIT(18)
@@ -59,10 +60,23 @@ MODULE_PARM_DESC(quirk, "Board-specific quirk override");
 
 static void log_quirks(struct device *dev)
 {
-	if (BYT_CHT_ES8316_MAP(quirk) == BYT_CHT_ES8316_INTMIC_IN1_MAP)
+	int map;
+
+	map = BYT_CHT_ES8316_MAP(quirk);
+	switch (map) {
+	case BYT_CHT_ES8316_INTMIC_IN1_MAP:
 		dev_info(dev, "quirk IN1_MAP enabled");
-	if (BYT_CHT_ES8316_MAP(quirk) == BYT_CHT_ES8316_INTMIC_IN2_MAP)
+		break;
+	case BYT_CHT_ES8316_INTMIC_IN2_MAP:
 		dev_info(dev, "quirk IN2_MAP enabled");
+		break;
+	default:
+		dev_warn_once(dev, "quirk sets invalid input map: 0x%x, default to INTMIC_IN1_MAP\n", map);
+		quirk &= ~BYT_CHT_ES8316_MAP_MASK;
+		quirk |= BYT_CHT_ES8316_INTMIC_IN1_MAP;
+		break;
+	}
+
 	if (quirk & BYT_CHT_ES8316_SSP0)
 		dev_info(dev, "quirk SSP0 enabled");
 	if (quirk & BYT_CHT_ES8316_MONO_SPEAKER)
-- 
2.51.0



