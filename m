Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935EC16B3B7;
	Sun,  9 Mar 2025 21:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741556950; cv=none; b=jBThs6jM6Z9XdgBnX+WsR5hqKulQleIxN6i7DXOK/V54fij4YsT5wB6K6xXKFPVXgE1HQCWtAMAHLEDHtqX2XvuEETQ+JzoENYdHVbMJZrfxLCNnTNkmM0m2wmrKsEU0H1oJdrOFROuIoW+wNkvC3G7eJTXTKHjH6C+21P8VpK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741556950; c=relaxed/simple;
	bh=E1l/O9YZeI+myHOBN9lIwYaG7N6QrE+xuS3xGAhnwmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYHuYrjGccLpvw+Zo8pfX6x5sOKqrBKR/DSYAOS6lUwKKX6PYTo6bsD3XGNWVThEqPuh3o8eluOw+sbEGs5m5HKiLUR4uwj0FPnhyeGivbpaFlw/uhMkxGlqMFknO3u2wk1VWSauMyqRdnsssWN8VkG0dit4StgMMmzVTDidN0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMXNBvO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMXNBvO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DA9C4CEE3;
	Sun,  9 Mar 2025 21:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741556950;
	bh=E1l/O9YZeI+myHOBN9lIwYaG7N6QrE+xuS3xGAhnwmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMXNBvO6eQo4v+yaUwdbcjFiJEWSJDeE6HvpYnIj3cpQV80nQjRYrOhRvff7p3q0U
	 uQ9dp/4jPKDFufj/k60sBXc0VHa68TZBCZGQi2KtYrjylDuzEy2MmOL/oUwhRlEh6Z
	 WL5qKMp46NZwWrNL7LF1V2HcuQm/SUdBy+dmZzlR6XglMF2/etknYFd7sYg7REyJet
	 k7tGC6Usnsyd+oKDCan1gAo2m25xFp1KNjS4jZdiO1zV0+Q1RFfIcN9dBLiGiCMxbG
	 bEU8uLMrKEJ/e242bYcDzmy3Y+3ADwUYOGv1UexexS71A3OLY0NpArxy4qTuThkqp7
	 EFqJga69iSyAg==
From: Miguel Ojeda <ojeda@kernel.org>
To: aliceryhl@google.com
Cc: a.hindborg@kernel.org,
	alex.gaynor@gmail.com,
	benno.lossin@proton.me,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	lina@asahilina.net,
	linux-kernel@vger.kernel.org,
	miguel.ojeda.sandonis@gmail.com,
	ojeda@kernel.org,
	oliver.mangold@pm.me,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu,
	patches@lists.linux.dev
Subject: [PATCH] rust: kbuild: provide `RUSTC_HAS_DO_NOT_RECOMMEND` symbol
Date: Sun,  9 Mar 2025 22:48:57 +0100
Message-ID: <20250309214857.1559606-1-ojeda@kernel.org>
In-Reply-To: <Z8sXqXgfhHbNpG6B@google.com>
References: <Z8sXqXgfhHbNpG6B@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust 1.85.0 (current stable version) stabilized [1]
`#[diagnostic::do_not_recommend]` [2].

In order to use it across all supported Rust versions, introduce a new
Kconfig symbol for it.

This allows to perform conditional compilation based on it, e.g. on the
use site to enable the attribute:

    #[cfg_attr(RUSTC_HAS_DO_NOT_RECOMMEND, diagnostic::do_not_recommend)]
    impl A for i32 {}

An alternative would have been to `allow` the following warning:

    #![allow(unknown_or_malformed_diagnostic_attributes)]

However, that would lose the checking for typos across all versions,
which we do not want to lose.

One can also use the Kconfig symbol to allow the warning in older
compilers instead, to avoid repeating the `cfg_attr` line above in all
use sites:

    #![cfg_attr(
        not(RUSTC_HAS_DO_NOT_RECOMMEND),
        expect(unknown_or_malformed_diagnostic_attributes)
    )]

That still loses the checking for typos in older versions, but we still
keep it in newer ones, thus we should still catch mistakes eventually.

In this case we can promote it to `expect` as shown above, so that we do
not forget to remove these lines if we stop using the attribute somewhere.

Link: https://github.com/rust-lang/rust/pull/132056 [1]
Link: https://doc.rust-lang.org/reference/attributes/diagnostics.html#the-diagnosticdo_not_recommend-attribute [2]
Link: https://lore.kernel.org/rust-for-linux/CANiq72mYfhuRWkjomb1vOMMPOaxvdS6qjfVLAwxUw6ecdqyh2A@mail.gmail.com/
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 init/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index d0d021b3fa3b..213b4cc9310a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -132,6 +132,9 @@ config CC_HAS_COUNTED_BY
 config RUSTC_HAS_COERCE_POINTEE
 	def_bool RUSTC_VERSION >= 108400

+config RUSTC_HAS_DO_NOT_RECOMMEND
+	def_bool RUSTC_VERSION >= 108500
+
 config PAHOLE_VERSION
 	int
 	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))

base-commit: 7eb172143d5508b4da468ed59ee857c6e5e01da6
--
2.48.1
