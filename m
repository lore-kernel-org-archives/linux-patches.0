Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF66A3AA9F3;
	Sat, 17 Oct 2026 16:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256289; cv=none; b=RX7Zp0hgiVINP2d3PG7k42RTyTIEzEpE1ajV+EVrGZ5RxUlsEdbLwour0m+S4CW04Es5lLRsUlns6b89X92S3DTlrsYmfM65FcDodte0Du8SP6Pn4QNVfSN/5+MIc1RRiga/wTTbE3yCrvx34qUo9LIq4gaBi9DQd4nAi8FTQ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256289; c=relaxed/simple;
	bh=k6b5nbPTcZjB+4H71bfsunt8xli9MFW7Jp4Mq1ugbRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdIq5X7VK6jg2gIiJQuonmIijrv35ijw0nHRilvuqMYGHR+Fy3jahAp9fH9IdiiSgya9dm1DH9WQ1eyxjIBpPQkf6Z2IiyL4LRi0KPWMDt0gy2mKnxaCMvcYjw7y3WlhqRKuiyJFFSUhPoX4EG1mv9Wtp74yFAHtkF4XeEfuZyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3w32BKK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3w32BKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283921F000C4;
	Sat, 17 Oct 2026 16:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256288;
	bh=4+e9pq/Xu49p2GWGRQayr2YDpR7782O+YxN+xhZ9xiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u3w32BKKOC7MhcisH/+Ef4xbCEWrES9iCQtUgA6Q+ECZc4JfzAbX/if5+y4ZGT7xc
	 QuJ6VbP9Ij9xzwfNpRXyO61zQtIiVFh51IKUslZ8SRrDXyy4bL8g6SJZC+UBCU85g9
	 9N7ES79MsKhxjup1mLjTzP0DHJ+furJ3EqlSrAvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0187/1674] iio: accel: kionix-kx022a: Fix array boundary check
Date: Sat, 17 Oct 2026 17:40:59 +0200
Message-ID: <20261017160435.953469350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 0e65412aee4f651d2c9785f542a13e4b44002a75 ]

The driver performs a sanity check for an array size, when converting a
register value to an array index. The check incorrectly accepts the
sizeof(array) as a last index, when last valid index should be
sizeof(array) - 1.

Fix the check by bailing out when index >= sizeof(array).

Fixes: 7c1d1677b322 ("iio: accel: Support Kionix/ROHM KX022A accelerometer")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index 220465d9c713f..1f23130a84e5a 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -507,7 +507,7 @@ static int kx022a_read_raw(struct iio_dev *idev,
 		if (ret)
 			return ret;
 
-		if ((regval & KX022A_MASK_ODR) >
+		if ((regval & KX022A_MASK_ODR) >=
 		    ARRAY_SIZE(kx022a_accel_samp_freq_table)) {
 			dev_err(data->dev, "Invalid ODR\n");
 			return -EINVAL;
-- 
2.53.0



