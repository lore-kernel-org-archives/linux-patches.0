Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716F22F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD13C433D2;
	Wed, 12 Apr 2023 08:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288734;
	bh=64g9qhaXqLFVJLT4MseXGb2oTZhdPdjB/lowPRGvwME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KujdfvmpMDNPlPR65ebMCBeuZBAWka+VZDNyBcztRDa8W65/roKms5cbz4hYRub6u
	 AsM9ozq974uc5XzTE2pp8F46Hqbm1XczTT/d3yuzxOngfeCyem9Xc0LUljnBr01TOp
	 TJ3dpqjU/vAhLaxcTJW2KwaeYhVNR/BQ68ZJfHnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/93] kbuild: refactor single builds of *.ko
Date: Wed, 12 Apr 2023 10:33:51 +0200
Message-Id: <20230412082825.263712578@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit f110e5a250e3c5db417e094b3dd86f1c135291ca ]

Remove the potentially invalid modules.order instead of using
the temporary file.

Also, KBUILD_MODULES is don't care for single builds. No need to
cancel it.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: ed1f4ccfe947 ("clk: imx: imx8mp: add shared clk gate for usb suspend clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/Makefile b/Makefile
index 6459e91369fdb..4de8cd300451d 100644
--- a/Makefile
+++ b/Makefile
@@ -1850,6 +1850,8 @@ modules modules_install:
 	@echo >&2 '***'
 	@exit 1
 
+KBUILD_MODULES :=
+
 endif # CONFIG_MODULES
 
 # Single targets
@@ -1875,18 +1877,12 @@ $(single-ko): single_modpost
 $(single-no-ko): descend
 	@:
 
-ifeq ($(KBUILD_EXTMOD),)
-# For the single build of in-tree modules, use a temporary file to avoid
-# the situation of modules_install installing an invalid modules.order.
-MODORDER := .modules.tmp
-endif
-
+# Remove MODORDER when done because it is not the real one.
 PHONY += single_modpost
 single_modpost: $(single-no-ko) modules_prepare
 	$(Q){ $(foreach m, $(single-ko), echo $(extmod_prefix)$m;) } > $(MODORDER)
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
-
-KBUILD_MODULES := 1
+	$(Q)rm -f $(MODORDER)
 
 export KBUILD_SINGLE_TARGETS := $(addprefix $(extmod_prefix), $(single-no-ko))
 
@@ -1896,10 +1892,6 @@ build-dirs := $(foreach d, $(build-dirs), \
 
 endif
 
-ifndef CONFIG_MODULES
-KBUILD_MODULES :=
-endif
-
 # Handle descending into subdirectories listed in $(build-dirs)
 # Preset locale variables to speed up the build process. Limit locale
 # tweaks to this spot to avoid wrong language settings when running
-- 
2.39.2



