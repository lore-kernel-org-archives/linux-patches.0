Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B01315485
	for <patches@lists.linux.dev>; Wed, 31 May 2023 14:07:53 +0000 (UTC)
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-50bf847b267so5131386a12.3
        for <patches@lists.linux.dev>; Wed, 31 May 2023 07:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685542071; x=1688134071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=C+3Et5cju5cYIbnO1iHgVsG4nORzzNf7kwjzGpF1D98=;
        b=fSR/a0RIq2Cy5mzkIieekB3gKX1I5GrCdYGfRHVjcL4N9W/KM5z1Sp1MnfrCjE2oKe
         N8FYnt1/jahwGDrdC+4F5EYePBRPewx4QoM0eLfI49srEYomVFEN8jnsu6wO5KuweTt8
         ri3KhOk+zDaY8WvQu9kgGdtxkqUfIUJkbg2caGBB8i3WihtvvXL46IcyT8m9oBzoxdB0
         VTj3sn6a0swNGVDJmpI6k7Cu89VMVv2/ET/shIr8PVepO489GnU3l1Nw5ghTOB8vTyoH
         cWt49Ecc8rUUiEigBPNA7dm4fguCpl/C+VVjFmL+R9ZKC/wcrtyem2wiRfTZNBw5J7pq
         yZpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685542071; x=1688134071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C+3Et5cju5cYIbnO1iHgVsG4nORzzNf7kwjzGpF1D98=;
        b=PIUp0YFXPmWCa4eOZ6zK9IYoWu7Qc9yVXgRN/owEJIE9AkqqLxg7SQhPjIzsl1s1yz
         9ZCiKXp/NBi3efLmc584UpO68avhUsr33klkGaaBqQHsKlBElyNIiOAO/x+zbH9s5I/C
         sprEL8WIZlUQPmCRLaU6Gy3KJOo741yyntryl0wVQTsV8hNQR+/SStzPv1SsaHMtyFnh
         l9S3StkAxzCSVQMDE+TReayLul5TFyFlEtdcjUnvdYoEGjoQht9oyPpxngqJxOphk3TG
         iHVgrnib13cIdyUsxXoy9MW0OG9v8x+Pp8mJ0bTP5A5YtZyqpjlIDVn5ENHIM8QIu7Co
         PofA==
X-Gm-Message-State: AC+VfDy5PlBnOVqCI4KryeGoBPhAp1yYJt4RnFA7nPjmpwWE770NX3KH
	VV9t1XIulsmntxflBJK8/khCQeJ2wAWxVwA=
X-Google-Smtp-Source: ACHHUZ4Uxtcd4Nb36kVy/ZZ9fTZ91issBPdsIRNi9Y3SHHpw4PLW1p5R6MOHEcA2pFIlzoxssI15H8ZkQTiW5bA=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a50:cdc1:0:b0:504:fcf5:63ee with SMTP id
 h1-20020a50cdc1000000b00504fcf563eemr1835699edj.0.1685542071584; Wed, 31 May
 2023 07:07:51 -0700 (PDT)
Date: Wed, 31 May 2023 14:07:49 +0000
In-Reply-To: <87bki29jsc.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <87bki29jsc.fsf@metaspace.dk>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
Message-ID: <20230531140749.3708572-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 6/7] rust: workqueue: add safe API to workqueue
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	jiangshanlai@gmail.com, linux-kernel@vger.kernel.org, ojeda@kernel.org, 
	patches@lists.linux.dev, rust-for-linux@vger.kernel.org, tj@kernel.org, 
	wedsonaf@gmail.com
Content-Type: text/plain; charset="UTF-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
> Alice Ryhl <aliceryhl@google.com> writes:
>> +unsafe impl<T> WorkItem for Arc<T>
>> +where
>> +    T: ArcWorkItem + HasWork<Self> + ?Sized,
>> +{
>> +    type EnqueueOutput = Result<(), Self>;
>> +
>> +    unsafe fn __enqueue<F>(self, queue_work_on: F) -> Self::EnqueueOutput
>> +    where
>> +        F: FnOnce(*mut bindings::work_struct) -> bool,
>> +    {
>> +        let ptr = Arc::into_raw(self);
>> +
>> +        // Using `get_work_offset` here for object-safety.
>> +        //
>> +        // SAFETY: The pointer is valid since we just got it from `into_raw`.
>> +        let off = unsafe { (&*ptr).get_work_offset() };
>> +
>> +        // SAFETY: The `HasWork` impl promises that this offset gives us a field of type
>> +        // `Work<Self>` in the same allocation.
>> +        let work_ptr = unsafe { (ptr as *const u8).add(off) as *const Work<Self> };
> 
> We have this functionality in the default impl of
> `HasWork<T>::raw_get_work() where Self: Sized`. I am uncertain about the
> `Sized` bound. If it is sound to do the offset calculation here where
> `T: ?Sized`, it should also be sound in the default implementation of
> `HasWork<T>`. Should we not be able to change the bound on
> `HasWork<T>::raw_get_work()` to `Self: ?Sized` and call into that from
> here?
> 
>         let work_ptr = unsafe { <T as HasWork<Self>>::raw_get_work(ptr as _) };
> 
> Same for Box.
> 
> BR Andreas

I looked into this, and it seems like we can remove `Self: Sized` bound
from `raw_get_work`, so I am able to simplify this code somewhat.
However, it cannot be removed from `container_of`.

Thanks,
Alice
