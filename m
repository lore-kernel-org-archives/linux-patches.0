Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92350257855;
	Sun,  7 Jun 2026 10:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828431; cv=none; b=pHrKxOxPxmSwydOWQT7m/Xsvw8MDMnaeHvdYr5VH8bNOakJWVE8WiS8ObNSrrLja7wakhpFlM5aLqJ9FimiPuVhxBXoCjarCZ1FLF9uEWAED4YDbKjwU1Uj/sKRBo9kZOtakEY55WMmfgxL8R12hrtzWL6dVx2E+bdMsjPr6EdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828431; c=relaxed/simple;
	bh=C57uckOobXnrXuBTRvVjuqPdkV8OrwebG0HyfFOkRjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBLALB5IVtiRLOTDNLprOqZUKrGdYrBE1QahejNJYoSXEbcIIE+cLCLAwymIdauyLV+ouifkwkv6Vdfse7Bn0f29IcNsA3XYyzoNmjU84+yJ49Z5yarBGP0e7zzTwiB/FV4WxoCVyKR20QgTOFYo2WTHOnw8cbRyGDsIvvpJvG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jy+aUTz6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy+aUTz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C281F00893;
	Sun,  7 Jun 2026 10:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828430;
	bh=Di/2+4vIGzdRtOcaV2hxGNZxxwDIwhj7PdL21MmMTZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jy+aUTz65gOp9Zb2+ejuYVpcGiyvIaHNDRLjnbHTRNYneRR08nfrLKwmXxAS22h8N
	 My8Q2OJ3Ea64coqXM916mVrkvPL6cW0OXUo/kPYz+tWrtFL2FC3bfLTr26HbsioN2E
	 jyh/XKJVsWNjETG9DFcR/dvh3aF4Y7xTbwryLfwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 158/315] iio: dac: ad5686: fix input raw value check
Date: Sun,  7 Jun 2026 11:59:05 +0200
Message-ID: <20260607095733.398615994@linuxfoundation.org>
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

commit d01220ee5e43c65a206df827b39bf5cf5f7b9dce upstream.

Fix range check for input raw value, which is off by one, i.e., for a
10-bit DAC the max valid value is 1023, but 1 << 10 equals 1024, which
passes the previous check, allowing an out-of-range write. The issue
exists since the ad5686 driver was first introduced.

Fixes: c2f37c8dcadc ("iio: dac: New driver for AD5686R, AD5685R, AD5684R Digital to analog converters")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -154,7 +154,7 @@ static int ad5686_write_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val > (1 << chan->scan_type.realbits) || val < 0)
+		if (val >= (1 << chan->scan_type.realbits) || val < 0)
 			return -EINVAL;
 
 		mutex_lock(&st->lock);


