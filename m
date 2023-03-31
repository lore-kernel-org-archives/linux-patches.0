Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC98F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:51:28 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:51:15 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299480; x=1680558680;
	bh=EvXBmlzS/OPrQukOKPTGHKdUydzQEL6E+zl3Jv3yRhA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=cr93XniHrG4L7E+McMX7GKruy9ZEC7n2YKDePhV7zuSQ8Fib8VH0BzH36xjn5+/18
	 oH/SxM5JroSLbkyofZvjMMRV5nzRwwJRHvMeH+w2fPVcU1jRtHp15AAWL0pdi6oAxs
	 E2QLhGOe8lMniV8UwxQLquCNNpwnvTQP9k9kQFyFfPIWKuCTVjObhBHfd6LENOSECm
	 xY9zT5h+yQGnJt7ITX0H8+ZEXGiI/Oj/amlnbyWMuKt77fJK8qvLcJT+CQPjnflk2O
	 5mQxRGC7dsCFUDpQHeZeaJzG8CWT//dtsJSaIHHZ1HKAwDQuW18H4kna76buZE7Kye
	 i9EN2mfzlyogA==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>
Subject: [PATCH v4 00/15] Rust pin-init API for pinned initialization of structs
Message-ID: <20230331215053.585759-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Benno Lossin <y86-dev@protonmail.com>

This is the fourth version of the pin-init API. See [1] for v3.

The tree at [2] contains these patches applied on top of 6.3-rc1.
The Rust-doc documentation of the pin-init API can be found at [3].

These patches are a long way coming, since I held a presentation on
safe pinned initialization at Kangrejos [4]. And my discovery of this
problem was almost a year ago [5].

- #1 enables the `pin_macro` feature which is already stable in Rust
  version 1.68.
- #2 adds a utility macro `quote!` for proc-macros. This macro converts
  the typed characters directly into Rust tokens that are the output of
  proc-macros. It is used by the pin-init API proc-macros.
- #3 changes the `Err` types of the constructor functions of `Arc` and
  `UniqueArc` to `AllocError`.
- #4 adds the `assume_init` function to `UniqueArc<MaybeUninit<T>>` that
  unsafely assumes the pointee to be initialized and returns a
  `UniqueArc<T>`. `UniqueArc::write` is modified to use this new function.
  Later patches use it as well.
- #5 adds `Opaque::raw_get` to access the value inside of an `Opaque` from
  a raw pointer only.
- #6-11 introduce the pin-init API. The commit message of #4 details the
  problem it solves and lays out the overall architecture. The
  implementation details are fairly complex; however, this is required to
  provide a safe API for users -- reducing the amount of `unsafe` code is a
  key goal of the Rust support in the kernel. An example of the
  before/after difference from the point of view of users is provided in
  the commit message. It is a goal to at some point have pin-init as a
  language feature of Rust. A first step in this direction is the Field
  Projection RFC [6].
- #12 adds important traits and macros from pin-init to the prelude.
- #13 adds functions for easier initialization of `Opaque<T>` via
  FFI and raw pointer initializer functions. This is necessary when writing
  Rust wrappers and will be used by Wedson's `sync` module patches.
- #14 improves the `UniqueArc::try_new_uninit` function by using the
  pin-init API. The old version first allocated uninitialized memory on the
  stack and then moved it into the location in the heap. The new version
  directly allocates this on the heap.
- #15 adds functions for initializing already allocated `UniqueArc`s, this
  will be used by the Android Binder driver.

--

Changelog:

v3 -> v4:
- Improve documentation.
- Fixing doc-tests imports, comments and full paths in macro examples.
- Implement `Zeroable` for many more types.
- Fix unsoundness: `Zeroable` allowed to create fat pointers with a null
  VTABLE pointer.
- Split fallible components from `stack_pin_init!` into
  `stack_try_pin_init!`.
- Move `Invariant` type alias and `InitClosure` into `__internal`.
- Change the error type of the constructor functions of `Arc` and
  `UniqueArc` to `AllocError`.
- Add `try` variants to `InPlaceInit` to allow custom error types.
- Make `StackInit::init` a safe function.
- Rename `OnlyCallFromDrop::create` to `OnlyCallFromDrop::new`.
- Enable the `pin_macro` feature for use inside of `stack_pin_init!`.
- Make `quote!` and `quote_spanned!` use absolute paths.

v2 -> v3:
- Split the big original commit into six smaller commits.
- Use `PinnedDrop` in the `RawFoo` code example.
- Move the `init::common::ffi_init` functions to `Opaque::ffi_init`.
- Move all `#[doc(hidden)]`, internal types into the new `__internal`
  module.
- Specify safety guarantees and requirements of the initializer macros.
- Add a detailed example of what the expanded code of the various macros
  looks like.
- Require generics in the initializer macros to use turbofish syntax
  (`::<>`).
- Refactor the internals of the initializer macros, this way they have
  better type inference and generic arguments can be omitted more often.
- Replace `init::from_value` with a blanket impl of the initializer traits
  for ordinary objects.
- Add initializing functions for already allocated `UniqueArc`s.
- Add `Opaque::manual_init` functions akin to `ffi_init`, but they take an
  `extern "Rust" fn` instead.
- Documentation and inline comment improvements.

v1 -> v2:
- Split the common module and `UniqueArc::assume_init` into their own
  commits.
- Change the generics syntax of `pin_init!` to reflect normal struct
  generic syntax.
- Replace `PinnedDrop::__ensure_no_unsafe_op_in_drop` with an only unsafely
  creatable token.
- Hide `StackInit<T>` in the docs, because it is internal API.
- Improve macro internals of `pin_init!` according to Gary's review.
- Add check for `PhantomPinned` fields without a `#[pin]` attribute in
  `#[pin_data]`, as those fields will not have the intended effect.
- Add docs to `quote.rs`.

[1] https://lore.kernel.org/rust-for-linux/20230329223239.138757-1-y86-dev@=
protonmail.com/
[2] https://github.com/y86-dev/linux.git patch/pinned-init-v4
[3] https://rust-for-linux.github.io/docs/pinned-init/kernel/init
[4] https://kangrejos.com
[5] https://github.com/Rust-for-Linux/linux/issues/772
[6] https://github.com/rust-lang/rfcs/pull/3318

Benno Lossin (14):
  rust: enable the `pin_macro` feature
  rust: sync: change error type of constructor functions
  rust: sync: add `assume_init` to `UniqueArc`
  rust: types: add `Opaque::raw_get`
  rust: add pin-init API core
  rust: init: add initialization macros
  rust: init/sync: add `InPlaceInit` trait to pin-initialize smart
    pointers
  rust: init: add `PinnedDrop` trait and macros
  rust: init: add `stack_pin_init!` macro
  rust: init: add `Zeroable` trait and `init::zeroed` function
  rust: prelude: add `pin-init` API items to prelude
  rust: types: add common init-helper functions for `Opaque`
  rust: sync: reduce stack usage of `UniqueArc::try_new_uninit`
  rust: sync: add functions for initializing `UniqueArc<MaybeUninit<T>>`

Gary Guo (1):
  rust: macros: add `quote!` macro

 rust/kernel/init.rs            | 1429 ++++++++++++++++++++++++++++++++
 rust/kernel/init/__internal.rs |  234 ++++++
 rust/kernel/init/macros.rs     |  971 ++++++++++++++++++++++
 rust/kernel/lib.rs             |    7 +
 rust/kernel/prelude.rs         |    6 +-
 rust/kernel/sync/arc.rs        |   80 +-
 rust/kernel/types.rs           |   55 ++
 rust/macros/lib.rs             |   80 ++
 rust/macros/pin_data.rs        |   79 ++
 rust/macros/pinned_drop.rs     |   49 ++
 rust/macros/quote.rs           |  143 ++++
 scripts/Makefile.build         |    2 +-
 12 files changed, 3127 insertions(+), 8 deletions(-)
 create mode 100644 rust/kernel/init.rs
 create mode 100644 rust/kernel/init/__internal.rs
 create mode 100644 rust/kernel/init/macros.rs
 create mode 100644 rust/macros/pin_data.rs
 create mode 100644 rust/macros/pinned_drop.rs
 create mode 100644 rust/macros/quote.rs


base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
--
2.39.2


