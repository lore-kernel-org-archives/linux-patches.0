Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1221F560B;
	Tue, 26 Aug 2025 11:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208297; cv=none; b=e/tvIMBOO2v2v3be0FqGsXH3XgqjrgLDFTD0UDIciA4E4P33qE9DDx2xXRcZqAxsbdCEXgUCIeRllIczCecvR073AgnuL5rXWD9z/aqo13hCNx5GGIv7u3s3cQ0HMVQIkYLowJPsrefxOJn1GN+9n4RxP7WkDB5/U9ChY3Q4gvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208297; c=relaxed/simple;
	bh=LFc8AYyrju1/IgjwiQhNebVtER1tFS2hnUK7QDif+5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yc2dZZT67TFz28w6QLdrepAea/i36rYFcxzgChkl3SvtDfTjtUH07PROnCS5427yt9Sn9OjL726woX/+dOAWdoYLxG2ciegmecJ4XRIhu8BeiqmOHshHW0gOK3iHBJilSDD4Kov+efQ0m6POfggjxFkvGGzX4DDR6YjtbskMhfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+0uqLlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+0uqLlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293BDC4CEF1;
	Tue, 26 Aug 2025 11:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208297;
	bh=LFc8AYyrju1/IgjwiQhNebVtER1tFS2hnUK7QDif+5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+0uqLlYsVToES05JcuI+u3Okq+dmZd/zKhmDE3k7foxb+n75RrFnjLo/Yc5R5OME
	 XPnTyhYwAc54F1oN5rRmLGfwEBynB3Xjlgt673Sg+ruM+Qw+cGw9SbPi3haxI6f6LS
	 pgHNzEjWhgdHFimK82rn4pAsvw2AesmtAZHt3ODg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 057/322] iio: adc: ad_sigma_delta: change to buffer predisable
Date: Tue, 26 Aug 2025 13:07:52 +0200
Message-ID: <20250826110916.934801702@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 66d4374d97f85516b5a22418c5e798aed2606dec upstream.

Change the buffer disable callback from postdisable to predisable.
This balances the existing posteanble callback. Using postdisable
with posteanble can be problematic, for example, if update_scan_mode
fails, it would call postdisable without ever having called posteanble,
so the drivers using this would be in an unexpected state when
postdisable was called.

Fixes: af3008485ea0 ("iio:adc: Add common code for ADI Sigma Delta devices")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250703-iio-adc-ad_sigma_delta-buffer-predisable-v1-1-f2ab85138f1f@baylibre.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad_sigma_delta.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -407,7 +407,7 @@ err_unlock:
 	return ret;
 }
 
-static int ad_sd_buffer_postdisable(struct iio_dev *indio_dev)
+static int ad_sd_buffer_predisable(struct iio_dev *indio_dev)
 {
 	struct ad_sigma_delta *sigma_delta = iio_device_get_drvdata(indio_dev);
 
@@ -535,7 +535,7 @@ static bool ad_sd_validate_scan_mask(str
 
 static const struct iio_buffer_setup_ops ad_sd_buffer_setup_ops = {
 	.postenable = &ad_sd_buffer_postenable,
-	.postdisable = &ad_sd_buffer_postdisable,
+	.predisable = &ad_sd_buffer_predisable,
 	.validate_scan_mask = &ad_sd_validate_scan_mask,
 };
 


