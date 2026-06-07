Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C793E2C1595;
	Sun,  7 Jun 2026 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828807; cv=none; b=F7R7bLOpRp0PnRCoVK/AJ8M648rj51hNhmKQ3Hbe7wdntPI7cbpyBVezrqPSgizslB/DxnPGGWhZaWUzUizTyYFq6Dudt0ehKpzNUtjoGeS4fkgMb4yYSgy7QcOus/EMShZ5kIdgGgt21siZ5Jr5uBym/mYj4Po3X1JXb7+4AR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828807; c=relaxed/simple;
	bh=khmswqNUuxK5D5EGX6FUmztPpECWI4JAMG+O0J7ocwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nbem8zUgCstyDkkg/TYep5LyJlw9rwXK4G9XrRBnso+NhZl90kjdde0cP8Ncc6RpdNggNhzPFDtDeHV3+MA4fygbYfkEJ3DL30HHZk6tlvgZXnlljvPubw52/iGCCIaRFsSv9Bh68mWRjQtelUgscNcfj3iFuUEFFiTcPYTfNKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=InA2MWlW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="InA2MWlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251921F00893;
	Sun,  7 Jun 2026 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828806;
	bh=ZpkMURHpiFFOpJLI/HymyUmYFoihZDufHNNjE2zXsGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=InA2MWlWQuB6TWaOUgwyhyIBZ8ytGq9KTGsd5AFapHFeZ/ZqJbDsNlP7FFBmemwy3
	 OdrLH1Lb9Drku7OeJ8I5VaCPsDYw9ShkhRbMfJb0wJNBjQycfY+DEZalQOwzIS1bia
	 1hvvBALI3ERHEb0KpANwNkynr07DDVi67xWW8FVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 170/307] iio: gyro: adis16260: fix division by zero in write_raw
Date: Sun,  7 Jun 2026 11:59:27 +0200
Message-ID: <20260607095733.963670700@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit 761e8b489e6cf166c574034b70637f8a7eadd0ee upstream.

Add a validation check for the sampling frequency value before using it
as a divisor. A user writing zero to the sampling_frequency sysfs
attribute triggers a division by zero in the kernel.

Fixes: 089a41985c6c ("staging: iio: adis16260 digital gyro driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16260.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/gyro/adis16260.c
+++ b/drivers/iio/gyro/adis16260.c
@@ -287,6 +287,9 @@ static int adis16260_write_raw(struct ii
 		addr = adis16260_addresses[chan->scan_index][1];
 		return adis_write_reg_16(adis, addr, val);
 	case IIO_CHAN_INFO_SAMP_FREQ:
+		if (val <= 0)
+			return -EINVAL;
+
 		if (spi_get_device_id(adis->spi)->driver_data)
 			t = 256 / val;
 		else


