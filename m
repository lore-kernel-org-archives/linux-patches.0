Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F6146AF3C;
	Tue, 16 Jun 2026 18:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635152; cv=none; b=FeKbeNsdFPKOux/ajmJa7cjFkzbM2c3ZGL8UzhN+StMaBR5s9VQVTqQ2CGFtV0KXOjQ7Rq8YfGFLfLLwU4bm2BaCnk7u38UwapKLMtiPmwo+c4eHVrS89PfpX0ug1Z6J3qs4kAIdszWQ68CW/Itw+L6PMY/FECdjltJAHhvcdCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635152; c=relaxed/simple;
	bh=7EKvgTa8IBexcidKWNcWcrcXCdvB3Tem1xBGhfmhcR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lW2O0RgvbkB6JAzQztT4BibtKc1DWwiq60L8vsAO/iggQ0z1LcfYcCN3hsyeGWRW1E+KVlZN2fd/RxKcOpzv5Ordn9IWWhiQIi2+jQiPbkVpY1R0aOa5KNxvyWJ4PhOEs4OawOKcknClHkiSBquwWKA4AX9+WMtcX6ab4UU595Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2I727+p/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2I727+p/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7B61F000E9;
	Tue, 16 Jun 2026 18:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635151;
	bh=ioCV9p3+DfeXoBnKtjG77+UcF3C61T+TdV6ttjolBcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2I727+p/Loh3mGS9kqQanJ23uoxyYFlYmRMeMnP4bbc6RB519pTyIiv4uCg5LUz8X
	 wvV3h+KqMA8SYtgSwCeuTJrtZmXOtyMG3vq3+yWm+kuyNl3/wewsRDYEVpnNvjpHsB
	 gz1djnd2fKFFSf7InT1cpEuawU/MSG4KUnrQt6cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 367/411] iio: dac: ad5686: fix ref bit initialization for single-channel parts
Date: Tue, 16 Jun 2026 20:30:05 +0530
Message-ID: <20260616145120.837321488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

[ Upstream commit ecae2ae606d493cf11457946436335bd0e726663 ]

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
[ adapted `has_external_vref` to the in-tree equivalent `voltage_uv` variable in the `val =` computation ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    6 +++---
 drivers/iio/dac/ad5686.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -513,7 +513,7 @@ int ad5686_probe(struct device *dev,
 		break;
 	case AD5686_REGMAP:
 		cmd = AD5686_CMD_INTERNAL_REFER_SETUP;
-		ref_bit_msk = 0;
+		ref_bit_msk = AD5686_REF_BIT_MSK;
 		break;
 	case AD5693_REGMAP:
 		cmd = AD5686_CMD_CONTROL_REG;
@@ -525,9 +525,9 @@ int ad5686_probe(struct device *dev,
 		goto error_disable_reg;
 	}
 
-	val = (voltage_uv | ref_bit_msk);
+	val = voltage_uv ? ref_bit_msk : 0;
 
-	ret = st->write(st, cmd, 0, !!val);
+	ret = st->write(st, cmd, 0, val);
 	if (ret)
 		goto error_disable_reg;
 
--- a/drivers/iio/dac/ad5686.h
+++ b/drivers/iio/dac/ad5686.h
@@ -44,6 +44,7 @@
 
 #define AD5310_REF_BIT_MSK			BIT(8)
 #define AD5683_REF_BIT_MSK			BIT(12)
+#define AD5686_REF_BIT_MSK			BIT(0)
 #define AD5693_REF_BIT_MSK			BIT(12)
 
 /**


