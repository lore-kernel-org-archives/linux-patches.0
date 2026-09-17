Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B7A4F3910;
	Thu, 17 Sep 2026 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660212; cv=none; b=qvhhyPXFlG1ofTdme9pCkQAvuxcKkhaaUq+gjfBUmPJUbM1OFA2tfmuyNawfBJAVJUzGlpBSZoM2m0SZAoPrkGixGXyg3BI/eRGzS1yZyqKjkq0B3NaN+oZrwCfaxC7F9NvsrJkfHtw2R+RoTQsiPr6IaIGnuv3IB5BJzRBkdbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660212; c=relaxed/simple;
	bh=GRMEGyINUb0WI5j6YophnT2EpPnWKyN26qJ+gXqcM+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtbBLqJVd983sIAoC/mNVrlyM/ihlaEfscGSCdJyuxCjCSG9dDZcHur53iaaPtpKkdtqxKr4E+8kfVOAp+S54Fex1/8MBF40uq5spdsF3ACfB67ccQw+dAIwSOhV20yp78SLEFwIUAX5zTG7H1QQFZDkGo7LCZ1I7jzeL5YBcLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGlFhxfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGlFhxfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7C71F000FF;
	Thu, 17 Sep 2026 15:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660203;
	bh=+6KaTfkkHHoCIMOUikuuGNQB6SqeWDspcpfZpzkr/3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UGlFhxfP5ai9FrAvN2BizQPtBoHopxUvrfQl1keP3Nbkl24Z0Z1dQIpkJSlYibqQG
	 E1NZU5HxNLadi5uX1gOl2Oul4SNyY+z0jvndi37CZoUr6kK6bWqjBd48ujPA/1r9/n
	 lihJ1gYB5hpcf8asGZQMSMA1J/vanAyAEsIFAsn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yorick Rommers <yorick-rommers@hotmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 513/733] ASoC: amd: acp-da7219-max98357a: dont bind on Raven/Picasso boards
Date: Thu, 17 Sep 2026 16:13:41 +0100
Message-ID: <20260917151404.916756059@linuxfoundation.org>
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

From: Yorick Rommers <yorick-rommers@hotmail.com>

commit 7e125889f1705fc6326679a3db3b4159f7a8c87e upstream.

The "AMDI5682" ACPI HID is matched by two AMD ASoC machine drivers:
cz-da7219-max98357a (this driver, Carrizo/Stoney) and
acp3x-alc5682-max98357 (Raven/Picasso). cz-da7219-max98357a is linked
first and probes the platform device first; its DAI links reference the
Stoney ACP, which is absent on Raven/Picasso, so its card can never be
instantiated there.

This was harmless until commit 42d99857d6f0 ("ASoC: core: Move all users
to deferrable card binding"): devm_snd_soc_register_card() now returns 0
for a card left pending instead of propagating -EPROBE_DEFER, so
cz_probe() succeeds and permanently binds AMDI5682. acp3x-alc5682-max98357
never binds and the internal speakers and headphone jack get no card.

Detect Raven/Picasso (and later) by the ACP3.x audio coprocessor's
dedicated PCI function (1022:15e2); Carrizo/Stoney reach the ACP through
the GPU driver and have no such device. Return -ENODEV so the driver core
continues probing AMDI5682 with acp3x-alc5682-max98357.

Fixes: 42d99857d6f0 ("ASoC: core: Move all users to deferrable card binding")
Cc: stable@vger.kernel.org
Signed-off-by: Yorick Rommers <yorick-rommers@hotmail.com>
Tested-by: Yorick Rommers <yorick-rommers@hotmail.com>
Link: https://patch.msgid.link/20260907121228.13754-1-yorick-rommers@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/acp-da7219-max98357a.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/soc/amd/acp-da7219-max98357a.c b/sound/soc/amd/acp-da7219-max98357a.c
index af559653e625..1ac729a58bb4 100644
--- a/sound/soc/amd/acp-da7219-max98357a.c
+++ b/sound/soc/amd/acp-da7219-max98357a.c
@@ -17,6 +17,7 @@
 #include <linux/i2c.h>
 #include <linux/input.h>
 #include <linux/acpi.h>
+#include <linux/pci.h>
 
 #include "acp.h"
 #include "../codecs/da7219.h"
@@ -742,6 +743,18 @@ static const struct regulator_desc acp_da7219_desc = {
 	.n_voltages = 1,
 };
 
+/*
+ * The ACP3.x+ (Raven/Picasso and later) audio coprocessor is a dedicated PCI
+ * function.  Carrizo/Stoney - the only platforms handled by this driver - reach
+ * the ACP through the GPU driver and have no such device.
+ */
+#define ACP3X_PCI_DEV_ID	0x15e2
+
+static const struct pci_device_id acp3x_pci_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, ACP3X_PCI_DEV_ID) },
+	{ 0, },
+};
+
 static int cz_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -750,6 +763,16 @@ static int cz_probe(struct platform_device *pdev)
 	struct regulator_dev *rdev;
 	struct device *dev = &pdev->dev;
 
+	/*
+	 * AMDI5682 is also matched by acp3x-alc5682-max98357 (Raven/Picasso).
+	 * If the ACP3.x PCI function is present this is such a board; return
+	 * -ENODEV so that driver binds instead.
+	 */
+	if (pci_dev_present(acp3x_pci_ids)) {
+		dev_info(dev, "ACP3.x PCI device present, deferring to acp3x-alc5682-max98357\n");
+		return -ENODEV;
+	}
+
 	card = (struct snd_soc_card *)acp_soc_is_rltk_max(dev);
 	if (!card)
 		return -ENODEV;
-- 
2.55.0



