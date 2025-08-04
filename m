Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5E1F1527;
	Mon,  4 Aug 2025 00:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267999; cv=none; b=WoVEKuMoZzFWDHDqaJA8H7JUA+D6AoZib8LM3X6fCC7ZEM7J6E8GAFtj+/Upr9nIWYXNR98yMSwE9UOzDmjfgVnCQvSbr99ixwrzgWPrd1FEgbBCyHId0UWIgnj5el2plCnTnrrH8B+gLeSUpofJsgu9vxgd8ew6Ugc89pEn2H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267999; c=relaxed/simple;
	bh=NBfkoVspTHZgH1II3lTp35ypMdHlo7/HLcXJdZrIzsY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bFYZYLfhaoWUFP79IdSYkDxsW9Hyz2IAHW1LLfpbrvNa7uBH+FGhm7AfIiuKMp6Oq84+U8FycsG5H8bBMI6CVVQfkdYrPSmsgSzkfrgm85WYLSwa2Ev6jvseFNrStPCeWozmR3fGJhwgxcZSrPbDo744U0yOl3tSVzDPrf6wcJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HEd9EG2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HEd9EG2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9381EC4CEF0;
	Mon,  4 Aug 2025 00:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267999;
	bh=NBfkoVspTHZgH1II3lTp35ypMdHlo7/HLcXJdZrIzsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEd9EG2SG7YqfIqRJKvX7rXKmqRk71g5417AOmHgtGVj/4h5c0dVUd9L70ghiU5y1
	 ZtaECJDEMc76kmiuOnQtgD5taWZG3P/RFQpcITGfh7KHkQRQgYHfqQHOE3+1AO2M1x
	 aPwP83XUzGEqm4W1C6xEUHAgB/Z4oWUN5lK9BXAWxrc2Nk8fqrvFGQFo7q62wrK/+M
	 toP6ynxbWh5f1k5eGqugMNL8cvGTaiFzvVQdvNYZqfDl+6Vs+nX7S1RSi5eJE0Mvaq
	 PZggRxcrtPsOKDuNdIEk4thB03OwKp1UgobScjQeqqBQFuWrzhIf9HubQzJ4y5/YxL
	 2/6i4qnOAik0A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	zhoubinbin@loongson.cn,
	u.kleine-koenig@baylibre.com,
	nathan@kernel.org,
	viro@zeniv.linux.org.uk
Subject: [PATCH AUTOSEL 5.15 29/44] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Sun,  3 Aug 2025 20:38:34 -0400
Message-Id: <20250804003849.3627024-29-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003849.3627024-1-sashal@kernel.org>
References: <20250804003849.3627024-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
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

