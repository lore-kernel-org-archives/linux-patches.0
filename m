Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977C0289376;
	Fri,  6 Jun 2025 15:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224520; cv=none; b=Om6i2c5nDhRgQrQFGKLHa+XhubgcTyEEsPMARpcLdZSThfun6qvvcQkvAYLTfX+kCsud5rEnNUb9MG5D61MDFuC1T6OvYbjnc67QgcgwhFLkMP+As5TvHzjJddCy9lUvOkS5vTW3N4Yb+NpZQ8LmiitDF78Iirb25eJ0ZXk7La0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224520; c=relaxed/simple;
	bh=cSV2s7RixPkjrBSQuDprrXa/GlT3m+vYjOcot1cKvq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyeM0G4NfQBerS40CB8BMwdRtceqUvvUpJ33l7Yl1lh7uMCFt2fr+M/CvxHioWsny7NZuqWrpdWUHFwUktApY7Pp+568HBBge8iJ47vxx+jsmphdslMDnK4mSbwF7tJA1ZzAdXV62N2cwM5IvcqXPmA+DuNxSDFISL54bblZVyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BoIaFOBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BoIaFOBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E20CC4CEEB;
	Fri,  6 Jun 2025 15:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224520;
	bh=cSV2s7RixPkjrBSQuDprrXa/GlT3m+vYjOcot1cKvq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoIaFOBAaQrEHFuG91nXISJ5LQwWnfty/Zs/y4GSp34JJWmB0pUUTSq0VJm2Y4n8C
	 ypu4ITvJsguB8r69f4sLfbDJ7pZNZt/KvCwttN9NglPPw3aDAMuUPMmgGPl07QMDFO
	 ZenDofBQrxrygo92avNZ7pRk0LB8RVloacQhGctO1FiBSPdsvA0NsH4m274WHZPiVr
	 Y2mtVxuLqHe2zucHmt//dx4ny399/31hD3dbmf6jvVG0TcNJf5LOzEEn85aJ5DT8UD
	 L9uLvrCw2Eds8oXw1USF/3MbZReJsm0hIz+OMVFW5rKf0IUFFT5/PHtUHsVAVdDUaK
	 iZitxlOTx7AwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cw00.choi@samsung.com,
	krzk@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 09/21] mfd: max14577: Fix wakeup source leaks on device unbind
Date: Fri,  6 Jun 2025 11:41:34 -0400
Message-Id: <20250606154147.546388-9-sashal@kernel.org>
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

[ Upstream commit d905d06e64b0eb3da43af6186c132f5282197998 ]

Device can be unbound, so driver must also release memory for the wakeup
source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250406-mfd-device-wakekup-leak-v1-3-318e14bdba0a@linaro.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Now let me understand the difference between the fixes - the historical
commits show two patterns:
1. Using `devm_device_init_wakeup()` - automatically handles cleanup
2. Manual cleanup by calling `device_init_wakeup(dev, false)` in remove
   functions

Let me check if this specific commit has `Cc: stable@vger.kernel.org` in
the message:

Based on my analysis of this commit and comparison with the similar
historical commits, here is my assessment:

**YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Analysis

### **Code Change Analysis**
The commit adds a single line in the `max14577_i2c_remove()` function:
```c
+       device_init_wakeup(max14577->dev, false);
```

This addition occurs at drivers/mfd/max14577.c:459, right before
`mfd_remove_devices()` is called.

### **Bug Fix Characteristics**
1. **Memory Leak Fix**: The commit fixes a wakeup source memory leak
   that occurs when the device is unbound. When `device_init_wakeup(dev,
   true)` is called during probe (line 442), it allocates memory for
   wakeup source structures. Without the corresponding cleanup call,
   this memory is leaked on device removal.

2. **Small and Contained**: The fix is minimal - a single line addition
   that mirrors the cleanup pattern used throughout the kernel.

3. **Low Risk**: The change has extremely low regression risk since it
   only adds proper cleanup that should have been there originally.

### **Comparison with Historical Similar Commits**
Looking at the provided historical commits, there are two categories:

**YES commits (backported)**:
- `gpio: mpc8xxx: Fix wakeup source leaks on device unbind` - Same exact
  pattern and includes `Cc: stable@vger.kernel.org`
- `gpio: zynq: Fix wakeup source leaks on device unbind` - Same exact
  pattern and includes `Cc: stable@vger.kernel.org`

**NO commits (not backported)**:
- IIO driver commits that use `devm_device_init_wakeup()` instead of
  manual cleanup

The key difference is that the YES commits use the same fix pattern as
this MFD commit - manual cleanup in the remove function, while the NO
commits use the `devm_` managed approach that automatically handles
cleanup.

### **Impact Assessment**
- **User Impact**: Memory leaks on device unbind affect systems where
  MFD devices are frequently bound/unbound
- **Subsystem**: MFD (Multi-Function Device) is a core kernel subsystem
  used by many embedded systems
- **Regression Risk**: Minimal - adding proper cleanup cannot cause
  functional regression

### **Stable Tree Criteria Met**
1. ✅ Fixes an important bug (memory leak)
2. ✅ Small and contained change
3. ✅ No architectural changes
4. ✅ Minimal risk of regression
5. ✅ Follows established patterns seen in other backported commits

The commit follows the exact same pattern as the GPIO driver commits
that were successfully backported to stable trees (commits #1 and #2 in
the historical examples), making it a clear candidate for backporting.

 drivers/mfd/max14577.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 6fce79ec2dc64..7e7e8af9af224 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -456,6 +456,7 @@ static void max14577_i2c_remove(struct i2c_client *i2c)
 {
 	struct max14577 *max14577 = i2c_get_clientdata(i2c);
 
+	device_init_wakeup(max14577->dev, false);
 	mfd_remove_devices(max14577->dev);
 	regmap_del_irq_chip(max14577->irq, max14577->irq_data);
 	if (max14577->dev_type == MAXIM_DEVICE_TYPE_MAX77836)
-- 
2.39.5

