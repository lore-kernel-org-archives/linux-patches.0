Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EEB156871;
	Wed,  4 Sep 2024 20:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482719; cv=none; b=NjGNOCwF/1AfgGavjLPB4Uqqn8kF0/t2wcGOYx5Eyw3DzA093mnBYH0v7kkA+NYdrsZPMYrO5D8ok7ioKMWWn2L4LowognuqGIZUSp6h0UQPfze5qs6ldgu4mgEdlmuMm2pn5M4zus77K0Z5EN0OHlQuJH7KG/8Rm+lxZKeRO5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482719; c=relaxed/simple;
	bh=vJQvhymk7IQJA94TrCwgY0z7LvJcOwadrzPK6L20pWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPnoH1nn43MIICzFDfn0dQcJakk3FCaL2hVDVyQlrXdAJzC+7IngOKI7lYUaIO6KxbyZ9eWEQO1AmaH6/8Ka8uL4yPb5Dk8x7Xlxf3YEQDcRSfZ4bpGugoBnOYGr1oYiRoesBMpcFhBldQj0oLP+jQ67cr4Bpg0C9lIfzvu+Zj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r4gsCmiA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r4gsCmiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72845C4CEC5;
	Wed,  4 Sep 2024 20:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482718;
	bh=vJQvhymk7IQJA94TrCwgY0z7LvJcOwadrzPK6L20pWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4gsCmiA8R/FnmPj8VVbJjBYfoAo9rBJ9G0VqScpwzFkZJfj+fh7QsaQYjQtsb3DC
	 nwflgYO5lrAdez2Ehh5klsua6l6GD600MW+67TCoZj7y94OehMLI4XWuiXMM+1JAJo
	 uTOPCN/Zq8/jPPRdMleUG0oonwVptTKqjbjD7p1wNpoUoURCtZPC3p+rmY/nu54siy
	 Bmh2CPbHoPXkAxXABZ6KLMJ5UHNmRRtEgcdyU5u093kzQojDZnYx6PAjhcKJ58LrvZ
	 n8TrwBIFR9bQgobmFE7uSQT6rw1pN4wO9xbvoqPE6AfaraYuAP7AYKmIlaHsqRMT75
	 k/fPeRMfsOs6w==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 10/19] rust: sync: remove unneeded `#[allow(clippy::non_send_fields_in_send_ty)]`
Date: Wed,  4 Sep 2024 22:43:38 +0200
Message-ID: <20240904204347.168520-11-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rust 1.58.0 (before Rust was merged into the kernel) made Clippy's
`non_send_fields_in_send_ty` lint part of the `suspicious` lint group for
a brief window of time [1] until the minor version 1.58.1 got released
a week after, where the lint was moved back to `nursery`.

By that time, we had already upgraded to that Rust version, and thus we
had `allow`ed the lint here for `CondVar`.

Nowadays, Clippy's `non_send_fields_in_send_ty` would still trigger here
if it were enabled.

Moreover, if enabled, `Lock<T, B>` and `Task` would also require an
`allow`. Therefore, it does not seem like someone is actually enabling it
(in, e.g., a custom flags build).

Finally, the lint does not appear to have had major improvements since
then [2].

Thus remove the `allow` since it is unneeded.

Link: https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1581-2022-01-20 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/8045 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/sync/condvar.rs | 1 -
 1 file changed, 1 deletion(-)

diff --git a/rust/kernel/sync/condvar.rs b/rust/kernel/sync/condvar.rs
index 7e00048bf4b1..dec2e5ffc919 100644
--- a/rust/kernel/sync/condvar.rs
+++ b/rust/kernel/sync/condvar.rs
@@ -92,7 +92,6 @@ pub struct CondVar {
     _pin: PhantomPinned,
 }
 
-#[allow(clippy::non_send_fields_in_send_ty)]
 // SAFETY: `CondVar` only uses a `struct wait_queue_head`, which is safe to use on any thread.
 unsafe impl Send for CondVar {}
 
-- 
2.46.0

