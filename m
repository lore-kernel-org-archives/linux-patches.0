Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11513C81AD;
	Wed, 30 Sep 2026 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794312; cv=none; b=CDwMVqnN6JbpixVK+De6xqblPtKzF0694JYzTTOr4803LbeHAUzhrhPhjLa85ST5Qezm7o+xDIB6PWTlx2V3T8GuOT3H0j5EEpuxIL0BYhPUAMwyN+x9UigXbyWxvJyf35gzBZLkdqzU+EukSSTWqrBaXW9ZcfBglgM3c54M1eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794312; c=relaxed/simple;
	bh=xWNozpGGT9x1XU+7GH7j7Gi/NawcUiB4Ey2bpqnXDV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3DNcvMzbrdWap5WrB2UhlXUv+TjSgXEDPJf4EuQHOwjBv2d3bLwWibS8OcAFjz67LNqTlWNYpLN/TfiVPOqEmfnE8JHF6HxoGpMHbUmnabv5jENtIKXW36yvpqprd8+1ssfSk9ARGSBQLFimk3N4jNZ5O4kwKZUXWrcdfkuQQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8bTLcZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8bTLcZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36FA21F000FF;
	Wed, 30 Sep 2026 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794310;
	bh=0WhlxtK/nR6We5lup4+Kdz3F0QU/PvRhhwTdt65Um+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8bTLcZ0GDoPmsLxdi20pEb+4uFTgAC7oLilmApJTQRIM/JEjMZuoMHnkSUuibMek
	 9MN7/qgYIKypAZDW/0Eb/ErMnag150y+3MbQMjjVtlHmNs006xodv2c14ymPDhp5IE
	 Iso5Bn7konaczjAkp172zVyPlkGfcv/eW/LltNbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyansh Jain <priyansh.jain@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0167/1193] thermal/drivers/qcom/tsens: Atomic temperature read with hardware-guided retries
Date: Wed, 30 Sep 2026 17:14:11 +0200
Message-ID: <20260930152437.903701128@linuxfoundation.org>
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

From: Priyansh Jain <priyansh.jain@oss.qualcomm.com>

[ Upstream commit e28ef2f3ccea276436bd0f30c93f99e764ba492b ]

The existing TSENS temperature read logic polls the valid bit and then
reads the temperature register. When temperature reads are triggered
at very short intervals, this can race with hardware updates and allow
the temperature field to be read while it is still being updated.

In this case, the valid bit may already be asserted even though the
temperature value is transitioning, resulting in an incorrect reading.

Hardware programming guidelines require the temperature value and the
valid bit to be sampled atomically in the same read transaction. A
reading is considered valid only if the valid bit is observed set in
that same sample.

The guidelines further specify that software should attempt the
temperature read up to three times to account for transient update
windows. If none of the attempts yields a valid sample, a stable fallback
value must be returned: if the first and second samples match, the second
value is returned;otherwise, if the second and third samples match, the
third value is returned;if neither pair matches, -EAGAIN is returned.

Update the TSENS sensor read logic to implement atomic sampling along
with the recommended retry-and-compare fallback behavior. This removes
the race window and ensures deterministic temperature values in
accordance with hardware requirements.

Signed-off-by: Priyansh Jain <priyansh.jain@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260514113643.1954111-1-priyansh.jain@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qcom/tsens.c | 111 ++++++++++++++++++++++++-----------
 drivers/thermal/qcom/tsens.h |   1 +
 2 files changed, 78 insertions(+), 34 deletions(-)

diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index 0aff3318aa19a..d2dc97653ce3f 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -315,9 +315,66 @@ static inline int code_to_degc(u32 adc_code, const struct tsens_sensor *s)
 }
 
 /**
- * tsens_hw_to_mC - Return sign-extended temperature in mCelsius.
+ * tsens_read_temp - Retrieve temperature readings from the hardware.
  * @s:     Pointer to sensor struct
  * @field: Index into regmap_field array pointing to temperature data
+ * @temp: temperature in deciCelsius to be read from hardware
+ *
+ * This function handles temperature returned in ADC code or deciCelsius
+ * depending on IP version.
+ *
+ * Return: 0 on success, a negative errno will be returned in error cases
+ */
+static int tsens_read_temp(const struct tsens_sensor *s, int field, int *temp)
+{
+	struct tsens_priv *priv = s->priv;
+	int temp_val[MAX_READ_RETRY] = {0};
+	u32 status;
+	int ret;
+	u32 last_temp_mask = GENMASK(priv->fields[LAST_TEMP_0].msb,
+					priv->fields[LAST_TEMP_0].lsb);
+	u32 valid_bit = priv->rf[VALID_0] ? BIT(priv->fields[VALID_0].lsb) : 0;
+
+	for (int i = 0; i < MAX_READ_RETRY; i++) {
+		ret = regmap_read(priv->tm_map, priv->fields[field].reg, &status);
+		if (ret)
+			return ret;
+
+		/* VER_0 doesn't have a VALID bit */
+		if (!valid_bit) {
+			*temp = status & last_temp_mask;
+			return 0;
+		}
+
+		temp_val[i] = status & last_temp_mask;
+
+		if (status & valid_bit) {
+			*temp = temp_val[i];
+			return 0;
+		}
+	}
+
+	/*
+	 * As per the HW guidelines, if none of the attempts observe a
+	 * valid sample, a stable fallback value must be returned. If the
+	 * first and second samples match, the second value is returned;
+	 * otherwise, if the second and third samples match, the third
+	 * value is returned.
+	 */
+	if (temp_val[0] == temp_val[1])
+		*temp = temp_val[1];
+	else if (temp_val[1] == temp_val[2])
+		*temp = temp_val[2];
+	else
+		return -EAGAIN;
+
+	return 0;
+}
+
+/**
+ * tsens_hw_to_mC - Return sign-extended temperature in mCelsius.
+ * @s:     Pointer to sensor struct
+ * @temp: temperature in milliCelsius to be read from hardware
  *
  * This function handles temperature returned in ADC code or deciCelsius
  * depending on IP version.
@@ -325,20 +382,14 @@ static inline int code_to_degc(u32 adc_code, const struct tsens_sensor *s)
  * Return: Temperature in milliCelsius on success, a negative errno will
  * be returned in error cases
  */
-static int tsens_hw_to_mC(const struct tsens_sensor *s, int field)
+static int tsens_hw_to_mC(const struct tsens_sensor *s, int temp)
 {
 	struct tsens_priv *priv = s->priv;
 	u32 resolution;
-	u32 temp = 0;
-	int ret;
 
 	resolution = priv->fields[LAST_TEMP_0].msb -
 		priv->fields[LAST_TEMP_0].lsb;
 
-	ret = regmap_field_read(priv->rf[field], &temp);
-	if (ret)
-		return ret;
-
 	/* Convert temperature from ADC code to milliCelsius */
 	if (priv->feat->adc)
 		return code_to_degc(temp, s) * 1000;
@@ -513,8 +564,10 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 					&d->crit_irq_mask);
 		if (ret)
 			return ret;
-
-		d->crit_thresh = tsens_hw_to_mC(s, CRIT_THRESH_0 + hw_id);
+		ret = regmap_field_read(priv->rf[CRIT_THRESH_0 + hw_id], &d->crit_thresh);
+		if (ret)
+			return ret;
+		d->crit_thresh = tsens_hw_to_mC(s, d->crit_thresh);
 	} else {
 		/* No mask register on older TSENS */
 		d->up_irq_mask = 0;
@@ -524,8 +577,16 @@ static int tsens_read_irq_state(struct tsens_priv *priv, u32 hw_id,
 		d->crit_thresh = 0;
 	}
 
-	d->up_thresh  = tsens_hw_to_mC(s, UP_THRESH_0 + hw_id);
-	d->low_thresh = tsens_hw_to_mC(s, LOW_THRESH_0 + hw_id);
+	ret = regmap_field_read(priv->rf[UP_THRESH_0 + hw_id], &d->up_thresh);
+	if (ret)
+		return ret;
+
+	d->up_thresh = tsens_hw_to_mC(s, d->up_thresh);
+	ret = regmap_field_read(priv->rf[LOW_THRESH_0 + hw_id], &d->low_thresh);
+	if (ret)
+		return ret;
+
+	d->low_thresh = tsens_hw_to_mC(s, d->low_thresh);
 
 	dev_dbg(priv->dev, "[%u] %s%s: status(%u|%u|%u) | clr(%u|%u|%u) | mask(%u|%u|%u)\n",
 		hw_id, __func__,
@@ -749,33 +810,15 @@ static void tsens_disable_irq(struct tsens_priv *priv)
 
 int get_temp_tsens_valid(const struct tsens_sensor *s, int *temp)
 {
-	struct tsens_priv *priv = s->priv;
 	int hw_id = s->hw_id;
 	u32 temp_idx = LAST_TEMP_0 + hw_id;
-	u32 valid_idx = VALID_0 + hw_id;
-	u32 valid;
 	int ret;
 
-	/* VER_0 doesn't have VALID bit */
-	if (tsens_version(priv) == VER_0)
-		goto get_temp;
-
-	/* Valid bit is 0 for 6 AHB clock cycles.
-	 * At 19.2MHz, 1 AHB clock is ~60ns.
-	 * We should enter this loop very, very rarely.
-	 * Wait 1 us since it's the min of poll_timeout macro.
-	 * Old value was 400 ns.
-	 */
-	ret = regmap_field_read_poll_timeout(priv->rf[valid_idx], valid,
-					     valid, 1, 20 * USEC_PER_MSEC);
-	if (ret)
-		return ret;
-
-get_temp:
-	/* Valid bit is set, OK to read the temperature */
-	*temp = tsens_hw_to_mC(s, temp_idx);
+	ret = tsens_read_temp(s, temp_idx, temp);
+	if (!ret)
+		*temp = tsens_hw_to_mC(s, *temp);
 
-	return 0;
+	return ret;
 }
 
 int get_temp_common(const struct tsens_sensor *s, int *temp)
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index b94a84c94e29a..b274ad7da0474 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -21,6 +21,7 @@
 #define THRESHOLD_MIN_ADC_CODE	0x0
 
 #define MAX_SENSORS 16
+#define MAX_READ_RETRY 3
 
 #include <linux/interrupt.h>
 #include <linux/thermal.h>
-- 
2.53.0



