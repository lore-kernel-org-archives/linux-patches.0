Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAEC1F755C;
	Tue,  3 Dec 2024 14:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237669; cv=none; b=FwzHAAi0IDXga1m4Qzqgc27DQlQM9kJzCFz5QpFXxFVUcYp4aPBFu3VYQzub24/xXRFNX2cjLPLi2fXf3zY+1Z4YwHYhZtNIIdRtOkO6YkoMATFEjhJMZ8DBLkkaP5enEzJ9NjIg3HAA9XXfYTeyj0DkeNGUgY1sx8Ye2W7JtIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237669; c=relaxed/simple;
	bh=i+1RWF9cPGB27xeX/mjeTVHmbZFqYSrPoZRxfWkoCRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WmKGU6xdXe4xCbFMbFq7ITdKy98Thz5x58VlyxnAOxypLmpIzh7i8fJ/+Hk33SSBym568Pp03fDp9+Ef/xhaQTbTEwS1o0TJhcfcwi7COM46xHZRc8+YRajFSM2uj7IhMfpSFXYYVhq8pjVei+veaxsi/z9hbcJBXOeJ0S5xagw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dL1KYkkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dL1KYkkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6ED3C4CECF;
	Tue,  3 Dec 2024 14:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237669;
	bh=i+1RWF9cPGB27xeX/mjeTVHmbZFqYSrPoZRxfWkoCRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dL1KYkklUj2pRYb6tHqCNF4G4uJJ6DAz5AadubMWpYd5QHy2WxbEoxb+MgIDnWS1D
	 /RiwQiUnA2aO6Dyln/jnQrvVC+0BQtBnoe+m7x3q2tt6lvzn95Su7rHAY/8anZ6oo2
	 1oLDeNVI+vyTaeJ6ze5xteaVo9Gegl0tkrWvDRbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 007/817] ASoC: Intel: bytcr_rt5640: Add support for non ACPI instantiated codec
Date: Tue,  3 Dec 2024 15:32:59 +0100
Message-ID: <20241203143955.914498596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit d48696b915527b5bcdd207a299aec03fb037eb17 ]

On some x86 Bay Trail tablets which shipped with Android as factory OS,
the DSDT is so broken that the codec needs to be manually instantatiated
by the special x86-android-tablets.ko "fixup" driver for cases like this.

This means that the codec-dev cannot be retrieved through its ACPI fwnode,
add support to the bytcr_rt5640 machine driver for such manually
instantiated rt5640 i2c_clients.

An example of a tablet which needs this is the Vexia EDU ATLA 10 tablet,
which has been distributed to schools in the Spanish Andalucía region.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20241024211615.79518-1-hdegoede@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/bytcr_rt5640.c | 33 ++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index 4479825c08b5e..ba4293ae7c24f 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -17,6 +17,7 @@
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/device/bus.h>
 #include <linux/dmi.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
@@ -32,6 +33,8 @@
 #include "../atom/sst-atom-controls.h"
 #include "../common/soc-intel-quirks.h"
 
+#define BYT_RT5640_FALLBACK_CODEC_DEV_NAME	"i2c-rt5640"
+
 enum {
 	BYT_RT5640_DMIC1_MAP,
 	BYT_RT5640_DMIC2_MAP,
@@ -1698,9 +1701,33 @@ static int snd_byt_rt5640_mc_probe(struct platform_device *pdev)
 
 	codec_dev = acpi_get_first_physical_node(adev);
 	acpi_dev_put(adev);
-	if (!codec_dev)
-		return -EPROBE_DEFER;
-	priv->codec_dev = get_device(codec_dev);
+
+	if (codec_dev) {
+		priv->codec_dev = get_device(codec_dev);
+	} else {
+		/*
+		 * Special case for Android tablets where the codec i2c_client
+		 * has been manually instantiated by x86_android_tablets.ko due
+		 * to a broken DSDT.
+		 */
+		codec_dev = bus_find_device_by_name(&i2c_bus_type, NULL,
+					BYT_RT5640_FALLBACK_CODEC_DEV_NAME);
+		if (!codec_dev)
+			return -EPROBE_DEFER;
+
+		if (!i2c_verify_client(codec_dev)) {
+			dev_err(dev, "Error '%s' is not an i2c_client\n",
+				BYT_RT5640_FALLBACK_CODEC_DEV_NAME);
+			put_device(codec_dev);
+		}
+
+		/* fixup codec name */
+		strscpy(byt_rt5640_codec_name, BYT_RT5640_FALLBACK_CODEC_DEV_NAME,
+			sizeof(byt_rt5640_codec_name));
+
+		/* bus_find_device() returns a reference no need to get() */
+		priv->codec_dev = codec_dev;
+	}
 
 	/*
 	 * swap SSP0 if bytcr is detected
-- 
2.43.0



