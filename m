Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7391225A337;
	Tue, 25 Mar 2025 12:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905730; cv=none; b=hqL00ORwWy8hPp3q2L0Z+ldGU+nbTK63zr6ufgaOZ1L4Pk3QOF/kU1G/EOyLStpNeSs/I0s1kxawIDcGdy1e9D/iFQpJUB1cEvkHkt8kO+BSs7qQz/3tVSoJlYCW9sloJQqa47Krni4QxQ8+qCXmyK+PWfVvuLmpCvC+PI1iBNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905730; c=relaxed/simple;
	bh=gg5fDFOFdyoX5DkM/ht1maDNqi0aSpQDQ+n0+29DVRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkVYI263H3kkp0fYbr+2iwS+ne9pL927jr930i9nQuFp3FBgMDb+BH5hiT+XzdOKG8NxY6NpzbCw2OcC1jLMjzbDdaWgLc1t7qwhABbc6TV52LMbMacZAMce1PCR69YZJathZ0TKegkO0jR5zCfFuT8wYL9W8m9jG4afoF4poOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROHISj4Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROHISj4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24435C4CEE4;
	Tue, 25 Mar 2025 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905730;
	bh=gg5fDFOFdyoX5DkM/ht1maDNqi0aSpQDQ+n0+29DVRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROHISj4YoMWW8Y/n1VMnpNEL/3EXWGdW8hupc2JT010m1+6UedtCcRHCRUhIkFi6d
	 r5OnMojXa3nx6C560GusXTD44sayurMH7b8u7XUTABwHCWg+vMelULX2mxn6SwEwEB
	 Hf94Fh9TNB+q9iuhhfuiioTYSDljXwZrIrUimhmQ=
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
Subject: [PATCH 6.1 132/198] scripts: generate_rust_analyzer: add missing macros deps
Date: Tue, 25 Mar 2025 08:21:34 -0400
Message-ID: <20250325122200.116490605@linuxfoundation.org>
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
index 030e26ef87c25..1093c540e3240 100755
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



