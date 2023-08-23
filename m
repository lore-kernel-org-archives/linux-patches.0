Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A418F77
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 10:35:02 +0000 (UTC)
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-94a355c9028so382254866b.3
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 03:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692786901; x=1693391701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OBSXO6qqgmHuKqh6bzP0tT7XEbpao57yrY6B+MWzUYg=;
        b=imZbjfBgPXvWMOgaH+hUcStjhZBiu6fzZipiqROt6F+8KEpdtPXQIWs+WEqdH3+aTI
         BgRDsVt5CQmUVGFWV3IER7szc7NKjgWyw1WfVZxefRjcONdn+t4XFHg3GUKTvwPqg9jd
         I94I7/tGXnqD5NTi2d5dIo72eDBJ59N+aG3KNcWnOq3SxT36VLOFObWUXdhOO+OX8UnV
         DFCvoBfq8MS+HCWsPjeOhmaB5TPtiv4YhjJBMyCKJFzUjE25STn0KfvfeG+uPJ2wcVFD
         uJHRg+hOquSGFE1DHd5ku0rjl3GCuDnpUNtu/BDpV152II0xibXMeyp5OfiUzaQk0JE3
         3Gaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692786901; x=1693391701;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OBSXO6qqgmHuKqh6bzP0tT7XEbpao57yrY6B+MWzUYg=;
        b=H1Fzu/KNw2uAp0kKAeVu1KCXisknmxpctIO6PyVOyFJxXenDkU8RfWhJfAn3fzx0v2
         1H+Qws5TjKNnxR+XS0CFrbCVpCLJJTJ6B3Lh5vRSx/L6VL0Q2b2fnrFgqS1f3r/ucckV
         5UDhiPq8k/dp7kbqrdE77RYeq26qG1jalRJR0l76tBdzQp7wt/qAO2qdGgi4tY94l5mt
         b7JC7o+sPU22tTEjwNX4EXX70IDZ6Z6s4bb0LwnbMBres5KivlCOKkU6oJBKfMz7vBg2
         01deXpv4ATMbWPNK2uyBoPwmNAjcOGHRgguPm/qSVUCHVWu0Xgx7YhESBagPIdQK7OAg
         7lWA==
X-Gm-Message-State: AOJu0YwJ6Cg1bxXpcIS3thE7pWmgEMBGPe7W3WdMXfwt0zypd/6Le95H
	HrOpqFpTATWYOphEyObSLGGCO5ae9FiYCiw=
X-Google-Smtp-Source: AGHT+IHl5FcW1ZIDTb421nTXT/COFWJ7T+NTcJyQsV3MlUrkt79HVnSpJOzK3M/a4awKmbc1LYiRMFB3GGHK4Rs=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a17:907:cb11:b0:9a1:cbc2:e442 with SMTP
 id um17-20020a170907cb1100b009a1cbc2e442mr17162ejc.10.1692786901028; Wed, 23
 Aug 2023 03:35:01 -0700 (PDT)
Date: Wed, 23 Aug 2023 10:34:58 +0000
In-Reply-To: <87msyi406u.fsf@metaspace.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <87msyi406u.fsf@metaspace.dk>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230823103458.243871-1-aliceryhl@google.com>
Subject: Re: [PATCH v1] rust: add improved version of `ForeignOwnable::borrow_mut`
From: Alice Ryhl <aliceryhl@google.com>
To: nmi@metaspace.dk
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	linux-kernel@vger.kernel.org, ojeda@kernel.org, patches@lists.linux.dev, 
	rust-for-linux@vger.kernel.org, wedsonaf@gmail.com
Content-Type: text/plain; charset="utf-8"

Andreas Hindborg <nmi@metaspace.dk> writes:
>>> I am not sure this makes sense. How about splitting the trait in two,
>>> immutable and mutable and only implementing the immutable one or Arc?
>>
>> I used this design based on what would make sense for a linked list. The
>> idea is that we can have two different types of cursors for a linked
>> list: immutable and mutable. The immutable cursor lets you:
>>
>>  * move around the linked list
>>  * access the values using `borrow`
>>
>> The mutable cursor lets you:
>>
>>  * move around the linked list
>>  * delete or add items to the list
>>  * access the values using `borrow_mut`
>>
>> The mutable cursor gives you extra abilities beyond the `borrow` vs
>> `borrow_mut` distinction, so we want to provide both types of cursors
>> even if the pointer type is Arc. To do that, we need a trait that
>> defines what it means to have mutable access to an Arc.
> 
> I don't see how that prevents this trait from being split in two?

Well, you could split the trait, but if you make the mutable iterator
require the `borrow_mut` trait, then you have to implement the mutable
trait for `Arc` too if you want the mutable iterator to work with `Arc`.

And if you're always going to implement both traits, then maybe it
makes more sense to not split the traits?

Alice
