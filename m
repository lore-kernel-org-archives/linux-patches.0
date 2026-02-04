Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349DE19E96D;
	Wed,  4 Feb 2026 15:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219290; cv=none; b=JxjtwzcbvTj0A9mLRYIiiVEivHW95nE5IHF3kr9OzGTUfdEP6vIvISDb+5otal6pkk+THxfqJhunrEZ0Fa7GkwR9ZeNTo9ma2lZVhRDdnqdrACo85DgJeKlhrx1mnmncSFd5ODd+8BUVI7/P497z2TSIRPq0EtNs6q4eP6zF1Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219290; c=relaxed/simple;
	bh=MoCDGd7eipsPWD738KHhSv+0WAx9HZV2KYGIWe0SjEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDlyZuTbHKD84qKvFHNcIZa1qpIoG/02FD1aeL64yl8W0yqHWtVK8tGiw+hNZIa7EsqJuMtaLatbKvYY+UPDirujMTdt8feZcjtuIB1oIVlnW5SD1eFhYiFGKZPMdS5FisJwivspEuioie5KgwZJoMYGtwSlp8CBjvvGdtHBgPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHuqGwHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHuqGwHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F18AC4CEF7;
	Wed,  4 Feb 2026 15:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219289;
	bh=MoCDGd7eipsPWD738KHhSv+0WAx9HZV2KYGIWe0SjEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHuqGwHveRtm/Dz1reAShFam/EeoGCrWkqH8mcPxe9fnxyKyaWAgK2ut2F/1MUBzI
	 I+k+LbC3yC4i4rK8CYeZuyKlmSkuQszWhZIDpTJNxk/DPbJMBO2CkV5RcvdGI4dZlT
	 mEsMetEY9Ln1ZFY42jS/sbrsZhZxoIAt4JXJqBUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 097/122] scripts: generate_rust_analyzer: compile sysroot with correct edition
Date: Wed,  4 Feb 2026 15:41:19 +0100
Message-ID: <20260204143855.340114444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@kernel.org>

commit ac3c50b9a24e9ebeb585679078d6c47922034bb6 upstream.

Use `core_edition` for all sysroot crates rather than just core as all
were updated to edition 2024 in Rust 1.87.

Fixes: f4daa80d6be7 ("rust: compile libcore with edition 2024 for 1.87+")
Signed-off-by: Tamir Duberstein <tamird@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260116-rust-analyzer-sysroot-v2-1-094aedc33208@kernel.org
[ Added `>`s to make the quote a single block. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_analyzer.py |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -61,7 +61,6 @@ def generate_crates(srctree, objtree, sy
         display_name,
         deps,
         cfg=[],
-        edition="2021",
     ):
         append_crate(
             display_name,
@@ -69,13 +68,37 @@ def generate_crates(srctree, objtree, sy
             deps,
             cfg,
             is_workspace_member=False,
-            edition=edition,
+            # Miguel Ojeda writes:
+            #
+            # > ... in principle even the sysroot crates may have different
+            # > editions.
+            # >
+            # > For instance, in the move to 2024, it seems all happened at once
+            # > in 1.87.0 in these upstream commits:
+            # >
+            # >     0e071c2c6a58 ("Migrate core to Rust 2024")
+            # >     f505d4e8e380 ("Migrate alloc to Rust 2024")
+            # >     0b2489c226c3 ("Migrate proc_macro to Rust 2024")
+            # >     993359e70112 ("Migrate std to Rust 2024")
+            # >
+            # > But in the previous move to 2021, `std` moved in 1.59.0, while
+            # > the others in 1.60.0:
+            # >
+            # >     b656384d8398 ("Update stdlib to the 2021 edition")
+            # >     06a1c14d52a8 ("Switch all libraries to the 2021 edition")
+            #
+            # Link: https://lore.kernel.org/all/CANiq72kd9bHdKaAm=8xCUhSHMy2csyVed69bOc4dXyFAW4sfuw@mail.gmail.com/
+            #
+            # At the time of writing all rust versions we support build the
+            # sysroot crates with the same edition. We may need to relax this
+            # assumption if future edition moves span multiple rust versions.
+            edition=core_edition,
         )
 
     # NB: sysroot crates reexport items from one another so setting up our transitive dependencies
     # here is important for ensuring that rust-analyzer can resolve symbols. The sources of truth
     # for this dependency graph are `(sysroot_src / crate / "Cargo.toml" for crate in crates)`.
-    append_sysroot_crate("core", [], cfg=crates_cfgs.get("core", []), edition=core_edition)
+    append_sysroot_crate("core", [], cfg=crates_cfgs.get("core", []))
     append_sysroot_crate("alloc", ["core"])
     append_sysroot_crate("std", ["alloc", "core"])
     append_sysroot_crate("proc_macro", ["core", "std"])


