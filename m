Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFBE19049B;
	Mon, 23 Jun 2025 21:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715543; cv=none; b=j8Wh6Vf9O2geMSqODoCgh1IK1BLxqoCFX7VGSNZojyFh7OJwygdOhIRUrZT9vPbtAaSrJZxZGUX1EkVd2Sdx3PNzNSynlBW6qM/AtFYiWKg9W09kSWCI2uYQzGTOHxjtJXJOIsd2RG1xm5lnpd+oFzjM+Pl1ZkBmmh2PpoUYMik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715543; c=relaxed/simple;
	bh=Dr7U/Z2dHu8mmwahspd31+pk5Kh2lJ/Gwc1IbCNrmlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iClk+8/txbK/mxZOavd1xzQ56CYt6U6+YGxIUM3pfFPmGZ/HTGhpbhlLHHTPlmOQE9bPXgPJSeiGJWNp3AxlCGVRuvLQPGge/CEmNHzc6bzI/6Fhx7BRixh7/pgUQSLaKeLBP7BtRjUGYhWLe9t0GVwn4eBVWdnaEKZ1oGeG0QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmKVm8VR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmKVm8VR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5BEC4CEEA;
	Mon, 23 Jun 2025 21:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715543;
	bh=Dr7U/Z2dHu8mmwahspd31+pk5Kh2lJ/Gwc1IbCNrmlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmKVm8VRo0DSmYoqqq5N7hgMaABe6K3VunSGcmK/n3gK6oeyENDUIfhV2Uswd9C6p
	 yyYbxcozMOhElUl6kV4cqzr00SNA6paxKvJ/h30fczadNBzT9T3TzaY0oGHrBMXvZD
	 grJhrWA68LM9dN6n7PApg39PRpjfetxW8q+t7GuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Timur Tabi <ttabi@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/355] drm/nouveau/bl: increase buffer size to avoid truncate warning
Date: Mon, 23 Jun 2025 15:08:23 +0200
Message-ID: <20250623130635.857693849@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



