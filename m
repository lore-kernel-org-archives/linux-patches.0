Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5053E241674;
	Fri, 29 Aug 2025 19:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756495388; cv=none; b=AXoNJ6XSgIoM+d04vNgA5iuaicbKN0WvhdoMrHh4I5aTMnYDDDzva7S5Ecllet1anOqOlhaG7/lN7qGxLLbrh65B2nsm75yNvo7lljCmIGJzvNdnLSNmk0+5GDR3IbUxZdEnLuHSSlEd33lPjwxRKgCYXMtrKfvH7Dx9UyEgRkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756495388; c=relaxed/simple;
	bh=nGhud1S2ik/vjCeVwqLM0vCxAkmpQiP1560oLzqcxgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1MzUcDy8CiVE9eIqjyc6T2yVjGjFO7JTE8rou5a43WubOfxLbyzTSjMIBkTGECNjYIJOGSlbBhm4ZCbWzyCxer6GkSxxB9K422bXFDtE2DMpZWY5DhbToDuRwMWa9ZRyv8gAXRVMAtw5oRJxT87cXSzqBaiiU38RbbXAWn1i4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVdefEZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVdefEZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB88C4CEF1;
	Fri, 29 Aug 2025 19:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756495387;
	bh=nGhud1S2ik/vjCeVwqLM0vCxAkmpQiP1560oLzqcxgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVdefEZdr4MIirVprvNowlcZIFOjUD67q4gzDoN44GjGncFd+p+zT9W5QkGacuL/1
	 /tVFZ3AIyhyQHtsgJK2aZKB79oL89PvzNUvbkBphfNMoHwMY1jkQHgLglmeHIgKJny
	 Z6yUTQuzzYDr9SBhVmlOI8jPsCfY0XNq7skMHk0aKmgJfVCoXY/YaTs8+cL5vqEfXI
	 ABWbpviWTC3MvdyZhopa3pOkoMvWmE+DVOWiSysH1DSKcEhL1bskUfMDyj6KDun4XF
	 blqg6TJaE1TyRWCjCfnOK4+str4BVKTKlfuj/cK9S6gWE+gHapKopNEIiI9FUvt6GU
	 xINHs8U8qZgZA==
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
	patches@lists.linux.dev
Subject: [PATCH 2/3] rust: error: improve `to_result` documentation
Date: Fri, 29 Aug 2025 21:22:42 +0200
Message-ID: <20250829192243.678079-3-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-1-ojeda@kernel.org>
References: <20250829192243.678079-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Core functions like `to_result` should have good documentation.

Thus improve it, including adding an example of how to perform early
returns with it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index c415c3d3a3b6..1ebdb798fd5d 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -390,8 +390,43 @@ fn from(e: core::convert::Infallible) -> Error {
 /// [Rust documentation]: https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html
 pub type Result<T = (), E = Error> = core::result::Result<T, E>;
 
-/// Converts an integer as returned by a C kernel function to an error if it's negative, and
-/// `Ok(())` otherwise.
+/// Converts an integer as returned by a C kernel function to a [`Result`].
+///
+/// If the integer is negative, an [`Err`] with an [`Error`] as given by [`Error::from_errno`] is
+/// returned. This means the integer must be `>= -MAX_ERRNO`.
+///
+/// Otherwise, it returns [`Ok`].
+///
+/// It is a bug to pass an out-of-range negative integer. `Err(EINVAL)` is returned in such a case.
+///
+/// # Examples
+///
+/// This function may be used to easily perform early returns with the [`?`] operator when working
+/// with C APIs within Rust abstractions:
+///
+/// ```
+/// # use kernel::error::to_result;
+/// # mod bindings {
+/// #     #![expect(clippy::missing_safety_doc)]
+/// #     use kernel::prelude::*;
+/// #     pub(super) unsafe fn f1() -> c_int { 0 }
+/// #     pub(super) unsafe fn f2() -> c_int { EINVAL.to_errno() }
+/// # }
+/// fn f() -> Result {
+///     // SAFETY: ...
+///     to_result(unsafe { bindings::f1() })?;
+///
+///     // SAFETY: ...
+///     to_result(unsafe { bindings::f2() })?;
+///
+///     // ...
+///
+///     Ok(())
+/// }
+/// # assert_eq!(f(), Err(EINVAL));
+/// ```
+///
+/// [`?`]: https://doc.rust-lang.org/reference/expressions/operator-expr.html#the-question-mark-operator
 pub fn to_result(err: crate::ffi::c_int) -> Result {
     if err < 0 {
         Err(Error::from_errno(err))
-- 
2.51.0

