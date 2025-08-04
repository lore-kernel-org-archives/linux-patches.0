Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB5B15A8;
	Mon,  4 Aug 2025 00:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754268175; cv=none; b=nzPo2fNmSpBFBbIjWIggc2f4ny+1DZAzSIot9DuVye8R7D9vvV6Ms/gm0fxQkWtQtqE8QNIw26psomtK99VzzxDVQ0zYciaEDolq3za1Nk9pWbCdHbQDn0/SmbFTgRggB1gRgRslk0WalQtkkn0W9193p7l9WLt5yBI3ObJv41s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754268175; c=relaxed/simple;
	bh=p84uElI19tzMUUIT5etlzGEn5Fgc5wv3uiIUGG96L8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=encjjW9n1LUWPnH4EM9RqfqTTAT5VRcpHrKZy6dyfBSuztBgg8EgmydSlNkbeYPZuUWH5Coebseai3O7NBrjFmpfX7zI1G9EznMQDfxIYEmPMLHgxTxqeaoE0P/Vm8pcib3V+NF6mSCQ6ZVfD6AgUITrIsxwvgvZUk1ajyuD9i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bwTt1zR6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bwTt1zR6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC4FC4CEF0;
	Mon,  4 Aug 2025 00:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754268175;
	bh=p84uElI19tzMUUIT5etlzGEn5Fgc5wv3uiIUGG96L8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwTt1zR6bFQ++h089Qv3JoJiUuXuatgJBrGMv0HOL0M8Srtp/kTIr4GVM2nfgtMm6
	 9zvZlVNNww0tsE4l3gg56spJ6vXzJVFUgkGxo0fNPtn/d40U6ZpJKtbgM2SSp79EyC
	 zSqA2bNpWl3slkoQDngAD5LzbwXZzsCUFIUmQrEcHIkvNzm92gJNlbNYkZI1XPKCkU
	 v/q92eZnOjk38x3f/PadSuUiZnpB9p359KcS2jGYJoUt4VRgQqFJuLvn8BJgtzND7U
	 1MrL8XwRo9oEXrgrxo8gXhKBjRMFwYy3lgf7sD2rRXQiozM11oAOK3mmg47R/Rxok1
	 q52FXptu0/miw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@gmail.com,
	jonathanh@nvidia.com,
	linux-arm-kernel@lists.infradead.org,
	linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/28] ARM: tegra: Use I/O memcpy to write to IRAM
Date: Sun,  3 Aug 2025 20:42:11 -0400
Message-Id: <20250804004227.3630243-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804004227.3630243-1-sashal@kernel.org>
References: <20250804004227.3630243-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.296
Content-Transfer-Encoding: 8bit

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 398e67e0f5ae04b29bcc9cbf342e339fe9d3f6f1 ]

Kasan crashes the kernel trying to check boundaries when using the
normal memcpy.

Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://lore.kernel.org/r/20250522-mach-tegra-kasan-v1-1-419041b8addb@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of this commit, here's my determination:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a real crash/bug**: The commit fixes a KASAN (Kernel Address
   Sanitizer) crash that occurs when using regular `memcpy()` to write
   to IRAM (Internal RAM). This is a functional bug that causes kernel
   crashes when KASAN is enabled.

2. **Small and contained fix**: The change is minimal - it simply
   replaces `memcpy()` with `memcpy_toio()` on line 66 of arch/arm/mach-
   tegra/reset.c. This is a one-line change that doesn't alter any logic
   or introduce new features.

3. **Follows proper I/O memory access patterns**: The fix is technically
   correct. According to the kernel documentation in
   Documentation/driver-api/device-io.rst, I/O memory regions (which
   IRAM is mapped as via `IO_ADDRESS()`) should be accessed using
   I/O-specific functions like `memcpy_toio()` rather than regular
   `memcpy()`. The documentation explicitly states: "Do not use memset
   or memcpy on IO addresses; they are not guaranteed to copy data in
   order."

4. **No architectural changes**: The commit doesn't introduce any
   architectural changes or new functionality. It's purely a bug fix
   that corrects improper memory access.

5. **Minimal risk of regression**: Since this change only affects how
   data is copied to IRAM during the Tegra CPU reset handler
   initialization, and uses the proper kernel API for I/O memory access,
   the risk of introducing new issues is very low.

6. **Platform-specific but important**: While this fix is specific to
   ARM Tegra platforms, it fixes a crash that would affect any Tegra
   system running with KASAN enabled. This is important for developers
   and users who rely on KASAN for debugging.

The fact that `iram_base` is obtained through `IO_ADDRESS()` macro
clearly indicates this is I/O mapped memory that requires I/O-specific
accessors. KASAN correctly identified this misuse and crashed to prevent
potential issues. The fix properly uses `memcpy_toio()` which is
designed for copying to I/O memory regions and won't trigger KASAN
checks for regular memory access.

 arch/arm/mach-tegra/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-tegra/reset.c b/arch/arm/mach-tegra/reset.c
index 76a65df42d10..dce0cb1fdd6f 100644
--- a/arch/arm/mach-tegra/reset.c
+++ b/arch/arm/mach-tegra/reset.c
@@ -63,7 +63,7 @@ static void __init tegra_cpu_reset_handler_enable(void)
 	BUG_ON(is_enabled);
 	BUG_ON(tegra_cpu_reset_handler_size > TEGRA_IRAM_RESET_HANDLER_SIZE);
 
-	memcpy(iram_base, (void *)__tegra_cpu_reset_handler_start,
+	memcpy_toio(iram_base, (void *)__tegra_cpu_reset_handler_start,
 			tegra_cpu_reset_handler_size);
 
 	err = call_firmware_op(set_cpu_boot_addr, 0, reset_address);
-- 
2.39.5

