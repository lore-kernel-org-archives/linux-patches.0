Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700731C8618;
	Wed, 19 Mar 2025 14:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394981; cv=none; b=YxHG/se0YZ7jHCA4Ti1Z/sGT9+kaUCTaRf20Wbf92vDbTJK8HZoXo1ryMUrjUV1T1ErR4gD8KR9E0IkwuKuxCYeX7e6fvjjgl0S5kncIhaXlkpEzyx7cZYYnv7gmSed0+ztqXHS8yjkNqBhSZQ1LJF5OmRxGQ7lPr+a31utdqLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394981; c=relaxed/simple;
	bh=4DPvxJ9U5EG8nCJILSjfEcgkNHS3uGjBWl5a6ozVZgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMiwTOK3bwegvrY9hP8KGDpSme8VL6VVGc8lCi7nhDQzx0x8Drh8KsVlO8vumFIktWRTzFcbzLqGYdyBHstoTnlf9YtEv482GtO0CLlrPPxaRQdWXLIALe08XmuiMBhQUHi9dCWOl61txU/8UgojO/3HhwVx6KRwJYifGbeztk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AkSOQVDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AkSOQVDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469C3C4CEE4;
	Wed, 19 Mar 2025 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394981;
	bh=4DPvxJ9U5EG8nCJILSjfEcgkNHS3uGjBWl5a6ozVZgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AkSOQVDjbW0kM8CN2fZhIH3wM9qfiFz7SQans7aBEUerzLPXSyiEWN2yJJrcq+zJ9
	 UJ62sUI9kSQhT+wV79uF/9UZbr6YDpam9+6/SUIEaGvglrzP1BTswV6uMNDPnVyTTE
	 ff8/tIDT80xufAJNra+2vXb/NSLVA02qK/Nj0Fhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 220/241] scripts: generate_rust_analyzer: add missing include_dirs
Date: Wed, 19 Mar 2025 07:31:30 -0700
Message-ID: <20250319143033.190235159@linuxfoundation.org>
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

[ Upstream commit d1f928052439cad028438a8b8b34c1f01bc06068 ]

Commit 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
specified OBJTREE for the bindings crate, and `source.include_dirs` for
the kernel crate, likely in an attempt to support out-of-source builds
for those crates where the generated files reside in `objtree` rather
than `srctree`. This was insufficient because both bits of configuration
are required for each crate; the result is that rust-analyzer is unable
to resolve generated files for either crate in an out-of-source build.

  [ Originally we were not using `OBJTREE` in the `kernel` crate, but
    we did pass the variable anyway, so conceptually it could have been
    there since then.

    Regarding `include_dirs`, it started in `kernel` before being in
    mainline because we included the bindings directly there (i.e.
    there was no `bindings` crate). However, when that crate got
    created, we moved the `OBJTREE` there but not the `include_dirs`.
    Nowadays, though, we happen to need the `include_dirs` also in
    the `kernel` crate for `generated_arch_static_branch_asm.rs` which
    was not there back then -- Tamir confirms it is indeed required
    for that reason. - Miguel ]

Add the missing bits to improve the developer experience.

Fixes: 8c4555ccc55c ("scripts: add `generate_rust_analyzer.py`")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Tested-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20250210-rust-analyzer-bindings-include-v2-1-23dff845edc3@gmail.com
[ Slightly reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/generate_rust_analyzer.py | 42 +++++++++++++++----------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index 8cf278aceba7b..2a64067b09b0c 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -90,27 +90,27 @@ def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
         ["core", "compiler_builtins"],
     )
 
-    append_crate(
-        "bindings",
-        srctree / "rust"/ "bindings" / "lib.rs",
-        ["core"],
-        cfg=cfg,
-    )
-    crates[-1]["env"]["OBJTREE"] = str(objtree.resolve(True))
-
-    append_crate(
-        "kernel",
-        srctree / "rust" / "kernel" / "lib.rs",
-        ["core", "macros", "build_error", "bindings"],
-        cfg=cfg,
-    )
-    crates[-1]["source"] = {
-        "include_dirs": [
-            str(srctree / "rust" / "kernel"),
-            str(objtree / "rust")
-        ],
-        "exclude_dirs": [],
-    }
+    def append_crate_with_generated(
+        display_name,
+        deps,
+    ):
+        append_crate(
+            display_name,
+            srctree / "rust"/ display_name / "lib.rs",
+            deps,
+            cfg=cfg,
+        )
+        crates[-1]["env"]["OBJTREE"] = str(objtree.resolve(True))
+        crates[-1]["source"] = {
+            "include_dirs": [
+                str(srctree / "rust" / display_name),
+                str(objtree / "rust")
+            ],
+            "exclude_dirs": [],
+        }
+
+    append_crate_with_generated("bindings", ["core"])
+    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings"])
 
     def is_root_crate(build_file, target):
         try:
-- 
2.39.5



