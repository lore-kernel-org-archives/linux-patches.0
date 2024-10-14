Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749481AB536;
	Mon, 14 Oct 2024 15:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920011; cv=none; b=biP+vOelB4qRF7nnCZOCzOFO1NjW0La8m767VpZGAv8KFdP7a6JWGoQS91IOn3BugNa1la/u0+JIppTaeoCYBeOuWGtE91+X5WSjtg8MEQrxxKIaPKUmXXg+oniAAST2hvvpSIYNOE/qYHdNguQo1X67JTxaSyfoKztb26dwncM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920011; c=relaxed/simple;
	bh=eoOrIC03XxZ+KnSr4p/8d3a5P8t/bFL+KZ6AgV+BHeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6lfWoseIdL1FRDClSKuCuHutzXXcdWSueHrei5JSmkvNZU7wp0dBVU8J8vuf8iNF3um2PD4C66IbYBk2X6WudnsRfgOvy0WLFJBmOXofbe5CfIGgZ8pRfnPQ9nL/RpYbN2yPTczhbmpZ59QVG/dEK50B793oWGTZMS9xZFLU3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L/AiHqs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L/AiHqs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0226C4CEC3;
	Mon, 14 Oct 2024 15:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728920011;
	bh=eoOrIC03XxZ+KnSr4p/8d3a5P8t/bFL+KZ6AgV+BHeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/AiHqs4/26ba4DENikfuyTa9jAQelm9saXgQ4lnyLyvVZV4ZsiWL1BEFXolW+adj
	 6cUE0gV6joZP6T8i91hsoSHeG02cxoD5lLojlviafB+FMpIYVJ7Dlnqmj8H9G2tiP5
	 wm3hq3GxvzSrxgLQgJQWFrpdUZYGUDwhn9wDIYuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 765/798] rust: macros: provide correct provenance when constructing THIS_MODULE
Date: Mon, 14 Oct 2024 16:21:59 +0200
Message-ID: <20241014141248.121641181@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boqun Feng <boqun.feng@gmail.com>

commit a5a3c952e82c1ada12bf8c55b73af26f1a454bd2 upstream.

Currently while defining `THIS_MODULE` symbol in `module!()`, the
pointer used to construct `ThisModule` is derived from an immutable
reference of `__this_module`, which means the pointer doesn't have
the provenance for writing, and that means any write to that pointer
is UB regardless of data races or not. However, the usage of
`THIS_MODULE` includes passing this pointer to functions that may write
to it (probably in unsafe code), and this will create soundness issues.

One way to fix this is using `addr_of_mut!()` but that requires the
unstable feature "const_mut_refs". So instead of `addr_of_mut()!`,
an extern static `Opaque` is used here: since `Opaque<T>` is transparent
to `T`, an extern static `Opaque` will just wrap the C symbol (defined
in a C compile unit) in an `Opaque`, which provides a pointer with
writable provenance via `Opaque::get()`. This fix the potential UBs
because of pointer provenance unmatched.

Reported-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/x/topic/x/near/465412664
Fixes: 1fbde52bde73 ("rust: add `macros` crate")
Cc: stable@vger.kernel.org # 6.6.x: be2ca1e03965: ("rust: types: Make Opaque::get const")
Link: https://lore.kernel.org/r/20240828180129.4046355-1-boqun.feng@gmail.com
[ Fixed two typos, reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
[ Boqun: Use `UnsafeCell` since `Opaque` is not in v6.1, as suggested by
  Gary Guo, `UnsafeCell` also suffices for this particular case because
  `__this_module` is only used to create `THIS_MODULE`, no other Rust
  code will touch it. ]
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/macros/module.rs | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/rust/macros/module.rs b/rust/macros/module.rs
index 031028b3dc41b..94a92ab82b6b3 100644
--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -183,7 +183,11 @@ pub(crate) fn module(ts: TokenStream) -> TokenStream {
             // freed until the module is unloaded.
             #[cfg(MODULE)]
             static THIS_MODULE: kernel::ThisModule = unsafe {{
-                kernel::ThisModule::from_ptr(&kernel::bindings::__this_module as *const _ as *mut _)
+                extern \"C\" {{
+                    static __this_module: core::cell::UnsafeCell<kernel::bindings::module>;
+                }}
+
+                kernel::ThisModule::from_ptr(__this_module.get())
             }};
             #[cfg(not(MODULE))]
             static THIS_MODULE: kernel::ThisModule = unsafe {{
-- 
2.43.0



