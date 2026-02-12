Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA2D1D5174;
	Thu, 12 Feb 2026 01:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770858639; cv=none; b=bcSe6iORpbNx3gL/60LEtkTLt6z3THXub50LuKE/dGq9jz9YTKw7rq+uVsqpRjKhbxLKkG8Gt2MGCgg79AdeRzOmLnbCCDId9IA4ExWaGVjllXXnp8auR7gdmkjgOyEmxlv7W/AKo5HxcznuoDTNl/X5Mkr5cK4hzEpxHtWwGTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770858639; c=relaxed/simple;
	bh=obCLhOQsw15/JafM/JzsVZaEn8YPd9SbTUIixeWczZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfrfeRqLpKvPXpUCawDvJ+hmT31TGdM9vXSzaJQJQNhwFI2KOAgkh+ZWPt1UxuGM0JrhoPjf8zUr/9yz4kdmI5O5rV3cQ1Id96xF8+/1AD5BKLpDfKTsV52Tvk8JdqDd75kzjgIWxL2KclcEdt9IzBX9irqeoqliYwYaQbuhSMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lgVF6DQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lgVF6DQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07016C4CEF7;
	Thu, 12 Feb 2026 01:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770858639;
	bh=obCLhOQsw15/JafM/JzsVZaEn8YPd9SbTUIixeWczZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lgVF6DQLIimreAYhRWJIfB7jxA9qxjGm9Y1QIhyPkWWEHYUewjCfsAJDdIqmxD1aB
	 +r99P34pir261ZtOZo2B+PzaXQJnV+iqUmbP8cpXnpILT2yVcP6ygWQHWR2Xqg+jgB
	 Rcj5nsUQF8Q93tPqhkLOQH2n79jQgL/grNUVhGpofL+2nZjGSuzHq5lFFs1PL9bqZ9
	 olPa8lYjspC/u3j1zrqBXYoCzxIsLbHadLYlJauwoE3DgUI4hEA1JSdB1rO9dRdLlJ
	 nRhIjlMjYHmPGg4UXVWU8WaKD6/JWaILRi6nTAoZUZG4WP//2Bf+JDqDzeqciNwLea
	 p8MvIuoTNGriA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alice Ryhl <aliceryhl@google.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Benno Lossin <lossin@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	ojeda@kernel.org,
	shankari.ak0208@gmail.com,
	rust-for-linux@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] rust: sync: Implement Unpin for ARef
Date: Wed, 11 Feb 2026 20:09:46 -0500
Message-ID: <20260212010955.3480391-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260212010955.3480391-1-sashal@kernel.org>
References: <20260212010955.3480391-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 09248ed8cdb6345afc883c02aecd79dfbd9c2a9c ]

The default implementation of Unpin for ARef<T> is conditional on T
being Unpin due to its PhantomData<T> field. However, this is overly
strict as pointers to T are legal to move even if T itself cannot move.

Since commit 66f1ea83d9f8 ("rust: lock: Add a Pin<&mut T> accessor")
this causes build failures when combined with a Mutex that contains an
field ARef<T>, because almost any type that ARef is used with is !Unpin.

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://patch.msgid.link/20251218-unpin-for-aref-v2-1-30d77129cbc6@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have the complete picture. Let me compile my analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit adds `impl<T: AlwaysRefCounted> Unpin for ARef<T> {}` to fix
a type system issue in the Rust kernel API. The key statement is: *"this
causes build failures when combined with a Mutex that contains a field
ARef<T>, because almost any type that ARef is used with is !Unpin."*

The commit references `66f1ea83d9f8` ("rust: lock: Add a Pin<&mut T>
accessor") but the actual root cause is the earlier commit
`da123f0ee40f0` ("rust: lock: guard: Add T: Unpin bound to DerefMut"),
which adds `T: Unpin` as a requirement for `Guard::DerefMut`.

### 2. Code Change Analysis

The change is exactly 3 lines (1 comment + 2 code):

```rust
// Even if `T` is pinned, pointers to `T` can still move.
impl<T: AlwaysRefCounted> Unpin for ARef<T> {}
```

**The bug mechanism:**
- `ARef<T>` is defined as `struct ARef<T: AlwaysRefCounted> { ptr:
  NonNull<T>, _p: PhantomData<T> }`
- `PhantomData<T>` causes Rust's auto-trait system to derive `Unpin for
  ARef<T>` only when `T: Unpin`
- Nearly all types that `ARef` wraps (`Device`, `Mm`, `File`,
  `Credential`, etc.) contain `Opaque<bindings::*>` which has
  `PhantomPinned`, making them `!Unpin`
- Therefore `ARef<Device>`, `ARef<Mm>`, `ARef<File>`, etc. are all
  incorrectly `!Unpin`
- After `da123f0ee40f0` added `T: Unpin` bound to `Guard::DerefMut` (in
  v6.19), any struct containing `ARef<SomeType>` that's inside a `Mutex`
  would lose `DerefMut` on the guard, preventing mutable access

**Why the fix is correct:**
`ARef<T>` is a pointer type (it holds `NonNull<T>`). Moving an `ARef`
moves the pointer, not the pointed-to `T`. This is the same reasoning
used by Rust's standard library where `Box<T>`, `Arc<T>`, and `Rc<T>`
all unconditionally implement `Unpin`.

### 3. Dependency Analysis

The commit depends on:
1. `da123f0ee40f0` ("rust: lock: guard: Add T: Unpin bound to DerefMut")
   - in v6.19
2. `2497a7116ff9a` ("rust: lock: Pin the inner data") - in v6.19
3. `66f1ea83d9f8` ("rust: lock: Add a Pin<&mut T> accessor") - in v6.19

**Stable tree relevance:**
- **6.19.y**: Has all three prerequisite commits. The `T: Unpin` bound
  on `DerefMut` is present at line 284-286 of `lock.rs`. The `ARef<T>`
  Unpin fix is **missing**. This is the only stable tree where the fix
  is needed.
- **6.18.y and earlier**: Do NOT have the lock pinning changes.
  `DerefMut` has no `Unpin` bound. The fix is irrelevant.

### 4. Current In-Tree Impact Assessment

I verified that no current in-tree code in 6.19.y uses `Mutex<SomeType>`
where `SomeType` directly contains `ARef<T>`. The `rust_misc_device.rs`
sample has `ARef<Device>` as a sibling field to `Mutex<Inner>`, not
inside the Mutex. The binder driver similarly keeps `ARef<Mm>` separate
from its `Mutex<()>`.

However, the pattern of putting `ARef<T>` inside a mutex-protected
struct is a completely natural and common systems programming pattern.
Anyone developing Rust kernel modules targeting 6.19.y would likely hit
this. The commit `0bc605713f16a` ("rust: debugfs: Implement BinaryReader
for Mutex<T> only when T is Unpin") already shows that the DerefMut
Unpin bound caused a real build failure in linux-next, demonstrating
that these cascading effects are real.

### 5. Risk Assessment

- **Lines changed**: 3 (1 comment + 2 code)
- **Regression risk**: Effectively zero. Implementing `Unpin` for a
  pointer wrapper type is standard practice in Rust and cannot break
  existing code (it only relaxes a constraint, making more code
  compile).
- **Scope**: Single file (`rust/kernel/sync/aref.rs`), single trait
  implementation
- **Reviews**: 3 expert reviewers (Daniel Almeida, Alexandre Courbot,
  Benno Lossin)
- **Author**: Alice Ryhl, a key Rust-for-Linux contributor at Google

### 6. Classification

This is a **build fix / type system correctness fix**. While no in-tree
code currently triggers the build failure in 6.19.y, the fix addresses
an incorrectness in `ARef`'s trait implementation that was made
practically impactful by the lock pinning changes already present in
6.19.y. It is NOT a new feature - it corrects an overly restrictive
auto-derived trait bound that was wrong from the start but didn't matter
until the DerefMut bound was added.

### 7. Conclusion

**Arguments for YES:**
- Fixes a genuine type system incorrectness in `ARef<T>`
- Trivially small (2 lines of actual code), obviously correct, zero
  regression risk
- Well-reviewed by 3 Rust-for-Linux experts
- The prerequisite changes that make this issue observable are already
  in 6.19.y
- Analogous to how `Box<T>`, `Arc<T>`, `Rc<T>` implement `Unpin` in std
- The same DerefMut Unpin bound already caused a real build failure in
  another subsystem

**Arguments for NO:**
- No current in-tree code in 6.19.y directly triggers the build failure
- The commit is still in linux-next, pending mainline merge
- Could be viewed as adding new behavior (new trait implementation)
  rather than fixing a bug

On balance, the fix is small enough and correct enough that the benefit
of having it in 6.19.y outweighs the negligible risk. The lock pinning
changes already in 6.19.y made `ARef<T>` functionally broken for use
inside Mutex-protected structures, and this 2-line fix corrects that.
The lack of current in-tree code hitting it is mitigated by the fact
that the pattern is natural and expected, and similar cascading build
failures from the same root cause have already been observed.

**YES**

 rust/kernel/sync/aref.rs | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 0d24a0432015d..0616c0353c2b3 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -83,6 +83,9 @@ unsafe impl<T: AlwaysRefCounted + Sync + Send> Send for ARef<T> {}
 // example, when the reference count reaches zero and `T` is dropped.
 unsafe impl<T: AlwaysRefCounted + Sync + Send> Sync for ARef<T> {}
 
+// Even if `T` is pinned, pointers to `T` can still move.
+impl<T: AlwaysRefCounted> Unpin for ARef<T> {}
+
 impl<T: AlwaysRefCounted> ARef<T> {
     /// Creates a new instance of [`ARef`].
     ///
-- 
2.51.0

