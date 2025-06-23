Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC3270838;
	Mon, 23 Jun 2025 21:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715304; cv=none; b=UmmFO0qGCdTpJfFXQsFlZq/PBqQUcyjB9BazB6F9qNI6V+DF32jfJTqyGT/C4t3b3I0Y3gRvNavYLzayRipiZ+RwVQW4X3M7Vcakm/ZFmG93bfUj1UMsVjZXzSHaW8iVIXLn+pJ0T8njojPbjqrtjuN56ghYitw2NDkMErMV0kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715304; c=relaxed/simple;
	bh=Y3y82AIMp2tTpldveY0JMsSUlksqDvmau116+1ts8rI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECbt9z92726kZwvSqYE+mghSYw+LpDVg6wq4ERMrfADnATrGUnojrlJ+kidYxyBmH06f2n7ng2fhcfJSJmZCqLDEjJhqG9TZvPExm47x2/ZBXCmj+NBdsNTgNTU9OtWj9VyG4WZsvrRHDaqjlHVXDzc3M0asvpNLkatpzWdIRgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBvSc/6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBvSc/6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD6FC4CEEA;
	Mon, 23 Jun 2025 21:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715304;
	bh=Y3y82AIMp2tTpldveY0JMsSUlksqDvmau116+1ts8rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBvSc/6W5u2372yCQsafFw3U2lwoEF9oxlblK0aTqhpK5QL+FzdIkxMeXMqn8eDKb
	 Y6s7dDGUUQSBkOS5UkSWFCWw9UqcnA9Ngy2iUU9U1navrP6FgK2t1roNDx1m7BZbKH
	 mIuCXiOcYpnwx0KN83Kyw7ztaT75y5ckuwES6XgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 166/414] iio: adc: ad7606_spi: fix reg write value mask
Date: Mon, 23 Jun 2025 15:05:03 +0200
Message-ID: <20250623130646.183249817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Lechner <dlechner@baylibre.com>

commit 89944d88f8795c6c89b9514cb365998145511cd4 upstream.

Fix incorrect value mask for register write. Register values are 8-bit,
not 9. If this function was called with a value > 0xFF and an even addr,
it would cause writing to the next register.

Fixes: f2a22e1e172f ("iio: adc: ad7606: Add support for software mode for ad7616")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250428-iio-adc-ad7606_spi-fix-write-value-mask-v1-1-a2d5e85a809f@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7606_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7606_spi.c
+++ b/drivers/iio/adc/ad7606_spi.c
@@ -151,7 +151,7 @@ static int ad7606_spi_reg_write(struct a
 	struct spi_device *spi = to_spi_device(st->dev);
 
 	st->d16[0] = cpu_to_be16((st->bops->rd_wr_cmd(addr, 1) << 8) |
-				  (val & 0x1FF));
+				  (val & 0xFF));
 
 	return spi_write(spi, &st->d16[0], sizeof(st->d16[0]));
 }


