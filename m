Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171AA139D1B;
	Sat, 23 Nov 2024 22:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732400650; cv=none; b=tdxkT8q0DrDDBdKlPvaXhnK/t5joYRgLF/dPpJuUcH6TYWKDBGhm20sQ9+XoBO/7o/s8PBdgHvWKgBGyc7lOhslTl/61eBvcdRaJB2oRoTeTWe892LIA4CtzIPHBef6lt/1RxjpskcLpx+fxHWZS9cSj6OfL0T6wgor2U1IKFo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732400650; c=relaxed/simple;
	bh=0cceid9Jq8v7gT0R89WcHt7ECqajY1qVimASQaSFABY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r4KSpd5zp/4toIcxFJuilyDFj6Tkn07l8Z5DfkuaMpmKH6g26mCJOiwT2+z0acInjJV8FJbxzOAunBzivnp8tEVqyMFZLj/Ns+XsY8B4zK77++eS2kue8zIP7qXJYcF1l2Z/jasLhErW7TGYxNmaJ3TieSwQqAIL96k8FtoQzBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGn6Y5S7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGn6Y5S7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD253C4CECD;
	Sat, 23 Nov 2024 22:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732400649;
	bh=0cceid9Jq8v7gT0R89WcHt7ECqajY1qVimASQaSFABY=;
	h=From:To:Cc:Subject:Date:From;
	b=gGn6Y5S7FkIrpS+YMFGWtLN5XCUfK6ahd24hW52dLwi9psh856GI7gUuFRBvuHI60
	 BPHrQhJVrmKsbi1+1ZHvuTJI221AbJIDr8GEWiYJLvOV9ZAukHWH2mQRUC2pe2zfC7
	 i5FjJqbKUscomDl3oiTU1dCXWVfgo/ka9rgeQth1IhHeuUHZrx/EYjg3YHWRfATjU7
	 j+hXJWszVmajxEcs7g9Sy1v3ZJT2UKcfXPNxhFGHnNBATxPb3z8M/h71mZ3tFXVfwD
	 B5OYCjU+QkmqDbQOiSbZw4X3qASd+7mpv9fNzJPkojYA/q7y6W9LnS2ExzbDNhmSBp
	 HPwJLgqgLkE0Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH] rust: give Clippy the minimum supported Rust version
Date: Sat, 23 Nov 2024 23:23:45 +0100
Message-ID: <20241123222345.346976-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clippy's lints may avoid emitting a suggestion to use a language or
library feature that is not supported by the minimum supported version,
if given by the `msrv` field in the configuration file.

For instance, Clippy should not suggest using `let ... else` in a lint
if the MSRV did not implement that syntax.

If the MSRV is not provided, Clippy will assume all features are available.

Thus enable it with the minimum Rust version the kernel supports.

Note that there is currently a small disadvantage in doing so: since
we still use unstable features that nevertheless work in the range
of versions we support (e.g. `#[expect(...)]`), we lose suggestions
for those. However, over time we will stop using unstable features
(especially language and library ones) as it is our goal, thus, in the
end, we will want to have the `msrv` set.

Rust is also considering adding a similar feature in `rustc` too, which
we should probably enable if it becomes available [2].

Link: https://github.com/rust-lang/rust-clippy/blob/8298da72e7b81fa30c515631b40fc4c0845948cb/clippy_utils/src/msrvs.rs#L20 [1]
Link: https://github.com/rust-lang/compiler-team/issues/772 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .clippy.toml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/.clippy.toml b/.clippy.toml
index e4c4eef10b28..815c94732ed7 100644
--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+msrv = "1.78.0"
+
 check-private-items = true
 
 disallowed-macros = [

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
-- 
2.47.0

