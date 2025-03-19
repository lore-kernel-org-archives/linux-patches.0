Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7D11DEFD6;
	Wed, 19 Mar 2025 14:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395261; cv=none; b=sv0GRufyB4CA1ROMrZOgA8kEUHS+XpC1aM+a6ys/hhBbyXxrztau+94uVz7Gi0TRVqtS2fA3y/KpFBjqD6zCl9iwC5wsqJPIOyrxK0aFZGrE9l5rE1WD6aCValHu9ZM/1uFPc+y5uPQBnvah0bglXh1DZJB/DxIIftiyIHQV2YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395261; c=relaxed/simple;
	bh=mswuODvXakAtDvSCj7UbCOGGakB21diBaGyKd5rdSOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMECfML+Ds8fJIJGxUnOZ0yl3xJw0XXOwc91vMU/i57SvNdcxvciunQ15B7W36JZ5v96Kf6uQfxaTKfJEtfdKrDvJO6NK8YjtddFKkBkJlfuXhp0FngR10c2Vx5fuCfXMwRgxYxylYaeXvcD4LRuWq7FVWwc0rI50J68qUCGUZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00leedIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00leedIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC44C4CEE4;
	Wed, 19 Mar 2025 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395261;
	bh=mswuODvXakAtDvSCj7UbCOGGakB21diBaGyKd5rdSOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00leedIHHvrKmMiePX0MIaDY1s4X04gSeKEAsfhu9mNJcyAlGlwVEVi4v0XYFvtaP
	 Ec+no/g3gVfwMwDzH3gdCMLacjNKtKFL/22ETUR23xaSGHW2A0grW+NeAYW7DZEr3V
	 2zpd6WJiqVrwzzJfAZ0P+l98yrF+3mSSKn5sTr40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fiona Behrens <me@kloenk.dev>,
	Tamir Duberstein <tamird@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Chayim Refael Friedman <chayimfr@gmail.com>
Subject: [PATCH 6.6 146/166] scripts: generate_rust_analyzer: add missing macros deps
Date: Wed, 19 Mar 2025 07:31:57 -0700
Message-ID: <20250319143023.979002652@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit 2e0f91aba507a3cb59f7a12fc3ea2b7d4d6675b7 ]

The macros crate has depended on std and proc_macro since its
introduction in commit 1fbde52bde73 ("rust: add `macros` crate"). These
dependencies were omitted from commit 8c4555ccc55c ("scripts: add
`generate_rust_analyzer.py`") resulting in missing go-to-definition and
autocomplete, and false-positive warnings emitted from rust-analyzer
such as:

  [{
  	"resource": "/Users/tamird/src/linux/rust/macros/module.rs",
  	"owner": "_generated_diagnostic_collection_name_#1",
  	"code": {
  		"value": "non_snake_case",
  		"target": {
  			"$mid": 1,
  			"path": "/rustc/",
  			"scheme": "https",
  			"authority": "doc.rust-lang.org",
  			"query": "search=non_snake_case"
  		}
  	},
  	"severity": 4,
  	"message": "Variable `None` should have snake_case name, e.g. `none`",
  	"source": "rust-analyzer",
  	"startLineNumber": 123,
  	"startColumn": 17,
  	"endLineNumber": 123,
  	"endColumn": 21
  }]

Add the missing dependencies to improve the developer experience.

  [ Fiona had a different approach (thanks!) at:

        https://lore.kernel.org/rust-for-linux/20241205115438.234221-1-me@kloenk.dev/

    But Tamir and Fiona agreed to this one. - Miguel ]

Fixes: 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
Reviewed-by: Fiona Behrens <me@kloenk.dev>
Diagnosed-by: Chayim Refael Friedman <chayimfr@gmail.com>
Link: https://github.com/rust-lang/rust-analyzer/issues/17759#issuecomment-2646328275
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Tested-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20250210-rust-analyzer-macros-core-dep-v3-1-45eb4836f218@gmail.com
[ Removed `return`. Changed tag name. Added Link. Slightly
  reworded. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/generate_rust_analyzer.py | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index fc52bc41d3e7b..c99173e4b8f3e 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -49,14 +49,26 @@ def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
             }
         })
 
-    # First, the ones in `rust/` since they are a bit special.
-    append_crate(
-        "core",
-        sysroot_src / "core" / "src" / "lib.rs",
-        [],
-        cfg=crates_cfgs.get("core", []),
-        is_workspace_member=False,
-    )
+    def append_sysroot_crate(
+        display_name,
+        deps,
+        cfg=[],
+    ):
+        append_crate(
+            display_name,
+            sysroot_src / display_name / "src" / "lib.rs",
+            deps,
+            cfg,
+            is_workspace_member=False,
+        )
+
+    # NB: sysroot crates reexport items from one another so setting up our transitive dependencies
+    # here is important for ensuring that rust-analyzer can resolve symbols. The sources of truth
+    # for this dependency graph are `(sysroot_src / crate / "Cargo.toml" for crate in crates)`.
+    append_sysroot_crate("core", [], cfg=crates_cfgs.get("core", []))
+    append_sysroot_crate("alloc", ["core"])
+    append_sysroot_crate("std", ["alloc", "core"])
+    append_sysroot_crate("proc_macro", ["core", "std"])
 
     append_crate(
         "compiler_builtins",
@@ -74,7 +86,7 @@ def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
     append_crate(
         "macros",
         srctree / "rust" / "macros" / "lib.rs",
-        [],
+        ["std", "proc_macro"],
         is_proc_macro=True,
     )
     crates[-1]["proc_macro_dylib_path"] = f"{objtree}/rust/libmacros.so"
-- 
2.39.5



