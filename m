Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3E6186E4B;
	Tue, 10 Sep 2024 09:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961467; cv=none; b=mMwIoyiBv2zySt2noj7JbSNfiXZ2f5Qck8YbLjWF8PFQoEm8YVUbOrh5FN0RX1mR84rrlCHDqPEbcVpAYiAFEvidpIySlt7F5CaCHZO85LI3Hinj0ItD7AYIKbDDb0NFddvyT5NLnI7xOYZqtGfUbuAh4rbrfuSaDXF6el3OnyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961467; c=relaxed/simple;
	bh=Ud+H3nUrfV0yY6xFkFMGrJNVxmSDZUC90Nhpsj3Zv50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bx6n9HzATGee97Ms6KAA4NpdW9AD8BcJg1Mzti5NHRilAFn0yG32xmwzMOI5MaXo/HYe7pfI0HGbByiR2azflwMSXGOG5V90G5HPZyeIlFH8Ob9Z0KlEGE5IwMBjir589WLfikypTibHFwL4ejgBdKwk47f6ErhaqurHdVLhTeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJmb6N5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJmb6N5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD40C4CEC3;
	Tue, 10 Sep 2024 09:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961467;
	bh=Ud+H3nUrfV0yY6xFkFMGrJNVxmSDZUC90Nhpsj3Zv50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJmb6N5yIWv0NhbEr3dOYghon7dlVcUqLdTnC8zfs+GBnFhMVpbf9r6JW4iGnAp4E
	 xS46jq8ObTioohh6GTG6rVurLWiadh7sz82O2Lc43YSfpzK61zdBuFwRpJZtZQPMeO
	 z2aiGuEQCGaP46nVf5pPdBvRURwRJm39e++JXj3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 043/375] ASoC: Intel: Boards: Fix NULL pointer deref in BYT/CHT boards harder
Date: Tue, 10 Sep 2024 11:27:20 +0200
Message-ID: <20240910092623.693979617@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 0cc65482f5b03ac2b1c240bc34665e43ea2d71bb upstream.

Since commit 13f58267cda3 ("ASoC: soc.h: don't create dummy Component
via COMP_DUMMY()") dummy codecs declared like this:

SND_SOC_DAILINK_DEF(dummy,
        DAILINK_COMP_ARRAY(COMP_DUMMY()));

expand to:

static struct snd_soc_dai_link_component dummy[] = {
};

Which means that dummy is a zero sized array and thus dais[i].codecs should
not be dereferenced *at all* since it points to the address of the next
variable stored in the data section as the "dummy" variable has an address
but no size, so even dereferencing dais[0] is already an out of bounds
array reference.

Which means that the if (dais[i].codecs->name) check added in
commit 7d99a70b6595 ("ASoC: Intel: Boards: Fix NULL pointer deref
in BYT/CHT boards") relies on that the part of the next variable which
the name member maps to just happens to be NULL.

Which apparently so far it usually is, except when it isn't
and then it results in crashes like this one:

[   28.795659] BUG: unable to handle page fault for address: 0000000000030011
...
[   28.795780] Call Trace:
[   28.795787]  <TASK>
...
[   28.795862]  ? strcmp+0x18/0x40
[   28.795872]  0xffffffffc150c605
[   28.795887]  platform_probe+0x40/0xa0
...
[   28.795979]  ? __pfx_init_module+0x10/0x10 [snd_soc_sst_bytcr_wm5102]

Really fix things this time around by checking dais.num_codecs != 0.

Fixes: 7d99a70b6595 ("ASoC: Intel: Boards: Fix NULL pointer deref in BYT/CHT boards")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240823074217.14653-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/bxt_rt298.c      | 2 +-
 sound/soc/intel/boards/bytcht_cx2072x.c | 2 +-
 sound/soc/intel/boards/bytcht_da7213.c  | 2 +-
 sound/soc/intel/boards/bytcht_es8316.c  | 2 +-
 sound/soc/intel/boards/bytcr_rt5640.c   | 2 +-
 sound/soc/intel/boards/bytcr_rt5651.c   | 2 +-
 sound/soc/intel/boards/bytcr_wm5102.c   | 2 +-
 sound/soc/intel/boards/cht_bsw_rt5645.c | 2 +-
 sound/soc/intel/boards/cht_bsw_rt5672.c | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/sound/soc/intel/boards/bxt_rt298.c b/sound/soc/intel/boards/bxt_rt298.c
index dce6a2086f2a..6da1517c53c6 100644
--- a/sound/soc/intel/boards/bxt_rt298.c
+++ b/sound/soc/intel/boards/bxt_rt298.c
@@ -605,7 +605,7 @@ static int broxton_audio_probe(struct platform_device *pdev)
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(broxton_rt298_dais); i++) {
-		if (card->dai_link[i].codecs->name &&
+		if (card->dai_link[i].num_codecs &&
 		    !strncmp(card->dai_link[i].codecs->name, "i2c-INT343A:00",
 			     I2C_NAME_SIZE)) {
 			if (!strncmp(card->name, "broxton-rt298",
diff --git a/sound/soc/intel/boards/bytcht_cx2072x.c b/sound/soc/intel/boards/bytcht_cx2072x.c
index c014d85a08b2..df3c2a7b64d2 100644
--- a/sound/soc/intel/boards/bytcht_cx2072x.c
+++ b/sound/soc/intel/boards/bytcht_cx2072x.c
@@ -241,7 +241,7 @@ static int snd_byt_cht_cx2072x_probe(struct platform_device *pdev)
 
 	/* fix index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(byt_cht_cx2072x_dais); i++) {
-		if (byt_cht_cx2072x_dais[i].codecs->name &&
+		if (byt_cht_cx2072x_dais[i].num_codecs &&
 		    !strcmp(byt_cht_cx2072x_dais[i].codecs->name,
 			    "i2c-14F10720:00")) {
 			dai_index = i;
diff --git a/sound/soc/intel/boards/bytcht_da7213.c b/sound/soc/intel/boards/bytcht_da7213.c
index f4ac3ddd148b..08c598b7e1ee 100644
--- a/sound/soc/intel/boards/bytcht_da7213.c
+++ b/sound/soc/intel/boards/bytcht_da7213.c
@@ -245,7 +245,7 @@ static int bytcht_da7213_probe(struct platform_device *pdev)
 
 	/* fix index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(dailink); i++) {
-		if (dailink[i].codecs->name &&
+		if (dailink[i].num_codecs &&
 		    !strcmp(dailink[i].codecs->name, "i2c-DLGS7213:00")) {
 			dai_index = i;
 			break;
diff --git a/sound/soc/intel/boards/bytcht_es8316.c b/sound/soc/intel/boards/bytcht_es8316.c
index 2fcec2e02bb5..77b91ea4dc32 100644
--- a/sound/soc/intel/boards/bytcht_es8316.c
+++ b/sound/soc/intel/boards/bytcht_es8316.c
@@ -546,7 +546,7 @@ static int snd_byt_cht_es8316_mc_probe(struct platform_device *pdev)
 
 	/* fix index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(byt_cht_es8316_dais); i++) {
-		if (byt_cht_es8316_dais[i].codecs->name &&
+		if (byt_cht_es8316_dais[i].num_codecs &&
 		    !strcmp(byt_cht_es8316_dais[i].codecs->name,
 			    "i2c-ESSX8316:00")) {
 			dai_index = i;
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index a64d1989e28a..db4a33680d94 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1677,7 +1677,7 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 
 	/* fix index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(byt_rt5640_dais); i++) {
-		if (byt_rt5640_dais[i].codecs->name &&
+		if (byt_rt5640_dais[i].num_codecs &&
 		    !strcmp(byt_rt5640_dais[i].codecs->name,
 			    "i2c-10EC5640:00")) {
 			dai_index = i;
diff --git a/sound/soc/intel/boards/bytcr_rt5651.c b/sound/soc/intel/boards/bytcr_rt5651.c
index 80c841b000a3..8514b79f389b 100644
--- a/sound/soc/intel/boards/bytcr_rt5651.c
+++ b/sound/soc/intel/boards/bytcr_rt5651.c
@@ -910,7 +910,7 @@ static int snd_byt_rt5651_mc_probe(struct platform_device *pdev)
 
 	/* fix index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(byt_rt5651_dais); i++) {
-		if (byt_rt5651_dais[i].codecs->name &&
+		if (byt_rt5651_dais[i].num_codecs &&
 		    !strcmp(byt_rt5651_dais[i].codecs->name,
 			    "i2c-10EC5651:00")) {
 			dai_index = i;
diff --git a/sound/soc/intel/boards/bytcr_wm5102.c b/sound/soc/intel/boards/bytcr_wm5102.c
index cccb5e90c0fe..e5a7cc606aa9 100644
--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -605,7 +605,7 @@ static int snd_byt_wm5102_mc_probe(struct platform_device *pdev)
 
 	/* find index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(byt_wm5102_dais); i++) {
-		if (byt_wm5102_dais[i].codecs->name &&
+		if (byt_wm5102_dais[i].num_codecs &&
 		    !strcmp(byt_wm5102_dais[i].codecs->name,
 			    "wm5102-codec")) {
 			dai_index = i;
diff --git a/sound/soc/intel/boards/cht_bsw_rt5645.c b/sound/soc/intel/boards/cht_bsw_rt5645.c
index eb41b7115d01..1da9ceee4d59 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5645.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5645.c
@@ -569,7 +569,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 
 	/* set correct codec name */
 	for (i = 0; i < ARRAY_SIZE(cht_dailink); i++)
-		if (cht_dailink[i].codecs->name &&
+		if (cht_dailink[i].num_codecs &&
 		    !strcmp(cht_dailink[i].codecs->name,
 			    "i2c-10EC5645:00")) {
 			dai_index = i;
diff --git a/sound/soc/intel/boards/cht_bsw_rt5672.c b/sound/soc/intel/boards/cht_bsw_rt5672.c
index be2d1a8dbca8..d68e5bc755de 100644
--- a/sound/soc/intel/boards/cht_bsw_rt5672.c
+++ b/sound/soc/intel/boards/cht_bsw_rt5672.c
@@ -466,7 +466,7 @@ static int snd_cht_mc_probe(struct platform_device *pdev)
 
 	/* find index of codec dai */
 	for (i = 0; i < ARRAY_SIZE(cht_dailink); i++) {
-		if (cht_dailink[i].codecs->name &&
+		if (cht_dailink[i].num_codecs &&
 		    !strcmp(cht_dailink[i].codecs->name, RT5672_I2C_DEFAULT)) {
 			dai_index = i;
 			break;
-- 
2.46.0



