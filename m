Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07BDA2C9D;
	Mon, 23 Jun 2025 21:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713673; cv=none; b=ZjrJ4hPGALVAn65OFLybQLRpIzBfMwDU1KlNVyohBllsVwdUD/p8c3pxWe4mL3gxDBoiZDGcEUmGc9iCP40ISa8XV01rsRY3wLZh4bF0Sxc/raBsEoNMfAOU18BnDfNO7doshOwMd2Bz8D7NFG+Kjc6a4VH0S+CKRT9M8UaAndU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713673; c=relaxed/simple;
	bh=JM6hnH0O1saCoihOygk0DR0vlZd0QGY8Q8+yFVxFtHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2a7WvGtr25Zx1GpsUl3XD2MSgoGjKyY+OWNCq4LVgDbPgHsQ9RoFlipwFbDcPZ/mt7+jKBvvfP94VgdxrZdXzyoH1aPmTJ4gVq9GcSAnj0YEQjsHWkWMBEXDPqyJb4IAano8s1ZrPkBGwwbW5mWK8pH/bfUjfsgU9dRvDaDT3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cw7JaxuZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cw7JaxuZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B33AC4CEEA;
	Mon, 23 Jun 2025 21:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713672;
	bh=JM6hnH0O1saCoihOygk0DR0vlZd0QGY8Q8+yFVxFtHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cw7JaxuZBScsPpEkQAEht6Y2a4gZLZ3Q4biDXmWqERSP/1m/baEH7KkHmhKI2OJi8
	 4SXHc3j8b/bJD3YlphjPmo8eHBa1OpZ9/mb8aELUX4JF1IbHq3Rv1YvEV+KhMZtRYj
	 VtheIs+C4IcujTEfqfsTTLxjidsl8Ob1n56hrfG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 199/222] drm/nouveau/bl: increase buffer size to avoid truncate warning
Date: Mon, 23 Jun 2025 15:08:54 +0200
Message-ID: <20250623130618.213040213@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index f2f3280c3a50e..171cc170c458d 100644
--- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
+++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
@@ -40,7 +40,7 @@
 #include "nouveau_connector.h"
 
 static struct ida bl_ida;
-#define BL_NAME_SIZE 15 // 12 for name + 2 for digits + 1 for '\0'
+#define BL_NAME_SIZE 24 // 12 for name + 11 for digits + 1 for '\0'
 
 struct nouveau_backlight {
 	struct backlight_device *dev;
-- 
2.39.5



