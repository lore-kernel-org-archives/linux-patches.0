Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027C51F7580;
	Mon, 23 Jun 2025 22:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717222; cv=none; b=OGbhQar68iHVuuil5WBMaTRMFp8Mk9krJV8gBQwPLHqcSgD2+pF+LKBFGYP/IHEHWy9PBHGwWtV6/NHWAeLHZoCfZFoiYLmJOKiIp4R5wye9IkM8hsvUfRxCMIxG1s3N7jYsDAXfVRU6349Uva4XdUyAU8rsI3DL1vOZgExEYJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717222; c=relaxed/simple;
	bh=YDidlEUmO3XObSzhRoazHxoXG8rJjFZ+XKAx5ZxZpUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXn7rNplMLyEpGd0WGAnypfsTL1KWtJbNB6AguzuPnSKtR7UrrpX3w69ShQiKtO/YXqBz2XCU4J/5pWMFtZHcR5lOYWY8a5HQcnrsykk5kXmFz9tnFXM0Nf0hybbFjVbsp2qgH0yJRRcEC3TQK3HfgtJJcXszd8FIMmMLTxmIi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E00Y0OBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E00Y0OBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E06C4CEED;
	Mon, 23 Jun 2025 22:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717221;
	bh=YDidlEUmO3XObSzhRoazHxoXG8rJjFZ+XKAx5ZxZpUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E00Y0OBHV54rlQcP4TH/FfINGJ/G7u2rHxg2b0Hul192ziob+1XkOmVXznFFzmlgi
	 nCpLHVWjsVm+4L9lYgrneNyGpfAoXGPRwIen3N1VuwKs+m/Wd/0uy6ABgV29icbqM0
	 XBJPMUjpVGep1y/q+TURaEDcIxGqJ7PY9cM1AyGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	est31 <est31@protonmail.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 341/414] rust: compile libcore with edition 2024 for 1.87+
Date: Mon, 23 Jun 2025 15:07:58 +0200
Message-ID: <20250623130650.505998853@linuxfoundation.org>
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
[ Solved conflicts for 6.12.y backport. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile                     |   14 ++++++++------
 scripts/generate_rust_analyzer.py |   13 ++++++++-----
 2 files changed, 16 insertions(+), 11 deletions(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -53,6 +53,8 @@ endif
 core-cfgs = \
     --cfg no_fp_fmt_parse
 
+core-edition := $(if $(call rustc-min-version,108700),2024,2021)
+
 quiet_cmd_rustdoc = RUSTDOC $(if $(rustdoc_host),H, ) $<
       cmd_rustdoc = \
 	OBJTREE=$(abspath $(objtree)) \
@@ -95,8 +97,8 @@ rustdoc-macros: $(src)/macros/lib.rs FOR
 
 # Starting with Rust 1.82.0, skipping `-Wrustdoc::unescaped_backticks` should
 # not be needed -- see https://github.com/rust-lang/rust/pull/128307.
-rustdoc-core: private skip_flags = -Wrustdoc::unescaped_backticks
-rustdoc-core: private rustc_target_flags = $(core-cfgs)
+rustdoc-core: private skip_flags = --edition=2021 -Wrustdoc::unescaped_backticks
+rustdoc-core: private rustc_target_flags = --edition=$(core-edition) $(core-cfgs)
 rustdoc-core: $(RUST_LIB_SRC)/core/src/lib.rs FORCE
 	+$(call if_changed,rustdoc)
 
@@ -372,7 +374,7 @@ quiet_cmd_rustc_library = $(if $(skip_cl
       cmd_rustc_library = \
 	OBJTREE=$(abspath $(objtree)) \
 	$(if $(skip_clippy),$(RUSTC),$(RUSTC_OR_CLIPPY)) \
-		$(filter-out $(skip_flags),$(rust_flags) $(rustc_target_flags)) \
+		$(filter-out $(skip_flags),$(rust_flags)) $(rustc_target_flags) \
 		--emit=dep-info=$(depfile) --emit=obj=$@ \
 		--emit=metadata=$(dir $@)$(patsubst %.o,lib%.rmeta,$(notdir $@)) \
 		--crate-type rlib -L$(objtree)/$(obj) \
@@ -383,7 +385,7 @@ quiet_cmd_rustc_library = $(if $(skip_cl
 
 rust-analyzer:
 	$(Q)$(srctree)/scripts/generate_rust_analyzer.py \
-		--cfgs='core=$(core-cfgs)' \
+		--cfgs='core=$(core-cfgs)' $(core-edition) \
 		$(realpath $(srctree)) $(realpath $(objtree)) \
 		$(rustc_sysroot) $(RUST_LIB_SRC) $(KBUILD_EXTMOD) > \
 		$(if $(KBUILD_EXTMOD),$(extmod_prefix),$(objtree))/rust-project.json
@@ -407,9 +409,9 @@ define rule_rustc_library
 endef
 
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
@@ -18,7 +18,7 @@ def args_crates_cfgs(cfgs):
 
     return crates_cfgs
 
-def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
+def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs, core_edition):
     # Generate the configuration list.
     cfg = []
     with open(objtree / "include" / "generated" / "rustc_cfg") as fd:
@@ -34,7 +34,7 @@ def generate_crates(srctree, objtree, sy
     crates_indexes = {}
     crates_cfgs = args_crates_cfgs(cfgs)
 
-    def append_crate(display_name, root_module, deps, cfg=[], is_workspace_member=True, is_proc_macro=False):
+    def append_crate(display_name, root_module, deps, cfg=[], is_workspace_member=True, is_proc_macro=False, edition="2021"):
         crates_indexes[display_name] = len(crates)
         crates.append({
             "display_name": display_name,
@@ -43,7 +43,7 @@ def generate_crates(srctree, objtree, sy
             "is_proc_macro": is_proc_macro,
             "deps": [{"crate": crates_indexes[dep], "name": dep} for dep in deps],
             "cfg": cfg,
-            "edition": "2021",
+            "edition": edition,
             "env": {
                 "RUST_MODFILE": "This is only for rust-analyzer"
             }
@@ -53,6 +53,7 @@ def generate_crates(srctree, objtree, sy
         display_name,
         deps,
         cfg=[],
+        edition="2021",
     ):
         append_crate(
             display_name,
@@ -60,12 +61,13 @@ def generate_crates(srctree, objtree, sy
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
@@ -155,6 +157,7 @@ def main():
     parser = argparse.ArgumentParser()
     parser.add_argument('--verbose', '-v', action='store_true')
     parser.add_argument('--cfgs', action='append', default=[])
+    parser.add_argument("core_edition")
     parser.add_argument("srctree", type=pathlib.Path)
     parser.add_argument("objtree", type=pathlib.Path)
     parser.add_argument("sysroot", type=pathlib.Path)
@@ -171,7 +174,7 @@ def main():
     assert args.sysroot in args.sysroot_src.parents
 
     rust_project = {
-        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree, args.cfgs),
+        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree, args.cfgs, args.core_edition),
         "sysroot": str(args.sysroot),
     }
 


