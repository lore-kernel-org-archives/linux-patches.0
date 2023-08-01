Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7A81F953
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:28:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBF2C433C7;
	Tue,  1 Aug 2023 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882135;
	bh=1rW1SLtWYeCfO26de2Wl5M45zQ10bYqD50J1yyTPJbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gFyT2Q1Pe3p3naP4kOYkDAl22R/spNyIG9uQyXo5WQIA2ePLkuV1GMD+Z9zmXxJmv
	 1DQQPSjyGsbxNbajJ0cdfZn9w7CzrtJZ396AbDSUjmTNvfdPJVcoHBCJeGoj6Mc5mR
	 2wY+Ejhy0tE2VxJczuKL5lOO+WZy3Dn4lX+0n+kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 154/155] ASoC: cs42l51: fix driver to properly autoload with automatic module loading
Date: Tue,  1 Aug 2023 11:21:06 +0200
Message-ID: <20230801091915.626910880@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>

commit e51df4f81b02bcdd828a04de7c1eb6a92988b61e upstream.

In commit 2cb1e0259f50 ("ASoC: cs42l51: re-hook of_match_table
pointer"), 9 years ago, some random guy fixed the cs42l51 after it was
split into a core part and an I2C part to properly match based on a
Device Tree compatible string.

However, the fix in this commit is wrong: the MODULE_DEVICE_TABLE(of,
....) is in the core part of the driver, not the I2C part. Therefore,
automatic module loading based on module.alias, based on matching with
the DT compatible string, loads the core part of the driver, but not
the I2C part. And threfore, the i2c_driver is not registered, and the
codec is not known to the system, nor matched with a DT node with the
corresponding compatible string.

In order to fix that, we move the MODULE_DEVICE_TABLE(of, ...) into
the I2C part of the driver. The cs42l51_of_match[] array is also moved
as well, as it is not possible to have this definition in one file,
and the MODULE_DEVICE_TABLE(of, ...) invocation in another file, due
to how MODULE_DEVICE_TABLE works.

Thanks to this commit, the I2C part of the driver now properly
autoloads, and thanks to its dependency on the core part, the core
part gets autoloaded as well, resulting in a functional sound card
without having to manually load kernel modules.

Fixes: 2cb1e0259f50 ("ASoC: cs42l51: re-hook of_match_table pointer")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Link: https://lore.kernel.org/r/20230713112112.778576-1-thomas.petazzoni@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs42l51-i2c.c |    6 ++++++
 sound/soc/codecs/cs42l51.c     |    7 -------
 sound/soc/codecs/cs42l51.h     |    1 -
 3 files changed, 6 insertions(+), 8 deletions(-)

--- a/sound/soc/codecs/cs42l51-i2c.c
+++ b/sound/soc/codecs/cs42l51-i2c.c
@@ -19,6 +19,12 @@ static struct i2c_device_id cs42l51_i2c_
 };
 MODULE_DEVICE_TABLE(i2c, cs42l51_i2c_id);
 
+const struct of_device_id cs42l51_of_match[] = {
+	{ .compatible = "cirrus,cs42l51", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, cs42l51_of_match);
+
 static int cs42l51_i2c_probe(struct i2c_client *i2c,
 			     const struct i2c_device_id *id)
 {
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -825,13 +825,6 @@ int __maybe_unused cs42l51_resume(struct
 }
 EXPORT_SYMBOL_GPL(cs42l51_resume);
 
-const struct of_device_id cs42l51_of_match[] = {
-	{ .compatible = "cirrus,cs42l51", },
-	{ }
-};
-MODULE_DEVICE_TABLE(of, cs42l51_of_match);
-EXPORT_SYMBOL_GPL(cs42l51_of_match);
-
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>");
 MODULE_DESCRIPTION("Cirrus Logic CS42L51 ALSA SoC Codec Driver");
 MODULE_LICENSE("GPL");
--- a/sound/soc/codecs/cs42l51.h
+++ b/sound/soc/codecs/cs42l51.h
@@ -16,7 +16,6 @@ int cs42l51_probe(struct device *dev, st
 int cs42l51_remove(struct device *dev);
 int __maybe_unused cs42l51_suspend(struct device *dev);
 int __maybe_unused cs42l51_resume(struct device *dev);
-extern const struct of_device_id cs42l51_of_match[];
 
 #define CS42L51_CHIP_ID			0x1B
 #define CS42L51_CHIP_REV_A		0x00


