Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C77298985;
	Wed, 23 Apr 2025 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421752; cv=none; b=fy8MRq64nYv7lYWJ8eprM4z65t05sliB2mOxz2iMHZTOp/h4ycJSjRYmNabG5DowzG6HPLM2IcqkM4AzC0i5vmROOWP/x7sJrv9MNrvUjGnwz8BMtIQtORAccw5Azuhqb1D1jKIHvKQ6CUoy5B7bXmK8PeV90Hg5IHYkNqJnJ9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421752; c=relaxed/simple;
	bh=SY0SOMH4x3xEXcIVNVFqD5+s54F9EmFql6qhyt3gtik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhYptYP/2TuiEcz/aVpG0eWGvOxA1RR/LUrk+50zNwL8mY7tvOortmH2mU3za8Y5Tp0ohjEZhoEuKbK6CCAvz9bmcBurcQBUHoDnXLfIo1vzdiF7Kp+5h3bQm7zZnzEWPFWAen/ICsL0gQtXMCGkIQU8lkSg02dHy7xYdyWl2lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6wrtyU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6wrtyU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40511C4CEE2;
	Wed, 23 Apr 2025 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421752;
	bh=SY0SOMH4x3xEXcIVNVFqD5+s54F9EmFql6qhyt3gtik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6wrtyU+wTVy42DZG2Mruw4i3dSeheyLTGKRk2bgTkfsarAnjH+2ZmCzRdgiVxGhm
	 stTZG+b+DJ+pnJCQc9oIHZ0bf+ZoQff83q31eZqoSLtBj6VX3ooQ09pMO97qFYFuYz
	 Ftb2t+YY35/n8uchOoaD3sF0KbrhjKl6ODjkq5GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Fischer <kernel@o1oo11oo.de>,
	Tamir Duberstein <tamird@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 229/241] scripts: generate_rust_analyzer: Add ffi crate
Date: Wed, 23 Apr 2025 16:44:53 +0200
Message-ID: <20250423142629.930105185@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Fischer <kernel@o1oo11oo.de>

commit 05a2b0011c4b6cbbc9b577f6abebe4e9333b0cf6 upstream.

Commit d072acda4862 ("rust: use custom FFI integer types") did not
update rust-analyzer to include the new crate.

To enable rust-analyzer support for these custom ffi types, add the
`ffi` crate as a dependency to the `bindings`, `uapi` and `kernel`
crates, which all directly depend on it.

Fixes: d072acda4862 ("rust: use custom FFI integer types")
Signed-off-by: Lukas Fischer <kernel@o1oo11oo.de>
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250404125150.85783-2-kernel@o1oo11oo.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -97,6 +97,12 @@ def generate_crates(srctree, objtree, sy
         ["core", "compiler_builtins"],
     )
 
+    append_crate(
+        "ffi",
+        srctree / "rust" / "ffi.rs",
+        ["core", "compiler_builtins"],
+    )
+
     def append_crate_with_generated(
         display_name,
         deps,
@@ -116,9 +122,9 @@ def generate_crates(srctree, objtree, sy
             "exclude_dirs": [],
         }
 
-    append_crate_with_generated("bindings", ["core"])
-    append_crate_with_generated("uapi", ["core"])
-    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings", "uapi"])
+    append_crate_with_generated("bindings", ["core", "ffi"])
+    append_crate_with_generated("uapi", ["core", "ffi"])
+    append_crate_with_generated("kernel", ["core", "macros", "build_error", "ffi", "bindings", "uapi"])
 
     def is_root_crate(build_file, target):
         try:


