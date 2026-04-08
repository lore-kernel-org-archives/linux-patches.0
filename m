Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310363D6CA2;
	Wed,  8 Apr 2026 18:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673395; cv=none; b=lbuGs5sS1SN9WJkU4jwNtktr3U4nHJ8N/0pc6NqEvljkNQPJ6SGebz6ZALpSXspwu/lnhVzAJ+Kq66bS1XjW+A5IcUcGqlh79/J16HYMoCK9dFLjWMfRWABoGFrsoZ/WPBH76hsUmQEAsaRv2J3aL0Z6nsWU+wRUjs3YCpQtKBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673395; c=relaxed/simple;
	bh=qcn5M1ICZHCcfWKBSn111NoSDeYccj+Yy3UjW23l90g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ6XuE9CBVVjTSjkciif2+qbFMIuR8phxjNAUZUGhvIxmYpis3MwqimOnniNNQUQl8CR5jBGUiMZ9oQzV6nYkkobHgFVQMsWmhNU8QGxcfWOINEUoviewNBqgtfo5ergviZ0yJSmT+wdHQzB9q6gWBR3nCdpJzXh4OzNGjdjLPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcrgc50o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcrgc50o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B98E2C19421;
	Wed,  8 Apr 2026 18:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673395;
	bh=qcn5M1ICZHCcfWKBSn111NoSDeYccj+Yy3UjW23l90g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcrgc50o0lQEC9/0fpCjsrqppTZiPBK2J3vgyUDBzOk8qzyvfjQh8DJ+T9yMIknEQ
	 axl0wRpT35IwuD9AEI2nMSLU0Vf5y8A8tkM2xlvbI8bkBZHtMk5CphfoZ+yhPCHRiW
	 OJ849H/O6uoGMMgdOVTyyJQwAFhw00/H53ooQ7Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 183/277] iio: accel: adxl380: fix FIFO watermark bit 8 always written as 0
Date: Wed,  8 Apr 2026 20:02:48 +0200
Message-ID: <20260408175940.696201157@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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
@@ -888,7 +888,7 @@ static int adxl380_set_fifo_samples(stru
 	ret = regmap_update_bits(st->regmap, ADXL380_FIFO_CONFIG_0_REG,
 				 ADXL380_FIFO_SAMPLES_8_MSK,
 				 FIELD_PREP(ADXL380_FIFO_SAMPLES_8_MSK,
-					    (fifo_samples & BIT(8))));
+					    !!(fifo_samples & BIT(8))));
 	if (ret)
 		return ret;
 


