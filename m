Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C4228A402;
	Fri,  6 Jun 2025 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224558; cv=none; b=hmoQ/ibDYqiCVU9ohaY7qk3xXXNxDNMNgrUq5i8vfFgu7U0Bqi7YOPwW2WyMys7txUeZfDSWKG9B9gsD5iUFGmfmpLLvUF++9TZglyKidLVAmIwiVbwTcLxLzqbNHpTwTDSeFzDpDHmSwqljTf3RKpsdChZsy0zlMINi/MkhJck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224558; c=relaxed/simple;
	bh=pe0Vox7dvM7qgbNXuXg0mvM1LrAVccauJE/TpWsszTc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JBokvpFv6UQgn2euKTr/Q1M3P9UQO3MIBZie2+W046KiZoiMWL0IdbmXLofZIi+u/vDXlSM8uOqEXcQU+zfT0BSn/jjeakSThk1WfgihchyYuW5kVIrlkUVKl3f57Ln7IEW8WBvxWfg1Ra4TJdsVWhT4N5ARyIbMGG+JOMg+u8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WZqFg8OF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WZqFg8OF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C020C4CEEB;
	Fri,  6 Jun 2025 15:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224557;
	bh=pe0Vox7dvM7qgbNXuXg0mvM1LrAVccauJE/TpWsszTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZqFg8OFShbxLWJD+IvpmSOT4rBh2b3zwm1i5szSPeYwZ3TmWUfIKzXN3cEIQg32F
	 hII6t1icheN0HXTpU69k9hx4UkB4CgQX8lAjFm7r4wlYv48qk+yBKzw4chzZq4YSm6
	 ZEcKhV6AUfEfNnUS88VR4g56DxESx0xG9GWD8Fk+Sx2aoa/+duzjDBUEX/JAXyWpsI
	 tZ2xT3WyrBL4FIT2OWuU3VhzYqNk0N2W0qL4386WfduwJ6jypk11AQjQfzF8VyS8/6
	 QTZsxJNYb+qGhR6HhbrnjG1ypZxs/7ZV6efjPSgN9aec9i6Z/hbEFGLn2MCF47KgEf
	 pPSCBX2oxAQ7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.14 08/19] mfd: max77541: Fix wakeup source leaks on device unbind
Date: Fri,  6 Jun 2025 11:42:14 -0400
Message-Id: <20250606154225.546969-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154225.546969-1-sashal@kernel.org>
References: <20250606154225.546969-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 6c7115cdf6440e1e2f15e21efe92e2b757940627 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-4-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Perfect! Now I have all the information I need to make a comprehensive
analysis.

**YES**

This commit should be backported to stable kernel trees.

**Extensive Analysis:**

**1. Nature of the Bug:**
The commit fixes a wakeup source memory leak that occurs when the
max77541 MFD device is unbound. The current code in
`max77541_pmic_setup()` at line 155 calls `device_init_wakeup(dev,
true)` to enable wakeup capability, but there's no corresponding cleanup
when the device is removed.

**2. Code Change Analysis:**
The fix replaces:
```c
ret = device_init_wakeup(dev, true);
```
with:
```c
ret = devm_device_init_wakeup(dev);
```

This is a classic resource management improvement. The
`devm_device_init_wakeup()` function (as seen in
`/home/sasha/linux/include/linux/pm_wakeup.h`) automatically registers a
cleanup action via `devm_add_action_or_reset()` that calls
`device_disable_wakeup()` when the device is removed, preventing the
memory leak.

**3. Driver Context:**
- The max77541 driver was introduced in April 2023 (commit e0cbc202388a)
- It's an I2C-based MFD driver for MAX77541/MAX77540 PMICs
- The driver has **no remove function** (line 213-214 shows only
  `.probe` in the driver structure), making this cleanup particularly
  important since only devm-managed resources will be cleaned up
  automatically
- The driver uses devm-managed functions extensively (devm_kzalloc,
  devm_regmap_init_i2c, devm_mfd_add_devices), showing this change fits
  the existing pattern

**4. Comparison with Similar Commits:**
This commit follows the exact same pattern as the "YES" backport
examples:
- **Similar Commit #1 (gpio-mpc8xxx.c)**: Same fix pattern, same wakeup
  leak issue, marked YES for backport with explicit `Cc:
  stable@vger.kernel.org`
- **Similar Commit #2 (gpio-zynq.c)**: Same fix pattern, same wakeup
  leak issue, marked YES for backport with explicit `Cc:
  stable@vger.kernel.org`

The change is identical in nature to these GPIO drivers that were deemed
suitable for stable backporting.

**5. Stable Tree Criteria Assessment:**
- ✅ **Fixes important bug**: Memory leaks affect system stability over
  time
- ✅ **Small and contained**: Single line change, minimal risk
- ✅ **No architectural changes**: Uses existing devm infrastructure
- ✅ **No new features**: Pure bugfix
- ✅ **Minimal regression risk**: devm_device_init_wakeup() is well-
  established and widely used
- ✅ **Clear benefit**: Prevents resource leaks in production systems

**6. Impact and Risk Assessment:**
- **Impact**: Prevents memory leaks when max77541 devices are unbound
  (e.g., module unload, device removal, system suspend/resume cycles)
- **Risk**: Extremely low - the devm framework is mature and this
  pattern is used extensively across the kernel
- **Regression potential**: Minimal - the functionality remains
  identical, just with proper cleanup

**7. Subsystem Considerations:**
The MFD subsystem handles critical power management ICs. Memory leaks in
power management drivers can lead to system instability, especially in
embedded systems where the max77541 PMIC would typically be used.

This is a textbook example of a stable-worthy commit: it fixes a real
resource management bug with a minimal, well-tested change that follows
established kernel patterns.

 drivers/mfd/max77541.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77541.c b/drivers/mfd/max77541.c
index d77c31c86e435..f91b4f5373ce9 100644
--- a/drivers/mfd/max77541.c
+++ b/drivers/mfd/max77541.c
@@ -152,7 +152,7 @@ static int max77541_pmic_setup(struct device *dev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to initialize IRQ\n");
 
-	ret = device_init_wakeup(dev, true);
+	ret = devm_device_init_wakeup(dev);
 	if (ret)
 		return dev_err_probe(dev, ret, "Unable to init wakeup\n");
 
-- 
2.39.5

