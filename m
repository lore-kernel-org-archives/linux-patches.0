Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912081C82F4;
	Wed, 19 Mar 2025 14:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395112; cv=none; b=dhOmJt8BT6CYbt/3ejJol8Prfsh/EcRPK0t5C6gYL4YNOE4R0hHOvD2Zur4P/FMFvkpG5ZX6fDyTP3v86Took67rVm95qSXlJe/B4QJunXOlCNws7bmF0AVKs4Iasgfqq2Y2jl2j1xUeXE1VpXo0SFOTxX3jfGofhdy0lF6xZFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395112; c=relaxed/simple;
	bh=bzHeLv5ICcFb8XHsHKj5gZt4T0dSsWjAzynivjksI88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkeM8jI8JSSXK6Bh/4uoCZNTmW5BQug7b/EW/lpxPqGhsxKr3nyDzqfSUdtyxCwbgmtj5tnj803fqDqjRAFgJ4yNtxEACcY4FT6zcx3C5M3WWrvP1zdh7ckkTO8KT/TctNRbfdDREKtd+oEwv/Z2KnohjjS9/tda0ALWQLG0SvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nSPTGCab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nSPTGCab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CC7C4CEE4;
	Wed, 19 Mar 2025 14:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395112;
	bh=bzHeLv5ICcFb8XHsHKj5gZt4T0dSsWjAzynivjksI88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nSPTGCabG22ajwwg+QJkFFHv8slOMB9dpO9cLpL1HQ+EYc7q+5PKgQZrgCh1Eg+5I
	 F5Vm8JvNwB416S3M6ZMgzucLWZA9do19nWLE4iAWMIXhQWg7JfNRZ5sphCRg/nHNKb
	 +bs6sGybmqewn+xMSQfFDsKFhZuUMbIo7YgygnV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 166/231] rust: init: fix `Zeroable` implementation for `Option<NonNull<T>>` and `Option<KBox<T>>`
Date: Wed, 19 Mar 2025 07:30:59 -0700
Message-ID: <20250319143030.943418419@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benno Lossin <benno.lossin@proton.me>

commit df27cef153603b18a7d094b53cc3d5264ff32797 upstream.

According to [1], `NonNull<T>` and `#[repr(transparent)]` wrapper types
such as our custom `KBox<T>` have the null pointer optimization only if
`T: Sized`. Thus remove the `Zeroable` implementation for the unsized
case.

Link: https://doc.rust-lang.org/stable/std/option/index.html#representation [1]
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://lore.kernel.org/rust-for-linux/CAH5fLghL+qzrD8KiCF1V3vf2YcC6aWySzkmaE2Zzrnh1gKj-hw@mail.gmail.com/
Cc: stable@vger.kernel.org # v6.12+ (a custom patch will be needed for 6.6.y)
Fixes: 38cde0bd7b67 ("rust: init: add `Zeroable` trait and `init::zeroed` function")
Signed-off-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20250305132836.2145476-1-benno.lossin@proton.me
[ Added Closes tag and moved up the Reported-by one. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init.rs |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -1400,17 +1400,14 @@ impl_zeroable! {
     // SAFETY: `T: Zeroable` and `UnsafeCell` is `repr(transparent)`.
     {<T: ?Sized + Zeroable>} UnsafeCell<T>,
 
-    // SAFETY: All zeros is equivalent to `None` (option layout optimization guarantee).
+    // SAFETY: All zeros is equivalent to `None` (option layout optimization guarantee:
+    // https://doc.rust-lang.org/stable/std/option/index.html#representation).
     Option<NonZeroU8>, Option<NonZeroU16>, Option<NonZeroU32>, Option<NonZeroU64>,
     Option<NonZeroU128>, Option<NonZeroUsize>,
     Option<NonZeroI8>, Option<NonZeroI16>, Option<NonZeroI32>, Option<NonZeroI64>,
     Option<NonZeroI128>, Option<NonZeroIsize>,
-
-    // SAFETY: All zeros is equivalent to `None` (option layout optimization guarantee).
-    //
-    // In this case we are allowed to use `T: ?Sized`, since all zeros is the `None` variant.
-    {<T: ?Sized>} Option<NonNull<T>>,
-    {<T: ?Sized>} Option<KBox<T>>,
+    {<T>} Option<NonNull<T>>,
+    {<T>} Option<KBox<T>>,
 
     // SAFETY: `null` pointer is valid.
     //


