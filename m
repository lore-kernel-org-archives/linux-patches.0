Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0934B241674;
	Fri, 29 Aug 2025 19:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756495385; cv=none; b=VfRakyMwG7I93SRKem7dlIDTT0Ieg6pGkvAzu3zva+TOku4N9ce8P86KLGfJuR47UttJ0Fs4OoEMgiYwmi4dOu08XAKAJzDX76VkGrQjSnQihVTZN/060ChX+XQEb0SQQmWxmc9WYaqqjMG0jRwdxkptW8MqI0ULT0iRTgGWZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756495385; c=relaxed/simple;
	bh=RTdq4XCBySE+wjdxN5Vmcpc6AEytNGOl0QEDpXc4EpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip+80pPG5F1j5qu1oU+5VFqnppf6Fsgee1JMSJufCkrDZJiWJRD40AAwb0iQSmhV+KfXzgOOErs8ESbxVj7sl8RD0ZnmOD/D6EPWV4CgMFaQPC1vEiuDXBX9kCxrh1UZ4UXny/kQSmee6BDbeWJCsSWUBRkBvHwrM/ajrFE4aOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r1pyXjZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r1pyXjZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA211C4CEF8;
	Fri, 29 Aug 2025 19:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756495384;
	bh=RTdq4XCBySE+wjdxN5Vmcpc6AEytNGOl0QEDpXc4EpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r1pyXjZarIutc62IHt2EkceW5CwW3uReNw8hVp3NwHr98EZE12sEAxjCKA1B6Aa/d
	 aKMj9gpN3cXyQ0iK4+wd5a7Gs4NF+SvDVzG1eZUh9gZtZ+2kVzMd9OdPK1Jw44nUQG
	 ZqR0ErRkCTswn+Mb81X+ZAnQkb6Fo9zrGVevtFxLKovGQ7lQ8mjrqq3IkM307lELYF
	 fm9erv21uSQ1ECYi9Op1yh3WsuXxIWUIhdBBM2exQDi2tmijJAUnOqvirCW4Z06Yd/
	 58tJMVhQXbg8joGmmYO3bZ36r0vYa7EVgbLe61kSZqJPx9Z6BvPsNvBcF/OSLgEdcO
	 CitWBRtEIB6tw==
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
Subject: [PATCH 1/3] rust: error: improve `Error::from_errno` documentation
Date: Fri, 29 Aug 2025 21:22:41 +0200
Message-ID: <20250829192243.678079-2-ojeda@kernel.org>
In-Reply-To: <20250829192243.678079-1-ojeda@kernel.org>
References: <20250829192243.678079-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This constructor is public since commit 5ed147473458 ("rust: error:
make conversion functions public"), and we will refer to it from the
documentation of `to_result` in a later commit.

Thus improve its documentation, including adding examples.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index a41de293dcd1..c415c3d3a3b6 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -101,8 +101,23 @@ macro_rules! declare_err {
 impl Error {
     /// Creates an [`Error`] from a kernel error code.
     ///
-    /// It is a bug to pass an out-of-range `errno`. `EINVAL` would
-    /// be returned in such a case.
+    /// `errno` must be within error code range (i.e. `>= -MAX_ERRNO && < 0`).
+    ///
+    /// It is a bug to pass an out-of-range `errno`. [`code::EINVAL`] is returned in such a case.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// assert_eq!(Error::from_errno(-1), EPERM);
+    /// assert_eq!(Error::from_errno(-2), ENOENT);
+    /// ```
+    ///
+    /// The following calls are considered a bug:
+    ///
+    /// ```
+    /// assert_eq!(Error::from_errno(0), EINVAL);
+    /// assert_eq!(Error::from_errno(-1000000), EINVAL);
+    /// ```
     pub fn from_errno(errno: crate::ffi::c_int) -> Error {
         if let Some(error) = Self::try_from_errno(errno) {
             error
-- 
2.51.0

