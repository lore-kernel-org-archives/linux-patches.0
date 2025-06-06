Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EDF28A41E;
	Fri,  6 Jun 2025 15:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224560; cv=none; b=nvvz4eGbpNqmO6mCA/Q/DFtiiTDct1bR5LRvO/bcfq6ciUXrpv6HgoImqshfBfyPgnVnqqRdclT7jYkDVhb5lVx4tdprqWhPrkftUj1Y5hIFh4r/E2fGAMqSGm0ZCEC2Pe9AcLauMid4F05IKDe1J/WFJB3YeRiuagsiRRtToBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224560; c=relaxed/simple;
	bh=v12Z9mNjd8kuM3bbE8OGtgZhNK+oeG0XPTkTyTLEkBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dzCVK9zGtWIySPsu6fCxsBEi+KZUlCqoXS43I73JxfbVJt0IZ362BSWTZgStQ488FAM5LdaB6ZKTn9NwNZboimbmGTuer2fLZlVz/uge8/I6tFfiRwLkSLQ/88w3sXWli0jJxpXbiatSI9bmlJhn2RKINUkgAfDeKT9z91cKG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVzFOXio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVzFOXio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901A2C4CEF1;
	Fri,  6 Jun 2025 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224560;
	bh=v12Z9mNjd8kuM3bbE8OGtgZhNK+oeG0XPTkTyTLEkBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVzFOXionPqX+DKnaAK2hoPk+CjBr76YxGBHcc1lk8zvDJ3JJBC/2sw2DqOQxbPU0
	 Bx150zqIXM2qKbxU4IDyC5eS+Ymk1fc4QN3MEWj8J+rHapiAu9BqEtgfw9jzM2EshT
	 4Q3c4xG2yJcO2Hg1EflnlCoizFxrGsLMYTQ1f0Khs2QFMHYO23ppNtEC5Tfd1jpGli
	 tOeHD1p4mZgQlC6jN7ZbQN9RdM8gR/q9H1O9kVtDHA0/lPyiAl0qLJKt2EpCFABjh6
	 Wji7QZPeNjFW4y2D4A6tklBE2VXnPRubVEqBZvmKz7KFpt/ZAS0AKmOI1A9mZ9IPwN
	 sB1PcfKpXKwzQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Karel Balej <balejk@matfyz.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.14 10/19] mfd: 88pm886: Fix wakeup source leaks on device unbind
Date: Fri,  6 Jun 2025 11:42:16 -0400
Message-Id: <20250606154225.546969-10-sashal@kernel.org>
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

[ Upstream commit 6d0b2398b2638208d68ba06601f776cd5d983b75 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Karel Balej <balejk@matfyz.cz>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-1-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees based on the
following analysis:

## Code Change Analysis

The commit changes lines 127-128 in `drivers/mfd/88pm886.c` from:
```c
device_init_wakeup(dev, device_property_read_bool(dev, "wakeup-
source"));
```

To:
```c
if (device_property_read_bool(dev, "wakeup-source")) {
    err = devm_device_init_wakeup(dev);
    if (err)
        return dev_err_probe(dev, err, "Failed to init wakeup\n");
}
```

## Why This Should Be Backported

**1. Clear Bug Fix**: This fixes a definitive memory leak where wakeup
source memory is not properly freed when the device is unbound. The
`device_init_wakeup()` function allocates memory that requires manual
cleanup, while `devm_device_init_wakeup()` uses the device-managed
resource framework to automatically clean up.

**2. Matches Successful Backport Pattern**: This change follows the
exact same pattern as Similar Commits #1 and #2 (gpio drivers) which
were marked "Backport Status: YES". The fix uses identical methodology -
replacing `device_init_wakeup()` with `devm_device_init_wakeup()` and
proper error handling.

**3. Low Risk, High Benefit**:
   - **Risk**: Minimal - only affects error handling path and uses well-
     established devm pattern
   - **Benefit**: Eliminates memory leak without changing functional
     behavior
   - **Size**: Small, contained change with no architectural
     implications

**4. Stable Tree Compliance**:
   - ✅ Fixes important bug (memory leak)
   - ✅ No new features introduced
   - ✅ No architectural changes
   - ✅ Minimal regression risk
   - ✅ Confined to single driver

**5. Critical System Impact**: The 88PM886 is a Power Management IC used
in embedded devices. While not immediately critical, memory leaks in
power management components can accumulate over time in long-running
embedded systems.

**6. Consistent with Kernel-wide Effort**: The commit is part of a
broader kernel-wide cleanup to fix wakeup source leaks, with similar
fixes already being backported to stable trees across multiple
subsystems (GPIO, IIO, etc.).

The change is technically sound, follows established patterns, and
addresses a real resource leak with minimal risk - making it an ideal
candidate for stable tree backporting.

 drivers/mfd/88pm886.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/88pm886.c b/drivers/mfd/88pm886.c
index 891fdce5d8c12..177878aa32f86 100644
--- a/drivers/mfd/88pm886.c
+++ b/drivers/mfd/88pm886.c
@@ -124,7 +124,11 @@ static int pm886_probe(struct i2c_client *client)
 	if (err)
 		return dev_err_probe(dev, err, "Failed to register power off handler\n");
 
-	device_init_wakeup(dev, device_property_read_bool(dev, "wakeup-source"));
+	if (device_property_read_bool(dev, "wakeup-source")) {
+		err = devm_device_init_wakeup(dev);
+		if (err)
+			return dev_err_probe(dev, err, "Failed to init wakeup\n");
+	}
 
 	return 0;
 }
-- 
2.39.5

