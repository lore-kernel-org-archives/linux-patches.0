Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D33F4B7A44;
	Thu, 17 Sep 2026 17:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666240; cv=none; b=qUUODAXDatHNrRHzosnAT8mLgASZ2Rc9/SkCMV5WkyZ5w3L19cMty9NZacW1gB7JdQK67y4erP8BSy5L0h5PpYhMb75aTtQL65EabgDbPI5cNE+PUG04e9gSvnGOb/ZO0lO8PpbyvbxYkLE+dbxU4wLHAL+cp52SB9AfPI1wO/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666240; c=relaxed/simple;
	bh=Dc35Nb70cBAQrUCceN++RSD+VklZa8/0nEYVGL44tCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw8V1DEzBqgi3J1YBBtDfIVT0WJMNgVMkNJ6C7eAv0foEEVfhvjBRuHoqQSb7g1OsHahep4gL182qUDHoWNJYIAGC99bKMuaI/pmjdVjaHtARIfU6MAEClNoMK2Az1uGVm0V7Fof0AVl+BaTvXQ2Ftt60OBzXyCkWrfBiDjeb3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gag+q7Y2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gag+q7Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EEF1F000FF;
	Thu, 17 Sep 2026 17:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666239;
	bh=WetziyplhvtVcZ3hKb6CLw4JfewgwfwLGEFzcsLjGvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gag+q7Y2TcwMJXVEkD+B54nDg16M9snL9fQ7vKD8T9D44Y0Ovcm2q95vLsRY/nOOH
	 Sb6SmOV/tH7GnCfnywF4K8LSJZvgHiYziunC/JlJiq+Ugx1ggYUS8uIaKKQ8KmPypy
	 Px6CRIjvfRlRtkbslGgBzWpSTT4Q+X0QRw05KAXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 0970/1250] rust: allow `clippy::as_underscore` in the generated bindings
Date: Thu, 17 Sep 2026 16:12:45 +0100
Message-ID: <20260917151618.306467515@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: John Hubbard <jhubbard@nvidia.com>

commit 2ac74c6db40adaa29c50cbb281ae9a6f63de18e1 upstream.

A CLIPPY=1 build emitted about 15000 `as _` conversion warnings, all of
them in bindgen's generated output and none in hand-written code.

[ The lint messages look like:

    error: using `as _` conversion
         --> rust/bindings/bindings_generated.rs:18947:9
          |
    18947 |         self._bitfield_1.get_const::<0usize, 16u8>() as u32 as _
          |         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^-
          |                                                                |
          |                                                                help: consider giving the type explicitly: `u32`
          |
          = help: for further information visit https://rust-lang.github.io/rust-clippy/rust-1.98.0/index.html#as_underscore
          = note: `-D clippy::as-underscore` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(clippy::as_underscore)]`

    - Miguel ]

bindgen 0.73 returns each bitfield read through a trailing `as _`, and
0.72 returns it through a transmute, which the lint ignores. The
bindings and uapi crates allow `clippy::all` over the generated code.
That group does not cover `clippy::as_underscore`, a restriction lint.

Allow `clippy::as_underscore` by name in the bindings and uapi crates.

Assisted-by: LLM
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Link: https://patch.msgid.link/20260906215822.1201022-1-jhubbard@nvidia.com
Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
[ Removed CI sentence. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindings/lib.rs |    1 +
 rust/uapi/lib.rs     |    1 +
 2 files changed, 2 insertions(+)

--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -25,6 +25,7 @@
 )]
 
 #[allow(dead_code)]
+#[allow(clippy::as_underscore)]
 #[allow(clippy::cast_lossless)]
 #[allow(clippy::ptr_as_ptr)]
 #[allow(clippy::ref_as_ptr)]
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -14,6 +14,7 @@
 #![cfg_attr(test, allow(unsafe_op_in_unsafe_fn))]
 #![allow(
     clippy::all,
+    clippy::as_underscore,
     clippy::cast_lossless,
     clippy::ptr_as_ptr,
     clippy::ref_as_ptr,


