Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DD6328255;
	Sun,  7 Jun 2026 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830227; cv=none; b=Qa146jW8vlezrGTYyK63dLfqaCN/++fzlt3S3QtBb73uyS8vlkAYcozTrbA9eZN7ZMysbA/xZJ3nptUKG+tNCY53aHZ4+LRDMYS5gtjIU0OSfva9wV97GToKEU/P01zj9BW5CUhdICK3TrWtM66WX/D3GkbLuYRixWe4wa6aHsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830227; c=relaxed/simple;
	bh=ULb6PU7gaSLsYCpU3CSauHwnOq1Hq5xeBylDsol4/TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiyTjRf8uKfVzLwhn5v2JCKuYVgSUxJfEMdxehiRztINiNA2XutonnUbVsiRFrxjzy6EqLN8HAcapdh9IXXfTWSDE1me8hQaHpn5CQ5tdwJKJZCsdMp7LgyrztyZ28EfMXJNmhU6/6v8E53RXy6Ww7TBrgQOsFQNJ7u3TjKlpNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQ0ox8NN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQ0ox8NN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF481F00893;
	Sun,  7 Jun 2026 11:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830226;
	bh=iqqY82abSEKji7Rl4x6mJFuJeS5TRk8OivVoRst/2hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQ0ox8NNuO7H9SgzaBk5nneKU6MIhui6J2mORKXaRc++kCNO1V3cVnM1dTMiaIIhh
	 x9YBv676p2DfF3xndROBQhiVmhNyj2mZSwdRPftRUcwFc45ChDhXVMtb98NEervlg5
	 CgxM3bJrk/IHqtqXTyu8P6qHsjna/JOKxudIjPTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 292/307] iio: dac: ad5686: fix ref bit initialization for single-channel parts
Date: Sun,  7 Jun 2026 12:01:29 +0200
Message-ID: <20260607095738.467410142@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


