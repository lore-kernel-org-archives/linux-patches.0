Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EE713DB90;
	Tue, 27 Feb 2024 13:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041069; cv=none; b=DsZxkubT8TlqLDQ8fjz0AY+qlhvZp3gWzJCOodfSRCvIHJQb5DO1976L3nNgpsqwdwX8saSX+nidgoY/ohHWPNZxBUREWWmkhBAmb/AQ+Uq7zbXOFU9RRDRFzwgmPuoSF8tGYgWoQvWodnC0WNGASHiSEwWWOhBwOr3h/Ny0LJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041069; c=relaxed/simple;
	bh=vyoVPoOYzx+g1P1pVquy9m9QYLQrTGgh2xwvqPtEwwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y61mpeQB0l2CrFI1SDSq7Mgkm0oIeAtg1H3vbgtiBJUhGh+ZxeUaXW3axB3ztEBov69b4XIFSMU8377pMSrOtkPI1ucY82mQbpz8X7SAZZfzJwbEtIm6cigdX3fT1Pn2BMhgjNZVt4RgXMj9irMZSWE6QGj7v/n5XGcWwRIrDpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylEDJJI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylEDJJI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701FDC433F1;
	Tue, 27 Feb 2024 13:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041068;
	bh=vyoVPoOYzx+g1P1pVquy9m9QYLQrTGgh2xwvqPtEwwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylEDJJI5eYuwmcgF86tWO2m7blHj/HWswus6xELaHxZbpUQ+inpPVoRWgbWY3eT8j
	 z//X6BVdMldTMh+NZ5QUrtPAjIGesDuQVVQGYjAUaumdssVe0SVL2ZqW1PW6NOaQz2
	 b29KUmrNZhAZSRsecXiznjIVIOXFG3OM9K6QVRqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.7 181/334] sparc: Fix undefined reference to fb_is_primary_device
Date: Tue, 27 Feb 2024 14:20:39 +0100
Message-ID: <20240227131636.447518418@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 arch/sparc/Makefile       |    2 +-
 arch/sparc/video/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/Makefile
+++ b/arch/sparc/Makefile
@@ -60,7 +60,7 @@ libs-y                 += arch/sparc/pro
 libs-y                 += arch/sparc/lib/
 
 drivers-$(CONFIG_PM) += arch/sparc/power/
-drivers-$(CONFIG_FB) += arch/sparc/video/
+drivers-$(CONFIG_FB_CORE) += arch/sparc/video/
 
 boot := arch/sparc/boot
 
--- a/arch/sparc/video/Makefile
+++ b/arch/sparc/video/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
-obj-$(CONFIG_FB) += fbdev.o
+obj-$(CONFIG_FB_CORE) += fbdev.o


