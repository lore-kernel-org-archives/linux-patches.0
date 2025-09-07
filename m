Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1A94315A;
	Sun,  7 Sep 2025 20:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277852; cv=none; b=HFkzFtYBkBtNr6IvO3r+GEGjzl5/08XPX7VcXI43UoYdlg+CHt62a5v+jSyYkiKRuWoGDPcQpk6Dz3HkbkQZEYDh4XaCA1iSDyS0IgwamNWOl5E4SlwXN+abxYWzXmqF/yw2EcRiQqXc0ucCYIqb6K6ilIOpq6TFdus/CM9hyNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277852; c=relaxed/simple;
	bh=J5fxbx9K8u1UmpQGPXkzIW3+gkmoMSwuzP7LUdQwznM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0m7K9w1K2T/fxj0POYx7CAmTNDGykVizZjvxXAmmMZey5v0Wx0A9donK4nvnpO/c7CI94i3e2ozKehs360b5dz9RXexL3Tfp6fTdeZc3lPJRRmrquqWnW4K4ucobLbjt+RZqYw0H/fKiHFUJ8uQbf9ugSlJuQvf1Xz0+8iGU0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xijc0Vm2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xijc0Vm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E866C4CEF0;
	Sun,  7 Sep 2025 20:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277851;
	bh=J5fxbx9K8u1UmpQGPXkzIW3+gkmoMSwuzP7LUdQwznM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xijc0Vm2glGOCyq+4hZjQRylsmmoGR0aXS4YZpbr/qHGXGlxrVfioTaL3y/CDLVbk
	 k+T1OcAViZFYhzi/MWwiAJLkz3bTb6wHIYbNFBWd7Q0C7b7GmvB+xMLC8I7jkOhSkI
	 BeG3RgR9XvEOFS/qF8xhs/pVEOfhNS3x7ytvT/LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waffle Maybe <waffle.lapkin@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.16 143/183] rust: support Rust >= 1.91.0 target spec
Date: Sun,  7 Sep 2025 21:59:30 +0200
Message-ID: <20250907195619.201791443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 8851e27d2cb947ea8bbbe8e812068f7bf5cbd00b upstream.

Starting with Rust 1.91.0 (expected 2025-10-30), the target spec format
has changed the type of the `target-pointer-width` key from string
to integer [1].

Thus conditionally use one or the other depending on the version.

Cc: Waffle Maybe <waffle.lapkin@gmail.com>
Link: https://github.com/rust-lang/rust/pull/144443 [1]
Link: https://lore.kernel.org/r/20250829195525.721664-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/generate_rust_target.rs |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

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


