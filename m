Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB9239E9E;
	Fri, 29 Aug 2025 19:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756495392; cv=none; b=pBAaIP7rjyAZV9+H50jnGloLighpozw4Oj0MBGh966DLNxqrDanskwO4dirXSb1p/P/leMYEutSTmB9FzzH4QEhCRn5Z9fL0+P9YUyADR+3TVrkz0lf3ptT/Xa+CZFxi3Oc1FeqQvPJ9zJl/33IHZgQiylARBR6OZcFliL20wbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756495392; c=relaxed/simple;
	bh=mIhxfi8PIu+hlogvO+xLc5ASjZ3oFz+evVdeTWUt5c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHQ8F70xwBScuwdvMxWoYRfnhDiykpbuY14MH4v3VJ84LfHQkEWllx4HLP1TeTvTHUiaQHtY/JlXYZEUC3pBOd1DDRt/plcaAKoX6NpIbKE90KOa+C5YPv3dLuLYehGgE2G1VcG/4HQGhhbLXXxxTmFwpGvGTDW5BroO24se1/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YiCflnW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YiCflnW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577A2C4CEF7;
	Fri, 29 Aug 2025 19:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756495391;
	bh=mIhxfi8PIu+hlogvO+xLc5ASjZ3oFz+evVdeTWUt5c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiCflnW345EnnvmzDb7BWqZX4icGW8gvaYs6tUBIo1p7+oGdXOxByVnw+Zkvs/wZv
	 vbpWptxBruz1RKvNkxmkWusr2Nmo4lbSEpIQZhknxBwAt9jyLI494fSWwNEvzwBcYe
	 P9dTMIm2YfDjV6PSL7oz3njMKSeH0MYNaF3rHh33fVskMkVCMYmSU+FPinn17gKNlM
	 8Sae57XBAXzbqUMBzA6u7M4sSiHVhAFNwoIt9Km4l4fe6dVCd+hhC44/K7xzdVhJe+
	 EtLfIKGPdqi4phi167rhRsFmpcO+586SCwzwVbsQOnJ6DGwlPlEoM6Dh6CG9q7Z/AL
	 w2n5Is3cORcaw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 3/3] rust: error: replace `WARN_ON_ONCE` comment with `debug_assert!`
Date: Fri, 29 Aug 2025 21:22:43 +0200
Message-ID: <20250829192243.678079-4-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-1-ojeda@kernel.org>
References: <20250829192243.678079-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`warn_on!` support landed recently, and we had a very old comment
about using it when supported to catch invalid inputs passed to
`Error::from_errno`.

However, the kernel policy is that reaching a `WARN_ON` by user
interactions is a CVE, e.g. [1].

Since `from_errno` and other functions that use it such as `to_result`
will be used everywhere, sooner or later a caller may pass an invalid
value due to a user interaction.

Thus, instead, use a debug assertion -- this assumes hitting one of them
is not going to be considered a CVE (which requires
`CONFIG_RUST_DEBUG_ASSERTIONS=y`).

We don't want to potentially panic when testing the examples, thus
convert those to a build-test.

Cc: Greg KH <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/all/2024092340-renovate-cornflake-4b5e@gregkh/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 1ebdb798fd5d..7b9892a46505 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -115,18 +115,20 @@ impl Error {
     /// The following calls are considered a bug:
     ///
     /// ```
+    /// # fn no_run() {
     /// assert_eq!(Error::from_errno(0), EINVAL);
     /// assert_eq!(Error::from_errno(-1000000), EINVAL);
+    /// # }
     /// ```
     pub fn from_errno(errno: crate::ffi::c_int) -> Error {
         if let Some(error) = Self::try_from_errno(errno) {
             error
         } else {
-            // TODO: Make it a `WARN_ONCE` once available.
             crate::pr_warn!(
                 "attempted to create `Error` with out of range `errno`: {}\n",
                 errno
             );
+            debug_assert!(false);
             code::EINVAL
         }
     }
-- 
2.51.0

