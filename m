Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C5F29B8CF;
	Tue, 26 Aug 2025 11:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207172; cv=none; b=hUO61F7T0EWLgWSSAJ/zjdqAo5VC2DJBER28/vpHTilW2CV0evrZYC8s8IMPtRd3nZxHMpo5n0BSnWY5ZvKvtXr7bixN7kT3eDPlNJqkjIME+D0XUCAS/cI+IMdtiEI3fYm8PZ9l4pQGh3192siwAKitDNk1sUAg9LbYxX7K5KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207172; c=relaxed/simple;
	bh=6fZUQk0mlsx73ARX8dyyasMUC8J4gE0TTkO+3TgF1mU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eohx7QmTtPZNeLsMsY1nRgyKhQvJ7lCn2SvoN9MfwfqKXz5w7DmzxgAZNVThAjEIuZGx+2SI+T1mLKMjkfCnK2QBkkgSnibRsBphDhT9ooKXU8/gnkH19Fm1ODcyJGkVnRyQdukA5sE3bihuA0d2WYtR/CQPLCStue3UzrQf9PE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghK0WNgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghK0WNgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45892C4CEF1;
	Tue, 26 Aug 2025 11:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207172;
	bh=6fZUQk0mlsx73ARX8dyyasMUC8J4gE0TTkO+3TgF1mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghK0WNgzx58IvJ+RM0HJkkUoJ3RJtsbGgCjdn4+Qw1NmDkMUGCuCooJb5Bc8/FRmc
	 p9AMatC0UvDpDmRQAYfY5SaUQwGc5QJIIIpj9xn3IAVYJ9Fcrw7DiEpPPzP8T5KEfw
	 m/Yot7VotS58ZQe4/y21F2LP9x4gorHESKhLJR64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.16 077/457] iio: adc: ad7173: fix channels index for syscalib_mode
Date: Tue, 26 Aug 2025 13:06:01 +0200
Message-ID: <20250826110939.278488240@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 0eb8d7b25397330beab8ee62c681975b79f37223 upstream.

Fix the index used to look up the channel when accessing the
syscalib_mode attribute. The address field is a 0-based index (same
as scan_index) that it used to access the channel in the
ad7173_channels array throughout the driver. The channels field, on
the other hand, may not match the address field depending on the
channel configuration specified in the device tree and could result
in an out-of-bounds access.

Fixes: 031bdc8aee01 ("iio: adc: ad7173: add calibration support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250703-iio-adc-ad7173-fix-channels-index-for-syscalib_mode-v1-1-7fdaedb9cac0@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7173.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/adc/ad7173.c
+++ b/drivers/iio/adc/ad7173.c
@@ -319,7 +319,7 @@ static int ad7173_set_syscalib_mode(stru
 {
 	struct ad7173_state *st = iio_priv(indio_dev);
 
-	st->channels[chan->channel].syscalib_mode = mode;
+	st->channels[chan->address].syscalib_mode = mode;
 
 	return 0;
 }
@@ -329,7 +329,7 @@ static int ad7173_get_syscalib_mode(stru
 {
 	struct ad7173_state *st = iio_priv(indio_dev);
 
-	return st->channels[chan->channel].syscalib_mode;
+	return st->channels[chan->address].syscalib_mode;
 }
 
 static ssize_t ad7173_write_syscalib(struct iio_dev *indio_dev,
@@ -348,7 +348,7 @@ static ssize_t ad7173_write_syscalib(str
 	if (!iio_device_claim_direct(indio_dev))
 		return -EBUSY;
 
-	mode = st->channels[chan->channel].syscalib_mode;
+	mode = st->channels[chan->address].syscalib_mode;
 	if (sys_calib) {
 		if (mode == AD7173_SYSCALIB_ZERO_SCALE)
 			ret = ad_sd_calibrate(&st->sd, AD7173_MODE_CAL_SYS_ZERO,


