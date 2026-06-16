Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C1647AF6A;
	Tue, 16 Jun 2026 16:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628553; cv=none; b=EGO//U6uBDj+Jqu8JrdgbwYDipM0TFJvHpFyeAVIOHqRfwj6Lf/nrFDC1AqjWPrpMrFSfy02ktHEsXNZdYEoAGoBnXzrcyuWfcrfmDJ+jBt/V5fWrCjKVRJ4iNYTKPEuwt102+8lzUmcR4396QIhBRLHQIO/hVZUZzFp2Lg7bzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628553; c=relaxed/simple;
	bh=Au7X+OZ7kizl+oxjtfSrx6IhKMEPL5Am+B/7Ob4gBUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIkDFBaPj3TGhDhFbAP4ZMzzratRVZ9E/q77EAj8XSV+Y01diQCYaoAfG6vejUTyrzN5mVsh2dzFqWsmaYOtMVvEwUu7FpamrrQSnUvjOBSIT9awXvA217kyFY3mNbdzmw8EMC8OPCEDJ2NI+5RxSyPBV5Zwrkjq7HvPCU8ewYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vg6XHL+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vg6XHL+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EF1F000E9;
	Tue, 16 Jun 2026 16:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628552;
	bh=sX+usLE3wD7rnkuY0PlgrlGTk/rSdQ+ZrAcQxA/Ubsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vg6XHL+vWD8kj5ip0khMvJDE9+xVou1D3ciqCQqKG5AchkciFHoTHIr1kh+y28dto
	 rwgkxo5ELd1KCLDjWrsVL6aGMClME0u5wBLkLrD69yMx3PNrQXyn9UIpBIKaTVpycM
	 VxaqSUSV7VCCXknbNk7XYk8hPkb7Z3eh+RVjsrB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 110/452] iio: dac: ad5686: fix input raw value check
Date: Tue, 16 Jun 2026 20:25:37 +0530
Message-ID: <20260616145123.521163638@linuxfoundation.org>
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


