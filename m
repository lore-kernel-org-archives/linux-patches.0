Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61B42FA624;
	Tue, 17 Jun 2025 16:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179523; cv=none; b=WQafmrhxwT0CrG8g40WwEJXsOHKQL5ezthtnon0mZLXFpOL9CiaIXd39/PdmvXg0D/McECi10bhQf2iNVK4Aoyit43/vSs+AEuyOPqIReCFtf7mUgIhUEMLPD+PXO96RUC9W8MvIvF02oOx4jobCdmjdWOlApdBBRor14pDOzRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179523; c=relaxed/simple;
	bh=IRuHPN0kB8/SfquuNjsuC9+LEJfkvujCfSmwB/VTdI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzBv7of/xwrUTT1CXf6IzrrRz+aaqclsrP0BOiuVvGgbrICeeK+Ft7wsJypSqePy4J30dEGR5UKOYATsoFgccKZD7TP+KCBQ1fAvqpaoJUIxFlUOkE6aFbiVM6w3szT0++HyiRCX/HU5Nf3HVF5qmw93oa5Y2g2JhZ1+zJ6Q9Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f3XmbU3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f3XmbU3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563D1C4CEE3;
	Tue, 17 Jun 2025 16:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179522;
	bh=IRuHPN0kB8/SfquuNjsuC9+LEJfkvujCfSmwB/VTdI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3XmbU3eFuau2LhAm2PJmvr2ITDyPXRgllN0EMcHMsdcNQwkM8bzwKjBxIne9LSgF
	 QUyzzWuJBkUp4A1ZsScz5OBlPzo+SXIJq9Qz67ptroV/oHcytFyherAcbJ+5VhnSz9
	 Sf5MlGV92YAlIsXk5zHqTxvQI4UrvSHik37eIXxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	est31 <est31@protonmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.15 741/780] rust: compile libcore with edition 2024 for 1.87+
Date: Tue, 17 Jun 2025 17:27:29 +0200
Message-ID: <20250617152521.678313430@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

commit f4daa80d6be7d3c55ca72a8e560afc4e21f886aa upstream.

Rust 1.87 (released on 2025-05-15) compiles core library with edition
2024 instead of 2021 [1]. Ensure that the edition matches libcore's
expectation to avoid potential breakage.

[ J3m3 reported in Zulip [2] that the `rust-analyzer` target was
  broken after this patch -- indeed, we need to avoid `core-cfgs`
  since those are passed to the `rust-analyzer` target.

  So, instead, I tweaked the patch to create a new `core-edition`
  variable and explicitly mention the `--edition` flag instead of
  reusing `core-cfg`s.

  In addition, pass a new argument using this new variable to
  `generate_rust_analyzer.py` so that we set the right edition there.

  By the way, for future reference: the `filter-out` change is needed
  for Rust < 1.87, since otherwise we would skip the `--edition=2021`
  we just added, ending up with no edition flag, and thus the compiler
  would default to the 2015 one.

  [2] https://rust-for-linux.zulipchat.com/#narrow/channel/291565/topic/x/near/520206547

    - Miguel ]

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/138162 [1]
Reported-by: est31 <est31@protonmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/1163
Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20250517085600.2857460-1-gary@garyguo.net
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile                     |   14 ++++++++------
 scripts/generate_rust_analyzer.py |   13 ++++++++-----
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -60,6 +60,8 @@ endif
 core-cfgs = \
     --cfg no_fp_fmt_parse
 
+core-edition := $(if $(call rustc-min-version,108700),2024,2021)
+
 # `rustc` recognizes `--remap-path-prefix` since 1.26.0, but `rustdoc` only
 # since Rust 1.81.0. Moreover, `rustdoc` ICEs on out-of-tree builds since Rust
 # 1.82.0 (https://github.com/rust-lang/rust/issues/138520). Thus workaround both
@@ -106,8 +108,8 @@ rustdoc-macros: $(src)/macros/lib.rs FOR
 
 # Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` should
 # not be needed -- see https://github.com/rust-lang/rust/pull/128307.
-rustdoc-core: private skip_flags = -Wrustdoc::unescaped_backticks
-rustdoc-core: private rustc_target_flags = $(core-cfgs)
+rustdoc-core: private skip_flags = --edition=2021 -Wrustdoc::unescaped_backticks
+rustdoc-core: private rustc_target_flags = --edition=$(core-edition) $(core-cfgs)
 rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
 	+$(call if_changed,rustdoc)
 
@@ -416,7 +418,7 @@ quiet_cmd_rustc_library = $(if $(skip_cl
       cmd_rustc_library = \
 	OBJTREE=$(abspath $(objtree)) \
 	$(if $(skip_clippy),$(RUSTC),$(RUSTC_OR_CLIPPY)) \
-		$(filter-out $(skip_flags),$(rust_flags) $(rustc_target_flags)) \
+		$(filter-out $(skip_flags),$(rust_flags)) $(rustc_target_flags) \
 		--emit=dep-info=$(depfile) --emit=obj=$@ \
 		--emit=metadata=$(dir $@)$(patsubst %.o,lib%.rmeta,$(notdir $@)) \
 		--crate-type rlib -L$(objtree)/$(obj) \
@@ -427,7 +429,7 @@ quiet_cmd_rustc_library = $(if $(skip_cl
 
 rust-analyzer:
 	$(Q)MAKEFLAGS= $(srctree)/scripts/generate_rust_analyzer.py \
-		--cfgs='core=$(core-cfgs)' \
+		--cfgs='core=$(core-cfgs)' $(core-edition) \
 		$(realpath $(srctree)) $(realpath $(objtree)) \
 		$(rustc_sysroot) $(RUST_LIB_SRC) $(if $(KBUILD_EXTMOD),$(srcroot)) \
 		> rust-project.json
@@ -483,9 +485,9 @@ $(obj)/helpers/helpers.o: $(src)/helpers
 $(obj)/exports.o: private skip_gendwarfksyms = 1
 
 $(obj)/core.o: private skip_clippy = 1
-$(obj)/core.o: private skip_flags = -Wunreachable_pub
+$(obj)/core.o: private skip_flags = --edition=2021 -Wunreachable_pub
 $(obj)/core.o: private rustc_objcopy = $(foreach sym,$(redirect-intrinsics),--redefine-sym $(sym)=__rust$(sym))
-$(obj)/core.o: private rustc_target_flags = $(core-cfgs)
+$(obj)/core.o: private rustc_target_flags = --edition=$(core-edition) $(core-cfgs)
 $(obj)/core.o: $(RUST_LIB_SRC)/core/src/lib.rs \
     $(wildcard $(objtree)/include/config/RUSTC_VERSION_TEXT) FORCE
 	+$(call if_changed_rule,rustc_library)
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -19,7 +19,7 @@ def args_crates_cfgs(cfgs):
 
     return crates_cfgs
 
-def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
+def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs, core_edition):
     # Generate the configuration list.
     cfg = []
     with open(objtree / "include" / "generated" / "rustc_cfg") as fd:
@@ -35,7 +35,7 @@ def generate_crates(srctree, objtree, sy
     crates_indexes = {}
     crates_cfgs = args_crates_cfgs(cfgs)
 
-    def append_crate(display_name, root_module, deps, cfg=[], is_workspace_member=True, is_proc_macro=False):
+    def append_crate(display_name, root_module, deps, cfg=[], is_workspace_member=True, is_proc_macro=False, edition="2021"):
         crate = {
             "display_name": display_name,
             "root_module": str(root_module),
@@ -43,7 +43,7 @@ def generate_crates(srctree, objtree, sy
             "is_proc_macro": is_proc_macro,
             "deps": [{"crate": crates_indexes[dep], "name": dep} for dep in deps],
             "cfg": cfg,
-            "edition": "2021",
+            "edition": edition,
             "env": {
                 "RUST_MODFILE": "This is only for rust-analyzer"
             }
@@ -61,6 +61,7 @@ def generate_crates(srctree, objtree, sy
         display_name,
         deps,
         cfg=[],
+        edition="2021",
     ):
         append_crate(
             display_name,
@@ -68,12 +69,13 @@ def generate_crates(srctree, objtree, sy
             deps,
             cfg,
             is_workspace_member=False,
+            edition=edition,
         )
 
     # NB: sysroot crates reexport items from one another so setting up our transitive dependencies
     # here is important for ensuring that rust-analyzer can resolve symbols. The sources of truth
     # for this dependency graph are `(sysroot_src / crate / "Cargo.toml" for crate in crates)`.
-    append_sysroot_crate("core", [], cfg=crates_cfgs.get("core", []))
+    append_sysroot_crate("core", [], cfg=crates_cfgs.get("core", []), edition=core_edition)
     append_sysroot_crate("alloc", ["core"])
     append_sysroot_crate("std", ["alloc", "core"])
     append_sysroot_crate("proc_macro", ["core", "std"])
@@ -177,6 +179,7 @@ def main():
     parser = argparse.ArgumentParser()
     parser.add_argument('--verbose', '-v', action='store_true')
     parser.add_argument('--cfgs', action='append', default=[])
+    parser.add_argument("core_edition")
     parser.add_argument("srctree", type=pathlib.Path)
     parser.add_argument("objtree", type=pathlib.Path)
     parser.add_argument("sysroot", type=pathlib.Path)
@@ -193,7 +196,7 @@ def main():
     assert args.sysroot in args.sysroot_src.parents
 
     rust_project = {
-        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree, args.cfgs),
+        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree, args.cfgs, args.core_edition),
         "sysroot": str(args.sysroot),
     }
 


