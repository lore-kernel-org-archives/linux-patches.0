Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA83502545;
	Wed, 30 Sep 2026 16:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784357; cv=none; b=gtAMfPSwhVINUNS4hbrtnQnFc4YsKGXuJ6iBlW/1WAh0TKXYF+hIjbopRe2on7a8buwZmSx62+2/e3uhJ7YbG4X1u9UDQzKJj+yQXj2Oit8pPu0S7Ey0XqRDwBrsDGRTJKhQvWli69cj/rekzs6nNvcihPtMCAsjdjuIHCD+nRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784357; c=relaxed/simple;
	bh=sC07YK6FuZEHDKqv8xk/m9NGNkRhLG9b/L9V2N+ecqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocgl2Tb92j5oz+VeTS52qBcR9B0jyPYsteMg2rkvfrKH/QpJ3CS6MgqK+m/d9ijAshv8Ii2P/IqXYyhi/bKNETK78IHv8rwGCXK5Mf82nszOUtOPNVtGMb8TvEmHrxnEUe2FinWJYkWvI5rkXfMl7SPBzk5JS3z96COJ9XYYkfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4PhZWrM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4PhZWrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852731F000FF;
	Wed, 30 Sep 2026 16:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784352;
	bh=Zq0i/dni8uatEOr9iGmpt/dSe8tkCfHSyd9o0NnUT0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4PhZWrMnIacwN+QwPdLTgLVOKNHWgtZ/W9mKQLsI9hi4KhCMaPEoYAoT/xzLgOIc
	 6GEmtT5a13VX2M9Nl4D7+/J9+Plh4GgaGddi+zfrdwHRsg4UVhiRhZ5OcFHGRQJZxP
	 H2/EWeZ9DkNHcJW+uc6oj3+rvaV7vmPSDgqXiFL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Li <limiao@kylinos.cn>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/982] iio: light: stk3310: Deal with the ps interrupt issue in PM
Date: Wed, 30 Sep 2026 17:14:22 +0200
Message-ID: <20260930152419.523623395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b8e0da6aabc1..b1b0e77922ac1 100644
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
@@ -660,9 +681,18 @@ static void stk3310_remove(struct i2c_client *client)
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
 
@@ -670,6 +700,8 @@ static int stk3310_resume(struct device *dev)
 {
 	u8 state = 0;
 	struct stk3310_data *data;
+	__be16 buf;
+	int ret;
 
 	data = iio_priv(i2c_get_clientdata(to_i2c_client(dev)));
 	if (data->ps_enabled)
@@ -677,7 +709,37 @@ static int stk3310_resume(struct device *dev)
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



