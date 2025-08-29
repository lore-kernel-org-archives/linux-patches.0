Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D497224676A;
	Fri, 29 Aug 2025 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756497336; cv=none; b=r8WBY5pIzTPJu19/dBgwiGk8iyDRbZcEJ8EbSoKV01EeHa+Xja3cI7XXt460gfMqF85qZdAnttYM0cCzVJxQQ/zCRxGkcIewn86LFOXQ107NPWJZxw98s+rOlTgFd4y0RfIdclxt5rMEtWFBKnxe2qFuN9gE2qKbXX3+7Bm8ly8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756497336; c=relaxed/simple;
	bh=itlVCGisz6iB2X01ClCKsCQncrsTeK3qSEMOx++ZN8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ChM9Iq/2lyxWjrwh58fjbaXrWwaNoBb5e1uEfwbg2HqCETsb2gi2llIHb4w2fPE9IvrDl4XmgPZesdIdjp36064SkqqBrG8y1iW7BFvwR5BpFSN1bbn0oof9RaYVlJuMICmvNv3AEVbV4fj/rqdwXJN+2vPIysm6yC4lbl0EQ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SeM6Qfdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SeM6Qfdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72443C4CEF0;
	Fri, 29 Aug 2025 19:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756497336;
	bh=itlVCGisz6iB2X01ClCKsCQncrsTeK3qSEMOx++ZN8U=;
	h=From:To:Cc:Subject:Date:From;
	b=SeM6QfdxqgMW0X3my7juosJyc+L8arDghwWPS5PzGFL7NvMeIzjuG3bpg8hKujgqR
	 1fzNkcVuqR4gJZMpVTgKJWT/E1diNT67B2mFse4q2pr2RSv3vmg+Od66+pr7AXaOz6
	 b9g57sbhFOd/LbffwlxuKfbeHP7uuTwg5P3lMJrX3WfVrItNiqfHX4aasvaQCOooAJ
	 +NbJ8Li0ulzVS9eqwIE1d+a5vhVc9H0YikIwwVayd4MTUdwECuTQLkHbWOPflgJh5l
	 1xxwkBtGHFncKRnNV69qXYQ5PWufMGnazsLun3CItFe0U/n6K+PIgHBHntleoa1HBW
	 //FdAyoqfoyKg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Waffle Maybe <waffle.lapkin@gmail.com>
Subject: [PATCH] rust: support Rust >= 1.91.0 target spec
Date: Fri, 29 Aug 2025 21:55:25 +0200
Message-ID: <20250829195525.721664-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.91.0 (expected 2025-10-30), the target spec format
has changed the type of the `target-pointer-width` key from string
to integer [1].

Thus conditionally use one or the other depending on the version.

Cc: Waffle Maybe <waffle.lapkin@gmail.com>
Link: https://github.com/rust-lang/rust/pull/144443 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Conditional to the PR getting merged.

 scripts/generate_rust_target.rs | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 39c82908ff3a..38b3416bb979 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -225,7 +225,11 @@ fn main() {
         ts.push("features", features);
         ts.push("llvm-target", "x86_64-linux-gnu");
         ts.push("supported-sanitizers", ["kcfi", "kernel-address"]);
-        ts.push("target-pointer-width", "64");
+        if cfg.rustc_version_atleast(1, 91, 0) {
+            ts.push("target-pointer-width", 64);
+        } else {
+            ts.push("target-pointer-width", "64");
+        }
     } else if cfg.has("X86_32") {
         // This only works on UML, as i386 otherwise needs regparm support in rustc
         if !cfg.has("UML") {
@@ -245,7 +249,11 @@ fn main() {
         }
         ts.push("features", features);
         ts.push("llvm-target", "i386-unknown-linux-gnu");
-        ts.push("target-pointer-width", "32");
+        if cfg.rustc_version_atleast(1, 91, 0) {
+            ts.push("target-pointer-width", 32);
+        } else {
+            ts.push("target-pointer-width", "32");
+        }
     } else if cfg.has("LOONGARCH") {
         panic!("loongarch uses the builtin rustc loongarch64-unknown-none-softfloat target");
     } else {

base-commit: 1b237f190eb3d36f52dffe07a40b5eb210280e00
--
2.51.0
