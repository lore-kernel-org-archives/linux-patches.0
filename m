Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E06E477E57;
	Tue, 16 Jun 2026 17:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631008; cv=none; b=T3qOBx5SblNtfq7LlXObzdvV1xI1S2YkAs3Dl2VotPI/2y2AdM18IHH3IfKXSUAdLrSRmqBtsw1IbqXeXDn7auC/Ch8Du3Xyp/aZBgxoCtjl1aRmte5jE2AZ89Bx5MuSwmmSHWFFWlHlpieWoAjfufbbIb/ei4z2UIwkwXjz9Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631008; c=relaxed/simple;
	bh=54knzH0eh9rjHQJ98P2Iuajpiqy5aU6nOAYOPkEoNSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZ6QoY8/SIbvEyHsqB/IvfOgetN85fL7oyyPVzHjh9RHk1nmYKKwmTinKDQY7ao0IgPv6dDgVdp3/LW3iGclRfzf9aO2Q0J3R232ePFOb34gEupHLx01F955FWptdRrk4YLCZvjXEzpnP7bB1PFpYCizaJctH6HYRFhErcjekEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tUC9x9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tUC9x9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579CD1F000E9;
	Tue, 16 Jun 2026 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631007;
	bh=5gr1LMWWy2LZxmhKtlTYgVhx3PyexkxRgCn1M8IB+pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tUC9x9GlDdRGRTOWIgw6txn7k5fSge+64gHlKtDPmueg8FEyDiFh8srxE9bn7D8v
	 BtD5HqpFlKukQWutyEB2iR14klpg3yOKzta9CKCYSD7faYdkOjPakNAQGV31CozS1t
	 RdqZY1KWCdiooOQ/lDDvnK3yBAJFtbaQdpDdKWRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Rodrigo Alencar <rodrigo.alencar@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 105/522] iio: dac: ad5686: fix input raw value check
Date: Tue, 16 Jun 2026 20:24:12 +0530
Message-ID: <20260616145130.850341647@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Alencar <rodrigo.alencar@analog.com>

commit d01220ee5e43c65a206df827b39bf5cf5f7b9dce upstream.

Fix range check for input raw value, which is off by one, i.e., for a
10-bit DAC the max valid value is 1023, but 1 << 10 equals 1024, which
passes the previous check, allowing an out-of-range write. The issue
exists since the ad5686 driver was first introduced.

Fixes: c2f37c8dcadc ("iio: dac: New driver for AD5686R, AD5685R, AD5684R Digital to analog converters")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Rodrigo Alencar <rodrigo.alencar@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5686.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5686.c
+++ b/drivers/iio/dac/ad5686.c
@@ -154,7 +154,7 @@ static int ad5686_write_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
-		if (val > (1 << chan->scan_type.realbits) || val < 0)
+		if (val >= (1 << chan->scan_type.realbits) || val < 0)
 			return -EINVAL;
 
 		mutex_lock(&st->lock);


