Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C69133EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11251C433EF;
	Mon, 16 Jan 2023 15:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884785;
	bh=daq1wiaziEc1oK1N5ovOhOE1ZJUsLuG2cgWXKQ5qKo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5hpNIqo4G3FmAoLPJK/UDB7JRrl3BOQW0mIS6vAQ5jIEcmWZmjCKDObsX6OpTp5O
	 z4yk9jXxnikf5D5shJ/SZpDKuMzkG0eJOhOgRICa52NBE4y6gXmdTjwaoVaOA34dtI
	 WJqcHK+eZZTBhhpsVRvoQpwNnbeUt4dVKGT0JM/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Tokunori Ikegami <ikegami.t@gmail.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/183] mtd: cfi: allow building spi-intel standalone
Date: Mon, 16 Jan 2023 16:50:31 +0100
Message-Id: <20230116154807.934457137@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d19ab1f785d0b6b9f709799f0938658903821ba1 ]

When MTD or MTD_CFI_GEOMETRY is disabled, the spi-intel driver
fails to build, as it includes the shared CFI header:

include/linux/mtd/cfi.h:62:2: error: #warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work. [-Werror=cpp]
   62 | #warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work.

linux/mtd/spi-nor.h does not actually need to include cfi.h, so
remove the inclusion here to fix the warning. This uncovers a
missing #include in spi-nor/core.c so add that there to
prevent a different build issue.

Fixes: e23e5a05d1fd ("mtd: spi-nor: intel-spi: Convert to SPI MEM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Tokunori Ikegami <ikegami.t@gmail.com>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20221220141352.1486360-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c  | 1 +
 include/linux/mtd/spi-nor.h | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 2e0655c0b606..5dbf52aa0355 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -10,6 +10,7 @@
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/math64.h>
diff --git a/include/linux/mtd/spi-nor.h b/include/linux/mtd/spi-nor.h
index 42218a1164f6..f92bf7f7a754 100644
--- a/include/linux/mtd/spi-nor.h
+++ b/include/linux/mtd/spi-nor.h
@@ -7,7 +7,6 @@
 #define __LINUX_MTD_SPI_NOR_H
 
 #include <linux/bitops.h>
-#include <linux/mtd/cfi.h>
 #include <linux/mtd/mtd.h>
 #include <linux/spi/spi-mem.h>
 
-- 
2.35.1



