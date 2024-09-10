Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94A188A28;
	Tue, 10 Sep 2024 10:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963967; cv=none; b=NyGIPtTNPUOUiVCirfvszS6fXyVAsRUtYeDNaBtx9TWK35dXBMM4P9WDgmpslcgCupvMnMxHvR3VHnjqhsfo3wyXVF/6XW25MrbhpiCJ9lTnwHwolXDg3+igJCZwvwiNmoAmO9Z+3lvjpSf07QFxrlB28t9BmF8krSnx2isn0TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963967; c=relaxed/simple;
	bh=UbqNHQkdDKO1MG5eW9yI9vk994l9kCpKsi2tJcip0SU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avwX/BpmAaYW/7UJCtG3eklO0kpzaT0XI/na/uRZusr7VykRivdy13B49r+wn6lOEireCP9vTgPrJ8dcVLLL5o5KZ6XoFZ3hPJM6Y0h2C3Off3mgrrKNyjM9ocGiIn946QwHXPL087JoFTrrcZX4lk9pxbEWb625gBjmAqqw8YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rwi6O0n2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rwi6O0n2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F99C4CEC3;
	Tue, 10 Sep 2024 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963967;
	bh=UbqNHQkdDKO1MG5eW9yI9vk994l9kCpKsi2tJcip0SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rwi6O0n2RruYVU4PUm0zCsNgEqtHRRCoKkcX7iWwi8YgmNjcSR/Us2Bs3z/Kb/Fsn
	 FjWKDLg+Us1tLp8f84Fiuzxl2hp8SmVu5F0SCy2gQZbMBcwWTC5DS3wUMQEQPyyibm
	 NB32iPn6Hz4k5DLWVF0D0Hoa2tcjE3fsvHy54S84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Trevor Gross <tmgross@umich.edu>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 022/269] rust: macros: provide correct provenance when constructing THIS_MODULE
Date: Tue, 10 Sep 2024 11:30:09 +0200
Message-ID: <20240910092609.052786857@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/macros/module.rs |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/macros/module.rs
+++ b/rust/macros/module.rs
@@ -203,7 +203,11 @@ pub(crate) fn module(ts: TokenStream) ->
             // freed until the module is unloaded.
             #[cfg(MODULE)]
             static THIS_MODULE: kernel::ThisModule = unsafe {{
-                kernel::ThisModule::from_ptr(&kernel::bindings::__this_module as *const _ as *mut _)
+                extern \"C\" {{
+                    static __this_module: kernel::types::Opaque<kernel::bindings::module>;
+                }}
+
+                kernel::ThisModule::from_ptr(__this_module.get())
             }};
             #[cfg(not(MODULE))]
             static THIS_MODULE: kernel::ThisModule = unsafe {{


