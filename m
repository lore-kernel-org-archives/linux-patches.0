Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11A870808;
	Sun,  7 Jun 2026 10:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828933; cv=none; b=HkqXC81RkoK8Y35D/nQ0z3MPcGfBAVLGfSvVRJsmwOO6oGBVjUVp984R1BE1xp84kwg4v4g5UPJ+PRf6ktM+eQ5+AMkTxy/KH/9qAUQaPRTIavkavWNuS450JASzndcb7p2zeIlRCDFW1ET1dSc8s0qfFCSg82xC5Ivun8drBcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828933; c=relaxed/simple;
	bh=HIeOps/rWuzordl0sussBK+TPoepsW2/GvELsJtQKKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr3/JjZkoaUVRxasGgKYtx5SjbbN41qkcaLvIiNKAlf+dWrs7dJxYOh39g2rLdrZ+yzbA6tgQs+qx8KuABlzOGhRnxIDlz3qRfUErTX/GntUQ0L0AJj1vCjZJJyeSKEjcScqQGt1mMZQDCUOxplz1F6Gt38ZMpBXdQDqUZa71h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uF2LNimQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uF2LNimQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8FF1F00893;
	Sun,  7 Jun 2026 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828932;
	bh=ztDHy9ITVWAmAi12MGk9w8eKu7si1YgM8U8kr2r7/PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uF2LNimQS5D1spQKxAJyZbbMJghtFMYm7QgPucbGswW25oUtfdVX/Zrhvk87PTr/m
	 banAvNtDkk/w+aZCIYU8T/rb/z30qsc/oi44LsVQ/6o+s92xAEONhCED7mk3P1z7Xd
	 WC1lm4VkGq0r4mfbObZ92dzdYD6Qlc014oNvgkQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 165/307] iio: dac: ad5686: fix input raw value check
Date: Sun,  7 Jun 2026 11:59:22 +0200
Message-ID: <20260607095733.782762722@linuxfoundation.org>
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


