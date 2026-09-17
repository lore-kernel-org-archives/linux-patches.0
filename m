Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BE14B44CD;
	Thu, 17 Sep 2026 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660106; cv=none; b=YWKmuZPBknlrahA0vbyyL/3a57doddAwXPvk9OMtaiAigXNy6MzisTI6GrCKNfRmylJu+y7pFpm8nTLly7BH24BFsji4ysS8NbHJ1lUrAcFqCZGZWbZwUXGCI6T9atBosssuinCnsy8sc1CnHV+hQRcsiQ7TcdtRb5erwHUin4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660106; c=relaxed/simple;
	bh=nU0wYM1MVqZc7E1TppnIpKK47KxeqelQQSDpAES091M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqMqQrzUaKdHTJqox8rI0n5cAfK1FNAx1GbHrTae9wtZE+Xr5DejNALlTGolXZ4zlXH6dBrulACUSvdpnB//cYAGkrSnGZJMlgwWHq4U7QPhkMGDcfUKrs0HUTBkAMeuZB9RTs2Ajl/UbTkJjJM+QnCs2PPCUTUTnsGj01Lyb80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2g8xJtf4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2g8xJtf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163401F00899;
	Thu, 17 Sep 2026 15:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660094;
	bh=L2Q0GhBRDyRpsMihJwW5PF/6ACGtsHZUp7z5saD9TNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2g8xJtf4/mmCWbVXe49Ig2FeUbGwXfKIgFboSEF1RNvnhkxwJvTPFUAsJFXWwzHfb
	 PQcy62DpmoMniedbNvzFJ1b+hOWoZxhKA328ESLU1eKonJO2v0BKHmxvQDD3asgagl
	 FsQRZ/0g/X/+LmUteRInY2CFa0X1RU3XovV4rKNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Hubbard <jhubbard@nvidia.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 477/733] rust: allow `clippy::as_underscore` in the generated bindings
Date: Thu, 17 Sep 2026 16:13:05 +0100
Message-ID: <20260917151403.893487078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,6 +22,7 @@
 #![feature(cfi_encoding)]
 
 #[allow(dead_code)]
+#[allow(clippy::as_underscore)]
 #[allow(clippy::cast_lossless)]
 #[allow(clippy::ptr_as_ptr)]
 #[allow(clippy::ref_as_ptr)]
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -10,6 +10,7 @@
 #![no_std]
 #![allow(
     clippy::all,
+    clippy::as_underscore,
     clippy::cast_lossless,
     clippy::ptr_as_ptr,
     clippy::ref_as_ptr,


