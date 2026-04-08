Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E6437F8AC;
	Wed,  8 Apr 2026 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674757; cv=none; b=Ugrse1vEf0SFlb3Pdjwv49VT3eWgm7UU9Fy43ZZ8ZEXBdMmDl2zChcRj3QPIrzqvKQR224ZCRXDQZD2mXCtrdIsEMATyhqfXNfIFLcPvZWJ78u0buQhum1cWxTaRcJiHe6mWyGUNgShxS2MSoBxJF+8zR7J93CuRujfKcXDAWpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674757; c=relaxed/simple;
	bh=shuQ5X/lLsaD55D9/FDu4iM7Kywo77mfASXowwECM7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFRomd13qUTzX3NHWuHn/s6sdK1p9FJnY0ali2gwCa/HwtvTAFcqx4Qs4v88PhFpJEzJRdR2wd83zxBTxT+0NgEmQUFhLr9VzFXol3rVFKTZO1bZJhi6c4+atHBz23+rxm5k7kMexkihy8eFCPUwjcrb/HR86dx7YacUkiSsvVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVpwa/9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVpwa/9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFEBC19421;
	Wed,  8 Apr 2026 18:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674757;
	bh=shuQ5X/lLsaD55D9/FDu4iM7Kywo77mfASXowwECM7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVpwa/9JdzrIA9+nGGDVfyjmVyxrExUMDUf/QIlssfUO9yeewp2PZ3Kw+7gM2QXQg
	 +jToNk0pBoADHazhyFprrQzF7DjtcBEvk01Qz+1cz6gFkoIw78MTZyo14Sez+wJjPe
	 i4pUDMikrjPL2mePmfWKVArUBUFL5vDaXHPswO9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 222/311] iio: accel: adxl380: fix FIFO watermark bit 8 always written as 0
Date: Wed,  8 Apr 2026 20:03:42 +0200
Message-ID: <20260408175947.691256415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit bd66aa1c8b8cabf459064a46d3430a5ec5138418 upstream.

FIELD_PREP(BIT(0), fifo_samples & BIT(8)) produces either 0 or 256,
and since FIELD_PREP masks to bit 0, 256 & 1 evaluates to 0. Use !!
to convert the result to a proper 0-or-1 value.

Fixes: df36de13677a ("iio: accel: add ADXL380 driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/accel/adxl380.c
+++ b/drivers/iio/accel/adxl380.c
@@ -860,7 +860,7 @@ static int adxl380_set_fifo_samples(stru
 	ret = regmap_update_bits(st->regmap, ADXL380_FIFO_CONFIG_0_REG,
 				 ADXL380_FIFO_SAMPLES_8_MSK,
 				 FIELD_PREP(ADXL380_FIFO_SAMPLES_8_MSK,
-					    (fifo_samples & BIT(8))));
+					    !!(fifo_samples & BIT(8))));
 	if (ret)
 		return ret;
 


