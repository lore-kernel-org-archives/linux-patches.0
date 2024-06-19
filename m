Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA09147C6E;
	Wed, 19 Jun 2024 13:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803645; cv=none; b=Kph+3snzSVzC1IKzzOix5dxbUexE6y1vnQtAD76sKVvI/qkLXdcg96GSutmh7Ze9wQAJI4Tjp2Tv7nZJgceSb8CMlOmtiVSAK45FL8ediso4j0pWE8rtkx3Afn5TzXwcXuJQZWHcSHRHreZblMBXm15L4RRVJHxIE0GQCOqFqtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803645; c=relaxed/simple;
	bh=GWXsSWw52Myi5kjHC8X9/imvHAwa7hS4xYhWoG4rYIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fd8e41fNzW6HuTOvSSagHbX84uIvFVBdoWP+1kWr9lSeuE80El41vVA7e4E8lTnKhZ31fOK2LrelhS1XvrA0KDmjBYBeOwJmFNi50jkh5JB6uR027SnxtBernIQS5oC+XwrO67GaOtzpvBzAi+0qgdTpMNf6kU988VYdtGOKEVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMX6qTny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMX6qTny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5978C2BBFC;
	Wed, 19 Jun 2024 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803645;
	bh=GWXsSWw52Myi5kjHC8X9/imvHAwa7hS4xYhWoG4rYIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMX6qTnyaRNIFO6nVoChcdj+fG/rw+ioEENYshEkoyluVBhmb1rnVbf2Z/byaWhZn
	 K2dxJiJkIA6wxwbNzQUKIhrMs9G5rcK+zCL0tnnB1j7b3fOUzslvrlzOST+Bmzhooy
	 vvH6GM/jB+eFW5aUyHsuqspFO9q3MuKUSRlMMM8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/217] iio: accel: mxc4005: Reset chip on probe() and resume()
Date: Wed, 19 Jun 2024 14:54:58 +0200
Message-ID: <20240619125558.805105622@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6b8cffdc4a31e4a72f75ecd1bc13fbf0dafee390 ]

On some designs the chip is not properly reset when powered up at boot or
after a suspend/resume cycle.

Use the sw-reset feature to ensure that the chip is in a clean state
after probe() / resume() and in the case of resume() restore the settings
(scale, trigger-enabled).

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218578
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240326113700.56725-3-hdegoede@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mxc4005.c | 68 +++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index b8dfdb571bf1f..0ae544aaff0cc 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2014, Intel Corporation.
  */
 
+#include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
 #include <linux/iio/iio.h>
@@ -36,6 +37,7 @@
 
 #define MXC4005_REG_INT_CLR1		0x01
 #define MXC4005_REG_INT_CLR1_BIT_DRDYC	0x01
+#define MXC4005_REG_INT_CLR1_SW_RST	0x10
 
 #define MXC4005_REG_CONTROL		0x0D
 #define MXC4005_REG_CONTROL_MASK_FSR	GENMASK(6, 5)
@@ -43,6 +45,9 @@
 
 #define MXC4005_REG_DEVICE_ID		0x0E
 
+/* Datasheet does not specify a reset time, this is a conservative guess */
+#define MXC4005_RESET_TIME_US		2000
+
 enum mxc4005_axis {
 	AXIS_X,
 	AXIS_Y,
@@ -66,6 +71,8 @@ struct mxc4005_data {
 		s64 timestamp __aligned(8);
 	} scan;
 	bool trigger_enabled;
+	unsigned int control;
+	unsigned int int_mask1;
 };
 
 /*
@@ -349,6 +356,7 @@ static int mxc4005_set_trigger_state(struct iio_trigger *trig,
 		return ret;
 	}
 
+	data->int_mask1 = val;
 	data->trigger_enabled = state;
 	mutex_unlock(&data->mutex);
 
@@ -384,6 +392,13 @@ static int mxc4005_chip_init(struct mxc4005_data *data)
 
 	dev_dbg(data->dev, "MXC4005 chip id %02x\n", reg);
 
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_CLR1,
+			   MXC4005_REG_INT_CLR1_SW_RST);
+	if (ret < 0)
+		return dev_err_probe(data->dev, ret, "resetting chip\n");
+
+	fsleep(MXC4005_RESET_TIME_US);
+
 	ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK0, 0);
 	if (ret < 0)
 		return dev_err_probe(data->dev, ret, "writing INT_MASK0\n");
@@ -480,6 +495,58 @@ static int mxc4005_probe(struct i2c_client *client,
 	return devm_iio_device_register(&client->dev, indio_dev);
 }
 
+static int mxc4005_suspend(struct device *dev)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct mxc4005_data *data = iio_priv(indio_dev);
+	int ret;
+
+	/* Save control to restore it on resume */
+	ret = regmap_read(data->regmap, MXC4005_REG_CONTROL, &data->control);
+	if (ret < 0)
+		dev_err(data->dev, "failed to read reg_control\n");
+
+	return ret;
+}
+
+static int mxc4005_resume(struct device *dev)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct mxc4005_data *data = iio_priv(indio_dev);
+	int ret;
+
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_CLR1,
+			   MXC4005_REG_INT_CLR1_SW_RST);
+	if (ret) {
+		dev_err(data->dev, "failed to reset chip: %d\n", ret);
+		return ret;
+	}
+
+	fsleep(MXC4005_RESET_TIME_US);
+
+	ret = regmap_write(data->regmap, MXC4005_REG_CONTROL, data->control);
+	if (ret) {
+		dev_err(data->dev, "failed to restore control register\n");
+		return ret;
+	}
+
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK0, 0);
+	if (ret) {
+		dev_err(data->dev, "failed to restore interrupt 0 mask\n");
+		return ret;
+	}
+
+	ret = regmap_write(data->regmap, MXC4005_REG_INT_MASK1, data->int_mask1);
+	if (ret) {
+		dev_err(data->dev, "failed to restore interrupt 1 mask\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static DEFINE_SIMPLE_DEV_PM_OPS(mxc4005_pm_ops, mxc4005_suspend, mxc4005_resume);
+
 static const struct acpi_device_id mxc4005_acpi_match[] = {
 	{"MXC4005",	0},
 	{"MXC6655",	0},
@@ -506,6 +573,7 @@ static struct i2c_driver mxc4005_driver = {
 		.name = MXC4005_DRV_NAME,
 		.acpi_match_table = ACPI_PTR(mxc4005_acpi_match),
 		.of_match_table = mxc4005_of_match,
+		.pm = pm_sleep_ptr(&mxc4005_pm_ops),
 	},
 	.probe		= mxc4005_probe,
 	.id_table	= mxc4005_id,
-- 
2.43.0



