Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56F74078D3;
	Thu, 17 Sep 2026 18:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670908; cv=none; b=TiICLeyKSQg2dPA99xuS6bCNyjof0gikf9sTIbdXPQCIziF6P+GJU1o/zaiyVgXYlmG7eLHzRwpOeCLpUiMs5IvNs5KGvRIqf3rWAy9nyJMJcha7YGk0nflmFs+Ez8xNAVy0I2U37PhhhtGIV9i91Kj3WTZuCq8S0ImVwalJzBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670908; c=relaxed/simple;
	bh=sh9WwvgikmHhUTVCEQkgomz7TUbAEg2GQj5xJgkaQjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=atAk+wxp9VvltWXQO2nE7xIjcwC/mJWYU80TnNp9L4LMhnlYZ2N/EEftKwO0js3ajnz1rz2hOwe1W36+joYwEzbOAs0ORE8SCNGvQskNiFh9S7IF7UP3hDTWswNvziv5ucG9cUnRdHrV8mZN73XTJtEceZEpfvDKJEk7YIxT7tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvHiUbWu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvHiUbWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46131F000FF;
	Thu, 17 Sep 2026 18:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670906;
	bh=RHFMJFrrxZsjeeuoqHiM0/XdiB/1Ii4K5WKpJKW/Pj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvHiUbWurD8evPFg1Hy4vXLN/u3D3yXatQvI59hDw7z+EkMNOqNp4uYQrZfX6CqeT
	 3l63swp2vMj1K9L/tld4bjYgSWGID2JVmuyamuIoDyE3ShHTN0xavxprnbTkLkgTS8
	 WLtgFVxy9UUXfyXYLPOYUcwVNQheQUNbTYb8AHYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Emilio=20Cobos=20=C3=81lvarez?= <emilio@crisal.io>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 0809/1102] rust: allow `unknown_lints` in generated bindings for Rust < 1.88
Date: Thu, 17 Sep 2026 16:12:32 +0100
Message-ID: <20260917151600.801366236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit f4c3e38111fd84c2c7ae5785755f4a4d476e1cba upstream.

Starting with bindgen 0.73.2 [1], `#[allow(unnecessary_transmutes)]`
are used, even when `--rust-target 1.85` is passed.

However, the lint was introduced in Rust 1.88.0. Thus building with
older Rust versions warns like:

    error: unknown lint: `unnecessary_transmutes`
         --> rust/uapi/uapi_generated.rs:26294:13
          |
    26294 |     #[allow(unnecessary_transmutes)]
          |             ^^^^^^^^^^^^^^^^^^^^^^
          |
          = note: `-D unknown-lints` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(unknown_lints)]`

Thus allow `unknown_lints` in the generated bindings -- only when building
with older Rust versions.

I have asked upstream if this is intentional [1], i.e. if we are supposed
to always allow unknown lints in case `bindgen` uses such attributes,
or whether it is an oversight.

[ Emilio said it wasn't intentional -- we will work around it for now
  on the kernel side. - Miguel ]

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Cc: Emilio Cobos Álvarez <emilio@crisal.io>
Link: https://github.com/rust-lang/rust-bindgen/pull/3455#issuecomment-5588526559 [1]
Assisted-by: LLM
Link: https://patch.msgid.link/20260908170539.345207-1-ojeda@kernel.org
[ Removed the `cfg` for `allow(unnecessary_transmutes)` as suggested by
  Gary. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/bindings/lib.rs |    3 ++-
 rust/uapi/lib.rs     |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -26,7 +26,8 @@
 
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
-#[cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#[cfg_attr(not(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES), allow(unknown_lints))]
+#[allow(unnecessary_transmutes)]
 #[cfg_attr(
     CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
     allow(suspicious_runtime_symbol_definitions)
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -24,7 +24,8 @@
     unreachable_pub,
     unsafe_op_in_unsafe_fn
 )]
-#![cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#![cfg_attr(not(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES), allow(unknown_lints))]
+#![allow(unnecessary_transmutes)]
 #![cfg_attr(
     CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
     allow(suspicious_runtime_symbol_definitions)


