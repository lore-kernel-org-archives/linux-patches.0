Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A7D1BBBCB;
	Wed, 14 Aug 2024 16:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723653454; cv=none; b=c9Bi6Xzdugkm58eQr/4ynrdjRle4tZwe7AT0BG4eGMpcDfBwJ+6M7lMw2hPqolfhsOwdnjEWcTAxfw1BM+Svrrd5Xf6y96RYwnqDJ16AZGqe+OzKHegxKi4fM52O6dYAr3QpkkuvnZTJVLq5RcC/odnqkdvrf+TQiz/+4raPays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723653454; c=relaxed/simple;
	bh=v5M9ps6F/NmI6iXi/qytEoSwAtl0c5kzHVIFqFfviyM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fPTTZ/dd1+fHkJaTC2kT0wd82QRJ2JzHeecm9TaGqhntWLy/sAG+Jwf50eCkdrZKKIYYSwggXOwW06PfH9K/5UQSe9jdJHMPT5VVjmQG/w3YHuwA7/SZGmRgZtyTEz6KGCHtw/aVb1vfjFF1HqgHVtyUujDxNDXOUuQczl77/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oPbxhuah; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oPbxhuah"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984B6C4AF09;
	Wed, 14 Aug 2024 16:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723653453;
	bh=v5M9ps6F/NmI6iXi/qytEoSwAtl0c5kzHVIFqFfviyM=;
	h=From:To:Cc:Subject:Date:From;
	b=oPbxhuahVqajF4B9E+CAFhVHUvUBI+v+8dgWr975pj/CvP7+rMd56JnBezWR59n2V
	 anyJeCq889VuN1uKnHjF0SBYH3yMuFH4h1jrn5FCHIJmEsP31iPTaPgpDvmPOPr+oz
	 VFjZQ8rKGadGnObuaYKa9kk44ygPew9L/4rDwW0B+8m2mFSJlP+K9IDINCLHrgqMYh
	 Sa5HANASbLrw1g2/nnGhewVuMh2gCW7WPwRiqPgornugsW22d4dU1HgBKb3hO1PDN9
	 7BmS6UuzZ/nNCWtrWd3M9Uite66a3I4QpVdHXPv2nkqXAt9oG0fLY2AXkEYUd2Q13k
	 Rng9tM9PmyvXQ==
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
Subject: [PATCH] rust: enable bindgen's `--enable-function-attribute-detection` flag
Date: Wed, 14 Aug 2024 18:37:22 +0200
Message-ID: <20240814163722.1550064-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`bindgen` is able to detect certain function attributes and annotate
functions correspondingly in its output for the Rust side, when the
`--enable-function-attribute-detection` is passed.

In particular, it is currently able to use `__must_check` in C
(`#[must_use]` in Rust), which give us a bunch of annotations that are
nice to have to prevent possible issues in Rust abstractions, e.g.:

     extern "C" {
    +    #[must_use]
         pub fn kobject_add(
             kobj: *mut kobject,
             parent: *mut kobject,
             fmt: *const core::ffi::c_char,
             ...
         ) -> core::ffi::c_int;
     }

Apparently, there are edge cases where this can make generation very slow,
which is why it is behind a flag [1], but it does not seem to affect us
in any major way at the moment.

Link: https://github.com/rust-lang/rust-bindgen/issues/1465 [1]
Link: https://lore.kernel.org/rust-for-linux/CANiq72=u5Nrz_NW3U3_VqywJkD8pECA07q2pFDd1wjtXOWdkAQ@mail.gmail.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
If someone notices a major performance difference, please let me know!

 rust/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index 1f10f92737f2..c28b81e2a5fa 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -270,7 +270,7 @@ quiet_cmd_bindgen = BINDGEN $@
       cmd_bindgen = \
 	$(BINDGEN) $< $(bindgen_target_flags) \
 		--use-core --with-derive-default --ctypes-prefix core::ffi --no-layout-tests \
-		--no-debug '.*' \
+		--no-debug '.*' --enable-function-attribute-detection \
 		-o $@ -- $(bindgen_c_flags_final) -DMODULE \
 		$(bindgen_target_cflags) $(bindgen_target_extra)


base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
--
2.46.0
