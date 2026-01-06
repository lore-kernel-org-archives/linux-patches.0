Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734D533993;
	Tue,  6 Jan 2026 17:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720820; cv=none; b=imzCqB5Q+/gJw/Sgrldk1iX4iHgVWxIKgZExga2VwGLOYeyqwSVmbXgt49nzyQZO7hmCs1hB/8jcjpm5awZC1fzO2VBR6lgwDuwfS8+haNLwPWQAhadowNl9vSR8hHI3urpEEgslnmrPjBZPuq3DWo6J4Q/1oKf7id19IwwI618=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720820; c=relaxed/simple;
	bh=fR2tI5DlXmvcpxAVOwbd38QmwmdbWTLt0HP4ALeDono=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+lzyosNREZfQFoY8dNyLdIz66Pk/QEr6NFlIQlQI7Ltayi2CF+ibm/6lDTJrQcm3RXmmV4TbwGruFvACHcQI+wCBc5OEb2OKmiuRdAwxuks+KIA0qwQMhg4QXgCUTvL5/Ie41ltzq1pQDxifOBvYyA/wMmTyak+zpHDZmkx/j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCq3FYmL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCq3FYmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F277FC116C6;
	Tue,  6 Jan 2026 17:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720820;
	bh=fR2tI5DlXmvcpxAVOwbd38QmwmdbWTLt0HP4ALeDono=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCq3FYmLzoGnsQd1lm01nKvMoSuUuI0Hi8lXU4fcd+97CfFLdOERynNH2NrpIsLiI
	 45IP0eRFTmJjhSNYN3s4tq5W16ypzQhOWk4MWS+8m1w2ASskZtIlzPcWPn5mdf6Vw7
	 WazDXBcciNwG9gfxcFZuz0TpRkwLs8OL2I7N58Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 319/567] kbuild: fix compilation of dtb specified on command-line without make rule
Date: Tue,  6 Jan 2026 18:01:41 +0100
Message-ID: <20260106170503.126178958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>

[ Upstream commit b08fc4d0ec2466558f6d5511434efdfabbddf2a6 ]

Since commit e7e2941300d2 ("kbuild: split device tree build rules into
scripts/Makefile.dtbs"), it is no longer possible to compile a device tree
blob that is not specified in a make rule
like:
    dtb-$(CONFIG_FOO) += foo.dtb

Before the mentioned commit, one could copy a dts file to e.g.
arch/arm64/boot/dts/ (or a new subdirectory) and then convert it to a dtb
file using:
    make ARCH=arm64 foo.dtb

In this scenario, both 'dtb-y' and 'dtb-' are empty, and the inclusion of
scripts/Makefile.dtbs relies on 'targets' to contain the MAKECMDGOALS. The
value of 'targets', however, is only final later in the code.

Move the conditional include of scripts/Makefile.dtbs down to where the
value of 'targets' is final. Since Makefile.dtbs updates 'always-y' which is
used as a prerequisite in the build rule, the build rule also needs to move
down.

Fixes: e7e2941300d2 ("kbuild: split device tree build rules into scripts/Makefile.dtbs")
Signed-off-by: Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20251126100017.1162330-1-thomas.de_schampheleire@nokia.com
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.build | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 2c5c1a214f3b..6e07023b5442 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -449,18 +449,6 @@ ifneq ($(userprogs),)
 include $(srctree)/scripts/Makefile.userprogs
 endif
 
-ifneq ($(need-dtbslist)$(dtb-y)$(dtb-)$(filter %.dtb %.dtb.o %.dtbo.o,$(targets)),)
-include $(srctree)/scripts/Makefile.dtbs
-endif
-
-# Build
-# ---------------------------------------------------------------------------
-
-$(obj)/: $(if $(KBUILD_BUILTIN), $(targets-for-builtin)) \
-	 $(if $(KBUILD_MODULES), $(targets-for-modules)) \
-	 $(subdir-ym) $(always-y)
-	@:
-
 # Single targets
 # ---------------------------------------------------------------------------
 
@@ -490,6 +478,20 @@ FORCE:
 targets += $(filter-out $(single-subdir-goals), $(MAKECMDGOALS))
 targets := $(filter-out $(PHONY), $(targets))
 
+# Now that targets is fully known, include dtb rules if needed
+ifneq ($(need-dtbslist)$(dtb-y)$(dtb-)$(filter %.dtb %.dtb.o %.dtbo.o,$(targets)),)
+include $(srctree)/scripts/Makefile.dtbs
+endif
+
+# Build
+# Needs to be after the include of Makefile.dtbs, which updates always-y
+# ---------------------------------------------------------------------------
+
+$(obj)/: $(if $(KBUILD_BUILTIN), $(targets-for-builtin)) \
+	 $(if $(KBUILD_MODULES), $(targets-for-modules)) \
+	 $(subdir-ym) $(always-y)
+	@:
+
 # Read all saved command lines and dependencies for the $(targets) we
 # may be building above, using $(if_changed{,_dep}). As an
 # optimization, we don't need to read them if the target does not
-- 
2.51.0



