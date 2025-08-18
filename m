Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411232254C;
	Mon, 18 Aug 2025 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524436; cv=none; b=d+3tu3vm+DJ6SOLisSEuDAsRYs04maIo/4sPXn9Uvfl4VVzl2wCn1O8NDB3R/fAz2xmvKO1kj3sdOkGToydw+GmSP6IJtIwhgeIYKteJf9optJTMWlBMaIkgIqOyJIT8V1VKuFOyBNVS4DNqCsbtyAuxINTnx9Y6QWkIotyssRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524436; c=relaxed/simple;
	bh=fzM9aQjd8l6hfF8z8SNWXWXUqlXUPoCUy3crDalv65I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMnb4A5c7JKUdj6cULSE0czFNjD3mWNO04OhvnvDQIL54k9rDJxRP8xI/u/QH4K4Lz+T+VCx3WplKOmJuwgTh+PK8V+dVJ53gm4iv77QMZEroi8RspsWWzk4JZx8gceKENZ6NMWIysrUmnkhsO1ZPo6a1t5GMs2kr9b3su7Zmww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZGa25+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZGa25+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC56C116B1;
	Mon, 18 Aug 2025 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524436;
	bh=fzM9aQjd8l6hfF8z8SNWXWXUqlXUPoCUy3crDalv65I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZGa25+od6gj8BNrQNMio7TvEU1KCs7indFjVDvFS3RNBc+tVc1IlECMo0+1ZyOry
	 oM9bD2eC8XuT0YuPdnQTitJ3qi4BbUGX0aus+HphhQT8dbGXb7KgPrncA9lzSe7hIP
	 4vSaruzvEUriduuTWkeF4MZb2azmXdHCmKpEuFxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 439/515] rust: kbuild: clean output before running `rustdoc`
Date: Mon, 18 Aug 2025 14:47:05 +0200
Message-ID: <20250818124515.324156761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 252fea131e15aba2cd487119d1a8f546471199e2 upstream.

`rustdoc` can get confused when generating documentation into a folder
that contains generated files from other `rustdoc` versions.

For instance, running something like:

    rustup default 1.78.0
    make LLVM=1 rustdoc
    rustup default 1.88.0
    make LLVM=1 rustdoc

may generate errors like:

    error: couldn't generate documentation: invalid template: last line expected to start with a comment
      |
      = note: failed to create or modify "./Documentation/output/rust/rustdoc/src-files.js"

Thus just always clean the output folder before generating the
documentation -- we are anyway regenerating it every time the `rustdoc`
target gets called, at least for the time being.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Reported-by: Daniel Almeida <daniel.almeida@collabora.com>
Closes: https://rust-for-linux.zulipchat.com/#narrow/channel/288089/topic/x/near/527201113
Reviewed-by: Tamir Duberstein <tamird@kernel.org>
Link: https://lore.kernel.org/r/20250726133435.2460085-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -103,14 +103,14 @@ rustdoc: rustdoc-core rustdoc-macros rus
 rustdoc-macros: private rustdoc_host = yes
 rustdoc-macros: private rustc_target_flags = --crate-type proc-macro \
     --extern proc_macro
-rustdoc-macros: $(src)/macros/lib.rs FORCE
+rustdoc-macros: $(src)/macros/lib.rs rustdoc-clean FORCE
 	+$(call if_changed,rustdoc)
 
 # Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` should
 # not be needed -- see https://github.com/rust-lang/rust/pull/128307.
 rustdoc-core: private skip_flags = --edition=2021 -Wrustdoc::unescaped_backticks
 rustdoc-core: private rustc_target_flags = --edition=$(core-edition) $(core-cfgs)
-rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
+rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs rustdoc-clean FORCE
 	+$(call if_changed,rustdoc)
 
 rustdoc-compiler_builtins: $(src)/compiler_builtins.rs rustdoc-core FORCE
@@ -122,7 +122,8 @@ rustdoc-ffi: $(src)/ffi.rs rustdoc-core
 rustdoc-pin_init_internal: private rustdoc_host = yes
 rustdoc-pin_init_internal: private rustc_target_flags = --cfg kernel \
     --extern proc_macro --crate-type proc-macro
-rustdoc-pin_init_internal: $(src)/pin-init/internal/src/lib.rs FORCE
+rustdoc-pin_init_internal: $(src)/pin-init/internal/src/lib.rs \
+    rustdoc-clean FORCE
 	+$(call if_changed,rustdoc)
 
 rustdoc-pin_init: private rustdoc_host = yes
@@ -140,6 +141,9 @@ rustdoc-kernel: $(src)/kernel/lib.rs rus
     $(obj)/bindings.o FORCE
 	+$(call if_changed,rustdoc)
 
+rustdoc-clean: FORCE
+	$(Q)rm -rf $(rustdoc_output)
+
 quiet_cmd_rustc_test_library = $(RUSTC_OR_CLIPPY_QUIET) TL $<
       cmd_rustc_test_library = \
 	OBJTREE=$(abspath $(objtree)) \


