Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB1A17C77;
	Tue, 17 Feb 2026 01:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771290081; cv=none; b=cyarXv8Ko/eJz3OETe1aLv2n35jWF4qDnH4fGJclTowz0/WyyFb9keqAihr/AnXHYDp+hSwkx+DYs2cnRu+KTpbrveM7m1svOxge7vzO97pp4HrhMQpDN31lYNIDCOIuhxwfQIQ0a4WKc1nzdZGEJe0g9b74THxSo/IfACfxrro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771290081; c=relaxed/simple;
	bh=zu+6+bYRrKvVpVeMt3FoPRQqWS+069PP7MlrY5geJFk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FNOJNYOkHSG1yaHyy8l5YUyYtBee8SHJBjlvoiWkKu7XjeF3BG+NCq2WOiq4uaVq26EHiLXeoEL7Y75I39dCz9nHy8SmWytNvy6DXksMMvNPbZTve9c5JZTcEf+ZUCp3UxXVHdTobTrq/N/IElAYFikdjvTarMFXQ+ts2OSRHc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g6LDH9f0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g6LDH9f0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B239BC116C6;
	Tue, 17 Feb 2026 01:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771290080;
	bh=zu+6+bYRrKvVpVeMt3FoPRQqWS+069PP7MlrY5geJFk=;
	h=From:To:Cc:Subject:Date:From;
	b=g6LDH9f0gvlMLgfjpDKgIi9BkVwXGtiXA6prigsBZVk/Yd6sxNxirYTbAsZSURHAU
	 jOx4nKMZ3GmEIC4sLyXuEyWRN9xtP4aVN/inCPiP2PUkwEMtrfzGLzeoxR8B7istGu
	 k+F6c/zeI3Ed8XYggnBNB6haOJaXbDmzD1ox5kKoSxgk0bO3/858y/I6CSikg1+7aZ
	 xf0zaYEwpsTLdGLIy44P3ul41tGlm5h2ekcQDzTCWVYyvy0doHuN0rXD8Ck3Y4rjji
	 S0a3DPC7+QxvEfk10LfMyabIZgQ8gsZ/h6dy/OWOlBRrXXVQ5Y+/f/3ZGSeAwrP5eF
	 xxtZB8RAHOvCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Masney <bmasney@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>,
	mturquette@baylibre.com,
	sboyd@kernel.org,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] clk: microchip: core: correct return value on *_get_parent()
Date: Mon, 16 Feb 2026 20:01:12 -0500
Message-ID: <20260217010118.3503621-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 5df96d141cccb37f0c3112a22fc1112ea48e9246 ]

roclk_get_parent() and sclk_get_parent() has the possibility of
returning -EINVAL, however the framework expects this call to always
succeed since the return value is unsigned.

If there is no parent map defined, then the current value programmed in
the hardware is used. Let's use that same value in the case where
-EINVAL is currently returned.

This index is only used by clk_core_get_parent_by_index(), and it
validates that it doesn't overflow the number of available parents.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512050233.R9hAWsJN-lkp@intel.com/
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://lore.kernel.org/r/20251205-clk-microchip-fixes-v3-2-a02190705e47@redhat.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The driver was introduced in 2016, around v4.7. This is very old code
that has been in all stable trees.

## Bug Classification

This is a **type mismatch bug** where a signed error code (`-EINVAL`,
which is -22) is returned from a function with unsigned `u8` return
type. The framework API (`struct clk_ops.get_parent`) is defined as
returning `u8`.

When `-EINVAL` is returned as `u8`:
- It becomes 234 (0xEA) due to unsigned truncation
- This gets passed to `clk_core_get_parent_by_index()` which checks
  bounds (`index >= core->num_parents`)
- Since 234 is almost certainly larger than the number of parents, it
  returns NULL
- This means the clock has no parent set, which could cause
  initialization failures or wrong clock behavior

The fix replaces the `-EINVAL` return with returning the raw hardware
register value `v`, which is what the function already does when
`parent_map` is NULL. This is a sensible fallback - if the parent map
doesn't contain the hardware value, use it directly (as if there's no
map).

## Risk Assessment

**Very low risk:**
- The change is small and contained (two functions, same pattern)
- The logic change is straightforward: instead of returning an invalid
  value on the "no match found" path, return the hardware register value
- The fix is reviewed by the subsystem maintainer (Claudiu Beznea)
- The code only affects Microchip PIC32 clock driver - very narrow scope
- `clk_core_get_parent_by_index()` still performs bounds validation on
  the returned value

**Benefit:**
- Prevents incorrect clock parent resolution on Microchip PIC32
  platforms
- Fixes a real type mismatch bug that was caught by static analysis
  tools
- The bug has existed since the driver was introduced (~v4.7), so all
  stable trees are affected

## Verification

- **Verified:** `struct clk_ops.get_parent` returns `u8` (confirmed in
  `include/linux/clk-provider.h`)
- **Verified:** `clk_core_get_parent_by_index()` bounds-checks the index
  against `num_parents` and returns NULL for out-of-range
- **Verified:** `__clk_init_parent()` calls `.get_parent()` and passes
  result to `clk_core_get_parent_by_index()`
- **Verified:** `-EINVAL` is -22, which truncated to `u8` becomes 234
  (0xEA), which would exceed any realistic parent count
- **Verified:** The driver was introduced in 2016 (commit
  ce6e118846599), so the bug exists in all stable trees
- **Verified:** Reported by kernel test robot and Dan Carpenter (well-
  known static analysis reporters)
- **Verified:** Reviewed-by from Claudiu Beznea (subsystem maintainer)
- **Verified:** The fix simply uses the raw hardware value `v` as
  fallback, which is what the function already returns when `parent_map`
  is NULL

## Conclusion

This commit fixes a real bug where two clock `get_parent` callbacks
return a signed error code from a function with unsigned return type.
The fix is small, obvious, well-reviewed, and low-risk. It affects a
driver that has been in the kernel since v4.7, so all stable trees
contain the buggy code. The fix follows the existing pattern in the code
(using the hardware register value directly) and is the correct
approach.

**YES**

 drivers/clk/microchip/clk-core.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/microchip/clk-core.c b/drivers/clk/microchip/clk-core.c
index b34348d491f3e..73c05aa4e1d60 100644
--- a/drivers/clk/microchip/clk-core.c
+++ b/drivers/clk/microchip/clk-core.c
@@ -283,14 +283,13 @@ static u8 roclk_get_parent(struct clk_hw *hw)
 
 	v = (readl(refo->ctrl_reg) >> REFO_SEL_SHIFT) & REFO_SEL_MASK;
 
-	if (!refo->parent_map)
-		return v;
-
-	for (i = 0; i < clk_hw_get_num_parents(hw); i++)
-		if (refo->parent_map[i] == v)
-			return i;
+	if (refo->parent_map) {
+		for (i = 0; i < clk_hw_get_num_parents(hw); i++)
+			if (refo->parent_map[i] == v)
+				return i;
+	}
 
-	return -EINVAL;
+	return v;
 }
 
 static unsigned long roclk_calc_rate(unsigned long parent_rate,
@@ -826,13 +825,13 @@ static u8 sclk_get_parent(struct clk_hw *hw)
 
 	v = (readl(sclk->mux_reg) >> OSC_CUR_SHIFT) & OSC_CUR_MASK;
 
-	if (!sclk->parent_map)
-		return v;
+	if (sclk->parent_map) {
+		for (i = 0; i < clk_hw_get_num_parents(hw); i++)
+			if (sclk->parent_map[i] == v)
+				return i;
+	}
 
-	for (i = 0; i < clk_hw_get_num_parents(hw); i++)
-		if (sclk->parent_map[i] == v)
-			return i;
-	return -EINVAL;
+	return v;
 }
 
 static int sclk_set_parent(struct clk_hw *hw, u8 index)
-- 
2.51.0

