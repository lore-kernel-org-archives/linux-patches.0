Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF81437522C;
	Sat, 28 Feb 2026 17:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301554; cv=none; b=uCUCOy7/WQE6Sz79CLwE0JCBFw+ZypK6jJ5hRSzIQwQwb+DumSymNqK2nlPGvPPux5xmKImD+aEZyv6y6EYiBmexMTKm596J8GQ6KSOSzLixMCZDg79yD1lmDCGkBpF2oD5MVkpkESuCS08HE4BeHeCF6iAUJO88tIWFnu/lhKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301554; c=relaxed/simple;
	bh=r/JA94aE3VhVOGHnJHV9dB5Pk9aUKZpxR9fz6CJVFhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCAuo+8qirEnaa7z/SHYGyb4lXcpVeapmvGMjq7w6j2NuhsKj1zG2CZgjehb3TY/oVsHsz7yC8EcCcvb6uOvDCECczGbT5xQhPEnPctqunxnpql0T6Nx5vAf4BhEc+777nCWSgus5Xq6OTxNxchUXVwSbO+UuNnBAlepwejtpkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZpPaOVS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZpPaOVS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00444C19423;
	Sat, 28 Feb 2026 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301553;
	bh=r/JA94aE3VhVOGHnJHV9dB5Pk9aUKZpxR9fz6CJVFhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpPaOVS/13jQTWqIlF4Hf4DuN0l2eWdGchMzdJn38Yqf+x+1kjfifHjaWvRYi9tDa
	 yCoesEmGBGgYESaA/qTVZ9lPlJlWRXfCGtIGrBku401s4sdUYgMoTxX5Mw/bRE2bFq
	 V+LjuV0TGOf73XjO4nHk8nDbiat1IG+wHMKbq6xbshrTVHZdx5oQxRJ5//dTn33kKG
	 E3u4uJVsPmGGQJ/7LD+6/INkkWt7aWPQPUjQE8OpZP6OOKf39SFBSpdxSZzcnulh4Z
	 HqJNTN6Xj2kAS/0JCWmFNIO9PJiD/95YKbKGYzOWS3rnaWCbZZkjKZrNV1oma+tM1j
	 ugBla0Tug8ukQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Benno Lossin <lossin@kernel.org>,
	stable@vger.kernel.org,
	Gary Guo <gary@garyguo.net>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 737/752] rust: irq: add `'static` bounds to irq callbacks
Date: Sat, 28 Feb 2026 12:47:28 -0500
Message-ID: <20260228174750.1542406-737-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Benno Lossin <lossin@kernel.org>

[ Upstream commit 621609f1e5ca43a75edd497dd1c28bd84aa66433 ]

These callback functions take a generic `T` that is used in the body as
the generic argument in `Registration` and `ThreadedRegistration`. Those
types require `T: 'static`, but due to a compiler bug this requirement
isn't propagated to the function. Thus add the bound. This was caught in
the upstream Rust CI [1].

[ The three errors looked similar and will start appearing with Rust
  1.95.0 (expected 2026-04-16). The first one was:

      error[E0310]: the parameter type `T` may not live long enough
      Error:    --> rust/kernel/irq/request.rs:266:43
          |
      266 |     let registration = unsafe { &*(ptr as *const Registration<T>) };
          |                                           ^^^^^^^^^^^^^^^^^^^^^^
          |                                           |
          |                                           the parameter type `T` must be valid for the static lifetime...
          |                                           ...so that the type `T` will meet its required lifetime bounds
          |
      help: consider adding an explicit lifetime bound
          |
      264 | unsafe extern "C" fn handle_irq_callback<T: Handler + 'static>(_irq: i32, ptr: *mut c_void) -> c_uint {
          |                                                     +++++++++

    - Miguel ]

Link: https://github.com/rust-lang/rust/pull/149389 [1]
Signed-off-by: Benno Lossin <lossin@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 29e16fcd67ee ("rust: irq: add &Device<Bound> argument to irq callbacks")
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/rust-for-linux/20260217222425.8755-1-cole@unwrap.rs/
Link: https://patch.msgid.link/20260214092740.3201946-1-lossin@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/irq/request.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/irq/request.rs b/rust/kernel/irq/request.rs
index b150563fdef80..2ceeaeb0543a4 100644
--- a/rust/kernel/irq/request.rs
+++ b/rust/kernel/irq/request.rs
@@ -261,7 +261,10 @@ impl<T: Handler + 'static> Registration<T> {
 /// # Safety
 ///
 /// This function should be only used as the callback in `request_irq`.
-unsafe extern "C" fn handle_irq_callback<T: Handler>(_irq: i32, ptr: *mut c_void) -> c_uint {
+unsafe extern "C" fn handle_irq_callback<T: Handler + 'static>(
+    _irq: i32,
+    ptr: *mut c_void,
+) -> c_uint {
     // SAFETY: `ptr` is a pointer to `Registration<T>` set in `Registration::new`
     let registration = unsafe { &*(ptr as *const Registration<T>) };
     // SAFETY: The irq callback is removed before the device is unbound, so the fact that the irq
@@ -480,7 +483,7 @@ impl<T: ThreadedHandler + 'static> ThreadedRegistration<T> {
 /// # Safety
 ///
 /// This function should be only used as the callback in `request_threaded_irq`.
-unsafe extern "C" fn handle_threaded_irq_callback<T: ThreadedHandler>(
+unsafe extern "C" fn handle_threaded_irq_callback<T: ThreadedHandler + 'static>(
     _irq: i32,
     ptr: *mut c_void,
 ) -> c_uint {
@@ -496,7 +499,10 @@ unsafe extern "C" fn handle_threaded_irq_callback<T: ThreadedHandler>(
 /// # Safety
 ///
 /// This function should be only used as the callback in `request_threaded_irq`.
-unsafe extern "C" fn thread_fn_callback<T: ThreadedHandler>(_irq: i32, ptr: *mut c_void) -> c_uint {
+unsafe extern "C" fn thread_fn_callback<T: ThreadedHandler + 'static>(
+    _irq: i32,
+    ptr: *mut c_void,
+) -> c_uint {
     // SAFETY: `ptr` is a pointer to `ThreadedRegistration<T>` set in `ThreadedRegistration::new`
     let registration = unsafe { &*(ptr as *const ThreadedRegistration<T>) };
     // SAFETY: The irq callback is removed before the device is unbound, so the fact that the irq
-- 
2.51.0

