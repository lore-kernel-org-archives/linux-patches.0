Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A461D6AA;
	Wed, 28 Jan 2026 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615958; cv=none; b=Sj2q4Sse3/dcM/b14GleC2npn+DM8XFA8dR02/FI2Fb/NTzpjsU1JKWJv5nd7hxyDdDp63JySzsvXGKzvmAPO8in6uzditiMVDchXCQaXi04D+p4RaT8YBnoStWzytPFh3lb3n4ryNI0tNZGtarFAzvY8jgFeS1IcTdfUsTy/ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615958; c=relaxed/simple;
	bh=To0/PcCE7ai5CZr7QEFT4B3r3v7OQv6j/Yr9cEiMcc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cckGpPhCdQfSG6PfLs00RNwhEZa06m6n6NVMthh3UDiQIaftTA+MkfeF440mhsna0ljQaH7ml0Fqy/x+64ORC0LEWSiFnvppgMySdUpX8/NaPvSIbkTmpq5yfLW/T0ti+HTEIi20wN0EiN/cBSklY5jVSAeL34g8SFVqSAtnPIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0OOdlz/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0OOdlz/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47246C4CEF1;
	Wed, 28 Jan 2026 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615957;
	bh=To0/PcCE7ai5CZr7QEFT4B3r3v7OQv6j/Yr9cEiMcc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OOdlz/a4lwefXsGIA9BK4T96nWq1DL4b67G3M15isGUMNyPaqrv68HXEng2DMXIz
	 RomXjLaFdVuHDjWaFsWcuctAjfW7zY8s44l3P7ayxGhIpOU/NSe+PURlbwa4UmpDKd
	 gDqSGB1EKKCUQpOjIbaVIKZUzAgUWX3D/revvhZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Klute <fiona.klute@gmx.de>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 163/227] iio: chemical: scd4x: fix reported channel endianness
Date: Wed, 28 Jan 2026 16:23:28 +0100
Message-ID: <20260128145350.318497224@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
@@ -584,7 +584,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -599,7 +599,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 	{
@@ -612,7 +612,7 @@ static const struct iio_chan_spec scd4x_
 			.sign = 'u',
 			.realbits = 16,
 			.storagebits = 16,
-			.endianness = IIO_BE,
+			.endianness = IIO_CPU,
 		},
 	},
 };


