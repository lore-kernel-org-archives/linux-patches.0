Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28579DC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 23:32:12 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id 20so12930645ybl.0
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:32:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2eGx37EmHA0N0W9tODp3iY+Jtr51iEGe4dAXEDxPGHg=;
        b=XRlIs7dhg5iCvVEvX8TYR7BIQKWSK4S519EMsig4S5hCPso4dy7drqtAvz6p3eSBk9
         TL9nFCr1BHLTa/c154LoKHJxh3bg+zI74O6EVrr1xoP5MHfNiypcPqxsnhkkbpIrQQuu
         GuWKMCHBBY+Op8eDdAMcV3jZ9tpnlV19zXWNLzGzC2eag5zGIn5UzTLIzWQjAHb/tdvM
         7wxakp2+ndRz65RdQfgyxVWNNJmSobFZOgUKAOcopDU5EfuHSHDddPDacsMHVDQ+zjtT
         uRXhjiCzOw6fHAgZVPkK1SYmMuYnLCvGN2G2NxAQLlTxyju4nGP5M6+7QwQeF08oh2SS
         2Grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eGx37EmHA0N0W9tODp3iY+Jtr51iEGe4dAXEDxPGHg=;
        b=jI0QprSLSgvYPZRzNVbozFYKDP8ZyuVPdfm9Gz+C0yi9akn2061GW/ZQy7I9AyIWhy
         70/aIjSSZXZ8np/3rifqabYtfz1UA7Swo8v8W8+WzDyNU5jI/8ByncE+oVtPNlkpr8fN
         aO8Hqc2LLEik5U+a8OY9HMqSIHF4iUCkK0PrfBeze2FzvW8VMmRVir1hXrGTL6BihvAr
         V6CGr4JH5wuVX+4qi5/dRGj7b0GE7C6wTQLkijlJx2ky1yrvO6QH/Ai1VZdwY6M22ZoU
         Wi9LNkPdlaTVTyMf1B7Y/MRLghNleCKrQWfoJIHq0qGvisFvMl1qLBu6kJxjenIyfvp+
         lfVQ==
X-Gm-Message-State: AFqh2kpZJelPCRztF5AGzHMDn8k4MddvKkM8eza0HJyqViQ5CCSCLkhO
	zFulGOkp5eUJekEUmIrD/DUA7dHNz0Lr03mdkTI=
X-Google-Smtp-Source: AMrXdXuE1UAGgnxyZDwm/YOVUXX3/p67x7O3O4eboTy7D5CVHVN0IgALnQIj866+lQInoK43ZnNG9XsjVJ+vYXBy6yU=
X-Received: by 2002:a25:ca51:0:b0:7bf:b130:9e24 with SMTP id
 a78-20020a25ca51000000b007bfb1309e24mr195541ybg.328.1673911931888; Mon, 16
 Jan 2023 15:32:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221206010519.39075-1-ojeda@kernel.org>
In-Reply-To: <20221206010519.39075-1-ojeda@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 17 Jan 2023 00:32:00 +0100
Message-ID: <CANiq72kTrfYzmgdLjOecsVTQzHdy_ZDaCO2KgbODtHpL0pS7Qw@mail.gmail.com>
Subject: Re: [PATCH v1] rust: alloc: remove the `borrow` module (`ToOwned`, `Cow`)
To: ojeda@kernel.org
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 6, 2022 at 2:05 AM <ojeda@kernel.org> wrote:
>
> From: Miguel Ojeda <ojeda@kernel.org>
>
> The `Cow` type [1] requires that its generic parameter type implements
> the `ToOwned` trait [2], which provides a method to create owned data
> from borrowed data, usually by cloning.
>
> However, it is infallible, and thus in most cases it is not useful for
> the kernel. [3]
>
> Therefore, introduce `cfg(no_borrow)` to remove the `borrow` module
> (which contains `ToOwned` and `Cow`) from `alloc`.
>
> Link: https://doc.rust-lang.org/alloc/borrow/enum.Cow.html [1]
> Link: https://doc.rust-lang.org/alloc/borrow/trait.ToOwned.html [2]
> Link: https://lore.kernel.org/rust-for-linux/20221204103153.117675b1@GaryWorkstation/ [3]
> Cc: Gary Guo <gary@garyguo.net>
> Cc: Wedson Almeida Filho <wedsonaf@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Applied to rust-next, thanks all!

Cheers,
Miguel
