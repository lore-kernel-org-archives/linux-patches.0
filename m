Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0E64534B4;
	Tue, 16 Jun 2026 15:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625530; cv=none; b=Z6+FGYwRAwLijAfyq16zSQ1rbrRv+5rV2o55pqXfAhcQG4zSnW2G3Od4c5pBs4UibFEtFEWa1sTeKNTq1rv5eMTgeXXrNU/I3OfO//aJE96BfXBetN8XAVcIhciHDW2P5H3rX+/u4MZaSpKocR5cH2HYHaL7pI1wJ0y8LvGxrRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625530; c=relaxed/simple;
	bh=ajgogWKgx8j7g64eTOs+Ao0ohrFUr/yeS2Iy1tsXmzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/JKJ04yXhRzVbUBxlPAHgKr7IRRZnXItKrXuf0ZJWU/BGAIELVO4sxdVi9wn17J33czgxa/O6JO4HiziM5nhvg+4+PXPnXfWlbBxnG5q4zJ8wN2EREuf/MNDxd1gxvIvTn1VQPX+Iilhul1DsxckUjM3yf/Khp2c5JvcRsF7zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCT/YOTW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCT/YOTW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B822A1F000E9;
	Tue, 16 Jun 2026 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625529;
	bh=yst8PGqewdyumD+nO816GxR3K9AIgwMVYVutWhpL5zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCT/YOTWe+BjVfyyNa2ircaiB9mwPJgMNYHH2pb6snPeKXufJcpybFTa5LXv3jSwR
	 T1rHyanMaQBEW/gun6mpZ2qdeLK7bG5yGj14dNAsJgD6EtlsuuimUeOYpJstqm6tXn
	 YUP3xITy4INTz69v4tuyZJhAGnN6QQjrK2e4+5K4=
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
Subject: [PATCH 6.18 161/325] rust: arm64: set uwtable llvm module flag for CONFIG_UNWIND_TABLES
Date: Tue, 16 Jun 2026 20:29:17 +0530
Message-ID: <20260616145105.790292747@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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
@@ -63,6 +63,9 @@ else
 KBUILD_CFLAGS	+= -fasynchronous-unwind-tables
 KBUILD_AFLAGS	+= -fasynchronous-unwind-tables
 KBUILD_RUSTFLAGS += -Cforce-unwind-tables=y -Zuse-sync-unwind=n
+# Work around rustc bug on compilers without
+# https://github.com/rust-lang/rust/pull/156973.
+KBUILD_RUSTFLAGS += $(if $(call rustc-min-version,109800),,-Zllvm_module_flag=uwtable:u32:2:max)
 endif
 
 ifeq ($(CONFIG_STACKPROTECTOR_PER_TASK),y)


