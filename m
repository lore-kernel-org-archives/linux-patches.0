Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FA2189502;
	Tue, 30 Jul 2024 17:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359097; cv=none; b=HFIr5aJzRGRI0RMuQ1L8QWSH3yhfCW+SKhRkxqgVHUzmb8q+WmrWklJxHFnFnfiV6aKD0dkikCQe4L6F/nOSzcRf0v5fyXYgsTqs9m32kzveP0Lyeno6TvpECrV1cxr2ApoMNJ5RRDYM73KFsPOqA5m6vB10lnbCfeoAQ1eAfxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359097; c=relaxed/simple;
	bh=kD8pa6PXVY/+frWosQNweyThQSv2wG+Bd0EHcxFw5o8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=grVzy6gtKBVYyb1F0aUCigZq9hxu0drTzD5ifyAacjPe9dlPEnRHfbBNjkau51ONkZb2cVt0XA3DNznK+EaDbSPBjwgqS1ozK3Thpmnju+j7/EFMGgsSqhV0f7vGcb935QYCNApmotUnVYUjIJ3wGylZUww3rG0zlBmSk7Xmmzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VEVBOfVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VEVBOfVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E709C32782;
	Tue, 30 Jul 2024 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359097;
	bh=kD8pa6PXVY/+frWosQNweyThQSv2wG+Bd0EHcxFw5o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VEVBOfVCHOz6iFNAMkuAQILT1TucAKDgTbLlixQ2GIA6Cbmq4vsgq//pWMFo0ay4m
	 OcIj5iW+gAF04+u4k72HkBig0rxk935Lfa9QSXB7FATIxosCkGZYiyd4zWfJEQDlc9
	 4jBjoG4o6VdNAZQni1RMWdbEg8fWZKeDBlOgVl2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 433/809] mtd: make mtd_test.c a separate module
Date: Tue, 30 Jul 2024 17:45:09 +0200
Message-ID: <20240730151741.805010986@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



