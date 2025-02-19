Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166E81E3769;
	Wed, 19 Feb 2025 08:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954235; cv=none; b=DOo1XcWl7dEWS1Utocel3qh21UyJdUS8QpKA9je1qA1ZfHdbtHwQTwiajSdxeH4HOUWLe4BL/lU16nNL8xlx1dCK4HwyyRoSjBTHhpUGaVIfaCg9m/UiRq0Sx37E4mUOK62OryBG7+UHL+eqmtY1wnllW8uUZ46gL8czD85I1UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954235; c=relaxed/simple;
	bh=GS+axC9nxHIT6Kz5s4ElP1t5QhIRxesjvA+ldZKlw8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFcPJhcy2V80sE8bUpIvPZ4lfsnq0Loi125jEb59tByxExQadHCt9NcFDnzPYbcrz1Jt7KoFazae5aPTTXOBkYdaSuUXwqtPl6f636XFiYrGyf15aDbIpYCguLZUg+xwqYb9Mm66AAzA8ngVGtN6TCbD0N46e2h3vpwWVkDTP18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjF9Rt9A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjF9Rt9A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34297C4CED1;
	Wed, 19 Feb 2025 08:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954234;
	bh=GS+axC9nxHIT6Kz5s4ElP1t5QhIRxesjvA+ldZKlw8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjF9Rt9ANuAV0eX8KU228kcWnpj/k7Ikjt+mQnPUWLXeNl1NS266SRh4Eh8zBBAm4
	 I9aetVEcDuQ1aAFypocDS6e6VJkAHE2i1Qt25KbOWBfEoKA8XT3H0nYQQEkKxxSvcy
	 5aVKxWp9lQEPZHOuexKAu/E+YkI/sxZi4VGxkC5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 107/274] kbuild: suppress stdout from merge_config for silent builds
Date: Wed, 19 Feb 2025 09:26:01 +0100
Message-ID: <20250219082613.804295705@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 1f937a4bcb0472015818f30f4d3c5546d3f09933 ]

merge_config does not respect the Make's -s (--silent) option.

Let's sink the stdout from merge_config for silent builds.

This commit does not cater to the direct invocation of merge_config.sh
(e.g. arch/mips/Makefile).

Reported-by: Leon Romanovsky <leon@kernel.org>
Closes: https://lore.kernel.org/all/e534ce33b0e1060eb85ece8429810f087b034c88.1733234008.git.leonro@nvidia.com/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Tested-by: Leon Romanovsky <leon@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.defconf | 13 +++++++------
 scripts/kconfig/Makefile |  4 +++-
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/scripts/Makefile.defconf b/scripts/Makefile.defconf
index 226ea3df3b4b4..a44307f08e9d6 100644
--- a/scripts/Makefile.defconf
+++ b/scripts/Makefile.defconf
@@ -1,6 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 # Configuration heplers
 
+cmd_merge_fragments = \
+	$(srctree)/scripts/kconfig/merge_config.sh \
+	$4 -m -O $(objtree) $(srctree)/arch/$(SRCARCH)/configs/$2 \
+	$(foreach config,$3,$(srctree)/arch/$(SRCARCH)/configs/$(config).config)
+
 # Creates 'merged defconfigs'
 # ---------------------------------------------------------------------------
 # Usage:
@@ -8,9 +13,7 @@
 #
 # Input config fragments without '.config' suffix
 define merge_into_defconfig
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh \
-		-m -O $(objtree) $(srctree)/arch/$(SRCARCH)/configs/$(1) \
-		$(foreach config,$(2),$(srctree)/arch/$(SRCARCH)/configs/$(config).config)
+	$(call cmd,merge_fragments,$1,$2)
 	+$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
 endef
 
@@ -22,8 +25,6 @@ endef
 #
 # Input config fragments without '.config' suffix
 define merge_into_defconfig_override
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh \
-		-Q -m -O $(objtree) $(srctree)/arch/$(SRCARCH)/configs/$(1) \
-		$(foreach config,$(2),$(srctree)/arch/$(SRCARCH)/configs/$(config).config)
+	$(call cmd,merge_fragments,$1,$2,-Q)
 	+$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
 endef
diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index a0a0be38cbdc1..fb50bd4f4103f 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -105,9 +105,11 @@ configfiles = $(wildcard $(srctree)/kernel/configs/$(1) $(srctree)/arch/$(SRCARC
 all-config-fragments = $(call configfiles,*.config)
 config-fragments = $(call configfiles,$@)
 
+cmd_merge_fragments = $(srctree)/scripts/kconfig/merge_config.sh -m $(KCONFIG_CONFIG) $(config-fragments)
+
 %.config: $(obj)/conf
 	$(if $(config-fragments),, $(error $@ fragment does not exists on this architecture))
-	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/kconfig/merge_config.sh -m $(KCONFIG_CONFIG) $(config-fragments)
+	$(call cmd,merge_fragments)
 	$(Q)$(MAKE) -f $(srctree)/Makefile olddefconfig
 
 PHONY += tinyconfig
-- 
2.39.5



