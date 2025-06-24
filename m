Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1D2222580;
	Tue, 24 Jun 2025 04:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750738332; cv=none; b=DxOhys2WvK0ipoUNFrcGYuynwyfBy72aKpHLAEwK0hcndTp2iLhCiO0pva6u2LeGfUEADLKblD+LBdogTuTv2Z1uA/GIIO7y3jRH6gFwoS3ph2KH8L1g7wR7iojOQMV8pLpyQ8f/Mp4kbTIqGfU1A9EL0jNL+UkLrglI7o3F1PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750738332; c=relaxed/simple;
	bh=+cA9CULD16ZBgRCt7hWk+g7OnHi4i+dXVTJ4XyrH3qk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ncX61eGxsivdLYuov6vW77OriI4XcMTHZfO8gic2hSMftog65l7AgJKIWrqhBac7kq1cofMKJ8R0VneceN7/uvNxw7YRUuW/eqg/5m06ApqENs5Luv6fHHeBkySXFriY7W/HBYELeJxuovv3XaejIkeimI1vYje6YSD5Ca+RuWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFkt5yn3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFkt5yn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183E9C4CEE3;
	Tue, 24 Jun 2025 04:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750738332;
	bh=+cA9CULD16ZBgRCt7hWk+g7OnHi4i+dXVTJ4XyrH3qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFkt5yn326gFRTYshOzC3Zgu/8Pnuke+ncStKIIU/Fu1r+vtICXTPRF9TzoXol8UT
	 zdzGYXVFuatSqowSOZNfYP/2jWHU+zkXH9PwyI8MUkPsJVxW7SgaXPTnh+Ff7hKJE2
	 tDdWnjUdtPT0W6sp9C+W/ICI+yQ6AT9Ax+i+3aMob9nQFMI3bMHg7ab6UufYkhJN6x
	 OGqGtHkn2yBmpuDdS47iWREDrQw9pl9H7TwPM2I3KllT3SKkWM+0/St1sppYiwr1jB
	 siC2njcdBpcBKnitsrVQUX4vFkxPMUoVgAmdb1T5v54+iFMe0JQHQp+3QdbVQg7Os8
	 QyvXg33pjs17A==
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
Subject: [PATCH AUTOSEL 6.12 18/19] mtd: spinand: fix memory leak of ECC engine conf
Date: Tue, 24 Jun 2025 00:11:47 -0400
Message-Id: <20250624041149.83674-18-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250624041149.83674-1-sashal@kernel.org>
References: <20250624041149.83674-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.34
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
index 4d76f9f71a0e9..241f6a4df16c1 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1496,6 +1496,7 @@ static void spinand_cleanup(struct spinand_device *spinand)
 {
 	struct nand_device *nand = spinand_to_nand(spinand);
 
+	nanddev_ecc_engine_cleanup(nand);
 	nanddev_cleanup(nand);
 	spinand_manufacturer_cleanup(spinand);
 	kfree(spinand->databuf);
-- 
2.39.5

