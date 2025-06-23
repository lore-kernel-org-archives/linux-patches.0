Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205AC2528F3;
	Mon, 23 Jun 2025 13:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685006; cv=none; b=O+rHGBTi4fqg3xDFlhL7DSjmVOo7D+v2vYraScvP4SJte1YDa/cLKdlPAXWBjITUS6q7BhEYJfRUdF6CopcmAuMSuf1U6uOBLqmw/2WJXHx3Z1W32zhtCa/2e1liLExziRb1w3UWvM1ud2ZG5kj2PwQ9Ip1JHKUj2sx4M+xADSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685006; c=relaxed/simple;
	bh=zpgVYh3K7PxcNgmpNm77YjyDoEkFWichbOfbu+GQ6lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JcJpxkKFyGieiAlfFlVtIuU/3HS+qk5FI8DW1mG2Hgchgak4bU9OXwUYWmbdDG9gPtDpgAX7/4yHXLy1B1O3pYhz0ddXj64F89Vkmg4Frqr/86pTlntJU4XpPC9UfXmqEC8AYj78dMLfbI1OiNUGESGx7ykNIMifrwvfRDAC9TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPro/KLG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPro/KLG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8ECBC4CEEA;
	Mon, 23 Jun 2025 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685006;
	bh=zpgVYh3K7PxcNgmpNm77YjyDoEkFWichbOfbu+GQ6lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPro/KLGNH9Jy0D9+2cYfaI+BcvisiEqgtEMSA/HZ55vmbpNc8XyqPqrlBdv0nu2q
	 Rc98p/SryI2rTXRNiKqkzBnhvaDx8o5psnd5KmKe7bNFT8rstQjAoA8gUfVgUyFtIK
	 xYK/IqsA/+mH3fEAAf5nNlie8RY3rOn/bPv5wPBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.15 200/592] iio: imu: inv_icm42600: Fix temperature calculation
Date: Mon, 23 Jun 2025 15:02:38 +0200
Message-ID: <20250623130705.047194495@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


