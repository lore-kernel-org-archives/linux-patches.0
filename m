Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AE11C9EAA;
	Wed, 19 Mar 2025 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394980; cv=none; b=oin5EPi7Rb1r1NUy28cnFznxjoY5iHCR8XRQJiW4jBfx4MmZOHNGdQ04a6Z78HID8rcZ6sGU2oUFGKo9zP2CrEc9PKM/PXiO7hKPMuafURaDvymeW/m43cuyC3Zvsag0Ed36pah8ogm2XxfJk/2fTnoyZa8AkX44z82Cw2jyfrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394980; c=relaxed/simple;
	bh=5V6mPOluwy37qDnOgT4CqS6tekHjtYOzs36ZMlm+yOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EdH8pRwlpKLqNN/e1cmB2deT2102QhaTfPAb5SGfkE81E/JjdLpdCr8/bzPN18feqA2rIuGJQYiZxGcNLW3PP64G8zFRkiG4+kGRNzGEYtM2GgmRpkwjpL9eFMqBO+NMlGfOtXnKmQkaiQ4upciaQReooSF8HbtvKqPAOsI5qeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2q7Jui1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2q7Jui1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C78C4CEE4;
	Wed, 19 Mar 2025 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394980;
	bh=5V6mPOluwy37qDnOgT4CqS6tekHjtYOzs36ZMlm+yOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2q7Jui1R8dnfy5JSO66t7yTWvA9pzM1l2JJLke/BNDRXZ+xrH0iVBVyxxmrp3FvE
	 JIExR8GyiDx9eqDPTt7uRHuWPz1NnmEqtQFi8gN33hHAaFrsbSEDAgq0l3gsvXSyyS
	 p0eS5DE6klGBclys/KtkilniN9LokBbUL6KYQLT4=
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
Subject: [PATCH 6.13 219/241] scripts: generate_rust_analyzer: add missing macros deps
Date: Wed, 19 Mar 2025 07:31:29 -0700
Message-ID: <20250319143033.164566114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 09e1d166d8d23..8cf278aceba7b 100755
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
@@ -67,7 +79,7 @@ def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
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



