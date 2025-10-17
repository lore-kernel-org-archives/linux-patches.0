Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53AC330B36;
	Fri, 17 Oct 2025 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716089; cv=none; b=Z5OUL7P6h3pnqUZLkcSKMx6nW7p1QZ36VR+VdAR2yl5q8cC+RXINfztdWQLoOw/6Sk7vsiY0DkKzvjQLnuzad44W143BhDyMNzO4co2PqWAx1J9bI+OsmVa3BjPpztO+gtV3ugYYQvT7N74ivBLlsjkQjIseh10saNWrFZDKdYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716089; c=relaxed/simple;
	bh=eEZqdYjO9/AHnhaMy1p9TGkit2Q+F7N1JWVoVuGhK1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3bKEp2mcuchXviBkXStJGnc+2qR9IQ111kcRcQnntz+sdfiTr+Uvg/3V/IMbzkRJlOO5fwSJUBvc9x1IvAnF3icw8t6B9762inpzP2n7dKQXxRGZ1R4DhzNPl8K+FbhJjEPFSBSajePWIJ7JxogXxwj7yxV8+sB9/gikDfXW+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZHuzonq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZHuzonq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421BDC113D0;
	Fri, 17 Oct 2025 15:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716089;
	bh=eEZqdYjO9/AHnhaMy1p9TGkit2Q+F7N1JWVoVuGhK1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZHuzonqpwXBygdq/2IpK9zXGinC/+YcskFhXCgX5nynY37+HjMwLtTTBaNNeLLSI
	 03P4rH+K14E/Rj5EOCfVMXsvP1DLAAb4GAfkfgje+Uv/XHaAEJgTiceXm7/R35QX6w
	 pXfSRhqDE9I7ORhUfj6CGaavTGzDauKY5oiyqeA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/276] ASoC: Intel: bytcht_es8316: Fix invalid quirk input mapping
Date: Fri, 17 Oct 2025 16:52:41 +0200
Message-ID: <20251017145144.969617521@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b5c97d35864a6..923e69c7695c2 100644
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



