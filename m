Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565F8478E26;
	Tue, 16 Jun 2026 17:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630287; cv=none; b=Runk6+HXTRh/S83wBil1n5YUmtIxaZKHnphUdqMVWjv6Zu/kYhbsdZOTWOJuX+Ld8Eliieen1iXF5kjARSuSEcezGkcM1/wP6KdhlGP6/klMGa7RwNZCXfnlvmP/LZP3NCYjwQsuM2KuvwfjTQtUmhJEafXXG0ceX2jxPQQI1Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630287; c=relaxed/simple;
	bh=XS2tOolMX9TStf7mNPTAeMfu575DklSxdb0XnXQX9/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWr6CBFk0qX7Agr7RTdHvKo1Q8WOmd7eGgR+zNSlLaZqD+dSGivNPvuitrSXrtePaSwpJADHjWvSMFKSkeg8C9PX5ZBYoQtuLInaO7FUh3BvqRFSXmcCiEf/MCh9PTGL7ciGrnoj38T3RT4qRBc3nFzYHqFXXwvqTSB17HVbqeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RYDQ9y58; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RYDQ9y58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AA1F1F000E9;
	Tue, 16 Jun 2026 17:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630286;
	bh=IB13Oh8qjHUOLRdxTPc9QBrMahqnZs4fOjEbPR00tts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RYDQ9y58lUIE2TZQprm30RCMcAfcO9Y4nkVCXVXFdjxI5Tln9rCCWPjA1m1pto+PJ
	 Gtcm5n1dFjIF6ziN/PXCY19puQ5NulstBSVbjH1hOFOTTxEnlIx+3Yg+687PipYeEA
	 ir5/pTc9ogKBj02dkbhnxRsyPYZg3Ox0FuJRbiaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 413/452] iio: dac: ad5686: fix ref bit initialization for single-channel parts
Date: Tue, 16 Jun 2026 20:30:40 +0530
Message-ID: <20260616145138.479909371@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
@@ -528,7 +528,7 @@ int ad5686_probe(struct device *dev,
 		break;
 	case AD5686_REGMAP:
 		cmd = AD5686_CMD_INTERNAL_REFER_SETUP;
-		ref_bit_msk = 0;
+		ref_bit_msk = AD5686_REF_BIT_MSK;
 		break;
 	case AD5693_REGMAP:
 		cmd = AD5686_CMD_CONTROL_REG;
@@ -540,9 +540,9 @@ int ad5686_probe(struct device *dev,
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
@@ -46,6 +46,7 @@
 
 #define AD5310_REF_BIT_MSK			BIT(8)
 #define AD5683_REF_BIT_MSK			BIT(12)
+#define AD5686_REF_BIT_MSK			BIT(0)
 #define AD5693_REF_BIT_MSK			BIT(12)
 
 /**


