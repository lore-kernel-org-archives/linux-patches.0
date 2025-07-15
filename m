Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58C11DFCE;
	Tue, 15 Jul 2025 13:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587110; cv=none; b=GDV0CUg+1GT/kEH8NvWElmOFIX2V0JeV4L5n6ikc5rd6Ztl6JbQqAgPRBlhBwCi8ZSX/8muMvt7pcCzMo4okyqckoCVqj6GbnBGPYG9v8mhg5xxXywT+ygmJN8orsRYamC1t2xlpG/vJwZoFhnvS2+N670P9CttOIVlXKkD/mEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587110; c=relaxed/simple;
	bh=eQwEez+aI3/Z44ZGqsIf6/zQweaJFvJG6YxL5dl5d/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCE8qBEXIea++aSn2oFGl4YkKViH+Stks2Ymo1aWZbUSpTGHypZ952ETsy25DX+1xZLWaPBT8PdII8WIoaS6+8mqM3mkoLBkzvMjzecCzNPeE8ihyClfgpO9U04cKuGXAj9VHgPGH+UV3vgySoLXcCe/SDjFJoSCdosswEQ/tA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZD85rgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZD85rgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D87C4CEE3;
	Tue, 15 Jul 2025 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587110;
	bh=eQwEez+aI3/Z44ZGqsIf6/zQweaJFvJG6YxL5dl5d/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZD85rgr25LUiqRVINbusZkzj1+YCpQ+95JJLfo8J9H+WCf3wv38OeQQmjADejWyX
	 wRBnkTNOqqTHY1X0CGC7uJsHyWdEsasO+B7u9KGjqg0BImeGRWl7WYVhnVY/r3+x2g
	 ew7f2ZgSn0tDdhut1iy1BU3Ztpc1hqws55T6yVDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Yu <jack.yu@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 171/192] ASoC: rt721-sdca: fix boost gain calculation error
Date: Tue, 15 Jul 2025 15:14:26 +0200
Message-ID: <20250715130821.775109574@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Yu <jack.yu@realtek.com>

[ Upstream commit ff21a6ec0f27c126db0a86d96751bd6e5d1d9874 ]

Fix the boost gain calculation error in rt721_sdca_set_gain_get.
This patch is specific for "FU33 Boost Volume".

Signed-off-by: Jack Yu <jack.yu@realtek.com>
Link: https://patch.msgid.link/1b18fcde41c64d6fa85451d523c0434a@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt721-sdca.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index 1c9f32e405cf9..ba080957e9336 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -430,6 +430,7 @@ static int rt721_sdca_set_gain_get(struct snd_kcontrol *kcontrol,
 	unsigned int read_l, read_r, ctl_l = 0, ctl_r = 0;
 	unsigned int adc_vol_flag = 0;
 	const unsigned int interval_offset = 0xc0;
+	const unsigned int tendA = 0x200;
 	const unsigned int tendB = 0xa00;
 
 	if (strstr(ucontrol->id.name, "FU1E Capture Volume") ||
@@ -439,9 +440,16 @@ static int rt721_sdca_set_gain_get(struct snd_kcontrol *kcontrol,
 	regmap_read(rt721->mbq_regmap, mc->reg, &read_l);
 	regmap_read(rt721->mbq_regmap, mc->rreg, &read_r);
 
-	if (mc->shift == 8) /* boost gain */
+	if (mc->shift == 8) {
+		/* boost gain */
 		ctl_l = read_l / tendB;
-	else {
+	} else if (mc->shift == 1) {
+		/* FU33 boost gain */
+		if (read_l == 0x8000 || read_l == 0xfe00)
+			ctl_l = 0;
+		else
+			ctl_l = read_l / tendA + 1;
+	} else {
 		if (adc_vol_flag)
 			ctl_l = mc->max - (((0x1e00 - read_l) & 0xffff) / interval_offset);
 		else
@@ -449,9 +457,16 @@ static int rt721_sdca_set_gain_get(struct snd_kcontrol *kcontrol,
 	}
 
 	if (read_l != read_r) {
-		if (mc->shift == 8) /* boost gain */
+		if (mc->shift == 8) {
+			/* boost gain */
 			ctl_r = read_r / tendB;
-		else { /* ADC/DAC gain */
+		} else if (mc->shift == 1) {
+			/* FU33 boost gain */
+			if (read_r == 0x8000 || read_r == 0xfe00)
+				ctl_r = 0;
+			else
+				ctl_r = read_r / tendA + 1;
+		} else { /* ADC/DAC gain */
 			if (adc_vol_flag)
 				ctl_r = mc->max - (((0x1e00 - read_r) & 0xffff) / interval_offset);
 			else
-- 
2.39.5



