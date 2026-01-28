Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E659238159;
	Wed, 28 Jan 2026 15:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615207; cv=none; b=mPPFBMVuUHyzCXXtYBOnuCsOz+C7Bz7iWgqPV3bF5IvSVqm0WHEivGCFVhvHTiWybpKIhaU5V2jsnS29FAIKNGt7ieNeG2PerOWEEUNQON52b/eCTBdcBdKp6lh+mfjLet316PI7/Eo0awQ7pDB40ZHA64HVd7KsJ/vVfnTiiU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615207; c=relaxed/simple;
	bh=c3FHJSznmNKq97ASJr6A5fawZvLWDjXyFNL8Qqwxruk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFWhrhuW7OmCo1AcE26aKSJjylUd7le1t93T7PtgtkvyQ+rP+dCCSCkYBkCuO8rbl73ArOJ9drOYbx+ZfKFtRi1ISxfW25vEu8aGSVZSkMaf+Hrj7f5frDMwdfYNJoyPvyzkT1/aKa+VH70QW4Z0bXALCTbXWLIJGRxUSRm70lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKxFol6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKxFol6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE742C4CEF1;
	Wed, 28 Jan 2026 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615207;
	bh=c3FHJSznmNKq97ASJr6A5fawZvLWDjXyFNL8Qqwxruk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKxFol6EUOAOp2XLbzSHMScOO7WLWf+mRuslxr9my1z+DVO2rgJ5dGTS+ml+gOZwo
	 aUVlW/XWovNa6gPN4wPMBzS+ZJAcc06Ez4Y0v3ZJi2xl1cM8CvRSZImaJMDcARfiLO
	 TU4lNCfA2oiz1Y7uKiXlE7MuKPRdn4FEkSxnTYk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 109/169] iio: chemical: scd4x: fix reported channel endianness
Date: Wed, 28 Jan 2026 16:23:12 +0100
Message-ID: <20260128145337.930027016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Fiona Klute <fiona.klute@gmx.de>

commit 81d5a5366d3c20203fb9d7345e1aa46d668445a2 upstream.

The driver converts values read from the sensor from BE to CPU
endianness in scd4x_read_meas(). The result is then pushed into the
buffer in scd4x_trigger_handler(), so on LE architectures parsing the
buffer using the reported BE type gave wrong results.

scd4x_read_raw() which provides sysfs *_raw values is not affected, it
used the values returned by scd4x_read_meas() without further
conversion.

Fixes: 49d22b695cbb6 ("drivers: iio: chemical: Add support for Sensirion SCD4x CO2 sensor")
Signed-off-by: Fiona Klute <fiona.klute@gmx.de>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd4x.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/chemical/scd4x.c
+++ b/drivers/iio/chemical/scd4x.c
@@ -585,7 +585,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -600,7 +600,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -613,7 +613,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


