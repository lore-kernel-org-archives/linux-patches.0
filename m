Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D39F1A2550;
	Tue, 21 Jan 2025 20:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737490211; cv=none; b=XVruJmMJTRhn4WEfpcdK8rYmU26MTQJKiwDaubXeB10PDVx/1DoJongKEBfu9qd18Kf5YmBFuUd1Kd6u1rqPIpYJUWwVgJJeFwU0vCnOwfvF5oGmdNi+oDXImXknyfQnJrFjZOwBil2UShC6+jgUY5EEhVhH/9MSbtt4oJrkrnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737490211; c=relaxed/simple;
	bh=NaNW6SIeYFY/kjjoQyG05j4BnlZv/oI1rJ5HQO4JQ90=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uuLMGSzwMeqZIQiWzaW3/HP35Lp/Z7iwZenobnxZIdemo/g7RjrWbWAPLsnjqXHRdEsmJHeqMTpqCdLwkGqAIAQTERnqY40irCq6xwXrM7+HjxO6OAWkYjmCAX+eHDT2CTJmLBYg+elWKzYte2DvGuI+3SURcQHyZODnui/jzlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mv+au30h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mv+au30h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169A7C4CEDF;
	Tue, 21 Jan 2025 20:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737490209;
	bh=NaNW6SIeYFY/kjjoQyG05j4BnlZv/oI1rJ5HQO4JQ90=;
	h=From:To:Cc:Subject:Date:From;
	b=mv+au30hs9oP1Ku6oONT6BLtu3QVyVQSIkC/syWTzXviV1e0LNlelvl01tiErALFa
	 CgWJufFUCT7eGCubur8MzOihzTPWVtpWo2vdTCqd2tackydNjdJetsIXoaJgPJ6cpI
	 N2F7nbo13Ht0F3KbU6CQYHMOspQ7EpJwWQXMyGj8di2Gx6gRdFu6FoEwyju6rnmVQp
	 KbKb9ViHDWu27KHlIyaG97nxDqumEjHnXHPKZqsXHwvu0WxGkDK7bH8AySw5kgh7kP
	 A5z9O2ovrBSOyfD53w+IGHqcdRx8tw029uOTMf+sseFSLxuUKT52peAX52eOwoYQOF
	 RTlpm5KD3KexQ==
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
Subject: [PATCH] rust: init: use explicit ABI to clean warning in future compilers
Date: Tue, 21 Jan 2025 21:09:34 +0100
Message-ID: <20250121200934.222075-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.86.0 (currently in nightly, to be released on
2025-04-03), the `missing_abi` lint is warn-by-default [1]:

    error: extern declarations without an explicit ABI are deprecated
        --> rust/doctests_kernel_generated.rs:3158:1
         |
    3158 | extern {
         | ^^^^^^ help: explicitly specify the C ABI: `extern "C"`
         |
         = note: `-D missing-abi` implied by `-D warnings`
         = help: to override `-D warnings` add `#[allow(missing_abi)]`

Thus clean it up.

Link: https://github.com/rust-lang/rust/pull/132397 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 347049df556b..c962029f96e1 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -854,7 +854,7 @@ pub unsafe trait PinInit<T: ?Sized, E = Infallible>: Sized {
     /// use kernel::{types::Opaque, init::pin_init_from_closure};
     /// #[repr(C)]
     /// struct RawFoo([u8; 16]);
-    /// extern {
+    /// extern "C" {
     ///     fn init_foo(_: *mut RawFoo);
     /// }
     ///

base-commit: 100ceb4817a2ac650e29f107cf97161ce3e2289a
-- 
2.48.1

