Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E79E30E0FB;
	Wed, 29 Oct 2025 07:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761722122; cv=none; b=r+4dxegOFvNGEcB/Mj7M1C69ojNuDW1b+tR9H8xnkQ9yNf4eKoEeRnUOEh+ujcGgbmxUN9z96ndOtijcNF1Q2Nal+kO5NsCv8b/VYgXW8Zjbugq4FtB/95Muqzrl1E9G+O6AInUt5FPhcO/q9ygXibPz1XqOUQqIUchR7uGTolQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761722122; c=relaxed/simple;
	bh=lIrPM0N7zIwNN6WRFHZH6G1QJC9tIU5IIMYHxkifpD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pM+9IaQgNjTYdCkUR7uBTRBcNtWEXMBq36JOluORjHw58JgQmQXewX3Q4sbdyUBlwuMvfg1GUj+XsvZyQI+L4nswMUUfROz0mrO6TGuPpPKwpij8D7s8BzjGoac6avO8TnwsbHzDwy/YnawKAfy+TjDKRNjAsvSPQ6yHGh9lHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=utJJElwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="utJJElwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B18C4CEFB;
	Wed, 29 Oct 2025 07:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761722121;
	bh=lIrPM0N7zIwNN6WRFHZH6G1QJC9tIU5IIMYHxkifpD0=;
	h=From:To:Cc:Subject:Date:From;
	b=utJJElwMOzBWTy/R/tI3Uf71LOa024LJWKDvBZEEsm+tr2K+WGQA1OdVJ4bpulLCA
	 8s0pVuG5mFtj8KhW5sc7KiPzmkth9uV8BLMT51CjNytSGcYKaE4VZD7bDvIdjbP9Lh
	 45pOvXH+/+PA7W5pvOLRojTtYGDgp8qCP+eeAoXh3txCR4KpnFUysX7FKUX+cj/yX5
	 61xbPjCZeKkwR2Y9zwyCjwZhuSircWKQmUuEmx/JRW54kpGUYFzEc8rUf/4yz471dQ
	 bQQJRcacSuI0ielkBLOfysSe7nzZtxPS4t0ojPZVwDmK1aL/NnJLQveCrq1YZxqtT0
	 YQ2Nx+EaR+gzQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH] rust: devres: fix private intra-doc link
Date: Wed, 29 Oct 2025 08:14:06 +0100
Message-ID: <20251029071406.324511-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The future move of pin-init to `syn` uncovers the following private
intra-doc link:

    error: public documentation for `Devres` links to private item `Self::inner`
       --> rust/kernel/devres.rs:106:7
        |
    106 | /// [`Self::inner`] is guaranteed to be initialized and is always accessed read-only.
        |       ^^^^^^^^^^^ this item is private
        |
        = note: this link will resolve properly if you pass `--document-private-items`
        = note: `-D rustdoc::private-intra-doc-links` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(rustdoc::private_intra_doc_links)]`

Currently, when rendered, the link points to "nowhere" (an inexistent
anchor for a "method").

Thus fix it.

Cc: stable@vger.kernel.org
Fixes: f5d3ef25d238 ("rust: devres: get rid of Devres' inner Arc")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/devres.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index 10a6a1789854..2392c281459e 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -103,7 +103,7 @@ struct Inner<T: Send> {
 ///
 /// # Invariants
 ///
-/// [`Self::inner`] is guaranteed to be initialized and is always accessed read-only.
+/// `Self::inner` is guaranteed to be initialized and is always accessed read-only.
 #[pin_data(PinnedDrop)]
 pub struct Devres<T: Send> {
     dev: ARef<Device>,

base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.51.0

