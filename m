Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA6D2FB2;
	Tue, 27 Aug 2024 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724753081; cv=none; b=MevtfRjhQ+i+ZaBnHxoW1I1B1BYR6YRxZXt/LHUzSugUg+9U+Z6ibC++V3VULA7JaL2nOSn/UTfo61gaNOyso1pjWMMFgM+wsl8o9IC99xIwI6mbLS97YP/0N1MC4v0hUfMa2rRI4Eju3aVJIEPXGa0JWxIqXw+VQv+UuGfDZso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724753081; c=relaxed/simple;
	bh=zfJAOzZN27Amn0QuamIFpL8ZwKJw/PPvyF+8IyGpYIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N8+UD0A+4N7YpkN4GHBzAiriBPreR4TnPOYrlfeiFLzQ2cGEufYW/QoWQZRr+FWatayPP79UdCHv8z6+q8uRgI40nt78xSzTBmTCgHGXSpPTOcVgznjzY0IY450LwrCoPAOeda4I9M+LkaIDqWfhXbGtG6MkMxDKgwEQ+to5I7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7tXtm/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7tXtm/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B27C8B7AC;
	Tue, 27 Aug 2024 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724753080;
	bh=zfJAOzZN27Amn0QuamIFpL8ZwKJw/PPvyF+8IyGpYIw=;
	h=From:To:Cc:Subject:Date:From;
	b=G7tXtm/JGcswk7WzftJ5CUcDOEjQJZ0tr1eYw9s3YJj3PCK6XTqBGxqux2qk28Cmo
	 pl7yyULUURN6XABHXIUa7FVpSM/+6PL/1NNwYzNiSsXRAQ7vtu+lfuLxNmIMmtkOTK
	 FJvYPZGMmeypdcFabfr/1JqWbtQJpHAp35GqRFzXp7YzPaCDJRlEanpfIwD5X4Mcg5
	 VgplYS72dmNVX5Ns3AKx3Oi1281vF2qS3IQd9MfhNpu9GudhDS9Tt5DfqlHQLBOv/H
	 nW0lUiYIiFMvFc3eb7G984VcK0MDxyP619F98kc4hZQHVK+IKEJXeXsEYKgJbLcb4F
	 c6ZmmCL9karxg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: allow `stable_features` lint
Date: Tue, 27 Aug 2024 12:04:03 +0200
Message-ID: <20240827100403.376389-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support for several Rust compiler versions started in commit 63b27f4a0074
("rust: start supporting several compiler versions"). Since we currently
need to use a number of unstable features in the kernel, it is a matter
of time until one gets stabilized and the `stable_features` lint warns.

For instance, the `new_uninit` feature may become stable soon, which
would give us multiple warnings like the following:

    warning: the feature `new_uninit` has been stable since 1.82.0-dev
    and no longer requires an attribute to enable
      --> rust/kernel/lib.rs:17:12
       |
    17 | #![feature(new_uninit)]
       |            ^^^^^^^^^^
       |
       = note: `#[warn(stable_features)]` on by default

Thus allow the `stable_features` lint to avoid such warnings. This is
the simplest approach -- we do not have that many cases (and the goal
is to stop using unstable features anyway) and cleanups can be easily
done when we decide to update the minimum version.

An alternative would be to conditionally enable them based on the
compiler version (with the upcoming `RUSTC_VERSION` or maybe with the
unstable `cfg(version(...))`, but that one apparently will not work for
the nightly case). However, doing so is more complex and may not work
well for different nightlies of the same version, unless we do not care
about older nightlies.

Another alternative is using explicit tests of the feature calling
`rustc`, but that is also more complex and slower.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I may take this through `rust-fixes` too, since it is straightfoward and
it could help some developers/CIs if something gets stabilized soon.

 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 68ebd6d6b444..cf1111476f46 100644
--- a/Makefile
+++ b/Makefile
@@ -445,6 +445,7 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 # host programs.
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
+			    -Astable_features \
 			    -Dunsafe_op_in_unsafe_fn \
 			    -Dnon_ascii_idents \
 			    -Wrust_2018_idioms \
--
2.46.0
