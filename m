Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4A613B7A0;
	Tue, 27 Feb 2024 13:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042060; cv=none; b=FcIj7sx4o5EpJRiRHl+BU0lweaZ9Wnbm1l1PCXxJCG2yUBTc6j+qZ+8X5CDfvfjU15tK33PeI9iVxerPzuEMOL7BFuo2/wMwAko3EBlXqVkPxvdfVFhSTmwkjK1uaNvAhu4Fy9eEdNmKgyQBWqv1YQ6KxUGnmoU11MWFWHi9sX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042060; c=relaxed/simple;
	bh=LpQfHC3AdMpBJVRZ50PWjCQX8sYiOssbqJtXeojRtD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDI+fwaQilY/C8POAumktJZ4ijw3D3go6jo6XQz+NUZxrRcF0XEkLkBF867mPm8ILSZDZ6Z9cYt3+JrEESqHjf4tcZk4IDAZA6vXe1rIOgy7mSRh40CU4gyeSGz4vLetDhGVT8+THSNyxdjUknzMNj8HN8wHIWsZwzk9wduxfWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vW06nBVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW06nBVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA09C433F1;
	Tue, 27 Feb 2024 13:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042060;
	bh=LpQfHC3AdMpBJVRZ50PWjCQX8sYiOssbqJtXeojRtD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vW06nBViQ2GOkANB2+H7xuuADPbh64tjOdJTyTdTOSNCVOumjHCzAOiMa6qlfyL5E
	 VtN1tbbtfoa7Vh/iMOCy210uF7YzNr/Wi1QtFnU92RntexNDzKlc7ukx9HES3ZiF/w
	 LWI1bO1xYU6iX/6FZYdT2BAsU5w1iKW/bhfna9ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.6 165/299] sparc: Fix undefined reference to fb_is_primary_device
Date: Tue, 27 Feb 2024 14:24:36 +0100
Message-ID: <20240227131631.160053744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Martinez Canillas <javierm@redhat.com>

commit ed683b9bb91fc274383e222ba5873a9ee9033462 upstream.

Commit 55bffc8170bb ("fbdev: Split frame buffer support in FB and FB_CORE
symbols") added a new FB_CORE Kconfig symbol, that can be enabled to only
have fbcon/VT and DRM fbdev emulation, but without support for any legacy
fbdev driver.

Unfortunately, it missed to change the CONFIG_FB in arch/sparc makefiles,
which leads to the following linking error in some sparc64 configurations:

   sparc64-linux-ld: drivers/video/fbdev/core/fbcon.o: in function `fbcon_fb_registered':
>> fbcon.c:(.text+0x4f60): undefined reference to `fb_is_primary_device'

Fixes: 55bffc8170bb ("fbdev: Split frame buffer support in FB and FB_CORE symbols")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202401290306.IV8rhJ02-lkp@intel.com/
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240220095428.3341195-1-javierm@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/Makefile       | 2 +-
 arch/sparc/video/Makefile | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/Makefile b/arch/sparc/Makefile
index 5f6035936131..2a03daa68f28 100644
--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -60,7 +60,7 @@ libs-y                 += arch/sparc/prom/
 libs-y                 += arch/sparc/lib/
 
 drivers-$(CONFIG_PM) += arch/sparc/power/
-drivers-$(CONFIG_FB) += arch/sparc/video/
+drivers-$(CONFIG_FB_CORE) += arch/sparc/video/
 
 boot := arch/sparc/boot
 
diff --git a/arch/sparc/video/Makefile b/arch/sparc/video/Makefile
index 6baddbd58e4d..d4d83f1702c6 100644
--- a/arch/sparc/video/Makefile
+++ b/arch/sparc/video/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_FB) += fbdev.o
+obj-$(CONFIG_FB_CORE) += fbdev.o
-- 
2.44.0



