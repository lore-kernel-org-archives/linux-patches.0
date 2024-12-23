Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4EF8827;
	Mon, 23 Dec 2024 16:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970725; cv=none; b=PLiqxtY7ZYzO9NYTFOlyhbYMgo+QXJyiWU6WYMRZRMK70eG2DSTMJZlv9OkUMBXWdrik3Vc23H3gzx9h1xvnmHorTZ/s1UckPvzP9IIDM/dv0hpIk9L0wMcI6qRAIvurfPMF8KgbcCLeZ4Y6gpqaF21bQ+p3WtsXRXw9c797x+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970725; c=relaxed/simple;
	bh=L9ehiYDs7N43ubJtcsxa4ddPVySN6erWvdc2P32LIDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbPnae9nWM3BDJegleLpcN0kaE9svhdP/5ks7pcUbr4T+YvjLc9Z8lc1uDtymlhnqJPRk32KHas7J7002uGzoy7vLMNA9H3k60IWxAkLxvbiCPLWsRGdOjpbtBo4Td2n1TpBlktuzg18UPP7SnA/AJqIeDMmNKwHpaXHjL5iua4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpL7er9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpL7er9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89ABBC4CED3;
	Mon, 23 Dec 2024 16:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970724;
	bh=L9ehiYDs7N43ubJtcsxa4ddPVySN6erWvdc2P32LIDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpL7er9gtrNAFMQ2kuvLMnYoQkUyuWV29WInZfk53vkmx1KlwdwToTEIe6f44OlCq
	 aOBgBLH38lATt10BU3oUCxW1ULwYBmcofIl9vqLB7gmu+GGm/sZoZXgVA/RcI82qeg
	 smk84F8+PQMzIW94zBCsK7u4NTlC8ANs5oVrbZCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 50/83] hwmon: (tmp513) Dont use "proxy" headers
Date: Mon, 23 Dec 2024 16:59:29 +0100
Message-ID: <20241223155355.562699319@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



