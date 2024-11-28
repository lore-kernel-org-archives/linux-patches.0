Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4947433B1;
	Thu, 28 Nov 2024 02:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732761772; cv=none; b=UZsHBgnfs7G/kcB0Qem/znGthRygcpAaE0JbqQgaRFHT7hipAk+d7+dztnc4zdyOJMdrT9O5yDCn3/I7nd/+Qbh9i8ITcpAacrYGsQSB+lbfsfGnIlwc0FnxZB9OxLBRz/wILLiBeGUGm99m9j7ETl0B/NB53kgK5ISAkEiLAGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732761772; c=relaxed/simple;
	bh=qEwTpfjVKTo4gJrLIBICGWx3kJtzTO2e+wI38ZqOdm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o7+FUZi/XwMVMFE0/iFqf2pbrzDvM9AKb4obusvaM5SpU0wOvgOIt3TtPr+0cgPc7WvdzVQ220Q/DKaSNL9NWs9iVI5Oz6YA6PMPSmGdffGlf4XsLNJUYrx9P+pbtSfB/w849kDqmmNAapbaSnlMTKX8Yyom7+KacHlgqZsyUgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQ4d2vmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQ4d2vmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299A1C4CECC;
	Thu, 28 Nov 2024 02:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732761771;
	bh=qEwTpfjVKTo4gJrLIBICGWx3kJtzTO2e+wI38ZqOdm8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQ4d2vmAM7mpBhPRYGdPnnbxEyBMbGr54aewvPAeBmeOT3JLS3UJ5oA5j+GBUHcif
	 6KjUR/A1B1puaALv9HTi/uQ4dhwbflNt98HCePXksj4XT+6i3DgjcMfuzamTFYt1dJ
	 HbQAh6puXFwAVrRRpp4ewTTAWKKdMMUwEJuzBuCO0VApmt2dDPeJb+UpW3W0rWDxSv
	 CBqohwirLQgtJz+jCM9R4MzeYxp5J2u/Jqdu71t623O5eNRmSEV2fHed2eldfyhYJn
	 EaPZLZvO4VJud3Sx7s07MLGwRWIiuNxz4Tb897rWJOxX/jJlXksiZEMUaFitm5Tiik
	 qnaV7Go/DPa1g==
Date: Wed, 27 Nov 2024 18:42:49 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, masahiroy@kernel.org,
	mmaurer@google.com, arnd@arndb.de, deller@gmx.de, song@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0fYqZutUzDdxTGf@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
 <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>
 <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <Z0fT4hC30NISjmi_@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0fT4hC30NISjmi_@bombadil.infradead.org>

Now with Masahiro's cleanups, in my testing we don't need the FORCE anymore.


From 83497e0e83d81950df54d82461b1dae629842147 Mon Sep 17 00:00:00 2001
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Wed, 27 Nov 2024 14:10:57 -0800
Subject: [PATCH v3] selftests: kallsyms: fix double build stupidity

Fix the stupid FORCE so that re-builds will only trigger
when really needed. While at it, document the sensible ranges
supported and fix the script to accept these alternatives.

Also adopt Masahiro Yamada's suggested cleanups on the Makefile.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 lib/Kconfig.debug                     | 32 ++++++++++++++++++++++++++-
 lib/tests/module/Makefile             | 17 +++++++-------
 lib/tests/module/gen_test_kallsyms.sh |  9 ++++++--
 3 files changed, 46 insertions(+), 12 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b5929721fc63..da8c35bfaeaf 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2986,9 +2986,39 @@ config TEST_KALLSYMS_D
 	tristate
 	depends on m
 
+choice
+	prompt "Kallsym test range"
+	default TEST_KALLSYMS_LARGE
+	help
+	  Selecting something other than "Fast" will enable tests which slow
+	  down the build and may crash your build.
+
+config TEST_KALLSYMS_FAST
+	bool "Fast builds"
+	help
+	  You won't really be testing kallsysms, so this just helps fast builds
+	  when allmodconfig is used..
+
+config TEST_KALLSYMS_LARGE
+	bool "Enable testing kallsyms with large exports"
+	help
+	  This will enable larger number of symbols. Only enable this if you
+	  are a modules developer. This will slow down your build considerbly.
+
+config TEST_KALLSYMS_MAX
+	bool "Known kallsysms limits"
+	help
+	  This will enable exports to the point we know we'll start crashing
+	  builds.
+
+endchoice
+
 config TEST_KALLSYMS_NUMSYMS
 	int "test kallsyms number of symbols"
-	default 100
+	range 2 10000
+	default 2 if TEST_KALLSYMS_FAST
+	default 100 if TEST_KALLSYMS_LARGE
+	default 10000 if TEST_KALLSYMS_MAX
 	help
 	  The number of symbols to create on TEST_KALLSYMS_A, only one of which
 	  module TEST_KALLSYMS_B will use. This also will be used
diff --git a/lib/tests/module/Makefile b/lib/tests/module/Makefile
index af5c27b996cb..86cc3e42e44a 100644
--- a/lib/tests/module/Makefile
+++ b/lib/tests/module/Makefile
@@ -3,13 +3,12 @@ obj-$(CONFIG_TEST_KALLSYMS_B) += test_kallsyms_b.o
 obj-$(CONFIG_TEST_KALLSYMS_C) += test_kallsyms_c.o
 obj-$(CONFIG_TEST_KALLSYMS_D) += test_kallsyms_d.o
 
-$(obj)/%.c: FORCE
-	@$(kecho) "  GEN     $@"
-	$(Q)$(srctree)/lib/tests/module/gen_test_kallsyms.sh $@\
-		$(CONFIG_TEST_KALLSYMS_NUMSYMS) \
-		$(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
+quiet_cmd_gen_test_kallsyms = GEN     $@
+	cmd_gen_test_kallsyms = $< $@ \
+	$(CONFIG_TEST_KALLSYMS_NUMSYMS) \
+	$(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
 
-clean-files += test_kallsyms_a.c
-clean-files += test_kallsyms_b.c
-clean-files += test_kallsyms_c.c
-clean-files += test_kallsyms_d.c
+$(obj)/%.c: $(src)/gen_test_kallsyms.sh $(KCONFIG_CONFIG)
+	$(call if_changed,gen_test_kallsyms)
+
+targets += $(foreach x, a b c d, test_kallsyms_$(x).c)
diff --git a/lib/tests/module/gen_test_kallsyms.sh b/lib/tests/module/gen_test_kallsyms.sh
index 3f2c626350ad..561dcac0f359 100755
--- a/lib/tests/module/gen_test_kallsyms.sh
+++ b/lib/tests/module/gen_test_kallsyms.sh
@@ -7,6 +7,11 @@ NUM_SYMS=$2
 SCALE_FACTOR=$3
 TEST_TYPE=$(echo $TARGET | sed -e 's|lib/tests/module/test_kallsyms_||g')
 TEST_TYPE=$(echo $TEST_TYPE | sed -e 's|.c||g')
+FIRST_B_LOOKUP=1
+
+if [[ $NUM_SYMS -gt 2 ]]; then
+	FIRST_B_LOOKUP=$((NUM_SYMS/2))
+fi
 
 gen_template_module_header()
 {
@@ -52,10 +57,10 @@ ____END_MODULE
 
 gen_template_module_data_b()
 {
-	printf "\nextern int auto_test_a_%010d;\n\n" 28
+	printf "\nextern int auto_test_a_%010d;\n\n" $FIRST_B_LOOKUP
 	echo "static int auto_runtime_test(void)"
 	echo "{"
-	printf "\nreturn auto_test_a_%010d;\n" 28
+	printf "\nreturn auto_test_a_%010d;\n" $FIRST_B_LOOKUP
 	echo "}"
 }
 
-- 
2.45.2

