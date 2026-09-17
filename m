Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942414B7A44;
	Thu, 17 Sep 2026 17:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666243; cv=none; b=SVgujMfQO5w7nTywfaVo1BOJ9T93Idy+7RaMMgt+3ZkACc6KBobx7oGItLAKextL5jkKeHEHaYlJfIrDeJ65PULhpCZQNYZlfkmooA7TW1q8tNk++hCJrnX3fmr1m5PwkzbleD8yGPg37WWeZHxEDVkHovxaNc1vcbxFTaC0hzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666243; c=relaxed/simple;
	bh=5YGqDnzdjNxVRU+G0ug8WCsD7jPHJctLrWZ9Z4f/Wrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHnQdJgx7vmeXHA7ECGoXfsNX9fhc0XKu080O3/E46bq/e/okVprfJK+bJ4KTtbXExAg3hxnv5iATn1GpBq0UYTW5ooMVNQbOUT09RXFWBP68qNo11mw90FKmTS5diiFp5Z4cJaJnNmFdHC4Fe7auT+6qb2c1ZxpY010peRPnKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9/9Dpol; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9/9Dpol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D001F000FF;
	Thu, 17 Sep 2026 17:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666242;
	bh=yxMUp8m+qawXKlga/NJXtMbb/3AGBkkl8KYPJPCJsBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9/9DpolibnA29sPeFLG1rYN2/DRDxiFi0dd/t3QVjnDkvqDr86c8Am7fCdR+cBhK
	 GWPL9sQHUirJmWm/3sWdR3BR6r38Rj4477shSzJbdybeYvjxSXhFVD0GMle7rKNcL9
	 jbEMUj5sMHIekFGKqi5yQ11jGGDC/bgKo1MovdCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Emilio=20Cobos=20=C3=81lvarez?= <emilio@crisal.io>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 0971/1250] rust: allow `unknown_lints` in generated bindings for Rust < 1.88
Date: Thu, 17 Sep 2026 16:12:46 +0100
Message-ID: <20260917151618.332978778@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -30,7 +30,8 @@
 #[allow(clippy::ptr_as_ptr)]
 #[allow(clippy::ref_as_ptr)]
 #[allow(clippy::undocumented_unsafe_blocks)]
-#[cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#[cfg_attr(not(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES), allow(unknown_lints))]
+#[allow(unnecessary_transmutes)]
 #[cfg_attr(
     CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
     allow(suspicious_runtime_symbol_definitions)
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -28,7 +28,8 @@
     unreachable_pub,
     unsafe_op_in_unsafe_fn
 )]
-#![cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#![cfg_attr(not(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES), allow(unknown_lints))]
+#![allow(unnecessary_transmutes)]
 #![cfg_attr(
     CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
     allow(suspicious_runtime_symbol_definitions)


