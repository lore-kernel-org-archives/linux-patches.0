Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7179347791;
	Mon,  8 Jan 2024 15:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PnjXNocB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1DBC4339A;
	Mon,  8 Jan 2024 15:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726603;
	bh=xRN69cSsECNRd/BBU7AzypQCXtcYde5GfjqHQlHqE8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PnjXNocBaYaFwt2KMoulrGOS414A3i6MhkJ8V5yRdkd2FTMczHbFxgFrRcwnpbRqb
	 Ie+oR5eepmqmMmoe9Jn0Hf0G/iYhzqfF8ppEcnsMqqzxDIrJ03K5kr4KLrtPi9YiLY
	 VcuN8nP8bq2XQmzzeYYeWhr78gU4ki0TNQADcmJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 003/124] ALSA: hda/tas2781: move set_drv_data outside tasdevice_init
Date: Mon,  8 Jan 2024 16:07:09 +0100
Message-ID: <20240108150603.116622521@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit e7aa105657f7f62f54a493480588895cc8a9a1a7 upstream.

allow driver specific driver data in tas2781-hda-i2c and tas2781-i2c

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/1398bd8bf3e935b1595a99128320e4a1913e210a.1703204848.git.soyer@irl.hu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c   | 2 ++
 sound/soc/codecs/tas2781-comlib.c | 2 --
 sound/soc/codecs/tas2781-i2c.c    | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index 54d135405788..6d11bced78f0 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -659,6 +659,8 @@ static int tas2781_hda_i2c_probe(struct i2c_client *clt)
 	if (!tas_priv)
 		return -ENOMEM;
 
+	dev_set_drvdata(&clt->dev, tas_priv);
+
 	tas_priv->irq_info.irq = clt->irq;
 	ret = tas2781_read_acpi(tas_priv, device_name);
 	if (ret)
diff --git a/sound/soc/codecs/tas2781-comlib.c b/sound/soc/codecs/tas2781-comlib.c
index 933cd008e9f5..00e35169ae49 100644
--- a/sound/soc/codecs/tas2781-comlib.c
+++ b/sound/soc/codecs/tas2781-comlib.c
@@ -316,8 +316,6 @@ int tasdevice_init(struct tasdevice_priv *tas_priv)
 		tas_priv->tasdevice[i].cur_conf = -1;
 	}
 
-	dev_set_drvdata(tas_priv->dev, tas_priv);
-
 	mutex_init(&tas_priv->codec_lock);
 
 out:
diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index 55cd5e3c23a5..917b1c15f71d 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -689,6 +689,8 @@ static int tasdevice_i2c_probe(struct i2c_client *i2c)
 	if (!tas_priv)
 		return -ENOMEM;
 
+	dev_set_drvdata(&i2c->dev, tas_priv);
+
 	if (ACPI_HANDLE(&i2c->dev)) {
 		acpi_id = acpi_match_device(i2c->dev.driver->acpi_match_table,
 				&i2c->dev);
-- 
2.43.0



