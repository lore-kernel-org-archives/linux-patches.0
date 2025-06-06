Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6943289811;
	Fri,  6 Jun 2025 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224525; cv=none; b=WhfRUp1om2d3zEHzPJ5SUkW7L+igrpP7+erZoBneKL7z1hYrPUkLKGknM1XSVJ0lQQhM2OMxncmpRZfPLPpkfJ0VDLzmDdTVRZj4gKIGQBcDT666hXMc4PmRUXCv8aox9EEv4135lFFexisi+XAPcm+URFTuRzV1cEDIwN4x9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224525; c=relaxed/simple;
	bh=SbRY+0iVfObEflyC36jSvuSqH1iZLrL+tyKpXAwtp7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zc/h4CdOHbFwoX3vOvqqvirnnMm0hhv6w+7EE97UMTWz/TY1XCZrcdzcb6epYROMKWVM3UPwBk9s3rdxBd4ZE6b9BUGzJQIgnHQof/t6JJEaKBHsYPaxkB1W/D6l66s/hYYkh96AVWrTvQFhWSwiBGmm1Z+aB+TZ4MB0LON5RsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RsAbL3k4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RsAbL3k4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870D2C4CEF4;
	Fri,  6 Jun 2025 15:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224524;
	bh=SbRY+0iVfObEflyC36jSvuSqH1iZLrL+tyKpXAwtp7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsAbL3k465xNPd4MAAKe6j3PkzETk9YMd1n04/qempi4yXvTPmNcoCSCIYR+btkMg
	 8xNHbnI8uQXeGmbCuKT8odoKdHgi+6OMnweJonJnhZ88KXwDt0HAqdLN3+eg24nK2F
	 epf3ep/wM9s7Go9gmvDFs2y8Yq+wyy+ify91IQ6OB1TOcx2wpkBAowvmIlXofoD2S8
	 ePmJ61ubrRcr4vR067sovU1EOUuqRTCQwL+TaY7W7fiNMo9a23bBEyyCHJTawNQ8FN
	 anRPXa/PRnNCPjFoqJmTeD7XDRjrpeInDofG+lzNnX16EXhArP/GW1gxFx1Z8mwQoF
	 nKkXJkdNDT4bA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	orsonzhai@gmail.com
Subject: [PATCH AUTOSEL 6.15 12/21] mfd: sprd-sc27xx: Fix wakeup source leaks on device unbind
Date: Fri,  6 Jun 2025 11:41:37 -0400
Message-Id: <20250606154147.546388-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154147.546388-1-sashal@kernel.org>
References: <20250606154147.546388-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 37ef4aa4039c42f4b15dc7e40d3e437b7f031522 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-8-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

## Resource Leak Analysis

The commit fixes a genuine resource leak in the sprd-sc27xx MFD driver.
When `device_init_wakeup(&spi->dev, true)` is called in the probe
function (line 213), it:

1. **Allocates kernel resources**: Creates wakeup source objects and
   sysfs entries
2. **Sets device capability flags**: Marks the device as wakeup-capable
3. **Registers with PM subsystem**: Adds the device to power management
   tracking

However, the driver **lacks a remove function** to clean up these
resources when the device is unbound.

## Code Change Analysis

The fix changes from:
```c
device_init_wakeup(&spi->dev, true);
```

To:
```c
ret = devm_device_init_wakeup(&spi->dev);
if (ret)
    return dev_err_probe(&spi->dev, ret, "Failed to init wakeup\n");
```

This uses the **managed version** (`devm_device_init_wakeup`) which
automatically calls cleanup when the device is removed, eliminating the
leak.

## Backport Justification

**1. Bug Fix Nature**: This addresses a clear resource leak affecting
production systems with removable devices or driver reloading scenarios.

**2. Minimal Risk**: The change is contained to a single function call
with identical functionality, just with automatic cleanup.

**3. Critical Subsystem**: MFD drivers control PMICs (Power Management
ICs), which are essential for power management and system stability.

**4. Pattern Consistency**: The fix follows the same pattern as the
approved similar commits for gpio drivers (mpc8xxx and zynq), which were
both marked for backporting.

**5. Clear Impact**: Resource leaks in device drivers can accumulate
over time and affect system stability, especially in embedded systems
where this PMIC driver is commonly used.

**6. Small, Contained Change**: The modification is minimal and self-
contained, reducing regression risk.

The commit clearly states the problem, provides a proper solution using
managed resources, and affects a driver commonly used in production
embedded systems where resource leaks can be particularly problematic.

 drivers/mfd/sprd-sc27xx-spi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sprd-sc27xx-spi.c b/drivers/mfd/sprd-sc27xx-spi.c
index 7186e2108108f..d6b4350779e6a 100644
--- a/drivers/mfd/sprd-sc27xx-spi.c
+++ b/drivers/mfd/sprd-sc27xx-spi.c
@@ -210,7 +210,10 @@ static int sprd_pmic_probe(struct spi_device *spi)
 		return ret;
 	}
 
-	device_init_wakeup(&spi->dev, true);
+	ret = devm_device_init_wakeup(&spi->dev);
+	if (ret)
+		return dev_err_probe(&spi->dev, ret, "Failed to init wakeup\n");
+
 	return 0;
 }
 
-- 
2.39.5

