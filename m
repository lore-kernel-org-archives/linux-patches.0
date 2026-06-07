Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881592D3A69;
	Sun,  7 Jun 2026 10:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828575; cv=none; b=rvA1G5QAjHj+p9zVCB0QncX/Q4U/+napAFPcVEpwqgLfG3fuICMCAq+o6UiRplbqJeHj1bLbfLcTwMipKUglbFg3D+yAo+SP7DrVdCVJ5tONcVowJFGZmz66lZ4rMNkS5PCe4mE0EBVLugUpZ6JChASSDkmBce7IS4lK52Mod/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828575; c=relaxed/simple;
	bh=ZKT4kSsdRfDd+Pe7X4wHESU+sIq3YsPTOIthWMIEII0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idRCdPcR02XE4kdEP4hT+la7slEZHu7ENlZOzOEy5po3ogq0WpyzTFwT+U0SFJvsWsdSaipjGyM3oOvgkrEfqHoongHxHGgyoF1KmkJff4cWYaJrZasIiOMYMft8QU/QTv+CkIpaL4hvDmhY0anQo/hyDHT+m5yT9o/eTaAju+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WNtmPsHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WNtmPsHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C196A1F00893;
	Sun,  7 Jun 2026 10:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828574;
	bh=BVcr8vnjU5eklYHUW8VRvKsjqbjULtxYt/D6fs3iOLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WNtmPsHXHlhRLpq5Dt/oL342NRQy/pDqQFNi6RlrHJNLMvnzI7LvmMZDbyqHSC+7c
	 QMzFkXfHfLHy/VlHB8mtaNQMShWpV/PPCufHDsKnk1y52ACVtdKs6lHE3vzicqR2Jf
	 s8ed7mQpbyqzZf/02d8i675Xs611d4XCBlg5VEnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 194/332] iio: Fix iio_multiply_value use in iio_read_channel_processed_scale
Date: Sun,  7 Jun 2026 11:59:23 +0200
Message-ID: <20260607095735.186250735@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

commit bb21ee31f5753a7972148798fd7dfb841dd33bdb upstream.

The function iio_multiply_value returns IIO_VAL_INT (1) on success or a
negative error number on failure, while iio_read_channel_processed_scale
should return an error code or 0. This creates a situation where the
expected result is treated as an error. Fix this by checking the
iio_multiply_value result separately, instead of passing it as a return
value.

Fixes: 05f958d003c9 ("iio: Improve iio_read_channel_processed_scale() precision")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -738,7 +738,11 @@ int iio_read_channel_processed_scale(str
 		if (ret < 0)
 			return ret;
 
-		return iio_multiply_value(val, scale, ret, pval, pval2);
+		ret = iio_multiply_value(val, scale, ret, pval, pval2);
+		if (ret < 0)
+			return ret;
+
+		return 0;
 	} else {
 		ret = iio_channel_read(chan, val, NULL, IIO_CHAN_INFO_RAW);
 		if (ret < 0)


