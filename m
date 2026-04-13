Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E02628505E;
	Mon, 13 Apr 2026 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097556; cv=none; b=LQPnoqi1ZTNhEN26Zb5x4g91RYdQSBe83xXross8sELPN6a6MJjSqarxjdQ7OPAfB5lo7MifAoUURM/iAbk2MGSqMifgHkhLk5q9cPqPCRR/sn5cpKgD7BizvycsWkhyWQeIS//IYmV9yC24UlG0f2m5cbTrnRXGR3cb+vPSab4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097556; c=relaxed/simple;
	bh=OV1WwmUMUvtvtNDag4HT7Qo6nSGDm8J3EoUz9ktHJvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9/I7rhG92bq0qUr0WCx7fsjs2WP4VXupgNcRswTqx/HRyKlIaF83gZk08HCvQYaT5oz/ANIEgg55BgqABbDRf8+zlSAae27NosDpB9Nt/NO6fGrbuCNQ3kKv5/73nt9kPtNMScThLyG8GKe6/QmH3il2b4AwuVGwsFKE+C+Iyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Naq26md0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Naq26md0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F86C2BCB6;
	Mon, 13 Apr 2026 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097556;
	bh=OV1WwmUMUvtvtNDag4HT7Qo6nSGDm8J3EoUz9ktHJvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Naq26md0aJNdAEt6UNI0sihZeS6jcYKAxnMuKwBYRxxvx5nyyr11ED9N1wYWcnxQt
	 Ulf5dKQX9NO9vH4oyW14kGB3/ofhVUtC/ZHCoj79cNkRajHgLCVS3EqLZz4pT1gcUU
	 x7DpwYCbRptOYnInsb9iyt8RkZotBFzktEnC5o6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 182/570] iio: dac: ds4424: reject -128 RAW value
Date: Mon, 13 Apr 2026 17:55:13 +0200
Message-ID: <20260413155837.274727464@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 5187e03b817c26c1c3bcb2645a612ea935c4be89 upstream.

The DS442x DAC uses sign-magnitude encoding, so -128 cannot be represented
in hardware (7-bit magnitude).

Previously, passing -128 resulted in a truncated value that programmed
0mA (magnitude 0) instead of the expected maximum negative current,
effectively failing silently.

Reject -128 to avoid producing the wrong current.

Fixes: d632a2bd8ffc ("iio: dac: ds4422/ds4424 dac driver")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ds4424.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ds4424.c
+++ b/drivers/iio/dac/ds4424.c
@@ -141,7 +141,7 @@ static int ds4424_write_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val < S8_MIN || val > S8_MAX)
+		if (val <= S8_MIN || val > S8_MAX)
 			return -EINVAL;
 
 		if (val > 0) {


