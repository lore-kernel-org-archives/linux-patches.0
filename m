Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8222571DC;
	Tue, 25 Mar 2025 12:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905728; cv=none; b=Iyqxl66tHdYHVww2sRu65Ncm+m/wsbSlBpgc00DRVlA3DUQ+v4GQqMup1Q83QHIlzbv76AMFIo0/kaD3QxEA2pmIV5urTjDK8AUL9xBo8/H/ZfhkBVqwKnqdm7NsGVmwI7jO4tvsiJqBgKao0+ZZmbS3d5AHHb5SyWSt0paGaQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905728; c=relaxed/simple;
	bh=O7Fvt7zErft/bswnBWFRkEgxrOY/Tw6EU4WMWtPJfEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ8e22cEgvhMTcguHMLhkQt5yq39Lyo/2e+3+htKoBDKhhFy2BRRne60U5gLQjrqWU0ADmxwAlAKDhpCEUOdwM4Ne2VJ0pk+FRPOFx4yM9ufQp0w1MpPnEwnRx095XiOX7qzTUQhEp6O3K+TyH1YjPVja4kTGXt/mz880MxGfFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iHUGVh3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iHUGVh3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4346DC4CEE4;
	Tue, 25 Mar 2025 12:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905728;
	bh=O7Fvt7zErft/bswnBWFRkEgxrOY/Tw6EU4WMWtPJfEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHUGVh3fC9NuxNrxQJBhpf55uNpu3lfDt8xw1m7JzcMAuntDHNhr1FklR6m+Whodt
	 MubZLo/inAPqZPgxuZThnyl4BhoA++f2bYLt9EW0nDdBNF55Zs+X5pO8I/bEEFkQPS
	 3E1837Ug4wpXrTgvMAVlaVGoQetNCks68y/m4mws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/198] scripts: generate_rust_analyzer: provide `cfg`s for `core` and `alloc`
Date: Tue, 25 Mar 2025 08:21:33 -0400
Message-ID: <20250325122200.090215006@linuxfoundation.org>
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

From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>

[ Upstream commit 4f353e0d1282dfe6b8082290fe8e606c5739a954 ]

Both `core` and `alloc` have their `cfgs` (such as `no_rc`) missing
in `rust-project.json`.

To remedy this, pass the flags to `generate_rust_analyzer.py` for
them to be added to a dictionary where each key corresponds to
a crate and each value to a list of `cfg`s. The dictionary is then
used to pass the `cfg`s to each crate in the generated file (for
`core` and `alloc` only).

Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Link: https://lore.kernel.org/r/20230804171448.54976-1-yakoyoku@gmail.com
[ Removed `Suggested-by` as discussed in mailing list. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 2e0f91aba507 ("scripts: generate_rust_analyzer: add missing macros deps")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/Makefile                     |  1 +
 scripts/generate_rust_analyzer.py | 16 ++++++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 003a1277d705f..ec737bad7fbb0 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -345,6 +345,7 @@ quiet_cmd_rustc_library = $(if $(skip_clippy),RUSTC,$(RUSTC_OR_CLIPPY_QUIET)) L
 
 rust-analyzer:
 	$(Q)$(srctree)/scripts/generate_rust_analyzer.py \
+		--cfgs='core=$(core-cfgs)' --cfgs='alloc=$(alloc-cfgs)' \
 		$(abs_srctree) $(abs_objtree) \
 		$(RUST_LIB_SRC) $(KBUILD_EXTMOD) > \
 		$(if $(KBUILD_EXTMOD),$(extmod_prefix),$(objtree))/rust-project.json
diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index a7fcacc1c72e7..030e26ef87c25 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -10,7 +10,15 @@ import os
 import pathlib
 import sys
 
-def generate_crates(srctree, objtree, sysroot_src, external_src):
+def args_crates_cfgs(cfgs):
+    crates_cfgs = {}
+    for cfg in cfgs:
+        crate, vals = cfg.split("=", 1)
+        crates_cfgs[crate] = vals.replace("--cfg", "").split()
+
+    return crates_cfgs
+
+def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
     # Generate the configuration list.
     cfg = []
     with open(objtree / "include" / "generated" / "rustc_cfg") as fd:
@@ -24,6 +32,7 @@ def generate_crates(srctree, objtree, sysroot_src, external_src):
     # Avoid O(n^2) iterations by keeping a map of indexes.
     crates = []
     crates_indexes = {}
+    crates_cfgs = args_crates_cfgs(cfgs)
 
     def append_crate(display_name, root_module, deps, cfg=[], is_workspace_member=True, is_proc_macro=False):
         crates_indexes[display_name] = len(crates)
@@ -45,6 +54,7 @@ def generate_crates(srctree, objtree, sysroot_src, external_src):
         "core",
         sysroot_src / "core" / "src" / "lib.rs",
         [],
+        cfg=crates_cfgs.get("core", []),
         is_workspace_member=False,
     )
 
@@ -58,6 +68,7 @@ def generate_crates(srctree, objtree, sysroot_src, external_src):
         "alloc",
         srctree / "rust" / "alloc" / "lib.rs",
         ["core", "compiler_builtins"],
+        cfg=crates_cfgs.get("alloc", []),
     )
 
     append_crate(
@@ -125,6 +136,7 @@ def generate_crates(srctree, objtree, sysroot_src, external_src):
 def main():
     parser = argparse.ArgumentParser()
     parser.add_argument('--verbose', '-v', action='store_true')
+    parser.add_argument('--cfgs', action='append', default=[])
     parser.add_argument("srctree", type=pathlib.Path)
     parser.add_argument("objtree", type=pathlib.Path)
     parser.add_argument("sysroot_src", type=pathlib.Path)
@@ -137,7 +149,7 @@ def main():
     )
 
     rust_project = {
-        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree),
+        "crates": generate_crates(args.srctree, args.objtree, args.sysroot_src, args.exttree, args.cfgs),
         "sysroot_src": str(args.sysroot_src),
     }
 
-- 
2.39.5



