Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE8BDDD1
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 12:03:36 +0000 (UTC)
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-987e47d2e81so327761866b.1
        for <patches@lists.linux.dev>; Mon, 03 Jul 2023 05:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688385814; x=1690977814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=t1v+YrLrrXSIOQf8bz1T6Uql4EJXsDtCQkkzaYmbuCA=;
        b=FUejcNSnRZ7m/03Jf1mqtKvjb50HqpeYWuZTR07jnKvM6WjmwvJfPuBbYfByz6wAqX
         2ccuZ/1FRGaF2Cqe5S4rn8dBIQh/9wUESH6ZPhOsoxYiobdeuxyAswhTl0331O0WHXUH
         /8YlTwweOWcndDF6e4sUrCgyna4ehXzpkfg7w+RV6iktnbIW1CmD8UwTn22y428Uw287
         rFRlphtxNPfTzfrQyK72Yv29IjoIXQPe5jJ3HiYDcSImvPqK70OXO5IWdkenE3jOenfV
         adyILTeopp83fyYSYyaFsLPluDWCPTUFyF28ZjIALZPKsOxdvOW0D8TSsKV3wsUnS8IX
         CBTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688385814; x=1690977814;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t1v+YrLrrXSIOQf8bz1T6Uql4EJXsDtCQkkzaYmbuCA=;
        b=Y9Dp1wxCjm/THqZBO+TImXb72d7jYlTh4T0bgbOyXFj2y1QaySW0jhIWO6vWF7mgsW
         st8N/7WEoNZ+PbWlzBknSSNtIcLAtAfKbgrWovowQK2o3GbyhdNg3rcqxJjy67yPaWj6
         iIF1PEeQLWxyTtD9RdrENYsEDrj7dLHOIiOShgu2LSkH5EFvLH5ljtW0U4x/uKK5wAwJ
         kkfug81QmCU6qszxOv6qYU8/VhAv96BdA+/QdomJHbTobmy1rKBbgypBelEc9yRK/tOH
         3BwqQeJxUfrPuUvxejdwuYBPXGn/Fvq3XyrEFlwkEPa1m3DkFZ0eJawpnuWUka9e31wJ
         7yjA==
X-Gm-Message-State: ABy/qLa0LuL3k+kkUy8G3tX/GozEqIFDdHWfppYQFRjp4uvr9oGP9jbl
	s+EhlGDALZ5PV5A0wlwSGV25Ddzrn7F9NSY=
X-Google-Smtp-Source: APBJJlH7LEH6KcScCZGItqnGPStgrwoa6mSsEXPWW5ygRZ3eSyaSxhfyPQVmVtx9Yc8HFCT8L9/B1f9r2ajUT+I=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:62a2:b0:990:88bf:c9e5 with SMTP
 id nd34-20020a17090762a200b0099088bfc9e5mr28112ejc.15.1688385814137; Mon, 03
 Jul 2023 05:03:34 -0700 (PDT)
Date: Mon,  3 Jul 2023 12:03:31 +0000
In-Reply-To: <20230624092330.157338-6-benno.lossin@proton.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230624092330.157338-6-benno.lossin@proton.me>
X-Mailer: git-send-email 2.41.0.255.g8b1d071c50-goog
Message-ID: <20230703120331.2384427-1-aliceryhl@google.com>
Subject: [PATCH 6/7] rust: init: Add functions to create array initializers
From: Alice Ryhl <aliceryhl@google.com>
To: benno.lossin@proton.me
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, bjorn3_gh@protonmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, lina@asahilina.net, 
	linux-kernel@vger.kernel.org, nmi@metaspace.dk, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Benno Lossin <benno.lossin@proton.me> writes:
> Add two functions `pin_init_array_from_fn` and `init_array_from_fn` that
> take a function that generates initializers for `T` from usize, the added
> functions then return an initializer for `[T; N]` where every element is
> initialized by an element returned from the generator function.
> 
> Suggested-by: Asahi Lina <lina@asahilina.net>
> Signed-off-by: Benno Lossin <benno.lossin@proton.me>
> ---
> +/// Initializes an array by initializing each element via the provided initializer.
> +///
> +/// # Examples
> +///
> +/// ```rust
> +/// let array: Box<[usize; 1000_000_000]>= Box::init(init_array_from_fn(|i| i)).unwrap();
> +/// println!("{array:?}");
> +/// ```
> +pub fn init_array_from_fn<I, const N: usize, T, E>(
> +    mut make_init: impl FnMut(usize) -> I,
> +) -> impl Init<[T; N], E>
> +where
> +    I: Init<T, E>,
> +{
> +    let init = move |slot: *mut [T; N]| {
> +        let slot = slot.cast::<T>();
> +        for i in 0..N {
> +            let init = make_init(i);
> +            // SAFETY: since 0 <= `i` < N, it is still in bounds of `[T; N]`.
> +            let ptr = unsafe { slot.add(i) };
> +            // SAFETY: The pointer is derived from `slot` and thus satisfies the `__init`
> +            // requirements.
> +            match unsafe { init.__init(ptr) } {
> +                Ok(()) => {}
> +                Err(e) => {
> +                    // We now free every element that has been initialized before:
> +                    for j in 0..i {
> +                        let ptr = unsafe { slot.add(j) };
> +                        // SAFETY: The value was initialized in a previous iteration of the loop
> +                        // and since we return `Err` below, the caller will consider the memory at
> +                        // `slot` as uninitialized.
> +                        unsafe { ptr::drop_in_place(ptr) };
> +                    }

The loop can be simplified like this:

ptr::drop_in_place(ptr::slice_from_raw_parts(slot, i));

Yes, this actually works and will run the destructor of each value.

Alice

