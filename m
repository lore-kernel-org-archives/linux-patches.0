Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A435D1F94A;
	Wed,  4 Jun 2025 00:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998554; cv=none; b=RlhB/h/eflQKcPKoO1sqaGUV8e2CjcvSYWNtfwFwlS1DL9D8KRrCrP8qU2aae+khYBgLCyf53io+AIHJfHWP6UuJgnYrFVQBxBAU8Q2qqJFJc2mtgwn/iNbtPoIZWR0x4LAOaebI+yFH0SxwNK+qypeJMmznDmo1tEn7mRX4ahI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998554; c=relaxed/simple;
	bh=MbCy05+s6yxGMHePxDATmg1y10Z8bcxDxDYfo67D3k8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fkub/ukvoeDIw4a1Oy6AIwoymRAuja2bs7sPfgHE5KQ/qvwzt9i7TgDVKlreYJk8aphBmX+p/lQVSshhlhuoE4cOBVzSmypxQqJ341nGflcrw+y3bWZ1E7bZrT9WWMCdEcRNTeBxKcrU0mUFd9aZrZ3JApuX/jiGPwDLgAO8l50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5bC2+H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5bC2+H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E659C4CEF1;
	Wed,  4 Jun 2025 00:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998554;
	bh=MbCy05+s6yxGMHePxDATmg1y10Z8bcxDxDYfo67D3k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5bC2+H1f0bzwfhHDb1B/8+Pk7XmR2dVC6gn8CIXbbMVEQ5RbZxIRzFTX2Qc4sowY
	 +pTpuO3vuLxYQTqWvnF6VK8tyBEvwlMpW3mGJAnOsJsJxvyzPa3X1RVIT09b60sykk
	 aIjk73ncMD8IFRGTP7nRBFP/kq1WD1wJmRr49s+U/3aFpCyXy57eountybjDI82ksN
	 D7kBmtDE+iH0UAQypl0QBq7JtG2yfzFsuao+n1bOyRklk1+Pp6hxZNG+3m+IzMwJgY
	 CO48M+F2MlqmGp/5NGFJGJy+KFbUYSh+EFfYb7qvf7lp8n2jAYYscfdYNPWPDsA7yd
	 VnnIDCR/CRKkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 013/108] Bluetooth: btmrvl_sdio: Fix wakeup source leaks on device unbind
Date: Tue,  3 Jun 2025 20:53:56 -0400
Message-Id: <20250604005531.4178547-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ba6535e8b494931471df9666addf0f1e5e6efa27 ]

Device can be unbound or probe can fail, so driver must also release
memory for the wakeup source.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Analysis of the Commit ### 1. Nature of the
Fix This commit addresses a **resource leak bug** in the btmrvl_sdio
driver. The fix changes `device_init_wakeup(dev, true)` to
`devm_device_init_wakeup(dev)`, which ensures automatic cleanup of
wakeup sources when the device is unbound or probe fails. ### 2. Code
Changes Analysis The specific changes are: ```diff -
device_init_wakeup(dev, true); + ret = devm_device_init_wakeup(dev); +
if (ret) + return dev_err_probe(dev, ret, "Failed to init wakeup\n");
``` This change: - Replaces manual wakeup initialization with device-
managed version - Adds proper error handling for the wakeup
initialization - Ensures automatic cleanup when device is removed or
probe fails ### 3. Comparison with Similar Commits This commit is **very
similar to Similar Commit #3** (gpio: mpc8xxx), which: - Also fixes
wakeup source leaks on device unbind - Uses the same pattern:
`device_init_wakeup()` → `devm_device_init_wakeup()` - Has identical
commit message structure and purpose - **Was marked for backporting
(Status: YES)** The pattern is also similar to **Similar Commit #2**
(btmrvl_sdio: Refactor irq wakeup), which was also backported (Status:
YES) and dealt with wakeup handling improvements. ### 4. Stable Tree
Criteria Assessment ✅ **Fixes important bug**: Resource leaks can cause
system-wide issues ✅ **Small and contained**: Only changes 3 lines in
one function ✅ **No architectural changes**: Uses existing kernel APIs ✅
**Minimal regression risk**: Device-managed resources are well-
established ✅ **Clear side effects**: Only improves resource management
✅ **Affects users**: Anyone using btmrvl_sdio with wakeup functionality
### 5. Risk Analysis **Low Risk Factors:** - `devm_device_init_wakeup()`
is a well-established API - The change follows standard kernel patterns
for resource management - Error handling is improved with proper error
propagation - Similar changes have been successfully backported (as
shown in Similar Commit #3) **No Major Concerns:** - No changes to
critical code paths - No new features introduced - No complex logic
modifications ### 6. Impact Assessment **Positive Impact:** - Prevents
wakeup source memory leaks - Improves system stability during device
unbind/rebind cycles - Follows kernel best practices for resource
management - Adds better error handling **User-Facing Benefit:** -
Systems using btmrvl_sdio devices will be more stable - Proper cleanup
during module unload or device removal - Better error reporting if
wakeup initialization fails ### Conclusion This commit meets all the
criteria for stable backporting: - It's a clear bugfix addressing
resource leaks - The change is minimal and low-risk - It follows
established patterns (identical to Similar Commit #3 which was
backported) - It improves system stability without introducing new
functionality - The fix is contained within a single driver subsystem
The commit should be backported to ensure users don't experience wakeup
source leaks when using btmrvl_sdio devices.

 drivers/bluetooth/btmrvl_sdio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index 07cd308f7abf6..93932a0d8625a 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -100,7 +100,9 @@ static int btmrvl_sdio_probe_of(struct device *dev,
 			}
 
 			/* Configure wakeup (enabled by default) */
-			device_init_wakeup(dev, true);
+			ret = devm_device_init_wakeup(dev);
+			if (ret)
+				return dev_err_probe(dev, ret, "Failed to init wakeup\n");
 		}
 	}
 
-- 
2.39.5

