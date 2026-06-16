Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C10D43DA2C;
	Tue, 16 Jun 2026 15:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623655; cv=none; b=VslE5REhF0LYkFdsNf3n16T0cTEabktUhcFnGID7tdzUrgpBxvaYIADuP0GZEOavlq3R95FXIgcFdExEbfPvGitm7XH5m3doUPKQrnhq21TMYWRuGdz4hCMvmSiHDkuAXNKMrwF70zShVT6wi06HFzYjYjAR1Fgzxd2jSOWZFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623655; c=relaxed/simple;
	bh=9ODJL55irshWtOSSHpqaZA5nAHi3YLnM0mCNc7jgWOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abgXyHk4NaY3eqmgrhxWWXtAGV44xhLgq0+MHucWV5CzhJ3zfCj+QNJoxD5acbT6QGu3cLqndneb2Yoc9IAOgj2vSo4TuHAUeLBqqdTqoM6YjALD961kv104BLQuFdmID0YW+REhQ8s/LCgYXushjJsCld34s+W0UBCra2DClT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=se4o1ayp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="se4o1ayp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BBE1F000E9;
	Tue, 16 Jun 2026 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623654;
	bh=MkloERE88vPO7bQKPxIT+JqW9LiGCAu+na2InM3rr/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=se4o1aypFYUU0+nhFVtsImH2bt/ID0K10SFcoIVhte9iFK6uwGpFu0/vSsGtL4faV
	 Cw4M95wDdqj2cNUbQvaX2m1MM4kabdF1Tlpj/ajiFpe8hg2G2tPShJHuhn7GngGZoQ
	 NAU10u1vBn+Nyl/nMx2ie854GSMQq4izuPt8en+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.0 191/378] rust: kasan/kbuild: fix rustc-option when cross-compiling
Date: Tue, 16 Jun 2026 20:27:02 +0530
Message-ID: <20260616145120.433180599@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 4a44b17406cb5a93f90af3df9392b3a45eb336fb upstream.

The Makefile version of rustc-option currently checks whether the option
exists for the host target instead of the target actually being compiled
for. It was done this way in commit 46e24a545cdb ("rust: kasan/kbuild:
fix missing flags on first build") to avoid a circular dependency on
target.json. However, because of this, rustc-option currently does not
function when cross-compiling from x86_64 to aarch64 if
CONFIG_SHADOW_CALL_STACK is enabled. This is because KBUILD_RUSTFLAGS
contains -Zfixed-x18 under this configuration. Since that flag does not
exist on the host target, rustc-option runs into a compilation failure
every time, leading to all flags being rejected as unsupported.

To fix this, update rustc-option to pass a --target parameter so that
the host target is not used. For targets using target.json, use a
built-in target that is as close as possible to the target created with
target.json to avoid the circular dependency on target.json.

One scenario where this causes a boot failure:
* Cross-compiled from x86_64 to aarch64.
* With CONFIG_SHADOW_CALL_STACK=y
* With CONFIG_KASAN_SW_TAGS=y
* With CONFIG_KASAN_INLINE=n
Then the resulting kernel image will fail to boot when it first calls
into Rust code with a crash along the lines of "Unable to handle kernel
paging request at virtual address 0ffffffc08541796". This is because the
call threshold is not specified, so rustc will inline kasan operations,
but the kasan shadow offset is not specified, which leads to the inlined
kasan instructions being incorrect.

Note that the -Zsanitizer=kernel-hwaddress parameter itself does not
lead to a rustc-option failure despite being aarch64-specific because
RUSTFLAGS_KASAN has not yet been added to KBUILD_RUSTFLAGS when
rustc-option is evaluated by the kasan Makefile.

Cc: stable@vger.kernel.org
Fixes: 46e24a545cdb ("rust: kasan/kbuild: fix missing flags on first build")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260507-rustc-option-cross-v2-1-2f650a49c2b5@google.com
[ Edited slightly:
    - Reset variable to avoid using the environment.
    - Use a simply expanded variable flavor for simplicity.
    - Export variable so that behavior in sub-`make`s is consistent.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

  This matches other variables. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile                  |    3 ++-
 arch/x86/Makefile         |    4 ++++
 arch/x86/Makefile.um      |    8 ++++++++
 scripts/Makefile.compiler |    2 +-
 4 files changed, 15 insertions(+), 2 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -606,6 +606,7 @@ KBUILD_RUSTFLAGS := $(rust_common_flags)
 		    -Crelocation-model=static \
 		    -Zfunction-sections=n \
 		    -Wclippy::float_arithmetic
+KBUILD_RUSTFLAGS_OPTION_CHKS :=
 
 KBUILD_AFLAGS_KERNEL :=
 KBUILD_CFLAGS_KERNEL :=
@@ -642,7 +643,7 @@ export KBUILD_USERCFLAGS KBUILD_USERLDFL
 
 export KBUILD_CPPFLAGS NOSTDINC_FLAGS LINUXINCLUDE OBJCOPYFLAGS KBUILD_LDFLAGS
 export KBUILD_CFLAGS CFLAGS_KERNEL CFLAGS_MODULE
-export KBUILD_RUSTFLAGS RUSTFLAGS_KERNEL RUSTFLAGS_MODULE
+export KBUILD_RUSTFLAGS RUSTFLAGS_KERNEL RUSTFLAGS_MODULE KBUILD_RUSTFLAGS_OPTION_CHKS
 export KBUILD_AFLAGS AFLAGS_KERNEL AFLAGS_MODULE
 export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_RUSTFLAGS_MODULE KBUILD_LDFLAGS_MODULE
 export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL KBUILD_RUSTFLAGS_KERNEL
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -81,6 +81,10 @@ KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-
 KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
 KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
 
+# The target.json file is not available when invoking rustc-option, so use the
+# built-in target when checking whether flags are supported instead.
+KBUILD_RUSTFLAGS_OPTION_CHKS += --target=x86_64-unknown-none
+
 #
 # CFLAGS for compiling floating point code inside the kernel.
 #
--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -14,6 +14,14 @@ endif
 
 KBUILD_RUSTFLAGS += --target=$(objtree)/scripts/target.json
 
+# The target.json file is not available when invoking rustc-option, so use the
+# built-in target when checking whether flags are supported instead.
+ifeq ($(CONFIG_X86_32),y)
+KBUILD_RUSTFLAGS_OPTION_CHKS += --target=i686-unknown-linux-gnu
+else
+KBUILD_RUSTFLAGS_OPTION_CHKS += --target=x86_64-unknown-linux-gnu
+endif
+
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000
 
--- a/scripts/Makefile.compiler
+++ b/scripts/Makefile.compiler
@@ -80,7 +80,7 @@ ld-option = $(call try-run, $(LD) $(KBUI
 # TODO: remove RUSTC_BOOTSTRAP=1 when we raise the minimum GNU Make version to 4.4
 __rustc-option = $(call try-run,\
 	echo '$(pound)![allow(missing_docs)]$(pound)![feature(no_core)]$(pound)![no_core]' | RUSTC_BOOTSTRAP=1\
-	$(1) --sysroot=/dev/null $(filter-out --sysroot=/dev/null --target=%,$(2)) $(3)\
+	$(1) --sysroot=/dev/null $(KBUILD_RUSTFLAGS_OPTION_CHKS) $(filter-out --sysroot=/dev/null --target=%target.json,$(2)) $(3)\
 	--crate-type=rlib --out-dir=$(TMPOUT) --emit=obj=- - >/dev/null,$(3),$(4))
 
 # rustc-option


