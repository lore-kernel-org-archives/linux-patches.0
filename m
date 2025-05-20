Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441D9253F25;
	Tue, 20 May 2025 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750470; cv=none; b=qO6E43JWESISEAOYK5xyxWw0qKd0wa4xHwCOZ2pt+fqNQRbVVSix1b/2z5IaCyBlfDs/4BxJoTDpi5/PscFHa9oXerEKC63J4auHCLFGJs7jMG98dcGWBMb9VoUGpdJEInlBrAgGCiDx0BiEtFZlBxwksbXTAGVOLT1h4ufPjTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750470; c=relaxed/simple;
	bh=3pXymaAZX/YIEUkfApLWcZaimpsgjdmT3DQEI3H3qVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S2AU+aQDj4rGpANle1gK9xzcN9OtnXIIApdkuEegX2CT5pvy706NRNh03AYtz7Jiz0EdUNagUwoxfvhJbZVmxfzTZMmWUCIihQQisqPBPAgCqbKt0OKo7QdBmfuFw5ggaXqucRIL4Gd/OVUdKs2n0VJ2AJJFGC3NvtqCRCVHiw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2tI+93w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2tI+93w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78EA1C4CEE9;
	Tue, 20 May 2025 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750470;
	bh=3pXymaAZX/YIEUkfApLWcZaimpsgjdmT3DQEI3H3qVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e2tI+93wfUTEFSl24u/J64llOFCcjBaPrDUBfWxxDyfOHreX+qpoimIBGvwhRv2VU
	 QocCx9mC5L3OONOCgMALLnYG0XIE2IW+lCYC7g9k4ASJ76AViCeYz4irB+ZXaKfA1T
	 uXkQgOQaSABmg0G52U999pvCX7MlvKuVsVaoQ658=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 019/145] iio: adc: ad7606: check for NULL before calling sw_mode_config()
Date: Tue, 20 May 2025 15:49:49 +0200
Message-ID: <20250520125811.306905853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 5257d80e22bf27009d6742e4c174f42cfe54e425 ]

Check that the sw_mode_config function pointer is not NULL before
calling it. Not all buses define this callback, which resulted in a NULL
pointer dereference.

Fixes: e571c1902116 ("iio: adc: ad7606: move scale_setup as function pointer on chip-info")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250318-iio-adc-ad7606-improvements-v2-1-4b605427774c@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index 7985570ed1521..0339e27f92c32 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -1228,9 +1228,11 @@ static int ad7616_sw_mode_setup(struct iio_dev *indio_dev)
 	st->write_scale = ad7616_write_scale_sw;
 	st->write_os = &ad7616_write_os_sw;
 
-	ret = st->bops->sw_mode_config(indio_dev);
-	if (ret)
-		return ret;
+	if (st->bops->sw_mode_config) {
+		ret = st->bops->sw_mode_config(indio_dev);
+		if (ret)
+			return ret;
+	}
 
 	/* Activate Burst mode and SEQEN MODE */
 	return ad7606_write_mask(st, AD7616_CONFIGURATION_REGISTER,
@@ -1261,6 +1263,9 @@ static int ad7606b_sw_mode_setup(struct iio_dev *indio_dev)
 	st->write_scale = ad7606_write_scale_sw;
 	st->write_os = &ad7606_write_os_sw;
 
+	if (!st->bops->sw_mode_config)
+		return 0;
+
 	return st->bops->sw_mode_config(indio_dev);
 }
 
-- 
2.39.5



