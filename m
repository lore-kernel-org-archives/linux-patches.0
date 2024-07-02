Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBE61BE226;
	Tue,  2 Jul 2024 17:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940809; cv=none; b=hx+e1b3crV2P+wOQx57kv2e4tmfX6AdxRwJ2VvS3Cy16D1IAl6laj6uz3HMB5FuEiXK1i+a/hZUeVwTUloZohGHK1n8PRiLprjsAiLCURpISFePq0d0ue9bdHi/Ak1UHW9sHsO5HP0zq7Y4VFegitalvUCwgve4MfUaYpG0KrVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940809; c=relaxed/simple;
	bh=fAUg+VBC1tjeQ5LW4U44yTs49HE3HhJj4juoC29jQPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGZfOwXmofq5Rlmeto5bBJwHxlSMbMaA/0ZoxTd9buEHQfUxu5kUAwEu06+QyoSrGk+r7zcH28RpHgXGroRFrbyEVtepNqPc+HvpyPXi4GFFZa+Ch6vGXS/OAZzZhGTaZYrQ+rahKzAyrxJlxVlojs/bAvPXML24hEF4rTvXymo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qut/XLbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qut/XLbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF4BC116B1;
	Tue,  2 Jul 2024 17:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940809;
	bh=fAUg+VBC1tjeQ5LW4U44yTs49HE3HhJj4juoC29jQPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qut/XLbjoLaI5/3My34tgZW4FWHovH4PbpTKH0bJ73Hezr4Y8TU6qa8q0aHDmtUsV
	 509s3OtpRbqgniFcy5p/E3vTbk3EFa1WjcInE+FlNRApLXmTXajP2P95B1WXizu41N
	 b8TrgC/2AiG77bB7Zh1QokrAYCZhm458XW2OjyLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Rizkalla <ajarizzo@gmail.com>,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Angel Iglesias <ang.iglesiasg@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/163] iio: pressure: bmp280: Fix BMP580 temperature reading
Date: Tue,  2 Jul 2024 19:01:56 +0200
Message-ID: <20240702170233.143724864@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Adam Rizkalla <ajarizzo@gmail.com>

[ Upstream commit 0f0f6306617cb4b6231fc9d4ec68ab9a56dba7c0 ]

Fix overflow issue when storing BMP580 temperature reading and
properly preserve sign of 24-bit data.

Signed-off-by: Adam Rizkalla <ajarizzo@gmail.com>
Tested-By: Vasileios Amoiridis <vassilisamir@gmail.com>
Acked-by: Angel Iglesias <ang.iglesiasg@gmail.com>
Link: https://lore.kernel.org/r/Zin2udkXRD0+GrML@adam-asahi.lan
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index 4c493db7db965..a65630d5742f0 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -1385,12 +1385,12 @@ static int bmp580_read_temp(struct bmp280_data *data, int *val, int *val2)
 
 	/*
 	 * Temperature is returned in Celsius degrees in fractional
-	 * form down 2^16. We rescale by x1000 to return milli Celsius
-	 * to respect IIO ABI.
+	 * form down 2^16. We rescale by x1000 to return millidegrees
+	 * Celsius to respect IIO ABI.
 	 */
-	*val = raw_temp * 1000;
-	*val2 = 16;
-	return IIO_VAL_FRACTIONAL_LOG2;
+	raw_temp = sign_extend32(raw_temp, 23);
+	*val = ((s64)raw_temp * 1000) / (1 << 16);
+	return IIO_VAL_INT;
 }
 
 static int bmp580_read_press(struct bmp280_data *data, int *val, int *val2)
-- 
2.43.0



