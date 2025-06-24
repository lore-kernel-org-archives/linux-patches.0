Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5275C253B73;
	Tue, 24 Jun 2025 04:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738394; cv=none; b=MitFWNZzNvoEzQTyy9UWT2sIaqYDnHJa+2AmJVl+CHVU3lVhP9AI4OXX+Or00kGDenRceCuAdKAyuJXSwV7+AQ61k6ZnmFVPlbTbkD4DqEkLAl+539T039OSekTGpOs3UtSoF00a3iyq1kJiRH3fmyubhYjGwyMxrqxU5Pe+aDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738394; c=relaxed/simple;
	bh=bLqWLGwHhdkgsdP3SlZTbb9MLRe8xgxtZ/4QPgEvkkk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AT5jqJt6byYEYkZMgV81kxX3qKjSG067XCMmhSuRS2COBXlMKRLQBfcS2gPeu9dewSMwo/BMViV2vjRnQYi5adx61WiBUwYprD+kmx42zZZTCFiIkQ+cIAKSNXHhe+s03IfDsyVe2TBKDdEH5wu7eWS4DtIe+ytYlELv5jBAc/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+2q10Ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+2q10Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E29AC4CEF0;
	Tue, 24 Jun 2025 04:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738393;
	bh=bLqWLGwHhdkgsdP3SlZTbb9MLRe8xgxtZ/4QPgEvkkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+2q10WwizHVyJ+FRQ8tjGfY+c03WU5vCs+huI77nxQP+hKQ3xcxcrpivk1HCyDj3
	 3KMnPoQgnoPddv5KIv0hxodVuKW1LVGEsFG+f8WHRhU/MvPqcc3Ju992/a6M0YBJDW
	 QLubBjZrtaOsJNVY+wF1fr8Vu6DsIHe8TrVpTtzk/0zs9wXr1Bbwj2dqnzKom3/iBF
	 i9oNmJMsu3Tj/lmJVWC9qzzc9UapoEdEN/OzfUyedd23lWD0E3F7l76DozoopTwi+J
	 waFYPoPJCdXUZjOtrDUMkD2yq3VJhIO0tzvHLSgK5i3q3nUArCBSI42qyx3jtPF1NR
	 IA8JNWkFhhj5Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pablo Martin-Gomez <pmartin-gomez@freebox.fr>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	tudor.ambarus@linaro.org,
	Takahiro.Kuwano@infineon.com,
	mmkurbanov@salutedevices.com,
	chengminglin@mxic.com.tw
Subject: [PATCH AUTOSEL 5.15 10/11] mtd: spinand: fix memory leak of ECC engine conf
Date: Tue, 24 Jun 2025 00:12:58 -0400
Message-Id: <20250624041259.84940-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041259.84940-1-sashal@kernel.org>
References: <20250624041259.84940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.185
Content-Transfer-Encoding: 8bit

From: Pablo Martin-Gomez <pmartin-gomez@freebox.fr>

[ Upstream commit 6463cbe08b0cbf9bba8763306764f5fd643023e1 ]

Memory allocated for the ECC engine conf is not released during spinand
cleanup. Below kmemleak trace is seen for this memory leak:

unreferenced object 0xffffff80064f00e0 (size 8):
  comm "swapper/0", pid 1, jiffies 4294937458
  hex dump (first 8 bytes):
    00 00 00 00 00 00 00 00                          ........
  backtrace (crc 0):
    kmemleak_alloc+0x30/0x40
    __kmalloc_cache_noprof+0x208/0x3c0
    spinand_ondie_ecc_init_ctx+0x114/0x200
    nand_ecc_init_ctx+0x70/0xa8
    nanddev_ecc_engine_init+0xec/0x27c
    spinand_probe+0xa2c/0x1620
    spi_mem_probe+0x130/0x21c
    spi_probe+0xf0/0x170
    really_probe+0x17c/0x6e8
    __driver_probe_device+0x17c/0x21c
    driver_probe_device+0x58/0x180
    __device_attach_driver+0x15c/0x1f8
    bus_for_each_drv+0xec/0x150
    __device_attach+0x188/0x24c
    device_initial_probe+0x10/0x20
    bus_probe_device+0x11c/0x160

Fix the leak by calling nanddev_ecc_engine_cleanup() inside
spinand_cleanup().

Signed-off-by: Pablo Martin-Gomez <pmartin-gomez@freebox.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Clear Memory Leak Bug**: The commit fixes a concrete memory leak
   where the ECC engine configuration memory (allocated in
   `spinand_ondie_ecc_init_ctx()` at line 272 via `kzalloc()`) is never
   freed. The kmemleak trace clearly shows this 8-byte allocation is
   leaked on every spinand device initialization.

2. **Small and Contained Fix**: The fix is minimal - it only adds a
   single line `nanddev_ecc_engine_cleanup(nand);` to the existing
   `spinand_cleanup()` function. This follows the established cleanup
   pattern already used in the error path (`err_cleanup_ecc_engine:` at
   line 1569).

3. **No Architectural Changes**: The commit doesn't introduce any new
   features or change any architecture. It simply ensures proper cleanup
   of already-allocated resources by calling an existing cleanup
   function.

4. **Follows Established Patterns**: The fix mirrors the cleanup already
   performed in the error handling path during `spinand_init()`. If
   initialization fails after `nanddev_ecc_engine_init()`, the code
   already calls `nanddev_ecc_engine_cleanup()`. This commit ensures the
   same cleanup happens during normal device removal.

5. **Clear Impact on Users**: Memory leaks affect system stability over
   time, especially in systems that frequently probe/remove SPI NAND
   devices (e.g., during development, testing, or hot-plug scenarios).
   Each leak is small (8 bytes) but cumulative.

6. **Low Risk**: The cleanup function `nanddev_ecc_engine_cleanup()`
   already checks if the engine exists before attempting cleanup (`if
   (nand->ecc.engine)`), making it safe to call even in edge cases.

7. **Similar to Backported Commits**: Like the backported commit "atm:
   idt77252: fix kmemleak when rmmod idt77252", this fixes a clear
   resource leak found by kmemleak, with a simple addition of the
   appropriate cleanup call in the removal path.

The commit follows stable tree rules perfectly: it's a small, important
bugfix with minimal regression risk that addresses a real memory leak
issue affecting users.

 drivers/mtd/nand/spi/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 2c8685f1f2fa7..80d0112d18fa6 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1271,6 +1271,7 @@ static void spinand_cleanup(struct spinand_device *spinand)
 {
 	struct nand_device *nand = spinand_to_nand(spinand);
 
+	nanddev_ecc_engine_cleanup(nand);
 	nanddev_cleanup(nand);
 	spinand_manufacturer_cleanup(spinand);
 	kfree(spinand->databuf);
-- 
2.39.5

