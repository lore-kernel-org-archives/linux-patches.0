Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C852F22
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 15:10:54 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id n10so20233910wrw.12
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 08:10:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=a7vLBMT/E4442MupPoT+pHag9Mp/Q4EXWsrU1jJIFGw=;
        b=Ao9gq0+WPkm+z44Wel00Vku0S8DTFGa02xbnf59CsnZtxiTNnqJ+UgjosIUt0kTFWH
         HFZEDWRKhHpFzfzoRA+ryE4mFIv84gsAR6Vaj28qUwWxZttmo87yWow4AmbCZjiouoK6
         kRPj6FvdLFOZoxxkE5/pYHflxqza6dmG3y9NlCH6e9KbWnghyXxJZBKW41vqdiS9mMXn
         7Kj9VFtGzCbGqUBf3jbouNAvzNU1V0rIQSCxnsAgmlN0PFtks7CK402y4vEsMxa4g8qO
         +y/3EpmVIP0TgVIAkWx0U9R5DVjLh9Iq2kGEujLJ2o1H3m+lKqFiiqX9qXGJLEcZv1tR
         liCg==
X-Gm-Message-State: ACrzQf3ok8M4AlZRoyXYWjQeigScvCL2CMDVLd6XET7zsLyQqg/9rYSF
	W8swh8isbReK2t6C0aHcxWM=
X-Google-Smtp-Source: AMsMyM7LFfPMWiwrUKZs1m9whot2DEqwso07KVrBGjYZYygeqa1Kb9evcZNTDI1rLZa8b6y5zBrQ7g==
X-Received: by 2002:adf:f58a:0:b0:22c:be20:24e8 with SMTP id f10-20020adff58a000000b0022cbe2024e8mr5903192wro.245.1664377853246;
        Wed, 28 Sep 2022 08:10:53 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id y3-20020a5d4ac3000000b0022ac672654dsm4642497wrs.58.2022.09.28.08.10.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 08:10:52 -0700 (PDT)
Date: Wed, 28 Sep 2022 15:10:51 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Gary Guo <gary@garyguo.net>, Matthew Bakhtiari <dev@mtbk.me>,
	Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v10 08/27] rust: adapt `alloc` crate to the kernel
Message-ID: <YzRj+47LIz2G9omo@liuwe-devbox-debian-v2>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-9-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-9-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:39PM +0200, Miguel Ojeda wrote:
> +    /// Tries to append an element to the back of a collection.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// let mut vec = vec![1, 2];
> +    /// vec.try_push(3).unwrap();
> +    /// assert_eq!(vec, [1, 2, 3]);
> +    /// ```
> +    #[inline]
> +    #[stable(feature = "kernel", since = "1.0.0")]
> +    pub fn try_push(&mut self, value: T) -> Result<(), TryReserveError> {
> +        if self.len == self.buf.capacity() {
> +            self.buf.try_reserve_for_push(self.len)?;
> +        }
> +        unsafe {
> +            let end = self.as_mut_ptr().add(self.len);
> +            ptr::write(end, value);
> +            self.len += 1;
> +        }

Missing safety comment here?

With a safety comment added:

Reviewed-by: Wei Liu <wei.liu@kernel.org>

> +        Ok(())
> +    }
