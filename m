Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688D02550B2;
	Tue, 29 Apr 2025 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950213; cv=none; b=M7P5aTGuA471RjZUk8SduGMRek2umT3okpW7Z2R+ll+Kf45BuSsSIAs1zJz4w/2biLRCGcqK+d9PuV0p1VMlLI3466oEop8wKSWUo8td1I69g5Bo1wYcS1afQ/pcOvmVnbHjGrXivz0NXHSn5XAes1BROMq2D505wHrbKKPMPeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950213; c=relaxed/simple;
	bh=1XfVTePV+ihRNiSH9/El/Psu6AdCkvl2pLU11weC+FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qbr9oHa9DB6uq2iNzJk2X54gfi8a2HC8WIZ5YogECVIcdSeoNPw6sK3yf+ebkpmACkWlUEdKBmtpHO6HyC+uxN93gZLtnvTG5WORwA+OE0oq3KRltQB2AGNvF+vrt9JB+ojObhqngKwAw/dp6uYYkDVy1/lenPHTNbzzyjSbFuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qO9ff8G/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qO9ff8G/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAECFC4CEEE;
	Tue, 29 Apr 2025 18:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950213;
	bh=1XfVTePV+ihRNiSH9/El/Psu6AdCkvl2pLU11weC+FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qO9ff8G/m8D9+E3nNDWEjmV9jgFhQ5iXCTSzZXKVuh6+25p9+GJObHnlTDHchFlHH
	 REwgOvhlvZaIuiNAtm/qoFMhW44jGByCR3ByX2nCK3C9O9WCk0Fj7UN4I09J6pfQiW
	 lICzEDf5ASZNe7DMKErhpUMzqmuvox+X37hnvJFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/204] iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check
Date: Tue, 29 Apr 2025 18:41:51 +0200
Message-ID: <20250429161100.372522234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 0af1c801a15225304a6328258efbf2bee245c654 ]

The data used is all in local variables so there is no advantage
in setting *val = ret with the direct mode claim held.
Move it later to after error check.

Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250217141630.897334-13-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8236644f5ecb ("iio: adc: ad7768-1: Fix conversion result sign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 70a25949142c0..19d604f5701d6 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -370,12 +370,11 @@ static int ad7768_read_raw(struct iio_dev *indio_dev,
 			return ret;
 
 		ret = ad7768_scan_direct(indio_dev);
-		if (ret >= 0)
-			*val = ret;
 
 		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
+		*val = ret;
 
 		return IIO_VAL_INT;
 
-- 
2.39.5



