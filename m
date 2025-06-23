Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A37E19E7F9;
	Mon, 23 Jun 2025 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717148; cv=none; b=oONTu3FKa+S/tkrmjDJkd3NnNWTt747ltYzh0pPHUI9IoDa2E+DlR2UCSK7ep06YtsRax5WvjXMMo4X+jqvNKMmDuMdnRlTChS4FV0pIAqzcZudUgXTjWd4UxJ1I1Y7cJKzli8mEB7nW4h6dcuMuniStXXDCmFolIyZfVyIifhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717148; c=relaxed/simple;
	bh=UrcnkYbHLjGdyzFE+xOXeuW0UUEwRo+U19jrWxZVbhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bb1WjJ3w5p971WGgRfEgrbub3J2HTQBDe9WZfeCbgdm71P/ZzTe34uhndnneOPnk7baEvc8IB2enJW+5m8l41QYFrr9L8RA97MvcZ/Il2GHv/vib3k2WKahUBl1knSBlUqDLu41QLk1hT9pdPW4kXNPSQ3FPk1TqbEElNdr3t4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=08PL0eEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="08PL0eEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01336C4CEEA;
	Mon, 23 Jun 2025 22:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717148;
	bh=UrcnkYbHLjGdyzFE+xOXeuW0UUEwRo+U19jrWxZVbhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08PL0eEwNE26IHZ1bgtF7j1rGyNoqUx92Y2oiv1J8VnTJliMfOnonvhOstTI0ao04
	 Gbb6DGlzt2wzEFY8ZxSYlJdGQnhpIBCl2d1qb+GVjeOfYOBZNgyw8TIu0UQLY6Fud4
	 7mag0ULslI84m/EbKKRLm5jqBsSWQyLN/0yrXFuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 372/508] iio: imu: inv_icm42600: Fix temperature calculation
Date: Mon, 23 Jun 2025 15:06:57 +0200
Message-ID: <20250623130654.490657764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit e2f820014239df9360064079ae93f838ff3b7f8c upstream.

>From the documentation:
"offset to be added to <type>[Y]_raw prior toscaling by <type>[Y]_scale"
Offset should be applied before multiplying scale, so divide offset by
scale to make this correct.

Fixes: bc3eb0207fb5 ("iio: imu: inv_icm42600: add temperature sensor support")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20250502-imu-v1-1-129b8391a4e3@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_temp.c
@@ -67,16 +67,18 @@ int inv_icm42600_temp_read_raw(struct ii
 		return IIO_VAL_INT;
 	/*
 	 * T°C = (temp / 132.48) + 25
-	 * Tm°C = 1000 * ((temp * 100 / 13248) + 25)
+	 * Tm°C = 1000 * ((temp / 132.48) + 25)
+	 * Tm°C = 7.548309 * temp + 25000
+	 * Tm°C = (temp + 3312) * 7.548309
 	 * scale: 100000 / 13248 ~= 7.548309
-	 * offset: 25000
+	 * offset: 3312
 	 */
 	case IIO_CHAN_INFO_SCALE:
 		*val = 7;
 		*val2 = 548309;
 		return IIO_VAL_INT_PLUS_MICRO;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = 25000;
+		*val = 3312;
 		return IIO_VAL_INT;
 	default:
 		return -EINVAL;


