Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A244E3E3156;
	Wed, 30 Sep 2026 18:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794259; cv=none; b=mJOVWFqm3As1V9TVAGEj41Lp5ySXxpFCx12PWhaJSyhuRdkqEe1bkQTu8OUj9c3X5QNpyqg6xBfYa2Wz207KJUKlOc+MVrzKhVEfpo8dDIHFYVFZFGlLp2i5AlwnwP+jN+f98Lpb37K97OBoAGf5isTg0dYfO4dlaerUiiOspJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794259; c=relaxed/simple;
	bh=WusJpnWGTXvecBWlOhMKtsZttp5pIctZ+UQyLb1A9BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQw9MSDO+O+IQizEmotBp/+8DcT1OViXoAterERgClVGb99xf3WNX2dz3e/JzXJaH2Yd7AYoL2iap74B5esHPPIB2MWYuzxtLveHLx7KRTnw5Nf+gIi/bMeLd7GXD1k0dULL5Y//6BwYOlLFlV9oXYbjIPUJm3mSKDTS2FX/8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1Odc8EC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1Odc8EC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4917D1F000FF;
	Wed, 30 Sep 2026 18:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794256;
	bh=mQ53EGsrMQQNvzEtYtonJDZm4ndUYYBD6ZMJ0k9lVv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1Odc8ECf3CHUUj6v4Rgjy0W8dEfv1d4BWTXOU/7BsK6+uuAWv9ulqLevbzpC7TW+
	 2GLQZrs5uDrP0bbNan3yRp9wKNqLyrh/696DXyELJOnm45R/eSh37BYZfNaD+eE5Yc
	 vJK/XB9EmKe3/t/EQQpI5z9/LiVzVaj+6XrP9hog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0145/1193] iio: light: stk3310: Deal with the ps interrupt issue in PM
Date: Wed, 30 Sep 2026 17:13:49 +0200
Message-ID: <20260930152437.429264024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miao Li <limiao@kylinos.cn>

[ Upstream commit 9c1d639e90cf42f5c1401f91f38ffd89af6dd970 ]

On the Inspur HS326 laptop(which integrated with HiSilicon M900
processor), if the STK3311-X chip's PS interrupt is configured
in "Recommended interrupt mode", the interrupt cannot be triggered
normally after waking from suspend or hibernation.

In this case, neither disabling and re-enabling the interrupt nor
resetting the PS threshold register can restore the interrupt to
normal operation.

If the interrupt is disabled in suspend() then reset the PS threshold
register and enable the interrupt in resume(). This resolves the issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/stk3310.c | 76 +++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/light/stk3310.c b/drivers/iio/light/stk3310.c
index 72b08d870d337..2204f0fb4dfd3 100644
--- a/drivers/iio/light/stk3310.c
+++ b/drivers/iio/light/stk3310.c
@@ -106,6 +106,9 @@ struct stk3310_data {
 	struct mutex lock;
 	bool als_enabled;
 	bool ps_enabled;
+	bool ps_int_enabled;
+	uint32_t ps_thdl;
+	uint32_t ps_thdh;
 	uint32_t ps_near_level;
 	u64 timestamp;
 	struct regmap *regmap;
@@ -275,10 +278,17 @@ static int stk3310_write_event(struct iio_dev *indio_dev,
 
 	buf = cpu_to_be16(val);
 	ret = regmap_bulk_write(data->regmap, reg, &buf, 2);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "failed to set PS threshold!\n");
+		return ret;
+	}
 
-	return ret;
+	if (reg == STK3310_REG_THDH_PS)
+		data->ps_thdh = val;
+	else
+		data->ps_thdl = val;
+
+	return 0;
 }
 
 static int stk3310_read_event_config(struct iio_dev *indio_dev,
@@ -313,11 +323,17 @@ static int stk3310_write_event_config(struct iio_dev *indio_dev,
 	/* Set INT_PS value */
 	mutex_lock(&data->lock);
 	ret = regmap_field_write(data->reg_int_ps, state);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "failed to set interrupt mode\n");
+		mutex_unlock(&data->lock);
+		return ret;
+	}
+
+	data->ps_int_enabled = state;
+
 	mutex_unlock(&data->lock);
 
-	return ret;
+	return 0;
 }
 
 static int stk3310_read_raw(struct iio_dev *indio_dev,
@@ -490,10 +506,15 @@ static int stk3310_init(struct iio_dev *indio_dev)
 
 	/* Enable PS interrupts */
 	ret = regmap_field_write(data->reg_int_ps, STK3310_PSINT_EN);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "failed to enable interrupts!\n");
+		return ret;
+	}
 
-	return ret;
+	data->ps_int_enabled = true;
+	data->ps_thdh = STK3310_PS_MAX_VAL;
+
+	return 0;
 }
 
 static bool stk3310_is_volatile_reg(struct device *dev, unsigned int reg)
@@ -659,9 +680,18 @@ static void stk3310_remove(struct i2c_client *client)
 static int stk3310_suspend(struct device *dev)
 {
 	struct stk3310_data *data;
+	int ret;
 
 	data = iio_priv(i2c_get_clientdata(to_i2c_client(dev)));
 
+	if (data->ps_int_enabled) {
+		ret = regmap_field_write(data->reg_int_ps, 0x0);
+		if (ret < 0) {
+			dev_err(dev, "failed to disable ps int at suspend.\n");
+			return ret;
+		}
+	}
+
 	return stk3310_set_state(data, STK3310_STATE_STANDBY);
 }
 
@@ -669,6 +699,8 @@ static int stk3310_resume(struct device *dev)
 {
 	u8 state = 0;
 	struct stk3310_data *data;
+	__be16 buf;
+	int ret;
 
 	data = iio_priv(i2c_get_clientdata(to_i2c_client(dev)));
 	if (data->ps_enabled)
@@ -676,7 +708,37 @@ static int stk3310_resume(struct device *dev)
 	if (data->als_enabled)
 		state |= STK3310_STATE_EN_ALS;
 
-	return stk3310_set_state(data, state);
+	ret = stk3310_set_state(data, state);
+	if (ret < 0)
+		return ret;
+
+	if (data->ps_thdl != 0x0) {
+		buf = cpu_to_be16(data->ps_thdl);
+		ret = regmap_bulk_write(data->regmap, STK3310_REG_THDL_PS, &buf, 2);
+		if (ret < 0) {
+			dev_err(dev, "failed to set reg THDL_PS at resume.\n");
+			return ret;
+		}
+	}
+
+	if (data->ps_thdh != STK3310_PS_MAX_VAL) {
+		buf = cpu_to_be16(data->ps_thdh);
+		ret = regmap_bulk_write(data->regmap, STK3310_REG_THDH_PS, &buf, 2);
+		if (ret < 0) {
+			dev_err(dev, "failed to set reg THDH_PS at resume.\n");
+			return ret;
+		}
+	}
+
+	if (data->ps_int_enabled) {
+		ret = regmap_field_write(data->reg_int_ps, STK3310_PSINT_EN);
+		if (ret < 0) {
+			dev_err(dev, "failed to enable ps int at resume.\n");
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(stk3310_pm_ops, stk3310_suspend,
-- 
2.53.0



