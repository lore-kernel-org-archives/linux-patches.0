Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F682571DC;
	Tue, 25 Mar 2025 12:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905726; cv=none; b=Aguh3CdYIrFboXDweXVbFUqdoivyoCd+oUq20PJiLYG3CPZJlmvZiUQDjN/7F4PRE9hw/46JBMzaqdK6m0wk9NLd0xYQWoM4co+55OWf2UCqCiZd6YIT+RspjAEiMlTqSYUrH3UIWSXI6WFRgKkLG1NtqnB6XUs7KnNn8CMpQes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905726; c=relaxed/simple;
	bh=/oNY5ltUNBgKZLONN2I3UAvMBgc2jN4WqAI0hSFQunE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPtKNPE1fZDB8DnwrS/DnMrAE8KOyzJeK/OWKu1B/BsX3cnh0FNi8lSxw9g7HIwFv6JiSF0MzkbJI4mpOYpUAvsXhRIKjIP6NwyOpvUqShRlBVI2wbaoxhvUjGYyHcCJqv/uzsRtbviDruYeG7iNmTQGIO4s0mTWo7y2OEHB/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNIxicgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNIxicgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E886C4CEE4;
	Tue, 25 Mar 2025 12:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905726;
	bh=/oNY5ltUNBgKZLONN2I3UAvMBgc2jN4WqAI0hSFQunE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNIxicgdjitAiK5dOIsnn1Qqw4JQ5aHd5eTzgw4szMBDGFWxrXh/7eTotgSNlhvKL
	 O6V1SMMEHbt4v+hV90rU8NK1hj8NAW60SNL4HtkSFVxIJxyjI1d7Zx94AjMjCwlmjf
	 GZA3ETFpnvUuLW69tltBoQDVNJGzBCHyYkVy1iko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinay Varma <varmavinaym@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/198] scripts: `make rust-analyzer` for out-of-tree modules
Date: Tue, 25 Mar 2025 08:21:32 -0400
Message-ID: <20250325122200.064555930@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinay Varma <varmavinaym@gmail.com>

[ Upstream commit 49a9ef76740206d52e7393f6fe25fc764de8df32 ]

Adds support for out-of-tree rust modules to use the `rust-analyzer`
make target to generate the rust-project.json file.

The change involves adding an optional parameter `external_src` to the
`generate_rust_analyzer.py` which expects the path to the out-of-tree
module's source directory. When this parameter is passed, I have chosen
not to add the non-core modules (samples and drivers) into the result
since these are not expected to be used in third party modules. Related
changes are also made to the Makefile and rust/Makefile allowing the
`rust-analyzer` target to be used for out-of-tree modules as well.

Link: https://github.com/Rust-for-Linux/linux/pull/914
Link: https://github.com/Rust-for-Linux/rust-out-of-tree-module/pull/2
Signed-off-by: Vinay Varma <varmavinaym@gmail.com>
Link: https://lore.kernel.org/r/20230411091714.130525-1-varmavinaym@gmail.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 2e0f91aba507 ("scripts: generate_rust_analyzer: add missing macros deps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile                          | 11 ++++++-----
 rust/Makefile                     |  6 ++++--
 scripts/generate_rust_analyzer.py | 27 ++++++++++++++++++---------
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 58d17d3395782..8d9cb47a76f2e 100644
--- a/Makefile
+++ b/Makefile
@@ -1851,11 +1851,6 @@ rustfmt:
 rustfmtcheck: rustfmt_flags = --check
 rustfmtcheck: rustfmt
 
-# IDE support targets
-PHONY += rust-analyzer
-rust-analyzer:
-	$(Q)$(MAKE) $(build)=rust $@
-
 # Misc
 # ---------------------------------------------------------------------------
 
@@ -1908,6 +1903,7 @@ help:
 	@echo  '  modules         - default target, build the module(s)'
 	@echo  '  modules_install - install the module'
 	@echo  '  clean           - remove generated files in module directory only'
+	@echo  '  rust-analyzer	  - generate rust-project.json rust-analyzer support file'
 	@echo  ''
 
 endif # KBUILD_EXTMOD
@@ -2044,6 +2040,11 @@ quiet_cmd_tags = GEN     $@
 tags TAGS cscope gtags: FORCE
 	$(call cmd,tags)
 
+# IDE support targets
+PHONY += rust-analyzer
+rust-analyzer:
+	$(Q)$(MAKE) $(build)=rust $@
+
 # Script to generate missing namespace dependencies
 # ---------------------------------------------------------------------------
 
diff --git a/rust/Makefile b/rust/Makefile
index 28ba3b9ee18dd..003a1277d705f 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -344,8 +344,10 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 	$(if $(rustc_objcopy),;$(OBJCOPY) $(rustc_objcopy) $@)
 
 rust-analyzer:
-	$(Q)$(srctree)/scripts/generate_rust_analyzer.py $(srctree) $(objtree) \
-		$(RUST_LIB_SRC) > $(objtree)/rust-project.json
+	$(Q)$(srctree)/scripts/generate_rust_analyzer.py \
+		$(abs_srctree) $(abs_objtree) \
+		$(RUST_LIB_SRC) $(KBUILD_EXTMOD) > \
+		$(if $(KBUILD_EXTMOD),$(extmod_prefix),$(objtree))/rust-project.json
 
 $(obj)/core.o: private skip_clippy = 1
 $(obj)/core.o: private skip_flags = -Dunreachable_pub
diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index ab6af280b9de0..a7fcacc1c72e7 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -6,10 +6,11 @@
 import argparse
 import json
 import logging
+import os
 import pathlib
 import sys
 
-def generate_crates(srctree, objtree, sysroot_src):
+def generate_crates(srctree, objtree, sysroot_src, external_src):
     # Generate the configuration list.
     cfg = []
     with open(objtree / "include" / "generated" / "rustc_cfg") as fd:
@@ -65,7 +66,7 @@ def generate_crates(srctree, objtree, sysroot_src):
         [],
         is_proc_macro=True,
     )
-    crates[-1]["proc_macro_dylib_path"] = "rust/libmacros.so"
+    crates[-1]["proc_macro_dylib_path"] = f"{objtree}/rust/libmacros.so"
 
     append_crate(
         "bindings",
@@ -89,19 +90,26 @@ def generate_crates(srctree, objtree, sysroot_src):
         "exclude_dirs": [],
     }
 
+    def is_root_crate(build_file, target):
+        try:
+            return f"{target}.o" in open(build_file).read()
+        except FileNotFoundError:
+            return False
+
     # Then, the rest outside of `rust/`.
     #
     # We explicitly mention the top-level folders we want to cover.
-    for folder in ("samples", "drivers"):
-        for path in (srctree / folder).rglob("*.rs"):
+    extra_dirs = map(lambda dir: srctree / dir, ("samples", "drivers"))
+    if external_src is not None:
+        extra_dirs = [external_src]
+    for folder in extra_dirs:
+        for path in folder.rglob("*.rs"):
             logging.info("Checking %s", path)
             name = path.name.replace(".rs", "")
 
             # Skip those that are not crate roots.
-            try:
-                if f"{name}.o" not in open(path.parent / "Makefile").read():
-                    continue
-            except FileNotFoundError:
+            if not is_root_crate(path.parent / "Makefile", name) and \
+               not is_root_crate(path.parent / "Kbuild", name):
                 continue
 
             logging.info("Adding %s", name)
@@ -120,6 +128,7 @@ def main():
     parser.add_argument("srctree", type=pathlib.Path)
     parser.add_argument("objtree", type=pathlib.Path)
     parser.add_argument("sysroot_src", type=pathlib.Path)
+    parser.add_argument("exttree", type=pathlib.Path, nargs="?")
     args = parser.parse_args()
 
     logging.basicConfig(
@@ -128,7 +137,7 @@ def main():
     )
 
     rust_project = {
-        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src),
+        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree),
         "sysroot_src": str(args.sysroot_src),
     }
 
-- 
2.39.5



