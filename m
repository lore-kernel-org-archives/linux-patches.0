Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D4B1FE47B;
	Sun,  7 Jun 2026 10:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828416; cv=none; b=nzZaew1/imh1iEyQRcCVWbQ2tvzr3wGbr8mi+f0SqFYwxKex1x2+qwDLmc/D4oc/POQVRdGES7fMVYQb8Gw3N4+EWkxYciHUJ7bGphVdJO+yN+Oml1uV2RxJod3bjQq3LCLpXIMG+hL2fVy2dQRINhNr7DRrXixsTd+Ap+VQTE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828416; c=relaxed/simple;
	bh=7625K4wIY9wfl0uztw/v+IXzX/H1OLr/1NA1L4rEQzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvozcTgn+F5R80tpwtQT2thoorYY/6eqUQelppfwsNotgON5oaMQEvDd9k/1cw7YmlgQ5xyXp6pD/mqQvWKkCOc35sidp3PkN1dv3PUqZSMxDA70n5hVRqiRkqlEgBCiV6yNajz5qEZUZdcKHv+bq7L8Mz9ryvP/ghUgWCkgHEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OD/bJ0Bs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OD/bJ0Bs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BECE1F00893;
	Sun,  7 Jun 2026 10:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828415;
	bh=8q7gZXVfyj4ZqnN9gBwkuCXFoySYb6xle4kJxz0H/mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OD/bJ0BsRyxW1jrbFEnog9AWtCSYkrvnOGi8swBUqEYPZAfZ/+2P9iUGngVTo8/NM
	 By94MMssFehrKypP5bxoW/edtQ3348jZx3VZMMNb1uHYkHqyv8zAUTJKoIjlJh3D42
	 tl6GW7EU9uHQqPyIjWdxbj5spGFrc6TwsABwLTbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 157/315] iio: dac: ad5686: fix ref bit initialization for single-channel parts
Date: Sun,  7 Jun 2026 11:59:04 +0200
Message-ID: <20260607095733.364313659@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

commit ecae2ae606d493cf11457946436335bd0e726663 upstream.

The reference bit position was ignored when writing the register at the
probe() function (!!val was used). When such bit is 1, internal voltage
reference is disabled so that an external one can be used. For
multi-channel devices, bit 0 of the Internal Reference Setup command
behaves the same way, so AD5686_REF_BIT_MSK is created. The issue exists
since support for single-channel devices were first introduced.

Fixes: be1b24d24541 ("iio:dac:ad5686: Add AD5691R/AD5692R/AD5693/AD5693R support")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    6 +++---
 drivers/iio/dac/ad5686.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -509,7 +509,7 @@ int ad5686_probe(struct device *dev,
 		break;
 	case AD5686_REGMAP:
 		cmd = AD5686_CMD_INTERNAL_REFER_SETUP;
-		ref_bit_msk = 0;
+		ref_bit_msk = AD5686_REF_BIT_MSK;
 		break;
 	case AD5693_REGMAP:
 		cmd = AD5686_CMD_CONTROL_REG;
@@ -520,9 +520,9 @@ int ad5686_probe(struct device *dev,
 		return -EINVAL;
 	}
 
-	val = (has_external_vref | ref_bit_msk);
+	val = has_external_vref ? ref_bit_msk : 0;
 
-	ret = st->write(st, cmd, 0, !!val);
+	ret = st->write(st, cmd, 0, val);
 	if (ret)
 		return ret;
 
--- a/drivers/iio/dac/ad5686.h
+++ b/drivers/iio/dac/ad5686.h
@@ -46,6 +46,7 @@
 
 #define AD5310_REF_BIT_MSK			BIT(8)
 #define AD5683_REF_BIT_MSK			BIT(12)
+#define AD5686_REF_BIT_MSK			BIT(0)
 #define AD5693_REF_BIT_MSK			BIT(12)
 
 /**


