Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCA03876B3;
	Fri,  4 Sep 2026 05:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498336; cv=none; b=p8zvIGFTBdTawiUqflDgLa4h+3elGzP54d8buOodWNqCr53V4JBliY4R8VkifoEskfP4v0Y7goZ9o31vFfAQroj5qTbZjwCV3Skldy+SVK73opHWcFEyZRZclRBPAQRLnf8AZ/3yahyIr3V3Eo6rTE2KYCt7WSe8XGjrr/GzFhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498336; c=relaxed/simple;
	bh=ErXf+JapEHZFx5DMYOd+lW7uRzbTycTdgrGya1Ljk3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eH6xkB78OW61exhuojLn7h88FThRzqOhl+siQvP2bJV7kWqhK+2LtjmufUvIYM+r/iH4q8/OUalt9YAvypqWXz1gCGL4o8be/veCTt5aZjBD6fDnKdobcr5YYThjN0wbG1UVyIs+dYZvcm8P4sli5CudG3Qn/UoyUU5BtU4BMl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GTFtPHPQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTFtPHPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69801F00A3D;
	Fri,  4 Sep 2026 05:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498335;
	bh=mnDBCOrS7UxlhTtb/voaCP/ejwBKPytuzCB/uw5RvtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GTFtPHPQ5AoRXJLwBdN0+vhc4U8fvWzAriytyXoT15QbTuz3Gnp5qZMP6QvDj1Olt
	 oIE7W1TDREGYwS29glFYIohsQpdeqkGEvwyDVSSFWk4xu1lggpQXGwWTtfNdsXXprp
	 P7w6PPRJc7A1SKMwvTpDe/g5k9+65nj76acCgDig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Boucher <bouanto@zoho.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 026/713] rust: kbuild: disambiguate `zerocopy` for `rusttest`
Date: Fri,  4 Sep 2026 06:49:54 +0200
Message-ID: <20260904045804.416381891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoni Boucher <bouanto@zoho.com>

commit fe39a233ea52601d416a1d02e7f70049aae47016 upstream.

Starting with Rust 1.76.0, `zerocopy` was added as an (indirect)
compiler dependency [1]. In turn, this meant that the `rustc-dev`
component started including a precompiled `zerocopy` crate in the sysroot.

This makes `rusttest` fail because the compiler finds several candidates:

    error[E0464]: multiple candidates for `rmeta` dependency `zerocopy` found
      --> rust/kernel/prelude.rs:64:9
       |
    64 | pub use zerocopy::{
       |         ^^^^^^^^
       |
       = note: candidate #1: .../lib/rustlib/x86_64-unknown-linux-gnu/lib/libzerocopy-dfef4cb07ca752aa.rmeta
       = note: candidate #2: ./rust/test/libzerocopy.rlib

We cannot use `--sysroot=/dev/null` for these, thus point to the dependency
explicitly.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Antoni Boucher <bouanto@zoho.com>
Cc: stable@vger.kernel.org
Fixes: 567621523ab7 ("rust: zerocopy: enable support in kbuild")
Link: https://github.com/rust-lang/rust/pull/118546 [1]
Link: https://patch.msgid.link/20260729173803.13459-1-ojeda@kernel.org
[ Investigated when it started happening, reworded to add that and to
  follow our usual style and sent on behalf of Antoni, who found this
  during his work to support Rust for Linux with the GCC backend, i.e.
  with `rustc_codegen_gcc`. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 627ed79dc6f5..fbe0accc51a3 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -350,7 +350,7 @@ rusttestlib-pin_init: $(src)/pin-init/src/lib.rs rusttestlib-macros \
 rusttestlib-kernel: private rustc_target_flags = --extern ffi \
     --extern build_error --extern macros --extern pin_init \
     --extern bindings --extern uapi \
-    --extern zerocopy --extern zerocopy_derive
+    --extern zerocopy=$(objtree)/$(obj)/test/libzerocopy.rlib --extern zerocopy_derive
 rusttestlib-kernel: $(src)/kernel/lib.rs rusttestlib-bindings rusttestlib-uapi \
     rusttestlib-build_error rusttestlib-pin_init $(obj)/$(libmacros_name) \
     $(obj)/bindings.o rusttestlib-zerocopy rusttestlib-zerocopy_derive FORCE
-- 
2.55.0



