Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1877E107;
	Sun,  7 Sep 2025 20:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277934; cv=none; b=un2ZOjWNSA3jgfcjUp/OI8Ny8CveaMaCFwEtCfoNgc4tOIUGGCp097IbNTquwAxI/tIlufhRvWfnsqyjmYpvyOvCYVDlPSv/eXqqQmXdYs2uym8p3CNitthOT6iHQKbzWX5cv0wi8IoNVkwEPsjk9/WHJ6pGzYE1QEqw/AsJtIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277934; c=relaxed/simple;
	bh=/VZT04UBQTs5Hp45ZvgL2st9U0GHKvIArXFwYf8Lk1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dzi3nkuHq33nIgt72G0IEwbc+wPaqcbUeNbFDecg8DmGjv73LEJWKcLIDpI/MTOktHcTeDz5KE0c6cYCC4QEK7EAqIIZ4EtWVVHabeqXel0K/P1u3QO+BKjxPCjvIDqAN274CzHIaGKhS3olsBvbeElHgOb84Sa+Sogg2EkXyYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eiKYIKIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eiKYIKIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209F0C4CEF0;
	Sun,  7 Sep 2025 20:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277934;
	bh=/VZT04UBQTs5Hp45ZvgL2st9U0GHKvIArXFwYf8Lk1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eiKYIKIloGLeecp7fESwhBKFO3P6/EpvmLWOwOvYZBga/4WoZvN7rrHxeRwbDTN6f
	 v+jtZHtIln0Irw3vZ95gQcM/p5T+gbjnhkvVMCTxdou6TvCkz4+RssBLYmF3spo0AJ
	 /p9b6DNhKPyY48gtYxpmZ4yXRg1jZwtWoIP6bzgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenliang Yan <wenliang202407@163.com>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 162/183] hwmon: (ina238) Correctly clamp power limits
Date: Sun,  7 Sep 2025 21:59:49 +0200
Message-ID: <20250907195619.664649745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit c2623573178bab32990695fb729e9b69710ed66d ]

ina238_write_power() was attempting to clamp the user input but was
throwing away the result. Ensure that we clamp the value to the
appropriate range before it is converted into a register value.

Fixes: 0d9f596b1fe34 ("hwmon: (ina238) Modify the calculation formula to adapt to different chips")
Cc: Wenliang Yan <wenliang202407@163.com>
Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina238.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ina238.c b/drivers/hwmon/ina238.c
index 0562f9a4dcf12..5c90c3e59f80c 100644
--- a/drivers/hwmon/ina238.c
+++ b/drivers/hwmon/ina238.c
@@ -426,9 +426,10 @@ static int ina238_write_power(struct device *dev, u32 attr, long val)
 	 * Unsigned postive values. Compared against the 24-bit power register,
 	 * lower 8-bits are truncated. Same conversion to/from uW as POWER
 	 * register.
+	 * The first clamp_val() is to establish a baseline to avoid overflows.
 	 */
-	regval = clamp_val(val, 0, LONG_MAX);
-	regval = div_u64(val * 4 * 100 * data->rshunt, data->config->power_calculate_factor *
+	regval = clamp_val(val, 0, LONG_MAX / 2);
+	regval = div_u64(regval * 4 * 100 * data->rshunt, data->config->power_calculate_factor *
 			1000ULL * INA238_FIXED_SHUNT * data->gain);
 	regval = clamp_val(regval >> 8, 0, U16_MAX);
 
-- 
2.51.0



