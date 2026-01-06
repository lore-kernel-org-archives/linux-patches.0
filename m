Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC5F35F8D9;
	Tue,  6 Jan 2026 17:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721715; cv=none; b=I4O+vqxqQLBNknkFifLp2ahj5F7y4Ce14N0YGQtZ+jeltgTm4FMV/EYG5uF//DtWScyPE599qyMGUbmhrUOtMlf7qumvxDWSnRLPjagZQHTCb0kHCQZHHQcjDV418z+z0ndrlH6pehX3Idl1t7MjzZSUcwkD3ZQJS49rXgtKfXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721715; c=relaxed/simple;
	bh=mo9G37PRcQFoz1BTOaMk6zA6NbVklz+c+Pwo90pj7RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tekNfjhUPZ2gjkjyial0ZLsyGKlHqPy+9sK3zRL18uAuJZb3FBfWC81NZCZ/25IKeKnzJ9SSs0z2+eLsD0GRqEdumPlsqdmcAM8YEt+OkGVhVoI08NEmpY7puGQaGM4Ny+5e6jKtdZ2yKPyh2fRnmfhaioiEC98IK7S5zUacF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HqDB7dim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HqDB7dim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22453C116C6;
	Tue,  6 Jan 2026 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721715;
	bh=mo9G37PRcQFoz1BTOaMk6zA6NbVklz+c+Pwo90pj7RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HqDB7dimiwj3KjnlWE5iXtCMrJ0Hpibw2LQyYeVfZzu+Dg6e8ZNhpZjydiOccNlK5
	 F9ZnQDDbbq37S0LT9vCjxLvbhh1zVwouosEU7AJ9xHTcVaHpKILl1TjgUI8e89G0AY
	 aMcoAy/wht8XWNrBjk6suhRi44DD7rdQiOYKy6yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas De Schampheleire <thomas.de_schampheleire@nokia.com>,
	Nathan Chancellor <nathan@kernel.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 049/312] kbuild: fix compilation of dtb specified on command-line without make rule
Date: Tue,  6 Jan 2026 18:02:03 +0100
Message-ID: <20260106170549.629316141@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 52c08c4eb0b9..5037f4715d74 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -527,18 +527,6 @@ ifneq ($(userprogs),)
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
 
@@ -568,6 +556,20 @@ FORCE:
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



