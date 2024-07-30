Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBEE1A6192;
	Tue, 30 Jul 2024 16:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357686; cv=none; b=MKY++1rhI9uOR9VPiJ2f1T9cq9+MYQQEVaBQiYwzLlRz3hjzRpXe+/HDHtHKwwLKqTanEwgmIx5cW1VX3tr740hSCa2g261RbBYnnGmvOqPWnLrYqmAT1egeUOUFIxx0HExJZTRnQa43eXkwWH041LooszkF9QlTviOZ9/8r9zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357686; c=relaxed/simple;
	bh=OLuDiMZDrbBtj2/U5Fmzk0dcyO3E7S0rRIsBMJEW+Qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuVHEGBikWou1x8v8+ENWN2PmGZ/Lyo3fKFiGMQ5nWXugExQVH7nxg/jAi4GkLFI+J+Wl4hANGjdwXkj8tjO7gCkRFx8cvgYKP/OgopXUv5QJtISSYoRIzoB2U360tXXwqjIIV2aVlST17JgaKQS4LKi5GcYtM2Gq42gY6LV2QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJ//xtWL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJ//xtWL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF39EC32782;
	Tue, 30 Jul 2024 16:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357686;
	bh=OLuDiMZDrbBtj2/U5Fmzk0dcyO3E7S0rRIsBMJEW+Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJ//xtWLDRcpVefhPnIoFKH+kaM4ZpO7+1vWbHi2sMFB2rAUegi0qnLh4n28UiLDR
	 NvKTMt3XYG6vENTqYDMCqUkjzaoYFN27lHXuRUceklTERJQkNjmD7M8gl6y445rmmZ
	 UQRIwww9P6Wm+dfOQdQ+ai1gg6hFqCfrBkHEJnQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/568] mtd: make mtd_test.c a separate module
Date: Tue, 30 Jul 2024 17:46:28 +0200
Message-ID: <20240730151650.857775187@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a5cf054d325e6f362e82fe6d124a1871a4af8174 ]

This file gets linked into nine different modules, which causes a warning:

scripts/Makefile.build:236: drivers/mtd/tests/Makefile: mtd_test.o is added to multiple modules: mtd_nandbiterrs mtd_oobtest mtd_pagetest mtd_readtest mtd_speedtest mtd_stresstest mtd_subpagetest mtd_torturetest

Make it a separate module instead.

Fixes: a995c792280d ("mtd: tests: rename sources in order to link a helper object")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240529095049.1915393-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/tests/Makefile   | 34 +++++++++++++++++-----------------
 drivers/mtd/tests/mtd_test.c |  9 +++++++++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/drivers/mtd/tests/Makefile b/drivers/mtd/tests/Makefile
index 5de0378f90dbd..7dae831ee8b6b 100644
--- a/drivers/mtd/tests/Makefile
+++ b/drivers/mtd/tests/Makefile
@@ -1,19 +1,19 @@
 # SPDX-License-Identifier: GPL-2.0
-obj-$(CONFIG_MTD_TESTS) += mtd_oobtest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_pagetest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_readtest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_speedtest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_stresstest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_subpagetest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_torturetest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_nandecctest.o
-obj-$(CONFIG_MTD_TESTS) += mtd_nandbiterrs.o
+obj-$(CONFIG_MTD_TESTS) += mtd_oobtest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_pagetest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_readtest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_speedtest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_stresstest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_subpagetest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_torturetest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_nandecctest.o mtd_test.o
+obj-$(CONFIG_MTD_TESTS) += mtd_nandbiterrs.o mtd_test.o
 
-mtd_oobtest-objs := oobtest.o mtd_test.o
-mtd_pagetest-objs := pagetest.o mtd_test.o
-mtd_readtest-objs := readtest.o mtd_test.o
-mtd_speedtest-objs := speedtest.o mtd_test.o
-mtd_stresstest-objs := stresstest.o mtd_test.o
-mtd_subpagetest-objs := subpagetest.o mtd_test.o
-mtd_torturetest-objs := torturetest.o mtd_test.o
-mtd_nandbiterrs-objs := nandbiterrs.o mtd_test.o
+mtd_oobtest-objs := oobtest.o
+mtd_pagetest-objs := pagetest.o
+mtd_readtest-objs := readtest.o
+mtd_speedtest-objs := speedtest.o
+mtd_stresstest-objs := stresstest.o
+mtd_subpagetest-objs := subpagetest.o
+mtd_torturetest-objs := torturetest.o
+mtd_nandbiterrs-objs := nandbiterrs.o
diff --git a/drivers/mtd/tests/mtd_test.c b/drivers/mtd/tests/mtd_test.c
index c84250beffdc9..f391e0300cdc9 100644
--- a/drivers/mtd/tests/mtd_test.c
+++ b/drivers/mtd/tests/mtd_test.c
@@ -25,6 +25,7 @@ int mtdtest_erase_eraseblock(struct mtd_info *mtd, unsigned int ebnum)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mtdtest_erase_eraseblock);
 
 static int is_block_bad(struct mtd_info *mtd, unsigned int ebnum)
 {
@@ -57,6 +58,7 @@ int mtdtest_scan_for_bad_eraseblocks(struct mtd_info *mtd, unsigned char *bbt,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mtdtest_scan_for_bad_eraseblocks);
 
 int mtdtest_erase_good_eraseblocks(struct mtd_info *mtd, unsigned char *bbt,
 				unsigned int eb, int ebcnt)
@@ -75,6 +77,7 @@ int mtdtest_erase_good_eraseblocks(struct mtd_info *mtd, unsigned char *bbt,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(mtdtest_erase_good_eraseblocks);
 
 int mtdtest_read(struct mtd_info *mtd, loff_t addr, size_t size, void *buf)
 {
@@ -92,6 +95,7 @@ int mtdtest_read(struct mtd_info *mtd, loff_t addr, size_t size, void *buf)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(mtdtest_read);
 
 int mtdtest_write(struct mtd_info *mtd, loff_t addr, size_t size,
 		const void *buf)
@@ -107,3 +111,8 @@ int mtdtest_write(struct mtd_info *mtd, loff_t addr, size_t size,
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(mtdtest_write);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MTD function test helpers");
+MODULE_AUTHOR("Akinobu Mita");
-- 
2.43.0



