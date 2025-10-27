Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B9731B80E;
	Mon, 27 Oct 2025 18:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590436; cv=none; b=lEFpGs8WRy7UWg2KnGtNmbwZYPPdXMcyUEn4+/L/jEvF/2de97GzGrqKmQhVu2q8JGlLSP6mE515S8xrxuzI3ZOFyZwJWnitCqkpH2TwZ1CGZHUiLxb92E0MJKSlxZIGLkNgdHv0ejYUzP3at+i7nUv+j+WGCet1pRvhE43dYfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590436; c=relaxed/simple;
	bh=cwS7z3nIePSCfeECsXqssQMLdIK3mQiFbMP2R3v5lVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwO7VesuUOeyExm+j9qHAt8AVNsRLKhpApOK2sB8SOO+GjqZUXtiIP4RJqDGl5BSzWZLX4QyAJ6fgYb9xqOgEWJWvjU8DTlCAT8IyHZKLX2I/AjJeGy67gelT4GU2FVBjopumxr9Ylf6b842KFVKb6REjMM04ofkUYtZkvXQZvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bV9xOStf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bV9xOStf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DAF3C4CEF1;
	Mon, 27 Oct 2025 18:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590436;
	bh=cwS7z3nIePSCfeECsXqssQMLdIK3mQiFbMP2R3v5lVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bV9xOStfmqCPclRKy+XH0TXn/sUWjqlaToPycBnrE/bhBT5RRCGe6E3oqRwv/p1sQ
	 MlowVNTbQzGRTdgl06Sh0qVu6mYt3s+XSjRauLTgXznX+9kkqKTsN3wwmXDBnRgvTw
	 Ew6nLN0I03VylILKrCfJD16kIlZ7NrUF9NJ8EANA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/224] ASoC: Intel: bytcht_es8316: Fix invalid quirk input mapping
Date: Mon, 27 Oct 2025 19:33:11 +0100
Message-ID: <20251027183510.211626028@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 57d6d0b48068c..006e489e7e890 100644
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



