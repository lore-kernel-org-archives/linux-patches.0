Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D719313B788;
	Mon,  9 Jun 2025 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749476684; cv=none; b=tYGiWZuLHSi42hkx8ZQGc0Q2GVD4nCO4pp+NoiUFu/15N09g0vr69H8Gh5sBEISIi4cSptsMwDO0WXUTwDCBkB8z8BOAZc9yHSapyhr2H4DFNOMrYIBETb7Wvz84kRlqQBIdc3FnSyDBxp84FxfE3f2Dmp6vuG6PcR+nRbgV704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749476684; c=relaxed/simple;
	bh=gFZT/IpN0NPWElZthO194zhcbMHS5G1mfW6krDuYoW0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tx1mfWuo9ZYfwKhVTN0ChwAReMs/rrUVFDHPUCXtxkZE6DOxcPqnQJ7UYmsJzEZhN4skLqnEphSnzvKU2M/r2mR/o3OwSXYJ1PIU7dF5i2670DQxT7xiFuYgg7wW9NkXrkkERrBrJvverXvA8Cb3JMC3LygqyiT4P8T26pd6Lfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChVKVPOo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChVKVPOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820EFC4CEEB;
	Mon,  9 Jun 2025 13:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749476684;
	bh=gFZT/IpN0NPWElZthO194zhcbMHS5G1mfW6krDuYoW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChVKVPOoHJ4Cq/j6PdCX9vJvaqHlFuIkRFXiHO0Wb0/mS+S5c/X3Z4PfWcXo5ghI9
	 peyMrCDxJlBpgWa/t54ifOmC7K+dGNVHgKq7eXEr5y5ctVTitW96uW0MOYl7sEpRRo
	 86E3qTEI89de3PcKQP6D+EoOGkoFcTfNFEvaXP8QeC6AP4cxaaKZ15Gob3Vs6/Vd5m
	 jyK3LjtkbOPvh+VdbhlJfjcqpiCn7ssCmtgBauKoWRFhrC503XhYOW663BnxreVSbX
	 CaDYpE21Dx4XuDpIGYiHKSZrLs1FfQOUcI7hCcQvZKBSUhAR0Ta5ux1WGuqk40ntYX
	 5Y9Mq/k3CZRFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Heidelberg <david@ixit.cz>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>,
	andy@kernel.org,
	dlechner@baylibre.com,
	clamor95@gmail.com
Subject: [PATCH AUTOSEL 6.15 22/35] iio: light: al3000a: Fix an error handling path in al3000a_probe()
Date: Mon,  9 Jun 2025 09:43:38 -0400
Message-Id: <20250609134355.1341953-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250609134355.1341953-1-sashal@kernel.org>
References: <20250609134355.1341953-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Heidelberg <david@ixit.cz>

[ Upstream commit c0461f8e842495041c18b2c67647501d55c17441 ]

If regmap_write() fails in al3000a_init(), al3000a_set_pwr_off is
not called.

In order to avoid such a situation, move the devm_add_action_or_reset()
which calls al3000a_set_pwr_off right after a successful
al3000a_set_pwr_on.

Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20250402-al3010-iio-regmap-v4-2-d189bea87261@ixit.cz
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me analyze the commit thoroughly:

## Analysis

**YES**

This commit should be backported to stable kernel trees. Here's my
detailed analysis:

### 1. **Bug Fix Nature**
This commit fixes a clear resource management bug in the error handling
path. Looking at the code changes:

**Before the fix (problematic code flow):**
```c
static int al3000a_init(struct al3000a_data *data)
{
    ret = al3000a_set_pwr_on(data);  // Enables regulator + device
    if (ret)
        return ret;

    ret = regmap_write(data->regmap, AL3000A_REG_SYSTEM,
AL3000A_CONFIG_RESET);
    if (ret)
        return ret;  // BUG: Power stays on if this fails

    return regmap_write(data->regmap, AL3000A_REG_SYSTEM,
AL3000A_CONFIG_ENABLE);
    // BUG: Power stays on if this fails too
}
```

**After the fix:**
```c
static int al3000a_init(struct al3000a_data *data)
{
    ret = al3000a_set_pwr_on(data);
    if (ret)
        return ret;

    ret = devm_add_action_or_reset(dev, al3000a_set_pwr_off, data);
    if (ret)
        return ret;  // Now power gets turned off automatically

    ret = regmap_write(data->regmap, AL3000A_REG_SYSTEM,
AL3000A_CONFIG_RESET);
    if (ret)
        return ret;  // Power automatically cleaned up by devm

    return regmap_write(data->regmap, AL3000A_REG_SYSTEM,
AL3000A_CONFIG_ENABLE);
}
```

### 2. **Resource Leak Impact**
This fixes a resource leak where:
- The regulator remains enabled if `regmap_write()` operations fail
- The device remains powered on unnecessarily
- This can affect power management and battery life on portable devices
- Could potentially cause issues for subsequent probe attempts

### 3. **Pattern Consistency**
Examining the similar commit #1 (al3010 driver) with "Backport Status:
YES", this fix follows the exact same pattern:
- Both fix resource management in error paths
- Both move `devm_add_action_or_reset()` immediately after power-on
- Both ensure cleanup happens automatically if subsequent operations
  fail
- Both are minimal, targeted fixes

Looking at `/home/sasha/linux/drivers/iio/light/al3010.c:93-97`, I can
see the al3010 driver already implements this pattern correctly,
confirming this is the established best practice.

### 4. **Minimal Risk Assessment**
- **Change scope**: Very limited, only affects error handling in probe
  path
- **No functional changes**: Normal operation flow remains identical
- **No architectural changes**: Just moves existing cleanup code earlier
- **Backward compatible**: No API or behavior changes for successful
  cases

### 5. **Stable Tree Criteria Compliance**
✅ **Important bugfix**: Fixes resource leak affecting all users of this
driver
✅ **Minimal risk**: Change is very small and well-contained
✅ **No new features**: Pure bug fix
✅ **Confined to subsystem**: Only affects IIO light sensor driver
✅ **Clear side effects**: Only positive effect (proper resource cleanup)

### 6. **User Impact**
- Affects any system using the AL3000A ambient light sensor
- Resource leaks can accumulate over time with repeated probe failures
- Power management improvements are important for embedded/mobile
  systems

### 7. **Historical Context**
The similar commit reference #1 for al3010 driver shows this exact same
pattern was deemed worthy of backporting, establishing precedent for
these types of resource management fixes in IIO light drivers.

This commit fits all the criteria for stable backporting: it's a clear
bugfix, has minimal risk, follows established patterns, and improves
system reliability without introducing new features or architectural
changes.

 drivers/iio/light/al3000a.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/al3000a.c b/drivers/iio/light/al3000a.c
index e2fbb1270040f..6d5115b2a06c5 100644
--- a/drivers/iio/light/al3000a.c
+++ b/drivers/iio/light/al3000a.c
@@ -85,12 +85,17 @@ static void al3000a_set_pwr_off(void *_data)
 
 static int al3000a_init(struct al3000a_data *data)
 {
+	struct device *dev = regmap_get_device(data->regmap);
 	int ret;
 
 	ret = al3000a_set_pwr_on(data);
 	if (ret)
 		return ret;
 
+	ret = devm_add_action_or_reset(dev, al3000a_set_pwr_off, data);
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to add action\n");
+
 	ret = regmap_write(data->regmap, AL3000A_REG_SYSTEM, AL3000A_CONFIG_RESET);
 	if (ret)
 		return ret;
@@ -157,10 +162,6 @@ static int al3000a_probe(struct i2c_client *client)
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to init ALS\n");
 
-	ret = devm_add_action_or_reset(dev, al3000a_set_pwr_off, data);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to add action\n");
-
 	return devm_iio_device_register(dev, indio_dev);
 }
 
-- 
2.39.5

