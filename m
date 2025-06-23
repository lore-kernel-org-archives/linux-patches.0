Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4728222581;
	Mon, 23 Jun 2025 22:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717487; cv=none; b=ncem8vJ/JRvqbPDrln3ErXS2jYGc/N+UcCXvarEWbCTfdsaZSs3tu+oWh+bim2Zdhrba04iL1LfBpWMS5aD7OC5Wd0zSPlBrxOPQv+3nN8vRqLll7TiedAgCMIAFRWjtcAVf/kAJZS/DvCey12g3qZPmSn4eXBNm2j6cnYpVJjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717487; c=relaxed/simple;
	bh=E3osXNSCG9flPccWiXvNdwIBhH4/8KHUDde5Rm4Ttxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRa9AO4Bj996HZFZFeKmu/Fs6QUtmbcGtEin8vbOT1D1nyzTJTeZvdLO39UhvqzlMp395BQqISDwPOulE4a8AFz0hNDlI2/V9ZAPM5xxCXge4NxZqWD6vmUck+ESUPOZT5eeREAwjDFOMOeq+7FGWfDB7lHfux9P96UpEfK/xmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VpiCgyKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpiCgyKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA3AC4CEEA;
	Mon, 23 Jun 2025 22:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717486;
	bh=E3osXNSCG9flPccWiXvNdwIBhH4/8KHUDde5Rm4Ttxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpiCgyKJR/2qFJJO9exTpleK7hB4AXE7uhtvwla5olltkuShi5Uu8nho3zWIFOvpg
	 ZZt1AWpWnXLIVVNbSiEm7yf1gF/+g1boDZXfoFYwCvxBAuHplOHWFxkj1FueauLzfM
	 4oFIC7K7Zv/8UJrrj2zMhHd9TtysfCiE70etx96E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/414] drm/i915/pmu: Fix build error with GCOV and AutoFDO enabled
Date: Mon, 23 Jun 2025 15:08:17 +0200
Message-ID: <20250623130650.967949888@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit a7137b1825b535eb7258b25beeb0d5425e0037d2 ]

i915_pmu.c may fail to build with GCOV and AutoFDO enabled.

../drivers/gpu/drm/i915/i915_pmu.c:116:3: error: call to '__compiletime_assert_487' declared with 'error' attribute: BUILD_BUG_ON failed: bit > BITS_PER_TYPE(typeof_member(struct i915_pmu, enable)) - 1
  116 |                 BUILD_BUG_ON(bit >
      |                 ^

Here is a way to reproduce the issue:
$ git checkout v6.15
$ mkdir build
$ ./scripts/kconfig/merge_config.sh -O build -n -m <(cat <<EOF
CONFIG_DRM=y
CONFIG_PCI=y
CONFIG_DRM_I915=y

CONFIG_PERF_EVENTS=y

CONFIG_DEBUG_FS=y
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y

CONFIG_AUTOFDO_CLANG=y
EOF
)
$ PATH=${PATH}:${HOME}/llvm-20.1.5-x86_64/bin make LLVM=1 O=build \
       olddefconfig
$ PATH=${PATH}:${HOME}/llvm-20.1.5-x86_64/bin make LLVM=1 O=build \
       CLANG_AUTOFDO_PROFILE=...PATH_TO_SOME_AFDO_PROFILE... \
       drivers/gpu/drm/i915/i915_pmu.o

Although not super sure what happened, by reviewing the code, it should
depend on `__builtin_constant_p(bit)` directly instead of assuming
`__builtin_constant_p(config)` makes `bit` a builtin constant.

Also fix a nit, to reuse the `bit` local variable.

Fixes: a644fde77ff7 ("drm/i915/pmu: Change bitmask of enabled events to u32")
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Link: https://lore.kernel.org/r/20250612083023.562585-1-tzungbi@kernel.org
(cherry picked from commit 686d773186bf72b739bab7e12eb8665d914676ee)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 21eb0c5b320d5..c43223916a1b1 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -115,7 +115,7 @@ static u32 config_mask(const u64 config)
 {
 	unsigned int bit = config_bit(config);
 
-	if (__builtin_constant_p(config))
+	if (__builtin_constant_p(bit))
 		BUILD_BUG_ON(bit >
 			     BITS_PER_TYPE(typeof_member(struct i915_pmu,
 							 enable)) - 1);
@@ -124,7 +124,7 @@ static u32 config_mask(const u64 config)
 			     BITS_PER_TYPE(typeof_member(struct i915_pmu,
 							 enable)) - 1);
 
-	return BIT(config_bit(config));
+	return BIT(bit);
 }
 
 static bool is_engine_event(struct perf_event *event)
-- 
2.39.5



