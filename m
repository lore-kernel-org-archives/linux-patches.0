Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 917E02DE6F9;
	Thu,  3 Jul 2025 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555162; cv=none; b=ZUsJ96iFTcK7nypK8PODYcoH9Z6ZSX5P5p/WFK2AkCxM3c0ci8jGUqT9miFEQQyhoKYr+BDygxMXEk47adbCM2AKU7Jeil9h9GHEpEhI3ibd1hjAxg83NVFxgPK0L/UTQWiacNiVP0RaPmCoAqb9ZPSmeO1KzyGKj6aWwwK2d/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555162; c=relaxed/simple;
	bh=hmuFSSAOxJRC05Ogti9ljlYQQo5YrKnstUzRBmGRa24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFfCYtj5336tkINTEvjP+nxbMx2bXDmhe0942KU7XppYz29w5YHOnw77aTAVqMAGhJaF5ErmuYfGSmN7VczFbsLOih0V3sE1UswIHWvYCTzOnqQeieo9jpeK8thPYroZn++WuXRm7jU9jOtDRfhmd0tkbYKnfM5jN6ASOY3HOEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kDjoH+I1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kDjoH+I1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4706C4CEE3;
	Thu,  3 Jul 2025 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555162;
	bh=hmuFSSAOxJRC05Ogti9ljlYQQo5YrKnstUzRBmGRa24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDjoH+I1b1m0xETJRdXMstpYJJBOPGUwiFA7zVawfkPEBPQ0+x8aEZ8fiCB5oV/aP
	 /bqLnIzE2c5b4YTIPWmCm+hOq0LgCJScXv2U96EaaTmWac3GIayqYNfG7xPRGTa+Cc
	 WRLNNXuTj0mLt593qJNc7oNb4QLD44WYKT2bsh1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 165/263] drm/i915: fix build error some more
Date: Thu,  3 Jul 2025 16:41:25 +0200
Message-ID: <20250703144010.977661315@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d02b2103a08b6d6908f1d3d8e8783d3f342555ac ]

An earlier patch fixed a build failure with clang, but I still see the
same problem with some configurations using gcc:

drivers/gpu/drm/i915/i915_pmu.c: In function 'config_mask':
include/linux/compiler_types.h:568:38: error: call to '__compiletime_assert_462' declared with attribute error: BUILD_BUG_ON failed: bit > BITS_PER_TYPE(typeof_member(struct i915_pmu, enable)) - 1
drivers/gpu/drm/i915/i915_pmu.c:116:3: note: in expansion of macro 'BUILD_BUG_ON'
  116 |   BUILD_BUG_ON(bit >

As I understand it, the problem is that the function is not always fully
inlined, but the __builtin_constant_p() can still evaluate the argument
as being constant.

Marking it as __always_inline so far works for me in all configurations.

Fixes: a7137b1825b5 ("drm/i915/pmu: Fix build error with GCOV and AutoFDO enabled")
Fixes: a644fde77ff7 ("drm/i915/pmu: Change bitmask of enabled events to u32")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250620111824.3395007-1-arnd@kernel.org
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit ef69f9dd1cd7301cdf04ba326ed28152a3affcf6)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_pmu.c b/drivers/gpu/drm/i915/i915_pmu.c
index 990bfaba3ce4e..5bc696bfbb0fe 100644
--- a/drivers/gpu/drm/i915/i915_pmu.c
+++ b/drivers/gpu/drm/i915/i915_pmu.c
@@ -108,7 +108,7 @@ static unsigned int config_bit(const u64 config)
 		return other_bit(config);
 }
 
-static u32 config_mask(const u64 config)
+static __always_inline u32 config_mask(const u64 config)
 {
 	unsigned int bit = config_bit(config);
 
-- 
2.39.5



