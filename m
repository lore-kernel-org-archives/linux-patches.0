Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E436108
	for <patches@lists.linux.dev>; Fri, 19 May 2023 09:42:17 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-561120ed06fso63374197b3.3
        for <patches@lists.linux.dev>; Fri, 19 May 2023 02:42:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684489337; x=1687081337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSbexTpIDWFKTxIj9uHgD7rGvKby6+WkT0yDQfZhD+w=;
        b=0bBmjPkohTtvvlkvia/8urb44+bLMMzBP55rf2YP0+6CbNNARGd/AYaZ32xavtUSZO
         VwNg+G8m7Ye2FG3arr//xXruErVnxHZn5pkJeUtf5GK9WMHSmv3/eTf/OXqy4HQaKf7j
         x7zgUM1hoeZbSgYqGVJfoEnqxMrPYaiRMm1Te40sMKiF09Fykp1SS0rAfwPQAtgs+JId
         QlASrIjFE5qUbHAwYilquIDX0bJgtme1ZSYXY4w81pGKY1tBX6niGvryI/BFvM0dWtQu
         B4eQkuUKv2gooWjtdnKwPOa0m/Vz9SRMij5Yg6IHqZgM0P5EpUq10j6AW/miPcEzvZZ8
         IH1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684489337; x=1687081337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pSbexTpIDWFKTxIj9uHgD7rGvKby6+WkT0yDQfZhD+w=;
        b=lnh9sSM9Q7QZMJyUvdpIgVQtSGaNayCFa8oE28Tw7qlmIdxtEZGwXFW/njQVGRbB7+
         gSVdizxx57uVBh9zYoORZpfpjBsHau6XrmThr3nzR6Ypf/oxDcWT37/tlBgUZja/kTHB
         R+rvfF7t03jZvY7wasjffD16vwU4j080f/8iYS10fHB5Vuo5nyIqMQ1uD8MLKHgnEU3L
         +ZuuQTexx+KGCDz6ZcvOQAotMVFUl2ZIZuLym4/B56wEYa+xzPo4nR3yNBesxHIrqd+6
         TpGHH6jSbUBHsJghb6fMfAd5W3Wfzu7s9EaG3VdPzw6vtbhD9+KkXQzmdXW9AG/Sq6u2
         ELwA==
X-Gm-Message-State: AC+VfDx0Uzg/1XjE4lx8MbbMmFDZmge4pX2jim+3qDb2z/SlMtGmyjTz
	bV/JTqRRaZ2R0yOkpEfsdjnkFjw4y/g6NC8=
X-Google-Smtp-Source: ACHHUZ5/SZ/ktbdcdpuHzvlk/gFp5Ebc1vqNkocbohyl/ggFPbbhB79vbjQcakn/l+TC3ggL2hAN7h/T6fE2gmQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a81:af49:0:b0:561:9091:ff91 with SMTP id
 x9-20020a81af49000000b005619091ff91mr900753ywj.2.1684489336986; Fri, 19 May
 2023 02:42:16 -0700 (PDT)
Date: Fri, 19 May 2023 09:42:14 +0000
In-Reply-To: <ZGaXdS+psZoEZBMr@boqun-archlinux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <ZGaXdS+psZoEZBMr@boqun-archlinux>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230519094214.3433619-1-aliceryhl@google.com>
Subject: Re: [PATCH v1 1/2] rust: specify when `ARef` is thread safe
From: Alice Ryhl <aliceryhl@google.com>
To: boqun.feng@gmail.com
Cc: alex.gaynor@gmail.com, aliceryhl@google.com, benno.lossin@proton.me, 
	bjorn3_gh@protonmail.com, gary@garyguo.net, linux-kernel@vger.kernel.org, 
	mark.rutland@arm.com, mingo@redhat.com, ojeda@kernel.org, 
	patches@lists.linux.dev, peterz@infradead.org, rust-for-linux@vger.kernel.org, 
	wedsonaf@gmail.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

On 5/18/23 23:24, Boqun Feng wrote:
> On Wed, May 17, 2023 at 09:59:04AM +0000, Alice Ryhl wrote:
>> +// SAFETY: It is safe to send `ARef<T>` to another thread when the underlying `T` is `Sync` because
>> +// it effectively means sharing `&T` (which is safe because `T` is `Sync`); additionally, it needs
>> +// `T` to be `Send` because any thread that has an `ARef<T>` may ultimately access `T` directly, for
>
> Does the "ultimately access `T` directly" here imply mutably or
> exclusively? If so, it makes sense to me to call it out. I'm trying to
> make sure we can agree on some "common terminologies" ;)

It means "access using a mutable reference". I agree that "directly" is a bit
unclear - I copied it from the safety comment on Arc.

Alice
