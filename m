Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AED476049;
	Wed,  9 Sep 2026 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962431; cv=none; b=prXatGEC+GIvPigiWdDT8EiEQk4WMHhUXNjSdWDw637gEoubSSQ8nreiZmXhGDP/jBu9qgdJ6SloJ5JbJAOmJoZ68eq3UF5DAcrCDBxembzYzTzY9hC0Cip91tRga3Qx0xuDOP3onqECSgtxzogbSzrmhOEDMubQfXFAd1jPa6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962431; c=relaxed/simple;
	bh=OEJax5hKPITIBHckWqDzH7xozH1Zg9+1J1KS95+Jgl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XeitUPOlDF2QYKajvpKmw+dsQ6dPG3HQPQNVeYWswCD0BvyADa5SLMIWjzLcQW0fT1DuZrFKOwgnVQ42AxLS6w/kibQJvjX0d+QxrSisvOrRQJZKkEMpoXfpEGQSjE2AmIVMAlpthbk+06sx4kSGUeWyWrD+iELbEu+IdpL95Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ON7AhraI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ON7AhraI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A04F1F00A3A;
	Wed,  9 Sep 2026 14:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962430;
	bh=ytTMLeGtNO2wBUOqxS4o+wfstauzy0+7d3LU7lFlyk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ON7AhraISugIKxCjN5+uPfxIx+KtaYpw7VXyyr/3lNKikPgKDAS7Uo4ZIYNrhT6O1
	 PhS3sL3uwaovuXuvnapN2+iXcacUXwkLAlav/KoGaHJDloBr321slejYlPVKB+lipX
	 v7tSsJq7rflC0ie/NntirV94DFBuz7Jv+lP0G+qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 287/556] iio: light: opt4001: Fix power down clearing bits of the wrong register
Date: Wed,  9 Sep 2026 15:39:27 +0200
Message-ID: <20260909134240.765593069@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit 3b2cd82c524c75a2173f2e3f874652a75f81cd1d upstream.

opt4001_power_down() intends to clear the operating mode bits in the
CTRL register but reads OPT4001_DEVICE_ID instead of OPT4001_CTRL, so
the value written back to CTRL contains device ID bits rather than the
current configuration.

Fix and simplify this by using regmap_clear_bits() on the CTRL register
directly in the devm action, and drop opt4001_power_down() which has no
other users.

Suggested-by: Jonathan Cameron <jic23@kernel.org>
Fixes: 9a9608418292 ("iio: light: Add support for TI OPT4001 light sensor")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4001.c |   27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -222,33 +222,14 @@ static int opt4001_set_conf(struct opt40
 	return ret;
 }
 
-static int opt4001_power_down(struct opt4001_chip *chip)
-{
-	struct device *dev = &chip->client->dev;
-	int ret;
-	unsigned int reg;
-
-	ret = regmap_read(chip->regmap, OPT4001_DEVICE_ID, &reg);
-	if (ret) {
-		dev_err(dev, "Failed to read configuration\n");
-		return ret;
-	}
-
-	/* MODE_OFF is 0x0 so just set bits to 0 */
-	reg &= ~OPT4001_CTRL_OPER_MODE_MASK;
-
-	ret = regmap_write(chip->regmap, OPT4001_CTRL, reg);
-	if (ret)
-		dev_err(dev, "Failed to set configuration to power down\n");
-
-	return ret;
-}
-
 static void opt4001_chip_off_action(void *data)
 {
 	struct opt4001_chip *chip = data;
+	int ret;
 
-	opt4001_power_down(chip);
+	ret = regmap_clear_bits(chip->regmap, OPT4001_CTRL, OPT4001_CTRL_OPER_MODE_MASK);
+	if (ret)
+		dev_err(&chip->client->dev, "Failed to power down\n");
 }
 
 static const struct iio_chan_spec opt4001_channels[] = {


