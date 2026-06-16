Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7984779B3;
	Tue, 16 Jun 2026 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632721; cv=none; b=itl6i3tNlcQQIDkeEb+RabWkTaCr8N03+N8Jp/5W+rpI0S6/e2m37G+2h0ueFGfdMiGW6T8BxRqCANsjk8bj9sG69CUs8yTVfbBL3fwweqkDlO78MQpUq8Xy5WYwV4u6L5uBpSonwC0mcCp4lIXUjho12Yw5VjdWHCVFCUdGzE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632721; c=relaxed/simple;
	bh=8DPsm2KQgjAbDn1stmeVD9W6j0GIyTTGpO+YnnM/z5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaX0RMSt7OnleW0QXdFkr0qNcA7rhWz+wvSKU1fIk2zPcszx/yjKAujMtIizG0GT0XSDHXRHz+T/03ONLiIZtZcOe2lgC+LF20KffGTtBuct/NZKhE7bwq43KbT2g2x2KYTahXClUEg88kvgbHIW86sURg2zYQPILDZngDoe5KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XeLf8T2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XeLf8T2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825971F000E9;
	Tue, 16 Jun 2026 17:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632720;
	bh=WFjF7PBRCJh5pSuJNh8BsWLAduqPdPWF7r4y7UPKXOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XeLf8T2FJ8jdMhdNDS2NPYOXabwDD/fNgxZoaCfeTXrBhJ1vvQnXHtD13XrpdPko/
	 0XuTRMXQY/5pIG+0W1ut1Emh4wjMQrK21Bx3IKssHpnuUpS8DMtqJaXV48TUXOMteV
	 J3T2lhGXEulLX+9jWUNcsTxUpw7bZR3E26VW72N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 464/522] iio: dac: ad5686: fix ref bit initialization for single-channel parts
Date: Tue, 16 Jun 2026 20:30:11 +0530
Message-ID: <20260616145147.585395262@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
@@ -521,7 +521,7 @@ int ad5686_probe(struct device *dev,
 		break;
 	case AD5686_REGMAP:
 		cmd = AD5686_CMD_INTERNAL_REFER_SETUP;
-		ref_bit_msk = 0;
+		ref_bit_msk = AD5686_REF_BIT_MSK;
 		break;
 	case AD5693_REGMAP:
 		cmd = AD5686_CMD_CONTROL_REG;
@@ -533,9 +533,9 @@ int ad5686_probe(struct device *dev,
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


