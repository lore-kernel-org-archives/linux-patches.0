Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA93223708;
	Mon, 23 Jun 2025 22:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717218; cv=none; b=Iv/MWWGKXr1zA+FYGCk16Ag6Z4/m6SUjl9GVpCEYKDpkd2zdRAN/fU7TExamKsM3GpiiVIciZiKy7oaRVo7bWF/fkkkujvRB3Kk7Wdf1FZk0xdhCAjNOVyTesh3u+32MRRqZnnsaxt0BwUdz/SPSnAEfIaBw0T0HIhk7XBxQIZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717218; c=relaxed/simple;
	bh=WJvXQX0hBi1c14qDzlnPYRo+0tnPFmBJDv6kCFRfBSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMY1yXNUi1OB9LaNIlKQ4mu4DllC7YeDo6Wi3IyOHjwnk9PE+HZz6FqPI5u68URmOEeSbC3oG4rf66DZpeYx/J/KGr0Tktc+P4rC+HPZ13Jvai5u62KTPkkk/y4N9x2Csm5RMHHLvWHsofGNxjyKcC4r3EMPhRtxkHV/0Kk+Ksk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xpRslAC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xpRslAC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8C2C4CEEA;
	Mon, 23 Jun 2025 22:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717217;
	bh=WJvXQX0hBi1c14qDzlnPYRo+0tnPFmBJDv6kCFRfBSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xpRslAC3pzXCktsz+wWMgJKSiQOT+GNDQ9qvoXMO0SvrRxf2awPBHwkRhqJss4iCN
	 MxGmUncrirUTmIWBcIzUdvFEPtxmIjOeJuZuhXOiDfXb0fdBm/w2nFYsNnqWWvzOOq
	 XB9aL8ooledqjaDv0sLeBvEOFUQbPF6UywfOvNYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Fiona Behrens <me@Kloenk.dev>,
	Nicolas Schier <n.schier@avm.de>,
	Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.12 340/414] kbuild: rust: add rustc-min-version support function
Date: Mon, 23 Jun 2025 15:07:57 +0200
Message-ID: <20250623130650.481231861@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit ac954145e1ee3f72033161cbe4ac0b16b5354ae7 upstream.

Introduce `rustc-min-version` support function that mimics
`{gcc,clang}-min-version` ones, following commit 88b61e3bff93
("Makefile.compiler: replace cc-ifversion with compiler-specific macros").

In addition, use it in the first use case we have in the kernel (which
was done independently to minimize the changes needed for the fix).

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Fiona Behrens <me@Kloenk.dev>
Reviewed-by: Nicolas Schier <n.schier@avm.de>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kbuild/makefiles.rst |   14 ++++++++++++++
 arch/arm64/Makefile                |    2 +-
 scripts/Makefile.compiler          |    4 ++++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/Documentation/kbuild/makefiles.rst
+++ b/Documentation/kbuild/makefiles.rst
@@ -656,6 +656,20 @@ cc-cross-prefix
             endif
     endif
 
+$(RUSTC) support functions
+--------------------------
+
+rustc-min-version
+  rustc-min-version tests if the value of $(CONFIG_RUSTC_VERSION) is greater
+  than or equal to the provided value and evaluates to y if so.
+
+  Example::
+
+    rustflags-$(call rustc-min-version, 108500) := -Cfoo
+
+  In this example, rustflags-y will be assigned the value -Cfoo if
+  $(CONFIG_RUSTC_VERSION) is >= 1.85.0.
+
 $(LD) support functions
 -----------------------
 
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -48,7 +48,7 @@ KBUILD_CFLAGS	+= $(CC_FLAGS_NO_FPU) \
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(compat_vdso)
 
-ifeq ($(call test-ge, $(CONFIG_RUSTC_VERSION), 108500),y)
+ifeq ($(call rustc-min-version, 108500),y)
 KBUILD_RUSTFLAGS += --target=aarch64-unknown-none-softfloat
 else
 KBUILD_RUSTFLAGS += --target=aarch64-unknown-none -Ctarget-feature="-neon"
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -67,6 +67,10 @@ gcc-min-version = $(call test-ge, $(CONF
 # Usage: cflags-$(call clang-min-version, 110000) += -foo
 clang-min-version = $(call test-ge, $(CONFIG_CLANG_VERSION), $1)
 
+# rustc-min-version
+# Usage: rustc-$(call rustc-min-version, 108500) += -Cfoo
+rustc-min-version = $(call test-ge, $(CONFIG_RUSTC_VERSION), $1)
+
 # ld-option
 # Usage: KBUILD_LDFLAGS += $(call ld-option, -X, -Y)
 ld-option = $(call try-run, $(LD) $(KBUILD_LDFLAGS) $(1) -v,$(1),$(2),$(3))


