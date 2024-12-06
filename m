Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939D21EC013;
	Fri,  6 Dec 2024 15:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498602; cv=none; b=QlMTJnH72F6qnuhX+hho1rG/TSEl+FFb6JWcHCdBijKx5jV5Ifdi9i/vCqJ2Pim3ml4r120PEvKIh5Ko7znM+W0J5pJDJ1hdA6kH4pEHVezET4Qr9jAHbfMrKpA+MDy9yeP13SrkrMKF9SGaXZkiK6BG/88iL/+KlAdYivvRwKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498602; c=relaxed/simple;
	bh=RR7oLPoMhpVF8QdupumwwB57UB2V+3aP0Yr0/QzFnnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=otHa/EMWK+ji8jKnZ16/+X1UgGK7Bb0bUYkVzpAq0UDYgVrZqlIreCAHO+ess9MvxkjmsouvH4T28xJsCWMW9lSDrP+bclL/W4ZZhuyH8GbPgmtLpLUanACt0EBrS/oq5cV1TKHNF48vb9we+DEFQNk3b7FAlcuD0cZZuETN9qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mz4sJqv1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mz4sJqv1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A380CC4CEDE;
	Fri,  6 Dec 2024 15:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498602;
	bh=RR7oLPoMhpVF8QdupumwwB57UB2V+3aP0Yr0/QzFnnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mz4sJqv1qBN1eDRCx6I94kGHX4goS0Yh6rhQe85IBMfWzchkkUkhg6pHLh0Ww4RE0
	 vY2OBx13BqrRfF6J6woT8brr4ih371WAIW6V5ctIXLSAK1m29/4HqIXRaFEOcIXro8
	 p5IMUBeUYG3JdBI2dwuSXEhu0tlcjZTUzWtDRJXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 634/676] ad7780: fix division by zero in ad7780_write_raw()
Date: Fri,  6 Dec 2024 15:37:33 +0100
Message-ID: <20241206143718.135602889@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zicheng Qu <quzicheng@huawei.com>

commit c174b53e95adf2eece2afc56cd9798374919f99a upstream.

In the ad7780_write_raw() , val2 can be zero, which might lead to a
division by zero error in DIV_ROUND_CLOSEST(). The ad7780_write_raw()
is based on iio_info's write_raw. While val is explicitly declared that
can be zero (in read mode), val2 is not specified to be non-zero.

Fixes: 9085daa4abcc ("staging: iio: ad7780: add gain & filter gpio support")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241028142027.1032332-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -152,7 +152,7 @@ static int ad7780_write_raw(struct iio_d
 
 	switch (m) {
 	case IIO_CHAN_INFO_SCALE:
-		if (val != 0)
+		if (val != 0 || val2 == 0)
 			return -EINVAL;
 
 		vref = st->int_vref_mv * 1000000LL;


