Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC47B231A24;
	Mon, 10 Mar 2025 17:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626802; cv=none; b=DW2Tbjo1mvCu2mnlOFgErXX/7d5JRjVkK4CAphojAVMDQYRDA7P2mdGPKXX9NvgiNVIpz8TzPhzYlb3P/pCP18BONeHyedDmFzDGc9w4/gtlLHvwihk0TK0aSqLewuibSTfh1c+cqdpZmjXYsdChcMK8ZXvGk94vs6owebI8/z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626802; c=relaxed/simple;
	bh=9Xpry+DZKprjuwZUfALHI1nd9/xxZYXW6wgnuY4NGA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gD6tZlOJssk1EB1Qu24jmjbwsaoj+NJVElsmDHc126sPbEfZqU4f0ahBBQR7hEaGR1EizptgCtHJDfQVP0dpdiHoEGT/w2vmXX/U6xW+JNv7TLhDpaAaAP5raR7atQr1K33SDCrjPtIFTijMzpPCCYEo8v8ygMyxEnrmwCS7WCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7+Se9ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7+Se9ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78286C4CEED;
	Mon, 10 Mar 2025 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626801;
	bh=9Xpry+DZKprjuwZUfALHI1nd9/xxZYXW6wgnuY4NGA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7+Se9ckcc9qOZ5XivwzEmuvfZiXW1hWI9yClrQkQnRJMBR1+IFwsZ6fYuJeQVtal
	 kjH9odsU6HogmOsrwkdm4azGJh47momMGma9eAy8aJKlrEFfz+30osrXAb6m0vqSex
	 7c7B4/KtpMfJzKR0iC+Et1/nlLtqgLXMvf//YOHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 118/207] hwmon: (ad7314) Validate leading zero bits and return error
Date: Mon, 10 Mar 2025 18:05:11 +0100
Message-ID: <20250310170452.501789396@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erik Schumacher <erik.schumacher@iris-sensing.com>

[ Upstream commit e278d5e8aef4c0a1d9a9fa8b8910d713a89aa800 ]

Leading zero bits are sent on the bus before the temperature value is
transmitted. If any of these bits are high, the connection might be
unstable or there could be no AD7314 / ADT730x (or compatible) at all.
Return -EIO in that case.

Signed-off-by: Erik Schumacher <erik.schumacher@iris-sensing.com>
Fixes: 4f3a659581cab ("hwmon: AD7314 driver (ported from IIO)")
Link: https://lore.kernel.org/r/24a50c2981a318580aca8f50d23be7987b69ea00.camel@iris-sensing.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ad7314.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index 7802bbf5f9587..59424103f6348 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -22,11 +22,13 @@
  */
 #define AD7314_TEMP_MASK		0x7FE0
 #define AD7314_TEMP_SHIFT		5
+#define AD7314_LEADING_ZEROS_MASK	BIT(15)
 
 /*
  * ADT7301 and ADT7302 temperature masks
  */
 #define ADT7301_TEMP_MASK		0x3FFF
+#define ADT7301_LEADING_ZEROS_MASK	(BIT(15) | BIT(14))
 
 enum ad7314_variant {
 	adt7301,
@@ -65,12 +67,20 @@ static ssize_t ad7314_temperature_show(struct device *dev,
 		return ret;
 	switch (spi_get_device_id(chip->spi_dev)->driver_data) {
 	case ad7314:
+		if (ret & AD7314_LEADING_ZEROS_MASK) {
+			/* Invalid read-out, leading zero part is missing */
+			return -EIO;
+		}
 		data = (ret & AD7314_TEMP_MASK) >> AD7314_TEMP_SHIFT;
 		data = sign_extend32(data, 9);
 
 		return sprintf(buf, "%d\n", 250 * data);
 	case adt7301:
 	case adt7302:
+		if (ret & ADT7301_LEADING_ZEROS_MASK) {
+			/* Invalid read-out, leading zero part is missing */
+			return -EIO;
+		}
 		/*
 		 * Documented as a 13 bit twos complement register
 		 * with a sign bit - which is a 14 bit 2's complement
-- 
2.39.5



