Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E7E7E76F;
	Mon,  8 Apr 2024 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582255; cv=none; b=AEhooOYxX6h+1jtZ7mfWeQsHnZ84iRir8rOuwhrrcpyrrqrBsC5RPg2UIUZ52aF/t/FJZiIAyo2dHOgxbVQ73IQchWcBRCMXbSLmKF+OlvE9z/dvPRvlC/8kvBpuFFEFjeIe47v7nzWV1jNycOHKhQe2LKX/XWPMl4ON++XiISs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582255; c=relaxed/simple;
	bh=acEdbrW+4hiBXvML0OJLGsz8kGZPKyGk+X44epzc8Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEDfS0bHMrffhthyxwNSDadJ0GX2AZqLqjQT4gvZwbP9EB30G9n3hzi+PdQqW1hp+6Ii4mBOkqxRfwyo6xzsYrQNu0AWXSJUyNpr/PHFkO2vXGWQc+TCekIik/tbTdELoTUXQG6F82BOMbhkcMuB1E9m3dZLMxBedJC5f+77rf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFbwKEtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFbwKEtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304A4C433F1;
	Mon,  8 Apr 2024 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582255;
	bh=acEdbrW+4hiBXvML0OJLGsz8kGZPKyGk+X44epzc8Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KFbwKEtbAXRw+Ml11LF3aAlzUnYz8eoUseA5dTqFxpbx/ruAAzSm+5k/n2mqMQPe6
	 ipiR3SIG5XorbF764dksRSkqd5eve5iSKIjz0UQopr812fwQlOiLmYUE0pIgRT4+BY
	 av30K6E/0yhXgT8JdQJao/LLjJkMi5xTnQ7pBVmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 060/273] kbuild: make -Woverride-init warnings more consistent
Date: Mon,  8 Apr 2024 14:55:35 +0200
Message-ID: <20240408125311.163133929@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c40845e3195d074b34f8f8e400e28c9403a06588 ]

The -Woverride-init warn about code that may be intentional or not,
but the inintentional ones tend to be real bugs, so there is a bit of
disagreement on whether this warning option should be enabled by default
and we have multiple settings in scripts/Makefile.extrawarn as well as
individual subsystems.

Older versions of clang only supported -Wno-initializer-overrides with
the same meaning as gcc's -Woverride-init, though all supported versions
now work with both. Because of this difference, an earlier cleanup of
mine accidentally turned the clang warning off for W=1 builds and only
left it on for W=2, while it's still enabled for gcc with W=1.

There is also one driver that only turns the warning off for newer
versions of gcc but not other compilers, and some but not all the
Makefiles still use a cc-disable-warning conditional that is no
longer needed with supported compilers here.

Address all of the above by removing the special cases for clang
and always turning the warning off unconditionally where it got
in the way, using the syntax that is supported by both compilers.

Fixes: 2cd3271b7a31 ("kbuild: avoid duplicate warning options")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Acked-by: Jani Nikula <jani.nikula@intel.com>
Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce110/Makefile |  2 +-
 drivers/gpu/drm/amd/display/dc/dce112/Makefile |  2 +-
 drivers/gpu/drm/amd/display/dc/dce120/Makefile |  2 +-
 drivers/gpu/drm/amd/display/dc/dce60/Makefile  |  2 +-
 drivers/gpu/drm/amd/display/dc/dce80/Makefile  |  2 +-
 drivers/gpu/drm/i915/Makefile                  |  6 +++---
 drivers/gpu/drm/xe/Makefile                    |  4 ++--
 drivers/net/ethernet/renesas/sh_eth.c          |  2 +-
 drivers/pinctrl/aspeed/Makefile                |  2 +-
 fs/proc/Makefile                               |  2 +-
 kernel/bpf/Makefile                            |  2 +-
 mm/Makefile                                    |  3 +--
 scripts/Makefile.extrawarn                     | 10 +++-------
 13 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce110/Makefile b/drivers/gpu/drm/amd/display/dc/dce110/Makefile
index f0777d61c2cbb..c307f040e48fc 100644
--- a/drivers/gpu/drm/amd/display/dc/dce110/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dce110/Makefile
@@ -23,7 +23,7 @@
 # Makefile for the 'controller' sub-component of DAL.
 # It provides the control and status of HW CRTC block.
 
-CFLAGS_$(AMDDALPATH)/dc/dce110/dce110_resource.o = $(call cc-disable-warning, override-init)
+CFLAGS_$(AMDDALPATH)/dc/dce110/dce110_resource.o = -Wno-override-init
 
 DCE110 = dce110_timing_generator.o \
 dce110_compressor.o dce110_opp_regamma_v.o \
diff --git a/drivers/gpu/drm/amd/display/dc/dce112/Makefile b/drivers/gpu/drm/amd/display/dc/dce112/Makefile
index 7e92effec8944..683866797709b 100644
--- a/drivers/gpu/drm/amd/display/dc/dce112/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dce112/Makefile
@@ -23,7 +23,7 @@
 # Makefile for the 'controller' sub-component of DAL.
 # It provides the control and status of HW CRTC block.
 
-CFLAGS_$(AMDDALPATH)/dc/dce112/dce112_resource.o = $(call cc-disable-warning, override-init)
+CFLAGS_$(AMDDALPATH)/dc/dce112/dce112_resource.o = -Wno-override-init
 
 DCE112 = dce112_compressor.o
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce120/Makefile b/drivers/gpu/drm/amd/display/dc/dce120/Makefile
index 1e3ef68a452a5..8f508e6627480 100644
--- a/drivers/gpu/drm/amd/display/dc/dce120/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dce120/Makefile
@@ -24,7 +24,7 @@
 # It provides the control and status of HW CRTC block.
 
 
-CFLAGS_$(AMDDALPATH)/dc/dce120/dce120_resource.o = $(call cc-disable-warning, override-init)
+CFLAGS_$(AMDDALPATH)/dc/dce120/dce120_resource.o = -Wno-override-init
 
 DCE120 = dce120_timing_generator.o
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce60/Makefile b/drivers/gpu/drm/amd/display/dc/dce60/Makefile
index fee331accc0e7..eede83ad91fa0 100644
--- a/drivers/gpu/drm/amd/display/dc/dce60/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dce60/Makefile
@@ -23,7 +23,7 @@
 # Makefile for the 'controller' sub-component of DAL.
 # It provides the control and status of HW CRTC block.
 
-CFLAGS_$(AMDDALPATH)/dc/dce60/dce60_resource.o = $(call cc-disable-warning, override-init)
+CFLAGS_$(AMDDALPATH)/dc/dce60/dce60_resource.o = -Wno-override-init
 
 DCE60 = dce60_timing_generator.o dce60_hw_sequencer.o \
 	dce60_resource.o
diff --git a/drivers/gpu/drm/amd/display/dc/dce80/Makefile b/drivers/gpu/drm/amd/display/dc/dce80/Makefile
index 7eefffbdc9253..fba189d26652d 100644
--- a/drivers/gpu/drm/amd/display/dc/dce80/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dce80/Makefile
@@ -23,7 +23,7 @@
 # Makefile for the 'controller' sub-component of DAL.
 # It provides the control and status of HW CRTC block.
 
-CFLAGS_$(AMDDALPATH)/dc/dce80/dce80_resource.o = $(call cc-disable-warning, override-init)
+CFLAGS_$(AMDDALPATH)/dc/dce80/dce80_resource.o = -Wno-override-init
 
 DCE80 = dce80_timing_generator.o
 
diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index c13f14edb5088..7b20c2bcc641d 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -33,9 +33,9 @@ endif
 subdir-ccflags-$(CONFIG_DRM_I915_WERROR) += -Werror
 
 # Fine grained warnings disable
-CFLAGS_i915_pci.o = $(call cc-disable-warning, override-init)
-CFLAGS_display/intel_display_device.o = $(call cc-disable-warning, override-init)
-CFLAGS_display/intel_fbdev.o = $(call cc-disable-warning, override-init)
+CFLAGS_i915_pci.o = -Wno-override-init
+CFLAGS_display/intel_display_device.o = -Wno-override-init
+CFLAGS_display/intel_fbdev.o = -Wno-override-init
 
 # Support compiling the display code separately for both i915 and xe
 # drivers. Define I915 when building i915.
diff --git a/drivers/gpu/drm/xe/Makefile b/drivers/gpu/drm/xe/Makefile
index 802c807c782cc..1c9e6906b06a2 100644
--- a/drivers/gpu/drm/xe/Makefile
+++ b/drivers/gpu/drm/xe/Makefile
@@ -162,8 +162,8 @@ subdir-ccflags-$(CONFIG_DRM_XE_DISPLAY) += \
 	-Ddrm_i915_gem_object=xe_bo \
 	-Ddrm_i915_private=xe_device
 
-CFLAGS_i915-display/intel_fbdev.o = $(call cc-disable-warning, override-init)
-CFLAGS_i915-display/intel_display_device.o = $(call cc-disable-warning, override-init)
+CFLAGS_i915-display/intel_fbdev.o = -Wno-override-init
+CFLAGS_i915-display/intel_display_device.o = -Wno-override-init
 
 # Rule to build SOC code shared with i915
 $(obj)/i915-soc/%.o: $(srctree)/drivers/gpu/drm/i915/soc/%.c FORCE
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 475e1e8c1d35f..0786eb0da3914 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -50,7 +50,7 @@
  * the macros available to do this only define GCC 8.
  */
 __diag_push();
-__diag_ignore(GCC, 8, "-Woverride-init",
+__diag_ignore_all("-Woverride-init",
 	      "logic to initialize all and then override some is OK");
 static const u16 sh_eth_offset_gigabit[SH_ETH_MAX_REGISTER_OFFSET] = {
 	SH_ETH_OFFSET_DEFAULTS,
diff --git a/drivers/pinctrl/aspeed/Makefile b/drivers/pinctrl/aspeed/Makefile
index 489ea1778353f..db2a7600ae2bd 100644
--- a/drivers/pinctrl/aspeed/Makefile
+++ b/drivers/pinctrl/aspeed/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 # Aspeed pinctrl support
 
-ccflags-y += $(call cc-option,-Woverride-init)
+ccflags-y += -Woverride-init
 obj-$(CONFIG_PINCTRL_ASPEED)	+= pinctrl-aspeed.o pinmux-aspeed.o
 obj-$(CONFIG_PINCTRL_ASPEED_G4)	+= pinctrl-aspeed-g4.o
 obj-$(CONFIG_PINCTRL_ASPEED_G5)	+= pinctrl-aspeed-g5.o
diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index bd08616ed8bad..7b4db9c56e6a7 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -5,7 +5,7 @@
 
 obj-y   += proc.o
 
-CFLAGS_task_mmu.o	+= $(call cc-option,-Wno-override-init,)
+CFLAGS_task_mmu.o	+= -Wno-override-init
 proc-y			:= nommu.o task_nommu.o
 proc-$(CONFIG_MMU)	:= task_mmu.o
 
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index f526b7573e97c..418a8188a8e84 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -4,7 +4,7 @@ ifneq ($(CONFIG_BPF_JIT_ALWAYS_ON),y)
 # ___bpf_prog_run() needs GCSE disabled on x86; see 3193c0836f203 for details
 cflags-nogcse-$(CONFIG_X86)$(CONFIG_CC_IS_GCC) := -fno-gcse
 endif
-CFLAGS_core.o += $(call cc-disable-warning, override-init) $(cflags-nogcse-yy)
+CFLAGS_core.o += -Wno-override-init $(cflags-nogcse-yy)
 
 obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o log.o
 obj-$(CONFIG_BPF_SYSCALL) += bpf_iter.o map_iter.o task_iter.o prog_iter.o link_iter.o
diff --git a/mm/Makefile b/mm/Makefile
index e4b5b75aaec9c..4abb40b911ec4 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -29,8 +29,7 @@ KCOV_INSTRUMENT_mmzone.o := n
 KCOV_INSTRUMENT_vmstat.o := n
 KCOV_INSTRUMENT_failslab.o := n
 
-CFLAGS_init-mm.o += $(call cc-disable-warning, override-init)
-CFLAGS_init-mm.o += $(call cc-disable-warning, initializer-overrides)
+CFLAGS_init-mm.o += -Wno-override-init
 
 mmu-y			:= nommu.o
 mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 2f25a1de129d1..5660b96213e4b 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -114,6 +114,8 @@ KBUILD_CFLAGS += $(call cc-disable-warning, format-overflow)
 KBUILD_CFLAGS += $(call cc-disable-warning, format-truncation)
 KBUILD_CFLAGS += $(call cc-disable-warning, stringop-truncation)
 
+KBUILD_CFLAGS += -Wno-override-init # alias for -Wno-initializer-overrides in clang
+
 ifdef CONFIG_CC_IS_CLANG
 # Clang before clang-16 would warn on default argument promotions.
 ifneq ($(call clang-min-version, 160000),y)
@@ -151,10 +153,6 @@ KBUILD_CFLAGS += -Wtype-limits
 KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
 
-ifdef CONFIG_CC_IS_CLANG
-KBUILD_CFLAGS += -Winitializer-overrides
-endif
-
 KBUILD_CPPFLAGS += -DKBUILD_EXTRA_WARN2
 
 else
@@ -164,9 +162,7 @@ KBUILD_CFLAGS += -Wno-missing-field-initializers
 KBUILD_CFLAGS += -Wno-type-limits
 KBUILD_CFLAGS += -Wno-shift-negative-value
 
-ifdef CONFIG_CC_IS_CLANG
-KBUILD_CFLAGS += -Wno-initializer-overrides
-else
+ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-maybe-uninitialized
 endif
 
-- 
2.43.0



