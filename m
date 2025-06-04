Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619691F5F6;
	Wed,  4 Jun 2025 00:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998271; cv=none; b=MzidBOcLzELlXrJFKadmdVxa6AObc3WB29Z3xTCZR9bnJck/mNFMpjOThkt1RSEJDz6PccLoFglqHAgCb1x9f9k7s2fjsRyTqzeEUeIVxIRNQXKWpGoGJ6Adxg4HJRmOHpXsLFtrOnsZSwxn26kPcU7po3ZbxnKfSdlsNE+37rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998271; c=relaxed/simple;
	bh=MbCy05+s6yxGMHePxDATmg1y10Z8bcxDxDYfo67D3k8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXTqwSTxQcqn0Jm3N3wU3hwDp3vcMjHhLA2J2Mge3T/Ho4Y4N5AiA7hLxONCXJWZx+CGZnNL90BgpDQVirXKNHw0v+Z/BhKT9luS3aLwPYVKHifKENirnReQ+Ugw8fsPSGlzJHltozZ27pRnKrsO3LRg8KRNTxNirrlKV2Y54MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LepfBdwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LepfBdwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F16C4CEF1;
	Wed,  4 Jun 2025 00:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998271;
	bh=MbCy05+s6yxGMHePxDATmg1y10Z8bcxDxDYfo67D3k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LepfBdwvdZgQXPjnvAdIFAG8Q3fZxcbCH1ZOba3jeOttYZv40v7C2V888WbVi978z
	 zYY7VrrfkLEe1aGhP2K0wSn8FZcjA9FNvmra7V6774S0EUWSZgoVS6VIanY0trMIn6
	 Jb3VQRtPLyogXafU5/PO3VQIxYSttdK//8hgpj7to64g2Cey6tKx+ZImANmSQNIu8c
	 wYWbsjMdfKVodHTx6CIm8Mo61otdFIVirAm1lzs7rL3pTFza8luhvfLm4BVH75tccL
	 5Lq+k0sOtZgOgGGhPPppeSzgnFTP6gBj8nnL4ny9Hg2zHzOlkbdJxo43UJrpVX76ZE
	 YlQEDTNsXsONA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 013/118] Bluetooth: btmrvl_sdio: Fix wakeup source leaks on device unbind
Date: Tue,  3 Jun 2025 20:49:04 -0400
Message-Id: <20250604005049.4147522-13-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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

