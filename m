Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCC1222581;
	Mon, 23 Jun 2025 22:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717619; cv=none; b=P/jOMAK3dzhrbKho78Y1LSHO+HSptfX6xvsCmKjujLW4PQ5wJZOYRJsjWLDx57537UnCrmgwwMFs9XfQSV/xUfJIrC12AlFU0jpWCkBixiV3A76GlwHzemp9ivoxWt1v/oEqhyGNkG7sw3HJLLb7gEhj0brFB7Zg2IBdLLHVRD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717619; c=relaxed/simple;
	bh=YzytVnKiUK7Bqr8EYW7J5SoyughQLLadVA6TelgSzvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=is/eJfpd3GxVnIRO8O8W4gRWGRLMabQCX+Gt1apU/duuqu4ATlyVbQWdURV24e4y46hfC6Oj3qrrvHMFBG7ppvjeccpHIBrHpb+oc+4Ydv+b5uqr3FK5RRdzNGzSYYPuBC2xFoydEaoUewqtbaGmzAtW4MvwchQhr4HAb2ZDhqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0pr9n5Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0pr9n5Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F8BC4CEEA;
	Mon, 23 Jun 2025 22:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717619;
	bh=YzytVnKiUK7Bqr8EYW7J5SoyughQLLadVA6TelgSzvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0pr9n5Bv803aZZt17JNPhpLa0Ej6QXHm1lxGIto4g4nxwttw+2p4rEjf9RT+TSM7c
	 J8fIT2PuqvUk1g7AY1l1PNnkxLVif7188wCxiQHaRjKKl5rYJGWxR669Z+wwn2sW2A
	 o6EEQVJcKE7S7jZA7DY3KJ7QWUsRyd6Vv50CZFk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 473/508] drm/nouveau/bl: increase buffer size to avoid truncate warning
Date: Mon, 23 Jun 2025 15:08:38 +0200
Message-ID: <20250623130656.728142161@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Keller <jacob.e.keller@intel.com>

[ Upstream commit 61b2b3737499f1fb361a54a16828db24a8345e85 ]

The nouveau_get_backlight_name() function generates a unique name for the
backlight interface, appending an id from 1 to 99 for all backlight devices
after the first.

GCC 15 (and likely other compilers) produce the following
-Wformat-truncation warning:

nouveau_backlight.c: In function ‘nouveau_backlight_init’:
nouveau_backlight.c:56:69: error: ‘%d’ directive output may be truncated writing between 1 and 10 bytes into a region of size 3 [-Werror=format-truncation=]
   56 |                 snprintf(backlight_name, BL_NAME_SIZE, "nv_backlight%d", nb);
      |                                                                     ^~
In function ‘nouveau_get_backlight_name’,
    inlined from ‘nouveau_backlight_init’ at nouveau_backlight.c:351:7:
nouveau_backlight.c:56:56: note: directive argument in the range [1, 2147483647]
   56 |                 snprintf(backlight_name, BL_NAME_SIZE, "nv_backlight%d", nb);
      |                                                        ^~~~~~~~~~~~~~~~
nouveau_backlight.c:56:17: note: ‘snprintf’ output between 14 and 23 bytes into a destination of size 15
   56 |                 snprintf(backlight_name, BL_NAME_SIZE, "nv_backlight%d", nb);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The warning started appearing after commit ab244be47a8f ("drm/nouveau:
Fix a potential theorical leak in nouveau_get_backlight_name()") This fix
for the ida usage removed the explicit value check for ids larger than 99.
The compiler is unable to intuit that the ida_alloc_max() limits the
returned value range between 0 and 99.

Because the compiler can no longer infer that the number ranges from 0 to
99, it thinks that it could use as many as 11 digits (10 + the potential -
sign for negative numbers).

The warning has gone unfixed for some time, with at least one kernel test
robot report. The code breaks W=1 builds, which is especially frustrating
with the introduction of CONFIG_WERROR.

The string is stored temporarily on the stack and then copied into the
device name. Its not a big deal to use 11 more bytes of stack rounding out
to an even 24 bytes. Increase BL_NAME_SIZE to 24 to avoid the truncation
warning. This fixes the W=1 builds that include this driver.

Compile tested only.

Fixes: ab244be47a8f ("drm/nouveau: Fix a potential theorical leak in nouveau_get_backlight_name()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202312050324.0kv4PnfZ-lkp@intel.com/
Suggested-by: Timur Tabi <ttabi@nvidia.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20250610-jk-nouveua-drm-bl-snprintf-fix-v2-1-7fdd4b84b48e@intel.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_backlight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
index a614582779cae..6469820e46151 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -41,7 +41,7 @@
 #include "nouveau_acpi.h"
 
 static struct ida bl_ida;
-#define BL_NAME_SIZE 15 // 12 for name + 2 for digits + 1 for '\0'
+#define BL_NAME_SIZE 24 // 12 for name + 11 for digits + 1 for '\0'
 
 static bool
 nouveau_get_backlight_name(char backlight_name[BL_NAME_SIZE],
-- 
2.39.5



