Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EB918BC36;
	Fri,  7 Mar 2025 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387863; cv=none; b=ZiM8xZMXRoCXXP9bH1G9Yr7MStN+sCMyUvm4yaNhBjtEo4ag1zDILcGs/7PsSTDe+Mw5Nk48my6p0u/Cj5oBetv7H490S4pKNfTs04400LDI52sSSP0eShT9NwVzkqSHrvqrNLhQxLWrR2CjAfoJeX3i6XPFEAd/hLZmaMMDAIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387863; c=relaxed/simple;
	bh=lyP1NlcI3JnZ/+TAzxj+AMM4+kGx7wp1W+JPrS3TTyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INvfKsNWME6IyFbZYx7SYQNPoWG2AvQaRCA7GccCwhd6jwXkZop36UPyiym7nMo+8SO3UKpu41Wd52I+ANSOSAbdR0wUL5I4OiglgXPEAWB4R0wWcaG6JSjhxKisWZbVoTY2CidNjTlr4bZP6sZtuzBeP/66lNXtqNVctUyWJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jbAVB20T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jbAVB20T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47683C4CEE3;
	Fri,  7 Mar 2025 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387863;
	bh=lyP1NlcI3JnZ/+TAzxj+AMM4+kGx7wp1W+JPrS3TTyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbAVB20TQX5C667U61Sku8UZFvx0uc2PbuxAVX0v89mcWVVsm+tlqJsnHit5aufMu
	 B/aVwcztTeBtBjNoYhdya5TBu2qgy2w3W7G5bkjGExunZ63SPwV4DPmTNVzBpFWiIJ
	 Ri/KOUeB24qvC9sXzkhNrKrUwnSV+vA1qzDqqDMmw/JuRv8BSZNIMG85rMo0giqG5+
	 kuGzycqkKTrSQ3uoidlokjsqbGq29z+jDNO/bm9weKDOzzjL5jlzmwSQ0trVu4c9u2
	 sDq7QvWeRzUF6aTE5SZm1dGx1i6I6qxs9mw/uEsh8oPJhYmR3WIVJGeXagh681iceT
	 fmmvEp0eLP8nA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 10/60] rust: sync: remove unneeded `#[allow(clippy::non_send_fields_in_send_ty)]`
Date: Fri,  7 Mar 2025 23:49:17 +0100
Message-ID: <20250307225008.779961-11-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 5e7c9b84ad08cc7a41b2ddbbbaccb60057da3860 upstream.

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
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-11-ojeda@kernel.org
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
2.48.1

