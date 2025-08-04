Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A621BD01D;
	Mon,  4 Aug 2025 00:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268102; cv=none; b=WFG6Q+2xAPhIQeViMcnOtP/yj4mqyRLvzAWSY6tBqi9KubKZ1IiKfp0tE4T5eWNRzc9yfG5UdxUf9gzz4uE/pbxvD2nwOEsf+kr0e/oaniA+b5zWBmDP6VkihZtKxsNM9unlcJ8WYqF547pYOpx9jRkOhZXAuqxhGrZzpNxJW78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268102; c=relaxed/simple;
	bh=NBfkoVspTHZgH1II3lTp35ypMdHlo7/HLcXJdZrIzsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MaMYeg+1Il82bSNjDvWeLdR7fz3prlH6rIdqDK/MYlCbJfTq2ZkXKtpJTjiRPLFzS2SxvqFOwA5UQ977prBE7qkI8Og8qqaLGlU/uIlcyN+a+dJHW6LhUWwQoE7ofijTSg+6iB73s/3LS7yXc12ay1JeEu68hUnpyQjSQKhugEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S880jAq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S880jAq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF721C4CEF0;
	Mon,  4 Aug 2025 00:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268102;
	bh=NBfkoVspTHZgH1II3lTp35ypMdHlo7/HLcXJdZrIzsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S880jAq0uUsvyMVBVoBqxXKmkmffpqpen/Mz+eDp2HNQxEgI8fSYUYqdgtjXtWpnQ
	 vErgyV0vYAG+07IAJWX7XatJRuRgd1TLAnG/ORTLaOjNk0M2BZfqgWMGm/KAoKBnn1
	 oNwksqM6uVDXnMV4OCUbyAVvfrUp/NEjSf2V9w5BO8SRe59uv9w5FqdY3J+Pg9iQel
	 7p+t7lNwG4wMrkZ11BLCVdp4ZCymqfZe63c4omg17NERz3qmoIZ1OJP7I9rR1KOiJC
	 CQJ9QqyZf5RtSmPKtvjTW2pzZjO7H2p45DkCoS7t1HtgY3URqUyyv+C6WnPND4SCYa
	 oa3aiw93gOJBg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	wsa+renesas@sang-engineering.com,
	u.kleine-koenig@baylibre.com,
	viro@zeniv.linux.org.uk,
	zhoubinbin@loongson.cn,
	nathan@kernel.org
Subject: [PATCH AUTOSEL 5.10 24/39] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Sun,  3 Aug 2025 20:40:26 -0400
Message-Id: <20250804004041.3628812-24-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004041.3628812-1-sashal@kernel.org>
References: <20250804004041.3628812-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.240
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit 47a255f7d2eabee06cfbf5b1c2379749442fd01d ]

In the error path of sd_set_power_mode() we don't update host->power_mode,
which could lead to an imbalance of the runtime PM usage count. Fix this by
always updating host->power_mode.

Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Ricky Wu <ricky_wu@realtek.com>
Link: https://lore.kernel.org/r/20250610111633.504366-2-ulf.hansson@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Bug Analysis

The commit fixes a **runtime PM reference counting bug** in the
`sd_set_power_mode()` function. The issue is in the error handling path:

### Original Code Problem:
```c
if (power_mode == MMC_POWER_OFF) {
    err = sd_power_off(host);
    pm_runtime_put_noidle(sdmmc_dev(host));
} else {
    pm_runtime_get_noresume(sdmmc_dev(host));
    err = sd_power_on(host);
}

if (!err)
    host->power_mode = power_mode;  // Only updated on success
```

### The Bug:
1. When transitioning to `MMC_POWER_OFF`, the code calls
   `pm_runtime_put_noidle()` **regardless** of whether `sd_power_off()`
   succeeded
2. When transitioning to `MMC_POWER_ON`, the code calls
   `pm_runtime_get_noresume()` **before** calling `sd_power_on()`
3. However, `host->power_mode` is only updated if there's no error

This creates a **runtime PM reference count imbalance** because:
- If `sd_power_off()` fails, the runtime PM reference is still
  decremented, but `host->power_mode` remains at its previous value
  (likely `MMC_POWER_ON`)
- If `sd_power_on()` fails, the runtime PM reference is still
  incremented, but `host->power_mode` remains at its previous value
  (likely `MMC_POWER_OFF`)
- The early return check `if (power_mode == host->power_mode)` at the
  beginning of the function will prevent future attempts to fix the
  power state, leaving the runtime PM count permanently imbalanced

## Why This Is Suitable for Stable:

1. **Fixes a real bug**: Runtime PM reference count imbalances can lead
   to:
   - Device staying powered when it should be suspended
   - Device being suspended when it should be active
   - Power management failures
   - Potential system hangs or crashes

2. **Minimal change**: The fix is a simple one-liner that always updates
   `host->power_mode` regardless of error status

3. **Low regression risk**:
   - The change doesn't introduce new functionality
   - It doesn't alter the control flow
   - It simply ensures state consistency

4. **Clear bug fix**: This is not a feature addition or optimization -
   it's fixing incorrect error handling that violates runtime PM rules

5. **Affects users**: This bug can manifest in real-world scenarios when
   SD card power operations fail, particularly with flaky hardware or
   during system stress

6. **Subsystem contained**: The fix is limited to a single MMC host
   driver and doesn't affect core kernel infrastructure

The commit follows stable kernel rules by being a minimal, targeted fix
for a real bug that can affect system stability and power management.

 drivers/mmc/host/rtsx_usb_sdmmc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/host/rtsx_usb_sdmmc.c b/drivers/mmc/host/rtsx_usb_sdmmc.c
index 1be3a355f10d..ab7023d956eb 100644
--- a/drivers/mmc/host/rtsx_usb_sdmmc.c
+++ b/drivers/mmc/host/rtsx_usb_sdmmc.c
@@ -1032,9 +1032,7 @@ static int sd_set_power_mode(struct rtsx_usb_sdmmc *host,
 		err = sd_power_on(host);
 	}
 
-	if (!err)
-		host->power_mode = power_mode;
-
+	host->power_mode = power_mode;
 	return err;
 }
 
-- 
2.39.5

