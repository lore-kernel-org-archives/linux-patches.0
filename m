Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC88B12FB14;
	Tue, 14 May 2024 11:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686182; cv=none; b=txKTeel6WNugC1/D3KN9Xqj70al2FqPrv8d1SD2Xfc/6jJVCagqd4fjoEYSmh2FvhzNGZo49oPkftwiND0YqftH80VU0S4MIMAgOjlJ5sjjqRjcniOJ/34eOP1bEImOqVC3e51b6VudD/CU/1wPYs42JzPYv3lZly6ktNBGAy+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686182; c=relaxed/simple;
	bh=3xkHGTU4uP0iwNNiF0c4OCftbHtmypx0l7iQiwhLJuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlXGZVX+WOypIwMEas9R6F0Q4jYBF9B5jYHPEKHr4/zZgYoU44CNGnHBTMVXh/AHTfQ00IDkOafHwbZdGZC/eYaMA7z9HaMS6h5lrK63Qx83dtkJrvS9I6U1G6B3vTRKZTVcSiYrC6M4bBoUjxEecAoRqwExU2tTb8Xv5Wc/0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKN4Ww8T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKN4Ww8T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ED0C2BD10;
	Tue, 14 May 2024 11:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686182;
	bh=3xkHGTU4uP0iwNNiF0c4OCftbHtmypx0l7iQiwhLJuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKN4Ww8TI60EFFKq4MxH7qKgB35UWYad0s+aGhfEZwMHW6SKfuIiCTT74Mywdcu6j
	 aq63iTmACbrJmhjvdYOzBqACaL1KGIrDAWvC7kx2CvdgXdfRHosk7/8ePXCUyAw55u
	 +iAlgM7QdJUyP0RcSuY7M9LncyYhGl58moUKNE/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/236] kbuild: specify output names separately for each emission type from rustc
Date: Tue, 14 May 2024 12:16:21 +0200
Message-ID: <20240514101021.061560543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 295d8398c67e314d99bb070f38883f83fe94a97a ]

In Kbuild, two different rules must not write to the same file, but
it happens when compiling rust source files.

For example, set CONFIG_SAMPLE_RUST_MINIMAL=m and run the following:

  $ make -j$(nproc) samples/rust/rust_minimal.o samples/rust/rust_minimal.rsi \
                    samples/rust/rust_minimal.s samples/rust/rust_minimal.ll
    [snip]
    RUSTC [M] samples/rust/rust_minimal.o
    RUSTC [M] samples/rust/rust_minimal.rsi
    RUSTC [M] samples/rust/rust_minimal.s
    RUSTC [M] samples/rust/rust_minimal.ll
  mv: cannot stat 'samples/rust/rust_minimal.d': No such file or directory
  make[3]: *** [scripts/Makefile.build:334: samples/rust/rust_minimal.ll] Error 1
  make[3]: *** Waiting for unfinished jobs....
  mv: cannot stat 'samples/rust/rust_minimal.d': No such file or directory
  make[3]: *** [scripts/Makefile.build:309: samples/rust/rust_minimal.o] Error 1
  mv: cannot stat 'samples/rust/rust_minimal.d': No such file or directory
  make[3]: *** [scripts/Makefile.build:326: samples/rust/rust_minimal.s] Error 1
  make[2]: *** [scripts/Makefile.build:504: samples/rust] Error 2
  make[1]: *** [scripts/Makefile.build:504: samples] Error 2
  make: *** [Makefile:2008: .] Error 2

The reason for the error is that 4 threads running in parallel renames
the same file, samples/rust/rust_minimal.d.

This does not happen when compiling C or assembly files because
-Wp,-MMD,$(depfile) explicitly specifies the dependency filepath.
$(depfile) is a unique path for each target.

Currently, rustc is only given --out-dir and --emit=<list-of-types>
So, all the rust build rules output the dep-info into the default
<CRATE_NAME>.d, which causes the path conflict.

Fortunately, the --emit option is able to specify the output path
individually, with the form --emit=<type>=<path>.

Add --emit=dep-info=$(depfile) to the common part. Also, remove the
redundant --out-dir because the output path is specified for each type.

The code gets much cleaner because we do not need to rename *.d files.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
Tested-by: Miguel Ojeda <ojeda@kernel.org>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Stable-dep-of: ded103c7eb23 ("kbuild: rust: force `alloc` extern to allow "empty" Rust files")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile          | 11 +++++------
 scripts/Makefile.build | 14 +++++++-------
 scripts/Makefile.host  |  7 +++----
 3 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 7700d3853404e..6d0c0e9757f21 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -322,10 +322,9 @@ $(obj)/exports_kernel_generated.h: $(obj)/kernel.o FORCE
 quiet_cmd_rustc_procmacro = $(RUSTC_OR_CLIPPY_QUIET) P $@
       cmd_rustc_procmacro = \
 	$(RUSTC_OR_CLIPPY) $(rust_common_flags) \
-		--emit=dep-info,link --extern proc_macro \
-		--crate-type proc-macro --out-dir $(objtree)/$(obj) \
+		--emit=dep-info=$(depfile) --emit=link=$@ --extern proc_macro \
+		--crate-type proc-macro \
 		--crate-name $(patsubst lib%.so,%,$(notdir $@)) $<; \
-	mv $(objtree)/$(obj)/$(patsubst lib%.so,%,$(notdir $@)).d $(depfile); \
 	sed -i '/^\#/d' $(depfile)
 
 # Procedural macros can only be used with the `rustc` that compiled it.
@@ -339,10 +338,10 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 	OBJTREE=$(abspath $(objtree)) \
 	$(if $(skip_clippy),$(RUSTC),$(RUSTC_OR_CLIPPY)) \
 		$(filter-out $(skip_flags),$(rust_flags) $(rustc_target_flags)) \
-		--emit=dep-info,obj,metadata --crate-type rlib \
-		--out-dir $(objtree)/$(obj) -L$(objtree)/$(obj) \
+		--emit=dep-info=$(depfile) --emit=obj=$@ \
+		--emit=metadata=$(dir $@)$(patsubst %.o,lib%.rmeta,$(notdir $@)) \
+		--crate-type rlib -L$(objtree)/$(obj) \
 		--crate-name $(patsubst %.o,%,$(notdir $@)) $<; \
-	mv $(objtree)/$(obj)/$(patsubst %.o,%,$(notdir $@)).d $(depfile); \
 	sed -i '/^\#/d' $(depfile) \
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@)
 
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 41f3602fc8de7..9ae02542b9389 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -283,11 +283,11 @@ rust_common_cmd = \
 	-Zcrate-attr=no_std \
 	-Zcrate-attr='feature($(rust_allowed_features))' \
 	--extern alloc --extern kernel \
-	--crate-type rlib --out-dir $(obj) -L $(objtree)/rust/ \
-	--crate-name $(basename $(notdir $@))
+	--crate-type rlib -L $(objtree)/rust/ \
+	--crate-name $(basename $(notdir $@)) \
+	--emit=dep-info=$(depfile)
 
 rust_handle_depfile = \
-	mv $(obj)/$(basename $(notdir $@)).d $(depfile); \
 	sed -i '/^\#/d' $(depfile)
 
 # `--emit=obj`, `--emit=asm` and `--emit=llvm-ir` imply a single codegen unit
@@ -300,7 +300,7 @@ rust_handle_depfile = \
 
 quiet_cmd_rustc_o_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
       cmd_rustc_o_rs = \
-	$(rust_common_cmd) --emit=dep-info,obj $<; \
+	$(rust_common_cmd) --emit=obj=$@ $<; \
 	$(rust_handle_depfile)
 
 $(obj)/%.o: $(src)/%.rs FORCE
@@ -308,7 +308,7 @@ $(obj)/%.o: $(src)/%.rs FORCE
 
 quiet_cmd_rustc_rsi_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
       cmd_rustc_rsi_rs = \
-	$(rust_common_cmd) --emit=dep-info -Zunpretty=expanded $< >$@; \
+	$(rust_common_cmd) -Zunpretty=expanded $< >$@; \
 	command -v $(RUSTFMT) >/dev/null && $(RUSTFMT) $@; \
 	$(rust_handle_depfile)
 
@@ -317,7 +317,7 @@ $(obj)/%.rsi: $(src)/%.rs FORCE
 
 quiet_cmd_rustc_s_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
       cmd_rustc_s_rs = \
-	$(rust_common_cmd) --emit=dep-info,asm $<; \
+	$(rust_common_cmd) --emit=asm=$@ $<; \
 	$(rust_handle_depfile)
 
 $(obj)/%.s: $(src)/%.rs FORCE
@@ -325,7 +325,7 @@ $(obj)/%.s: $(src)/%.rs FORCE
 
 quiet_cmd_rustc_ll_rs = $(RUSTC_OR_CLIPPY_QUIET) $(quiet_modtag) $@
       cmd_rustc_ll_rs = \
-	$(rust_common_cmd) --emit=dep-info,llvm-ir $<; \
+	$(rust_common_cmd) --emit=llvm-ir=$@ $<; \
 	$(rust_handle_depfile)
 
 $(obj)/%.ll: $(src)/%.rs FORCE
diff --git a/scripts/Makefile.host b/scripts/Makefile.host
index 4a02b31cd1029..d812241144d44 100644
--- a/scripts/Makefile.host
+++ b/scripts/Makefile.host
@@ -86,7 +86,8 @@ hostc_flags    = -Wp,-MMD,$(depfile) \
 hostcxx_flags  = -Wp,-MMD,$(depfile) \
                  $(KBUILD_HOSTCXXFLAGS) $(HOST_EXTRACXXFLAGS) \
                  $(HOSTCXXFLAGS_$(target-stem).o)
-hostrust_flags = $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
+hostrust_flags = --emit=dep-info=$(depfile) \
+                 $(KBUILD_HOSTRUSTFLAGS) $(HOST_EXTRARUSTFLAGS) \
                  $(HOSTRUSTFLAGS_$(target-stem))
 
 # $(objtree)/$(obj) for including generated headers from checkin source files
@@ -147,9 +148,7 @@ $(host-cxxobjs): $(obj)/%.o: $(src)/%.cc FORCE
 # host-rust -> Executable
 quiet_cmd_host-rust	= HOSTRUSTC $@
       cmd_host-rust	= \
-	$(HOSTRUSTC) $(hostrust_flags) --emit=dep-info,link \
-		--out-dir=$(obj)/ $<; \
-	mv $(obj)/$(target-stem).d $(depfile); \
+	$(HOSTRUSTC) $(hostrust_flags) --emit=link=$@ $<; \
 	sed -i '/^\#/d' $(depfile)
 $(host-rust): $(obj)/%: $(src)/%.rs FORCE
 	$(call if_changed_dep,host-rust)
-- 
2.43.0



