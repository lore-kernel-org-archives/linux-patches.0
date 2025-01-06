Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D6816A930;
	Mon,  6 Jan 2025 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178631; cv=none; b=lzBKkPUdDQX0coHnOId13JG0dRO7Bb7Lpkh/s49RKAGR0QK44BUmwGdE1b0JaYvokpyTAmI2mE4nP0tjhzddoDrh7RBHHxYwsFiv3CAQZyhVnX6FeEx5irB4MF9EhieIZtNj3gKovNiJX8ZAHwGFP5I076VUCTw33mxNetDRgV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178631; c=relaxed/simple;
	bh=d2n4IAHoQQWPZPNxrKsge0KSGpTaLKd4CZbFpL+SAkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NrJ/qnt82gcNN3/7QMS6V5eB6KuBPVFgWmMsGYRWx8GkXnFzGOMIg98ggoqgK8yTpuEfBlYc4ZX+Ab0dkbSDcOErGGkhnxX0kwk5phH7I2L5zQrKpQ4eIxPm4w04ip77EqnAz5hQaMNnDSlyoYhfgmfRaj3uJCFgIbfnb/39hCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0fLycAO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0fLycAO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B676AC4CED2;
	Mon,  6 Jan 2025 15:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178631;
	bh=d2n4IAHoQQWPZPNxrKsge0KSGpTaLKd4CZbFpL+SAkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0fLycAOWyiCXQHeJ31jasyIhia1PDVJX1uLzbmmiEbzNhmXHIyYWqWzjVu+qXXa3
	 4Yy6tUvzhCkvp/qi9JOt+cdQ4PsbNpnEOt0/gBlwKRlUU7bpGa3Qxe9azMpkT/SrNN
	 hUt8ua169GcyCHkuPcUGj2/D2Vopm0cjVX7WI9l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/168] hwmon: (tmp513) Dont use "proxy" headers
Date: Mon,  6 Jan 2025 16:15:42 +0100
Message-ID: <20250106151139.751420846@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5d9ad4e0fa7cc27199fdb94beb6ec5f655ba9489 ]

The driver uses math.h and not util_macros.h.

All the same for the kernel.h, replace it with what the driver is using.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231128180654.395692-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 74d7e038fd07 ("hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index b9a93ee9c236..fe3f1113b64e 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -19,15 +19,19 @@
  * the Free Software Foundation; version 2 of the License.
  */
 
+#include <linux/bitops.h>
+#include <linux/bug.h>
+#include <linux/device.h>
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/i2c.h>
 #include <linux/init.h>
-#include <linux/kernel.h>
+#include <linux/math.h>
 #include <linux/module.h>
+#include <linux/property.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
-#include <linux/util_macros.h>
+#include <linux/types.h>
 
 // Common register definition
 #define TMP51X_SHUNT_CONFIG		0x00
-- 
2.39.5



