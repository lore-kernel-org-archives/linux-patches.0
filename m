Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E791B11CA4
	for <patches@lists.linux.dev>; Fri, 14 Jul 2023 10:28:03 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-cac213f9264so1490602276.3
        for <patches@lists.linux.dev>; Fri, 14 Jul 2023 03:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689330483; x=1691922483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=KwV3kc3uzzq7RspJm+cMTqP6WI/iboonsRW9iz1lFPg=;
        b=ock6SYJOEyKZbBOXOC5zHDRe95nmTWdhr80kYHNWZsr9+4xkjgkWLavfD1ZCzGSojh
         ByglL6H89jZ1yg6kuTpwQCTjzg6KgNd7dmAlIQqeg8DPezK0LlTL0h0AiODIflM9lkA9
         MiJhiCirB4eZM74fOckiTc0SkPUxQNPJNPhp1EuV9HNIqdzhD4RUGtrz2v+qjmSt0Zz1
         NUnKf4w4Af4KBATnHu4DBv+i88LUDE81rj4pSnldkGb2vFJyb332PKaHRcXAN1+yN7v2
         UNd/lZVxSObqs3/oiDcEyxF1OPHRVlRcE85GcU11KfYWPSzKhtoouTcrFmfLq4z0gB6s
         UxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689330483; x=1691922483;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwV3kc3uzzq7RspJm+cMTqP6WI/iboonsRW9iz1lFPg=;
        b=WWBYr1w4vIf6Lq1wy6PHHJq7xZCXSBtnLBXZd0o2r/oWA06Mk3JciUAzJmJJbY0M/W
         yBhFqL0KAdoORcQjuPL5Tb6zti3sFYhKpOthumHUXlt+/DQZ3nJO3q+E/rfClRTuO+4a
         vcibEw7PC6YyazerlZ4WQ2BAWsiNG/N6A2SaTndV5L5omi318msYerhj0E9TdLp0iWqD
         oH+43dOoj1Hi3QPCPYJasLWjYdZ9z+QhV3porOqgP8sH1iG0SDzjGM5FI2CRoNiviJe1
         1A5qAKnma95OrhkBTeZh6tdzlK58vHvc9SdG/NtfHQ027QUkFZ4DbrbYhCfpE9mNivmd
         XDMA==
X-Gm-Message-State: ABy/qLbU9De9hXIwytAtWoZHQ9lzLxRn5Kp3FSZ/V8ICDp7YdDqey0Gq
	CAz46uPjmKBaG7L5eZoEXHyUO0UbtSP3+f4=
X-Google-Smtp-Source: APBJJlE0+jjHBRKgSzS1qjpf41U9NfxUPZOhJjB8LMC2qYcOhSSegwjuGwuc6lh5JVX+4Mj8BQIiTzSVNga2q+8=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:ab70:0:b0:c60:63e7:efb4 with SMTP id
 u103-20020a25ab70000000b00c6063e7efb4mr22279ybi.9.1689330482859; Fri, 14 Jul
 2023 03:28:02 -0700 (PDT)
Date: Fri, 14 Jul 2023 10:28:00 +0000
In-Reply-To: <ZK2UeFE1A4iRfePS@boqun-archlinux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZK2UeFE1A4iRfePS@boqun-archlinux>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230714102800.2196236-1-aliceryhl@google.com>
Subject: Re: [PATCH v1] rust: add improved version of `ForeignOwnable::borrow_mut`
From: Alice Ryhl <aliceryhl@google.com>
To: boqun.feng@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, gary@garyguo.net, linux-kernel@vger.kernel.org, 
	ojeda@kernel.org, patches@lists.linux.dev, rust-for-linux@vger.kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Boqun Feng <boqun.feng@gmail.com> writes:
> On Mon, Jul 10, 2023 at 07:46:42AM +0000, Alice Ryhl wrote:
>> Previously, the `ForeignOwnable` trait had a method called `borrow_mut`
>> that was intended to provide mutable access to the inner value. However,
>> the method accidentally made it possible to change the address of the
>> object being modified, which usually isn't what we want. (And when we
>> want that, it can be done by calling `from_foreign` and `into_foreign`,
>> like how the old `borrow_mut` was implemented.)
>> 
>> In this patch, we introduce an alternate definition of `borrow_mut` that
>> solves the previous problem. Conceptually, given a pointer type `P` that
>> implements `ForeignOwnable`, the `borrow_mut` method gives you the same
>> kind of access as an `&mut P` would, except that it does not let you
>> change the pointer `P` itself.
>> 
>> This is analogous to how the existing `borrow` method provides the same
>> kind of access to the inner value as an `&P`.
>> 
>> Note that for types like `Arc`, having an `&mut Arc<T>` only gives you
>> immutable access to the inner `T`. This is because mutable references
>> assume exclusive access, but there might be other handles to the same
>> reference counted value, so the access isn't exclusive. The `Arc` type
>> implements this by making `borrow_mut` return the same type as `borrow`.
>> 
>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>> ---
>> 
>> This patch depends on https://lore.kernel.org/all/20230706094615.3080784-1-aliceryhl@google.com/
>> 
>>  rust/kernel/sync/arc.rs | 31 +++++++++-----
>>  rust/kernel/types.rs    | 93 ++++++++++++++++++++++++++++++-----------
>>  2 files changed, 89 insertions(+), 35 deletions(-)
>>  
>> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
>> index d479f8da8f38..1c2fb36906b6 100644
>> --- a/rust/kernel/types.rs
>> +++ b/rust/kernel/types.rs
>> @@ -20,66 +20,111 @@
>>  /// This trait is meant to be used in cases when Rust objects are stored in C objects and
>>  /// eventually "freed" back to Rust.
>>  pub trait ForeignOwnable: Sized {
>> -    /// Type of values borrowed between calls to [`ForeignOwnable::into_foreign`] and
>> -    /// [`ForeignOwnable::from_foreign`].
>> +    /// Type used to immutably borrow a value that is currently foreign-owned.
>>      type Borrowed<'a>;
>>  
>> +    /// Type used to mutably borrow a value that is currently foreign-owned.
>> +    type BorrowedMut<'a>;
>> +
> 
> I would probably want to say "if the `impl ForeignOwnable` doesn't have
> the exclusive ownership, `BorrowedMut` should be the same as `Borrowed`"
> for logical self-consistent,

I don't phrase it as a requirement, but I do already say something along
these lines.

> and even further make it as default as follow:
> 
> 	type BorrowedMut<'a> = Self::Borrowed<'a>;
> 
> 	unsafe fn borrow_mut<'a>(ptr: *const core::ffi::c_void) -> Self::BorrowedMut<'a> {
> 	    Self::borrow(ptr)
> 	}
> 
> but it might be over-engineering (and require associated_type_defaults
> and more)...

I don't think it makes sense to use defaults here. There are very few
implementers of this trait, and I'd like all of them to explicitly think
about whether `BorrowedMut` should be the same as `Borrowed`, or
different.

> Anyway,
> 
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> 
> Regards,
> Boqun

Alice

