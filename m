Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE67E20AF9B;
	Wed, 19 Mar 2025 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395255; cv=none; b=r1Kkw0B5EUsl38FMoql43bN1ka/40WAD6Sv9350s9p88267lggno8BKwet2tH7QwLPs4GAMUxIOa5WPegw0o7sFOQwjHTgbA7IdSm4/DpI3XvMbdUCMxgpwS3He/bD2okBoViPd+gXjHZhYzfzRAe4A5HFuFJDfgT1Eh4aqgaEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395255; c=relaxed/simple;
	bh=tIT5Aa27jZpFFU4dbsX44TyU/x+e2snjMHBYPEjltg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFGKn6vEPTh3vZ5IWBh8NPx3po07H+wJqA6/aTBilKDPaK9Nf5G/xCb8CcWeBDHbtMCsg2LR0lne4b2rb1YmM68IdbXjsYuMx2eV04NpJH1FzncnEC6iM85ltve1zbhiXj+/A67c3zViBJR1psPOXjczZOA35XD2CxtZ5ScfEz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9EBOfGC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9EBOfGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F30C4CEE4;
	Wed, 19 Mar 2025 14:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395254;
	bh=tIT5Aa27jZpFFU4dbsX44TyU/x+e2snjMHBYPEjltg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9EBOfGC5ExliZOasZbRY5KjRmMvuR8L/Z0ckJAy1CGgXLKfUD7lVtf9AIb5kxBFQ
	 TbsrqD/dh4O2mO+afq++qZMrivr0W2AVC529hpbW9U2Wm16xEPMMPHGvo0zX4SwXXD
	 k85wgYr3jhQpsN1ChieFNFHyYEEBu3PSL2kFcAgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 136/166] rust: init: fix `Zeroable` implementation for `Option<NonNull<T>>` and `Option<KBox<T>>`
Date: Wed, 19 Mar 2025 07:31:47 -0700
Message-ID: <20250319143023.701855660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1310,17 +1310,14 @@ impl_zeroable! {
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
-    {<T: ?Sized>} Option<Box<T>>,
+    {<T>} Option<NonNull<T>>,
+    {<T>} Option<Box<T>>,
 
     // SAFETY: `null` pointer is valid.
     //


