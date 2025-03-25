Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758C21F0E5B;
	Tue, 25 Mar 2025 18:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928212; cv=none; b=IDrfqzUn4Q/P435tj4c21vpOcG/8D9+MqxVV2aW0sflUXDWPvSno2u8YIge9VYYLZskLLQZuk/K7efxcUzvH048Aqd1vjw1MHiXE7YYkBvCgy6k28m5qz6uaywhh5JMysyFtL74CA4KHj+Sg3d8s6HacowN0T4Y9MXy9BKjwves=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928212; c=relaxed/simple;
	bh=lxUUlSThn5Avn0z7/o3Yphjmqxg3+x8EnqxeM1zvcV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a4yoM36djs2qFOfdtgw0TTZ7oEEMp/RgnGzGw412wVOdQyHmfk6g0KtyXEe6ZLsRQe7F2z53Vq2oIQoPs3CicYSb79ufAqAPhWOViFdCJ9v9b1mSQ3hkwhyu8hHSDpKi70GMMBURo7Cb34PE02W6LUGC9GCGvJQkyAwZyvZYYrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxTjGe1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxTjGe1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB66C4CEED;
	Tue, 25 Mar 2025 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928212;
	bh=lxUUlSThn5Avn0z7/o3Yphjmqxg3+x8EnqxeM1zvcV4=;
	h=From:To:Cc:Subject:Date:From;
	b=DxTjGe1xX+uQPbSWLTrtqL7QcLtDmGjdNJFR1ddxRqpKs8OUGqUQMKaC1OKlAg6+f
	 AdvM3RmoHgKxu/uI5vpDUqJx+Yc3ibb4qndbqSW8SMuCZM70nSVlN4dNI353TAk4YO
	 qoR+6LUny8XLYHLBDFhk6+kZcF4VLymPaieX+R5yNgC9lvr+McDX5yBx2++5btCkRV
	 ewyNUKxaffaGJKhv2W3GfFRbqSiBv6oda59T2/QiGUuDd+BbodRzge7FeYK3Vnc6ur
	 TL50FZXRz/XnfdNEUPFmIsuhNMbWuQS/Y9lQS0cCAqVIWV5xBwbduh1F3udYreOP6t
	 PFETTH9Idethw==
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
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: workaround `bindgen` issue with forward references to `enum` types
Date: Tue, 25 Mar 2025 19:43:09 +0100
Message-ID: <20250325184309.97170-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`bindgen` currently generates the wrong type for an `enum` when there
is a forward reference to it. For instance:

    enum E;
    enum E { A };

generates:

    pub const E_A: E = 0;
    pub type E = i32;

instead of the expected:

    pub const E_A: E = 0;
    pub type E = ffi::c_uint;

The issue was reported to upstream `bindgen` [1].

Now, both GCC and Clang support silently these forward references to
`enum` types, unless `-Wpedantic` is passed, and it turns out that some
headers in the kernel depend on them.

Thus, depending on how the headers are included, which in turn may depend
on the kernel configuration or the architecture, we may get a different
type on the Rust side for a given C `enum`.

That can be quite confusing, to say the least, especially since
developers may only notice issues when building for other architectures
like in [2]. In particular, they may end up forcing a cast and adding
an `#[allow(clippy::unnecessary_cast)]` like it was done in commit
94e05a66ea3e ("rust: hrtimer: allow timer restart from timer handler"),
which isn't great.

Instead, let's have a section at the top of our `bindings_helper.h` that
`#include`s the headers with the affected types -- hopefully there are
not many cases and there is a single ordering that covers all cases.

This allows us to remove the cast and the `#[allow]`, thus keeping the
correct code in the source files. When the issue gets resolved in upstream
`bindgen` (and we update our minimum `bindgen` version), we can easily
remove this section at the top.

Link: https://github.com/rust-lang/rust-bindgen/issues/3179 [1]
Link: https://lore.kernel.org/rust-for-linux/87tt7md1s6.fsf@kernel.org/ [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindings/bindings_helper.h | 19 +++++++++++++++++++
 rust/kernel/time/hrtimer.rs     |  6 ++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index ccb988340df6..9f29855d5ab0 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -6,6 +6,25 @@
  * Sorted alphabetically.
  */
 
+/*
+ * First, avoid forward references to `enum` types.
+ *
+ * This workarounds a `bindgen` issue with them:
+ * <https://github.com/rust-lang/rust-bindgen/issues/3179>.
+ *
+ * Without this, the generated Rust type may be the wrong one (`i32`) or
+ * the proper one (typically `c_uint`) depending on how the headers are
+ * included, which in turn may depend on the particular kernel configuration
+ * or the architecture.
+ *
+ * The alternative would be to use casts and likely an
+ * `#[allow(clippy::unnecessary_cast)]` in the Rust source files. Instead,
+ * this approach allows us to keep the correct code in the source files and
+ * simply remove this section when the issue is fixed upstream and we bump
+ * the minimum `bindgen` version.
+ */
+#include <linux/hrtimer_types.h>
+
 #include <kunit/test.h>
 #include <linux/blk-mq.h>
 #include <linux/blk_types.h>
diff --git a/rust/kernel/time/hrtimer.rs b/rust/kernel/time/hrtimer.rs
index ce53f8579d18..d52ce884303d 100644
--- a/rust/kernel/time/hrtimer.rs
+++ b/rust/kernel/time/hrtimer.rs
@@ -384,11 +384,9 @@ unsafe fn start(this: *const Self, expires: Ktime) {
 #[repr(u32)]
 pub enum HrTimerRestart {
     /// Timer should not be restarted.
-    #[allow(clippy::unnecessary_cast)]
-    NoRestart = bindings::hrtimer_restart_HRTIMER_NORESTART as u32,
+    NoRestart = bindings::hrtimer_restart_HRTIMER_NORESTART,
     /// Timer should be restarted.
-    #[allow(clippy::unnecessary_cast)]
-    Restart = bindings::hrtimer_restart_HRTIMER_RESTART as u32,
+    Restart = bindings::hrtimer_restart_HRTIMER_RESTART,
 }
 
 impl HrTimerRestart {
-- 
2.49.0

