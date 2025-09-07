Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18E41DE8AF;
	Sun,  7 Sep 2025 20:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277291; cv=none; b=OIBVqtQjlRekil4J/vJqF+J7HrgKarj/m/BTEVuaG/ujPjHCLOuarYGprb0FVh/r6V5izWRmYlezvZBtSGeJ9SEqEtaRX4GEjl25QblLlKcjU0W/wKFInps5h26X6/AmBR8QfbOx4ry+PyZ29+Lu1Tt0e7bevT3ecW+7jSMfZis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277291; c=relaxed/simple;
	bh=N0lvinHJntiabtK/gVXyi98n92T7ZWgTFYEqUDaCiFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYWyrs78B/13jVTCYl73B0YAjcwRWnKE+FWEBVE6SMM9ZoPTuOZdU4zKk7IXrrNjI8DbnvATbp1J1fH7TRur2QJ/E/wFiUpGWNJKRhmMUpQaYP6zKHUZiCcsanKiamCIfGx8DQqqRKpTwCqjveOGDHy3KHXNPANZxshkQdHGzYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+H/Ow31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+H/Ow31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA45C4CEF0;
	Sun,  7 Sep 2025 20:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277290;
	bh=N0lvinHJntiabtK/gVXyi98n92T7ZWgTFYEqUDaCiFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+H/Ow31/d2zNqV04tw234eifQLY93Mw2PRliK50qv9UyvBfethEwIIIiqs3NS4qC
	 Pxcel49Kh7QgUaf3r4dzZpkRkJD73hud+GP09zVs0qZPRetAD4/VseOqw2H24HMgD+
	 3ZvNNE+yzkFIyle3p1U3kSNYYcy9lqCepA1J3QcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waffle Maybe <waffle.lapkin@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 146/175] rust: support Rust >= 1.91.0 target spec
Date: Sun,  7 Sep 2025 21:59:01 +0200
Message-ID: <20250907195618.311722340@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -223,7 +223,11 @@ fn main() {
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
@@ -243,7 +247,11 @@ fn main() {
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


