Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0308A25B691;
	Tue, 11 Mar 2025 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707561; cv=none; b=qtDXBjxSHMFns/8jiyOb0TG9p0QYLy9NDyR2fJUhRDnpN5kn7je3ogM0YyINQzFehmi1Z7/63x6fSeMCgmwlAoWi6EUOTuLr0Hk+ysImSQMBd2UCeDaqLQhW1b+S1+2qaoLBrqZjPDD0Wjt7U6x8W6+/DIqVPmcNuHuUoADLPOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707561; c=relaxed/simple;
	bh=7LJh5uSR09DRGc8gYaBvd8+GImI2YxAHfeosdKLz0no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkjwT0jAk3LepuXrZyjI2KxuGcCKpdSlCu5XEX9hgZvJNL4pYcuCqf7WjmyRLloRNPp6MBCYrLfzOd1YAwlRB92VZbepse/VB5f2XaABPNe5OoQ3uYUjHIOCR2bSNzixevWvTWPP+ReyAssljjs40/mkDqAWiuvOolTn9IEPz3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2RDZ+OB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2RDZ+OB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753B0C4CEE9;
	Tue, 11 Mar 2025 15:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707560;
	bh=7LJh5uSR09DRGc8gYaBvd8+GImI2YxAHfeosdKLz0no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2RDZ+OB4/MActr275nW+6jvchDlg0R58W8XnoTFbAtSH1mCrdQNbQhdc6LacHpMW
	 QML8V+DjU8rEUzk6NcoZ5pbTiwY9IWtBepehGFXVgKvRNmrIe9gIWIaksKURI1kLc8
	 l/8oWakbJuu9ARYDfy8FINieY78AGjH2ePoU3cog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erik Schumacher <erik.schumacher@iris-sensing.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 413/462] hwmon: (ad7314) Validate leading zero bits and return error
Date: Tue, 11 Mar 2025 16:01:19 +0100
Message-ID: <20250311145814.648694975@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



