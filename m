Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC91043D4E8;
	Tue, 10 Mar 2026 09:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773133322; cv=none; b=MS3XsUYL/ZhCJe3GZBUzb2cGWkE/lmiI+F4dzuLKIXRT8qBAcZHQynto76EGPiS4IoA5x0Q3wghBIAECLOvpdNefb2v5PdFdi1/v/mzfzKpGcXuXTmi7WtuNyLWFXCD1nORSozltd+BUpHVGGrJfYowLLbxOQKWBwfE8yg0cobs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773133322; c=relaxed/simple;
	bh=9n3Ed1n/AWWKRgLqLE4D/kORWCQxeaPkXp35pEa7oE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUlMKI1xkjnkrHFxwCnB5wZjDv6APnVFrB/GYXXwAzP4+gTBltc/IAcxWov2hWvyE99z+RQctItyiqWFHY3h5PvSm00QqEgMomxcsUAaCJiLidW7K636ywP5N1Jp/kt6aBM0uuA7pNaVVw53XP7THp/VyRiYF/4ZrF3PfL7AgMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JC8dM5gB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JC8dM5gB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0AC2BC86;
	Tue, 10 Mar 2026 09:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773133322;
	bh=9n3Ed1n/AWWKRgLqLE4D/kORWCQxeaPkXp35pEa7oE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JC8dM5gBrONOFBIECx49u66DWtuuokkArQXqOvTIowppRKJs70Hr1PPwfuv4gPVxd
	 NaB/oM3NiNcfNzG5/BZ6cFbR/3W56Mikw+LkD63Nx/qU7cTdZ9FmeAX1e5xNmCPL8P
	 zdywGLDycwUVSEZANrS/VobdBTxzXOqakUsrxtGRvz6vvdM0YgRwC7o0AoAYffNoPX
	 Y8puQym3G4REKOJGXhmg3BYrRmB13eMQrPNQAHKJctPRx9bgacZ7ZkuvAE/Z7gvxRL
	 xncQlsnV61GHjcV5dEeE0HJ7njMiaFQ3ya3b+26Zol8YN/07VqigrEZN+dVt/LzXgO
	 4WYkZ9pHVpiKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vladimir Yakovlev <vovchkir@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] spi: spi-dw-dma: fix print error log when wait finish transaction
Date: Tue, 10 Mar 2026 05:01:11 -0400
Message-ID: <20260310090145.2709021-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260310090145.2709021-1-sashal@kernel.org>
References: <20260310090145.2709021-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.6
Content-Transfer-Encoding: 8bit

From: Vladimir Yakovlev <vovchkir@gmail.com>

[ Upstream commit 3b46d61890632c8f8b117147b6923bff4b42ccb7 ]

If an error occurs, the device may not have a current message. In this
case, the system will crash.

In this case, it's better to use dev from the struct ctlr (struct spi_controller*).

Signed-off-by: Vladimir Yakovlev <vovchkir@gmail.com>
Link: https://patch.msgid.link/20260302222017.992228-2-vovchkir@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The analysis is clear. When `dw_spi_dma_wait` times out, `cur_msg` could
potentially be NULL or in an inconsistent state. Dereferencing
`dws->ctlr->cur_msg->spi->dev` through a chain of 3 pointer dereferences
when `cur_msg` could be NULL causes a NULL pointer dereference crash.

The fix simply uses `dws->ctlr->dev` instead, which is always valid
since it's the controller's own device - guaranteed to exist as long as
the controller exists.

## Analysis

### What the commit fixes
This commit fixes a potential NULL pointer dereference crash in the SPI
DW DMA driver. When a DMA transaction times out in `dw_spi_dma_wait()`,
the error logging path accesses `dws->ctlr->cur_msg->spi->dev`. If
`cur_msg` is NULL (which can happen on error paths, as the SPI core sets
it to NULL in various places), this causes a kernel crash. The fix uses
`dws->ctlr->dev` instead, which is always valid.

### Meets stable kernel rules
1. **Obviously correct**: The fix is a single-line change replacing an
   unsafe pointer chain with a safe, always-valid device reference. The
   controller device (`ctlr->dev`) is always valid as long as the
   controller is registered.
2. **Fixes a real bug**: NULL pointer dereference leading to a kernel
   crash.
3. **Important issue**: Kernel crash/oops in a commonly used SPI driver.
4. **Small and contained**: One line change in one file.
5. **No new features**: Pure bug fix.

### Risk assessment
- **Risk**: Extremely low. The fix simply changes which `struct device
  *` is used for `dev_err()` logging. The worst case is the error
  message shows a slightly different device name in the log.
- **Benefit**: Prevents a kernel crash when a DMA transfer times out.

### Dependency check
The fix uses `ctlr` which was renamed from `host` in commit
`b926b15547d29` (Oct 2025). For older stable trees (pre-6.12 or so), the
field was named `master` or `host`, so the backport would need trivial
adaptation (changing `ctlr` to `host` or `master` depending on the
tree). The buggy code has been present since commit `bdbdf0f06337d`
(v5.8, May 2020), so all supported stable trees would benefit.

### Verification
- `git log -p --follow -S 'cur_msg->spi->dev'` confirmed the buggy
  pattern was introduced in commit `bdbdf0f06337d` (v5.8 era, 2020)
- `git tag --contains bdbdf0f06337d` confirmed it's in stable branches
  p-5.10, p-5.15, p-6.1
- `git show b926b15547d29` confirmed the `host` -> `ctlr` rename touched
  this exact line, creating a dependency for clean backport to newer
  stable trees
- Read of `spi.c` confirmed `cur_msg` is set to NULL in multiple places
  (lines 1910, 2198, 4480), validating the crash scenario
- The fix only changes the `struct device *` argument to `dev_err()`,
  which has zero functional impact beyond logging

**YES**

 drivers/spi/spi-dw-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-dma.c b/drivers/spi/spi-dw-dma.c
index 65adec7c7524b..fe726b9b1780d 100644
--- a/drivers/spi/spi-dw-dma.c
+++ b/drivers/spi/spi-dw-dma.c
@@ -271,7 +271,7 @@ static int dw_spi_dma_wait(struct dw_spi *dws, unsigned int len, u32 speed)
 					 msecs_to_jiffies(ms));
 
 	if (ms == 0) {
-		dev_err(&dws->ctlr->cur_msg->spi->dev,
+		dev_err(&dws->ctlr->dev,
 			"DMA transaction timed out\n");
 		return -ETIMEDOUT;
 	}
-- 
2.51.0

