Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D4A8F5A
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 09:31:58 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-52a0e160f76so1344542a12.1
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 02:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692696716; x=1693301516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u/W6jtJXaUE/gh/n+1FodWgnqTe/idj5hBc66GJX2bo=;
        b=Fd/2xyqlDK8ctp+IphjXZfkwLM3vpM3cfpY5hhlTJ6PcnNjQz2e0EFZLcmmWlL0155
         g7HjV35Qm7PeAa//XiJE6Mgd4FHd4HSSDmNgNIjtqJerMRqcjtYEYP3y67QaZfMAv0dl
         GdU0Vm7U7ahsDeeayRohyZE8DyzXdcHnfe1VTTgkbSeCzEsMlnQ/3BQSNuELCVdmyXOr
         vBhOCuLCAH8yQR+ucvwyHyTR/Mx4fH0k+S6bx3V6KRMODn1984frfmoj0y9FpTwzl7dA
         H8offrTWZ4xwq1KDOYCV9Yu4ulRUy+BbeaRsZdQtvvYpCllK92eB/IPtopx37Uq5FGD+
         nydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692696716; x=1693301516;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u/W6jtJXaUE/gh/n+1FodWgnqTe/idj5hBc66GJX2bo=;
        b=Gh2IHuRv+LS5/vV5g4T9r2ZC2XESoT7jxYDU5VIvBn4vYDbXcQ+FU7Dpd7nhaL3EFy
         cg6JOwWws9KlRz6VOJrbqHhGSEG4r083mdGYDYwGG9IhW9068ibBCUVnosteX4+jM8BH
         Kr96+mL8vHJppPNNg9Bd1FpHpP91EppU9JozVdnBUfi74+NS6mIlB8qv+/M6XERJGPMY
         aIVvRrCv9/OzrsTGt7mqOrfkOICdSRzpRA0OQimN0HZbDi6AbtzEO/jOQ9zpmmtanruu
         tg4afnRT5WA4kF38yqIMGWD1kpxgs1+BYL5BYMByapbGbGZ9Zy8ZOT60Q8QWYRF0E6Xj
         X1Zg==
X-Gm-Message-State: AOJu0YyHhcYekMBAiVr3abKQwn/2fE4oqagoiLY6ECmJUKsDAcL7czgx
	eVDUdANDGH+6Be35w9JxvVP3CIY0C3GyRlg=
X-Google-Smtp-Source: AGHT+IHU5+U+7RFLKURa2jqbhBEn2o6/mkJMJNhOerO0L9z5FZBO9RapI/AMbpvltVZlSY10g5zOZyZifzbKvKU=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:ab4f:0:b0:527:251d:f2ea with SMTP id
 t15-20020a50ab4f000000b00527251df2eamr54769edc.5.1692696716598; Tue, 22 Aug
 2023 02:31:56 -0700 (PDT)
Date: Tue, 22 Aug 2023 09:31:54 +0000
In-Reply-To: <87r0octho8.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <87r0octho8.fsf@metaspace.dk>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230822093154.3478754-1-aliceryhl@google.com>
Subject: Re: [PATCH v1] rust: add improved version of `ForeignOwnable::borrow_mut`
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="utf-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
>> diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
>> index 172f563976a9..f152a562c9c3 100644
>> --- a/rust/kernel/sync/arc.rs
>> +++ b/rust/kernel/sync/arc.rs
>> @@ -232,26 +232,35 @@ pub fn ptr_eq(this: &Self, other: &Self) -> bool {
>>  
>>  impl<T: 'static> ForeignOwnable for Arc<T> {
>>      type Borrowed<'a> = ArcBorrow<'a, T>;
>> +    // Mutable access to the `Arc` does not give any extra abilities over
>> +    // immutable access.
>> +    type BorrowedMut<'a> = ArcBorrow<'a, T>;
>>  
>>      fn into_foreign(self) -> *const core::ffi::c_void {
>>          ManuallyDrop::new(self).ptr.as_ptr() as _
>>      }
>>  
>> -    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
>> -        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
>> -        // a previous call to `Arc::into_foreign`.
>> -        let inner = NonNull::new(ptr as *mut ArcInner<T>).unwrap();
>> -
>> -        // SAFETY: The safety requirements of `from_foreign` ensure that the object remains alive
>> -        // for the lifetime of the returned value.
>> -        unsafe { ArcBorrow::new(inner) }
>> -    }
>> -
>>      unsafe fn from_foreign(ptr: *const core::ffi::c_void) -> Self {
>>          // SAFETY: By the safety requirement of this function, we know that `ptr` came from
>>          // a previous call to `Arc::into_foreign`, which guarantees that `ptr` is valid and
>>          // holds a reference count increment that is transferrable to us.
>> -        unsafe { Self::from_inner(NonNull::new(ptr as _).unwrap()) }
>> +        unsafe { Self::from_inner(NonNull::new_unchecked(ptr as _)) }
>>      }
>> +
>> +    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
>> +        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
>> +        // a previous call to `Arc::into_foreign`.
>> +        let inner = unsafe { NonNull::new_unchecked(ptr as *mut ArcInner<T>) };
>> +
>> +        // SAFETY: The safety requirements ensure that we will not give up our
>> +        // foreign-owned refcount while the `ArcBorrow` is still live.
>> +        unsafe { ArcBorrow::new(inner) }
>> +    }
>> +
>> +    unsafe fn borrow_mut<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
>> +        // SAFETY: The safety requirements for `borrow_mut` are a superset of the safety
>> +        // requirements for `borrow`.
>> +        unsafe { Self::borrow(ptr) }
>> +    }
>
> I am not sure this makes sense. How about splitting the trait in two,
> immutable and mutable and only implementing the immutable one or Arc?

I used this design based on what would make sense for a linked list. The
idea is that we can have two different types of cursors for a linked
list: immutable and mutable. The immutable cursor lets you:

 * move around the linked list
 * access the values using `borrow`

The mutable cursor lets you:

 * move around the linked list
 * delete or add items to the list
 * access the values using `borrow_mut`

The mutable cursor gives you extra abilities beyond the `borrow` vs
`borrow_mut` distinction, so we want to provide both types of cursors
even if the pointer type is Arc. To do that, we need a trait that
defines what it means to have mutable access to an Arc.

Alice

