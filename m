Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF3F7E0FF;
	Mon, 23 Dec 2024 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970421; cv=none; b=WJGgnCNf3K5BbJA9PssZxh1bnScaKufkJGobx7oW+/jg9fUXGISFOAxrXY2i3fi0Y78jp3v1dGCAHFBHIkMz0yZNbwpzFOuu+CnjPzGDo8ixzg4v6WnkkmSgKyIIq0cQeEraIR5+LRoAWyERA0xXeVVbD3eSmD2luJyIMdAvrNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970421; c=relaxed/simple;
	bh=qQSVFWsV69ma8Q03GPYITRY/MNxMXKZ5itytjUFvuV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkRgQjowmQrvblw6CAjVaWISF1JHrcvoll+1oh8ocKTTaxOII6Sl2fGrCLogHnhNah1k5+I6HeJkAVfPiaMSEBSs6WSK9ZeYk3nVNOsdPrQMqErbglY5CpuwyvBSdJt3XDV3D0DGLVDjJlOhWp3rfoAVV2X3ABHwmZVjrTTn3UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sArZ05yW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sArZ05yW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4FB5C4CED3;
	Mon, 23 Dec 2024 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970421;
	bh=qQSVFWsV69ma8Q03GPYITRY/MNxMXKZ5itytjUFvuV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sArZ05yW38kv+OuChPD/DuNgtjzGJ4TB7Ouet6TwfWidje0cMRtFCD0lb6MJ2zwRA
	 Z9RWlMNHG0CjF8sO/8VNKTqf84hs4a19QM6aY/YpC0dARYwdJQbzkkZ/792/I7TTMN
	 ihlnRvvI7xbp1C3Ho2WFvi1cfkHJGEszEAzzLVp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/116] hwmon: (tmp513) Dont use "proxy" headers
Date: Mon, 23 Dec 2024 16:59:09 +0100
Message-ID: <20241223155402.637196063@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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
index 9a180b1030c9..ca665033fe52 100644
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



