Received: from mail-41104.protonmail.ch (mail-41104.protonmail.ch [185.70.41.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CB68F53
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 08:55:28 +0000 (UTC)
Date: Mon, 14 Aug 2023 08:46:20 +0000
Authentication-Results: mail-41104.protonmail.ch;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="k2qN/Jx4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1692002785; x=1692261985;
	bh=NUvcaCDg0HGc9dhZ00uXG0esOB9jrNJkMRhz0/WtxiA=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=k2qN/Jx4xLT8u3/WhAEHUGylS53aNDn/BAIJT49zave/Xo1ylAlaE5tBfBoNKLQl+
	 YH+buY4ZZlXuuDIhx0sALudnBY7gXbfUrmMY3lV2MHHgEe5VySOHUXxc43ypZ8xcmu
	 ToyTu+U7yqADqq04WplwdcK4tOZgO0rWf8+9/PVT2bWYF61cDSvI9aWCQpYN8QZ6+q
	 r+wO8ZEP/oSPJeCfDPBxhyFwGEOx3bAGXz0Jh4z+ZUv7v6U+8yEh89cogCqyiLJrnQ
	 c5q1+/3377N+I8cOUG4PgUHnuapwHF7cb/+Tm7Wgkf0w7omIskyoRL88uEsVHT8uCa
	 0AnqL3+AlCRyg==
To: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, Alice Ryhl <aliceryhl@google.com>, Andreas Hindborg <nmi@metaspace.dk>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: [PATCH v4 00/13] Quality of life improvements for pin-init
Message-ID: <20230814084602.25699-1-benno.lossin@proton.me>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

This patch series adds several improvements to the pin-init api:
- a derive macro for the `Zeroable` trait,
- makes hygiene of fields in initializers behave like normal struct
  initializers would behave,
- prevent stackoverflow without optimizations
- add `..Zeroable::zeroed()` syntax to zero missing fields,
- support arbitrary paths in initializer macros.

It is based on the `rust-dev` branch.

This is the fourth version of this patch series.
- v3: https://lore.kernel.org/rust-for-linux/20230729090838.225225-1-benno.=
lossin@proton.me/
- v2: https://lore.kernel.org/rust-for-linux/20230719141918.543938-1-benno.=
lossin@proton.me/
- v1: https://lore.kernel.org/rust-for-linux/20230624092330.157338-1-benno.=
lossin@proton.me/

Changes not present on modified commits:
v3 -> v4:
No changes.

v2 -> v3:
- make `#[pin_data]` work better with `#[cfg]` attributes on fields.

v1 -> v2:
- implement `Zeroable` for `Opaque`,
- remove blanket impl of `PinInit` for `Init` and make it a supertrait
  instead,
- add `{pin_}chain` functions to execute code after initialization,
- update the example macro expansion.

Benno Lossin (13):
  rust: init: consolidate init macros
  rust: init: make `#[pin_data]` compatible with conditional compilation
    of fields
  rust: add derive macro for `Zeroable`
  rust: init: make guards in the init macros hygienic
  rust: init: wrap type checking struct initializers in a closure
  rust: init: make initializer values inaccessible after initializing
  rust: init: add `..Zeroable::zeroed()` syntax for zeroing all missing
    fields
  rust: init: Add functions to create array initializers
  rust: init: add support for arbitrary paths in init macros
  rust: init: implement `Zeroable` for `UnsafeCell<T>` and `Opaque<T>`
  rust: init: make `PinInit<T, E>` a supertrait of `Init<T, E>`
  rust: init: add `{pin_}chain` functions to `{Pin}Init<T, E>`
  rust: init: update expanded macro explanation

 rust/kernel/init.rs            | 646 ++++++++++++++-------------------
 rust/kernel/init/__internal.rs |  39 +-
 rust/kernel/init/macros.rs     | 519 +++++++++++++++++++++++---
 rust/kernel/prelude.rs         |   2 +-
 rust/macros/lib.rs             |  20 +
 rust/macros/quote.rs           |  12 +
 rust/macros/zeroable.rs        |  72 ++++
 7 files changed, 857 insertions(+), 453 deletions(-)
 create mode 100644 rust/macros/zeroable.rs


base-commit: e73e793b32b7c440a53fd4da75a34c062841b66f
--=20
2.41.0


