Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC35046AF36;
	Tue, 16 Jun 2026 16:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627282; cv=none; b=pczXvbQCZPZyPDVIVo6m0mdG23snsPrI6acczrMcVo+nm53YAwFUNC/gmQpZrZI6a+JJ5/FWmw5/L5PAqCdWwG1ePzD3d1WSFRegOUw3rJqbshAc9qbOUMMzi4v9ODKrK4M0PcxcZ0LxhBDMmBNrNebAUUP46lRGK+8s4PboesI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627282; c=relaxed/simple;
	bh=cF+SCW8eww92Z20HGzpbJTzTFiMK9WHtShd3ZSqiDEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G/KJMV2K4m1BH5Ct+A1ubawBnZ/xBItVZx+HALZlostkBsf5Zqext4N/bAb4zYVS1ZxzlXgQYeLIwELCa0XlDzTDQZynsSLnNv1XsR9vUPA0VnkiiTEJXf+7CbiUMSs6kwdGVrI9kgkAdFqyANj2F0LpU2FCe0yONXpbZv4VJCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LE8TpNu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LE8TpNu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A031F000E9;
	Tue, 16 Jun 2026 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627281;
	bh=yKZuhaQQcBouawGDUw1l97AkYeco5Tm9uQTR2GcdCJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LE8TpNu0KLw+xtHqhtdXpPi/dMbf00QB8tBD9ruw5lzRMcr1DgMqiDYnz7rzOgEPs
	 c97kTDOo4LDTeincQprE48x3Y4eabTM91qJ10lyqtAc70qWhIj36XcPfM/c5wm8WC9
	 63VrCbzRXr9NlIY/Yv6RQEgqN/HelRAiEDOikJt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Bo Ye <bo.ye@mediatek.com>,
	Isaac Manjarres <isaacmanjarres@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>
Subject: [PATCH 6.12 130/261] rust: arm64: set uwtable llvm module flag for CONFIG_UNWIND_TABLES
Date: Tue, 16 Jun 2026 20:29:28 +0530
Message-ID: <20260616145051.112762993@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit ac35b5580ace12e5d0a0b5e61e36d2c4e1ffa29c upstream.

Due to a rustc bug [1] the -Cforce-unwind-tables=y flag only emits the
uwtable annotation for functions, but not for the module. This means
that compiler-generated functions such as 'asan.module_ctor' do not
receive the uwtable annotation.

When CONFIG_UNWIND_PATCH_PAC_INTO_SCS is enabled, this leads to boot
failures because the dwarf information emitted for the kasan
constructors is wrong, which causes the SCS boot patching code to
patch the constructor in an illegal manner. Specifically, the paciasp
instruction is patched, but the autiasp instruction is not. This
mismatch leads to a crash when the constructor is called during boot.

	==================================================================
	BUG: KASAN: global-out-of-bounds in do_basic_setup+0x4c/0x90
	Read of size 8 at addr ffffffe3cc7eb488 by task swapper/0/1

Specifically the faulting instruction is the (*fn)() to invoke the
constructor in do_ctors() of the init/main.c file.

Once the fix lands in rustc, this flag can be made conditional on the
rustc version. Note that passing the flag on a rustc with the fix
present has no effect.

[ The fix [1] has landed for Rust 1.98.0 (expected release on
  2026-08-20).

  Thus add a version check as discussed.

    - Miguel ]

Fixes: d077242d68a3 ("rust: support for shadow call stack sanitizer")
Cc: stable@kernel.org
Link: https://github.com/rust-lang/rust/pull/156973 [1]
Reported-by: Bo Ye <bo.ye@mediatek.com>
Debugged-by: Isaac Manjarres <isaacmanjarres@google.com>
Debugged-by: Sami Tolvanen <samitolvanen@google.com>
Tested-by: Isaac Manjarres <isaacmanjarres@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260527-uwtable-module-flag-v1-1-caa41342be4b@google.com
[ Adjusted link and comment. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -66,6 +66,9 @@ else
 KBUILD_CFLAGS	+= -fasynchronous-unwind-tables
 KBUILD_AFLAGS	+= -fasynchronous-unwind-tables
 KBUILD_RUSTFLAGS += -Cforce-unwind-tables=y -Zuse-sync-unwind=n
+# Work around rustc bug on compilers without
+# https://github.com/rust-lang/rust/pull/156973.
+KBUILD_RUSTFLAGS += $(if $(call rustc-min-version,109800),,-Zllvm_module_flag=uwtable:u32:2:max)
 endif
 
 ifeq ($(CONFIG_STACKPROTECTOR_PER_TASK),y)


