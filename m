Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D86A28A1C4;
	Fri,  6 Jun 2025 15:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224523; cv=none; b=j0YG7hIV52es/CJBRmXkn06Ep9CKc2ZDeBR/Jl8lJXS57FTjpOenOzx+lwFvGyftoL3aCCQ787w2f7j6Hc63b5Du9HxYCb6Nh4+YJ1r88srb5uNPn0sPDMjLxUAJQ2Zxrou4cI0+22DHb0Tf0GY8jAQwAmbAsmnkGGcLTA6N1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224523; c=relaxed/simple;
	bh=v12Z9mNjd8kuM3bbE8OGtgZhNK+oeG0XPTkTyTLEkBY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OuXXxNEAv/bRqSXBQ7G3yX35rrgpfFQyuDSCpHFbwdpyJeYBhRYVPHS3AqernuxNxJgLjsG+QjE9P8f+8M/lJwz2MYOBFgtS6XSi+Op7wYfg/b/rPXJ29yuF85SP504g9qXt25TvLi5b2MOXuPVKl5EEXLak8uglFGUWOFH2iRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adOSqBQA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adOSqBQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56AC4C4AF0E;
	Fri,  6 Jun 2025 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224523;
	bh=v12Z9mNjd8kuM3bbE8OGtgZhNK+oeG0XPTkTyTLEkBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adOSqBQAKo/qj4JRskVlBBMkqsh1AcxykhoXxRYgr+pb8E4nJtU+4EoOeTJzHvCoA
	 BfhWOUfGX4H1sbL4k4eN2/EvjEPiNF9f1+q557h9md5rfyM8meqnRaiEx4e2eRXPA3
	 6F8p4jE3s8kr+diBW03kEkhaaaZlyAdcjnP/ZSVVIu2bbd8PaPwmhK+Z6mRqzoKcDI
	 8JXmRdPi28xTnAaDUCInjKWY5+bjpQe4Uu/7ASBcMyb2IVs5IJADpNgqsNYLDKbOA3
	 ZNRkrOntClL+V1HSZQUU1VoLKI9uKN/j4lbksFucWr0ia6a7vfcWVlxKH13WmvDi2C
	 hTfnXKT4Axvpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Karel Balej <balejk@matfyz.cz>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.15 11/21] mfd: 88pm886: Fix wakeup source leaks on device unbind
Date: Fri,  6 Jun 2025 11:41:36 -0400
Message-Id: <20250606154147.546388-11-sashal@kernel.org>
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

