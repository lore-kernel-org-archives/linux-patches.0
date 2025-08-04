Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88D52A1AA;
	Mon,  4 Aug 2025 00:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267883; cv=none; b=s2mA4VklCqSPZd/wmO9HAbvGdhx7NgJ6XfmP40iP1Z5vDijj7HpCWV2xUhkMyljv7kl3i0/QmWKrouQEHyi98S2iAlrFcHjDypBHYLX1eycp335Gm+AV/FGbRFGrBaXffvAjqSN8kayPfOmm9/Mk19I29hwAmf5tUPDL8njqHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267883; c=relaxed/simple;
	bh=XRJt11bek56Xpcbi3Da9OAYJZm5UOeRti/JjuMKh7FQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ayu0NQW1ci8W5qNb5NBWcrk/RnyszSaougfLvyAenU65OUDzShXJUn/ian8NKtp28ZRFqSYlkt9bnr6be5blECvACxXaL5rOjq0jF1WNAYCbp4TkeRGeJZHXqMGTx9Ja5FfvuqV8I/rVUtOW0y6adXn3mTH81yjBCqPzSQ3spJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRU1zFVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRU1zFVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1065DC4CEF0;
	Mon,  4 Aug 2025 00:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267882;
	bh=XRJt11bek56Xpcbi3Da9OAYJZm5UOeRti/JjuMKh7FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRU1zFVocop4kr9N9SXkSdeT4OPW1Zk956UVq6BXRvScEF7lLhVCDWvHPll7BMOCf
	 7MVssvx/nJxAJq9IQB5zRGQrkGFuMoql+Bo6qhy1PN71wKjmtbUa162xZtq9ftwN3c
	 5CAmIdTgG7y7xZYFXOmhyA/kVCFwe7/qGNrCAB2XT9CkjZfC7rns48ukpf8ytdjk0W
	 MP2+/GCFjfPcofkAZ/FXvrj+XhzTSUi0M8v2oNwOMB2zkiT4dGkHRCb6k1SViUzUo2
	 Y4EG24ba9rjnFU4GQuy+hi/nfFP/AHANAmHpIMXWC+xGC5R5lfUWsU8/lHuPspxzpR
	 Cuwy/w+UbUbcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
	Avri Altman <avri.altman@sandisk.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	zhoubinbin@loongson.cn,
	wsa+renesas@sang-engineering.com,
	viro@zeniv.linux.org.uk,
	nathan@kernel.org,
	u.kleine-koenig@baylibre.com
Subject: [PATCH AUTOSEL 6.1 34/51] mmc: rtsx_usb_sdmmc: Fix error-path in sd_set_power_mode()
Date: Sun,  3 Aug 2025 20:36:26 -0400
Message-Id: <20250804003643.3625204-34-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804003643.3625204-1-sashal@kernel.org>
References: <20250804003643.3625204-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.147
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
index 2c650cd58693..c5a6bbc06953 100644
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

