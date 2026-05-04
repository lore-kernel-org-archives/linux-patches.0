Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80EB315785;
	Mon,  4 May 2026 14:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904298; cv=none; b=rxd90ALloVQgu8swaRYL+MdcSkaETEzCzUfGafC8rMn8MxEGAG1hZp463InxzdTMsrqD5kxGgJS1seALkkbo37VfmRge2CCuIBFzCWjyjYidwusZupfuDe60toP7qY4Sa/DeYPahCB2Ri2gkhavZKlMWVJQF5HCFTpKX99DVKQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904298; c=relaxed/simple;
	bh=qVl9snOokzBYFsd9w1tvACMgXYsZeNkvEb4EQ+846Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3Zutt71myxkT8ZYRe1M7Zvlp+iRdh97LjCasQq+disGmGs0iOq0RV/lPTUdYgYS0ehSTlMBw3fBbvdbFkdeXrlInqpI7ZZGB8NRxFBYMkxxnBKM2VNM/iJBipwtD/H7Z0HKTy+zatZsOTV/z+qdNdY8YqY2qv8bDgyI0OFOuBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKU2008z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKU2008z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7D0C2BCB8;
	Mon,  4 May 2026 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904298;
	bh=qVl9snOokzBYFsd9w1tvACMgXYsZeNkvEb4EQ+846Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKU2008zZoVpSaS46Yr16KS8Cb5PpJ6fKbj4aXeVS6IKk8VTTPWAkClynSzKJe9mk
	 jOZ4LFO6aIoN1ris2HCjjasqmbnsecR5XBOdZpuhzp2lXddMhWqpYqCNdbJWpYhheL
	 UiIlPvWMBTMLkTkeiAmRNnqAXnOQuXKpGE5nx/Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/275] iio: frequency: admv1013: fix NULL pointer dereference on str
Date: Mon,  4 May 2026 15:53:19 +0200
Message-ID: <20260504135152.662578655@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit aac0a51b16700b403a55b67ba495de021db78763 ]

When device_property_read_string() fails, str is left uninitialized
but the code falls through to strcmp(str, ...), dereferencing a garbage
pointer. Replace manual read/strcmp with
device_property_match_property_string() and consolidate the SE mode
enums into a single sequential enum, mapping to hardware register
values via a switch consistent with other bitfields in the driver.

Several cleanup patches have been applied to this driver recently so
this will need a manual backport.

Fixes: da35a7b526d9 ("iio: frequency: admv1013: add support for ADMV1013")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/admv1013.c |   67 ++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 29 deletions(-)

--- a/drivers/iio/frequency/admv1013.c
+++ b/drivers/iio/frequency/admv1013.c
@@ -85,9 +85,9 @@ enum {
 };
 
 enum {
-	ADMV1013_SE_MODE_POS = 6,
-	ADMV1013_SE_MODE_NEG = 9,
-	ADMV1013_SE_MODE_DIFF = 12
+	ADMV1013_SE_MODE_POS,
+	ADMV1013_SE_MODE_NEG,
+	ADMV1013_SE_MODE_DIFF,
 };
 
 struct admv1013_state {
@@ -470,10 +470,23 @@ static int admv1013_init(struct admv1013
 	if (ret)
 		return ret;
 
-	data = FIELD_PREP(ADMV1013_QUAD_SE_MODE_MSK, st->quad_se_mode);
+	switch (st->quad_se_mode) {
+	case ADMV1013_SE_MODE_POS:
+		data = 6;
+		break;
+	case ADMV1013_SE_MODE_NEG:
+		data = 9;
+		break;
+	case ADMV1013_SE_MODE_DIFF:
+		data = 12;
+		break;
+	default:
+		return -EINVAL;
+	}
 
 	ret = __admv1013_spi_update_bits(st, ADMV1013_REG_QUAD,
-					 ADMV1013_QUAD_SE_MODE_MSK, data);
+					 ADMV1013_QUAD_SE_MODE_MSK,
+					 FIELD_PREP(ADMV1013_QUAD_SE_MODE_MSK, data));
 	if (ret)
 		return ret;
 
@@ -514,37 +527,33 @@ static void admv1013_powerdown(void *dat
 	admv1013_spi_update_bits(data, ADMV1013_REG_ENABLE, enable_reg_msk, enable_reg);
 }
 
+static const char * const admv1013_input_modes[] = {
+	[ADMV1013_IQ_MODE] = "iq",
+	[ADMV1013_IF_MODE] = "if",
+};
+
+static const char * const admv1013_quad_se_modes[] = {
+	[ADMV1013_SE_MODE_POS] = "se-pos",
+	[ADMV1013_SE_MODE_NEG] = "se-neg",
+	[ADMV1013_SE_MODE_DIFF] = "diff",
+};
+
 static int admv1013_properties_parse(struct admv1013_state *st)
 {
 	int ret;
-	const char *str;
 	struct device *dev = &st->spi->dev;
 
 	st->det_en = device_property_read_bool(dev, "adi,detector-enable");
 
-	ret = device_property_read_string(dev, "adi,input-mode", &str);
-	if (ret)
-		st->input_mode = ADMV1013_IQ_MODE;
-
-	if (!strcmp(str, "iq"))
-		st->input_mode = ADMV1013_IQ_MODE;
-	else if (!strcmp(str, "if"))
-		st->input_mode = ADMV1013_IF_MODE;
-	else
-		return -EINVAL;
-
-	ret = device_property_read_string(dev, "adi,quad-se-mode", &str);
-	if (ret)
-		st->quad_se_mode = ADMV1013_SE_MODE_DIFF;
-
-	if (!strcmp(str, "diff"))
-		st->quad_se_mode = ADMV1013_SE_MODE_DIFF;
-	else if (!strcmp(str, "se-pos"))
-		st->quad_se_mode = ADMV1013_SE_MODE_POS;
-	else if (!strcmp(str, "se-neg"))
-		st->quad_se_mode = ADMV1013_SE_MODE_NEG;
-	else
-		return -EINVAL;
+	ret = device_property_match_property_string(dev, "adi,input-mode",
+						    admv1013_input_modes,
+						    ARRAY_SIZE(admv1013_input_modes));
+	st->input_mode = ret >= 0 ? ret : ADMV1013_IQ_MODE;
+
+	ret = device_property_match_property_string(dev, "adi,quad-se-mode",
+						    admv1013_quad_se_modes,
+						    ARRAY_SIZE(admv1013_quad_se_modes));
+	st->quad_se_mode = ret >= 0 ? ret : ADMV1013_SE_MODE_DIFF;
 
 	ret = devm_regulator_bulk_get_enable(dev,
 					     ARRAY_SIZE(admv1013_vcc_regs),


