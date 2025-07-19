Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301891EF1D;
	Sat, 19 Jul 2025 18:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752950225; cv=none; b=p7O/znEYle9gH8NWfKprwVLVyWjneB3gSA8wFy0QYCtP0qg6n2rLNYKpNpdom0OVVKppmje5aMor4OmzE5d277ZPly/3yYBh9MTf5z2ZHkR7e7cZv88MWs+xAgInifNUR5h4rX6nAzCRADk2EzBMT8xOwuqWFMDW1A7k4BY/RGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752950225; c=relaxed/simple;
	bh=6S2MHYjCSvEbnYdKa6ZxyilifS2dWfn2HrXD97TZfPg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IYG2OyL84rqmhRvD93tSVAMMv0DPl6ExmiqfItmcGx2DgnCFTtBX4U3geV1e25E7mI9e/Gwp+JMlCeNIJO8n5weJ+JoFP485EYHc3g9LjtGiToM//WaogO4eGgBcXgdfjXGmc8I/8paaznjSJztypnyZKa8YwENtU5NsmB3E8/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3R/hiUJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3R/hiUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3BDC4CEE3;
	Sat, 19 Jul 2025 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752950224;
	bh=6S2MHYjCSvEbnYdKa6ZxyilifS2dWfn2HrXD97TZfPg=;
	h=From:To:Cc:Subject:Date:From;
	b=L3R/hiUJgBTPbjKMj30YmC985sG2vvBbkS1N8wHAPSYQvMwS1inkxSFh9ZyMte8BT
	 yH7GmP0LniMlrL0WxfrJ9C4IbK595eSyET+Ik7hlU8tIpThv0WK0Q2ztIHCVIgZkpW
	 h2CTQSfRTU7QX7r2/3TF3XGD3lYIQq7/5mpj5nppROCTMOrzOKLv5dfaLKovCoq2k4
	 By/mZoRDwO562OyXm+Ebrf7nRWVZZ5g73W7NcZ0ahRpCBlwolfaqZ8aX/ggrmASmNq
	 zq6u0BBLD+XfszANthrsItEUT8MDWHhK14H1fbcHTz2Ro+REZX1Zs3NilDWLot/yf8
	 B7uATd9LkROcQ==
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
Subject: [PATCH] rust: list: undo unintended replacement of method name
Date: Sat, 19 Jul 2025 20:36:49 +0200
Message-ID: <20250719183649.596051-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When we renamed `Opaque::raw_get` to `cast_into`, there was one
replacement that was not supposed to be there.

It does not cause an issue so far because it is inside a macro rule (the
`ListLinksSelfPtr` one) that is unused so far. However, it will start
to be used soon.

Thus fix it now.

Fixes: 64fb810bce03 ("rust: types: rename Opaque::raw_get to cast_into")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/list/impl_list_item_mod.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/list/impl_list_item_mod.rs b/rust/kernel/list/impl_list_item_mod.rs
index c1edba0a9501..3f6c30e14904 100644
--- a/rust/kernel/list/impl_list_item_mod.rs
+++ b/rust/kernel/list/impl_list_item_mod.rs
@@ -252,7 +252,7 @@ unsafe fn view_value(links_field: *mut $crate::list::ListLinks<$num>) -> *const
                 // the pointer stays in bounds of the allocation.
                 let self_ptr = unsafe { (links_field as *const u8).add(spoff) }
                     as *const ::core::cell::UnsafeCell<*const Self>;
-                let cell_inner = ::core::cell::UnsafeCell::cast_into(self_ptr);
+                let cell_inner = ::core::cell::UnsafeCell::raw_get(self_ptr);
                 // SAFETY: This is not a data race, because the only function that writes to this
                 // value is `prepare_to_insert`, but by the safety requirements the
                 // `prepare_to_insert` method may not be called in parallel with `view_value` or

base-commit: 23b128bba76776541dc09efaf3acf6242917e1f0
--
2.50.1
