Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D80433C8;
	Wed, 27 Nov 2024 23:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732749964; cv=none; b=WiKxxsROGznKQgRpp1sZLuf4SVyjHhyzIGYstWLqBEqlS0FuAceoyQMIvUetODAUvgNSIj26ZkU2Bmff0rR0hV8zLKR4bnYAEgokVdJH0eTfXkGUt5TNWnMMTFaFhmOdyzswguI2Zp3ljW7lj/CttdE2iHNtXJBOOlDlJLrWDoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732749964; c=relaxed/simple;
	bh=vmi+P8yL117Jcf3Rm8qz5U52cXggg+MsNiPykKptW9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zd57xWqgJjiCeN5N2S+0AflRAC7B7LLv7Vj0ZhpyQ0TAi9wQhMioAdoMyvLFiDnAvxk92f9FAKUMIga+x3ybt0jT2PPI4AfiWROZGerQyTo4Clt+c9ghi52FJq+XQvOGWo6lBubc+ea8CgbbvBxMPMtnui42YXIj2rjaMc+ILLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rVbNaneZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rVbNaneZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BF1C4CECC;
	Wed, 27 Nov 2024 23:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732749963;
	bh=vmi+P8yL117Jcf3Rm8qz5U52cXggg+MsNiPykKptW9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rVbNaneZrusINVJMmUXRTsghlJr6cQ4tqZvi6/PTBYcV/jWG5WY2SumJioG6UB+qi
	 qPulByWMyuitJCDa22C8jKpr9WshHcxEEMlv5p2j/02FxRiaXWJF3sLC2QLBz64V1a
	 O7hC52CMobRvspLtCN5gW8O8WiwlAoj/xjcxZ4eeMa1SAweQOhuaHfWKOlgJ4NDR3Y
	 2556OP+HVlJE0G1H7UGrydppMwC0p3sfTibdHg0i9W9mDhx8rGViWr8owltpZXyyZM
	 IF04Zx2y2S+wXrzL+ty9TPOjqCFmvdlZ1F1PM6l/SIJZkFs2hzB1xw0s75PzdxCJkn
	 s3qx3kd2btM2Q==
Date: Wed, 27 Nov 2024 15:26:01 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: samitolvanen@google.com, petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, masahiroy@kernel.org,
	mmaurer@google.com, arnd@arndb.de, deller@gmx.de, song@kernel.org
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
 <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z0eeuCyUGcKgsc5h@bombadil.infradead.org>

On Wed, Nov 27, 2024 at 02:35:36PM -0800, Luis Chamberlain wrote:
> Sorry about that, I'm on it.

OK here is a fix, goes double build tested and then run time tested.

From 6c9ef19d7676c3f650f1de3e2619c958f21c0b75 Mon Sep 17 00:00:00 2001
From: Luis Chamberlain <mcgrof@kernel.org>
Date: Wed, 27 Nov 2024 14:10:57 -0800
Subject: [PATCH] selftests: kallsyms: fix with sensible defaults

Folks use 'make allmodconfig' to test building Linux, and although
the test is intended to stress test that and later load insane modules,
we don't need to make 'make allmodconfig' suffer. So scale down to
the bare bones by default.

To do this be explicit about the sensible ranges and bound the test
so that folks who the impact if they enable more broader range test
options.

This also helps us clarify where we run into existing limits today.

Also, avoid the stupid FORCE so that re-builds will only trigger
when really needed.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 lib/Kconfig.debug                     | 38 ++++++++++++++++++++++++++-
 lib/tests/module/Makefile             |  2 +-
 lib/tests/module/gen_test_kallsyms.sh |  9 +++++--
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b5929721fc63..31b843690a00 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2986,9 +2986,43 @@ config TEST_KALLSYMS_D
 	tristate
 	depends on m
 
+choice
+	prompt "Kallsym test range"
+	default TEST_KALLSYMS_FAST
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
+	  are a modules developer. This will slow down your build considerbly
+	  by at least 2x.
+
+config TEST_KALLSYMS_MAX
+	bool "Known kallsysms limits"
+	help
+	  This will enable exports to the point we know we'll start crashing
+	  builds.
+
+endchoice
+
+
 config TEST_KALLSYMS_NUMSYMS
 	int "test kallsyms number of symbols"
-	default 100
+	range 2 8 if TEST_KALLSYMS_FAST
+	range 8 100 if TEST_KALLSYMS_LARGE
+	range 100 1000 if TEST_KALLSYMS_MAX
+	default 2 if TEST_KALLSYMS_FAST
+	default 8 if TEST_KALLSYMS_LARGE
+	default 100 if TEST_KALLSYMS_MAX
 	help
 	  The number of symbols to create on TEST_KALLSYMS_A, only one of which
 	  module TEST_KALLSYMS_B will use. This also will be used
@@ -2997,6 +3031,8 @@ config TEST_KALLSYMS_NUMSYMS
 	  trigger a segfault today, don't use anything close to it unless
 	  you are aware that this should not be used for automated build tests.
 
+	  We use sensible default to not slow down default allmodconfig builds.
+
 config TEST_KALLSYMS_SCALE_FACTOR
 	int "test kallsyms scale factor"
 	default 8
diff --git a/lib/tests/module/Makefile b/lib/tests/module/Makefile
index af5c27b996cb..5436386d7aa0 100644
--- a/lib/tests/module/Makefile
+++ b/lib/tests/module/Makefile
@@ -3,7 +3,7 @@ obj-$(CONFIG_TEST_KALLSYMS_B) += test_kallsyms_b.o
 obj-$(CONFIG_TEST_KALLSYMS_C) += test_kallsyms_c.o
 obj-$(CONFIG_TEST_KALLSYMS_D) += test_kallsyms_d.o
 
-$(obj)/%.c: FORCE
+$(obj)/%.c: $(srctree)/lib/tests/module/gen_test_kallsyms.sh $(KCONFIG_CONFIG)
 	@$(kecho) "  GEN     $@"
 	$(Q)$(srctree)/lib/tests/module/gen_test_kallsyms.sh $@\
 		$(CONFIG_TEST_KALLSYMS_NUMSYMS) \
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

