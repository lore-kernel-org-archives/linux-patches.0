Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15273EA2
	for <patches@lists.linux.dev>; Wed, 28 Sep 2022 10:09:58 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id v1so11365667plo.9
        for <patches@lists.linux.dev>; Wed, 28 Sep 2022 03:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=duP8xfDehjxwwRzMlO+xIkuofiVIyjCnJ39OqEBZnvg=;
        b=lib6B2mMxl5NxnINW0OzG0zC66Z3LCxS8m+inz3s790XzYWfBXOcjpz79BlYtXU+zC
         hfchdOgWGjEq9QbwDqw2agsx5TcvvzkUpGqDh/OymxIaA0trvTvjbAlv2j422Heo/mhf
         CHZYlO8o6iKNhyTtuCByT1TiWNNIHXygpcP6s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=duP8xfDehjxwwRzMlO+xIkuofiVIyjCnJ39OqEBZnvg=;
        b=ysbX3k1B8alhT2cQN/rUlf9W7lGO7GB6FvmoXVKspvcEGkyMkuY28n9ndJvSTtD2Km
         YJxnIinOOEzSkuf9sRgunsujYmYSseu3ujNrMpYSW4ylZWzWhqH+HEtT2cLt0F5MI2Qr
         QZ2ny1mpdtNiH6jneq1giP7yGsD7mO+FzbERTWbojPerHOFZfZBMse5lStafgsv5ajaY
         m1qXI9hb9ouOPXhzFqbVkAZwO4t8YTcjw2/pAMhMqIXzazYDM/8+ChvZ7hpo5cgG1avV
         EyWSGsZGQvwgGlwba5RKyk5e45qhtv2r1qr5r2GXNhl4UiWnY7N04w9p6jeO1eBVZMoo
         /88g==
X-Gm-Message-State: ACrzQf0mam5X2kqBD6sAnrQENQCu+6RSZPp8WDGD7BJl+CHYxVWfgs1A
	98dUTgkteQ4UsABZ8EepRGtqLg==
X-Google-Smtp-Source: AMsMyM4xOfc8HLa6MnTzpmJZID7CRRxzXzSmbwQ3uH59f74/DtPFaDC2Z73NATAqWDt7D8COPRC4yg==
X-Received: by 2002:a17:902:bd8e:b0:178:25ab:56cc with SMTP id q14-20020a170902bd8e00b0017825ab56ccmr31062254pls.86.1664359797576;
        Wed, 28 Sep 2022 03:09:57 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:d8e5:5ceb:cc0c:18ad])
        by smtp.gmail.com with ESMTPSA id u16-20020a170902e5d000b00172f6726d8esm3285144plf.277.2022.09.28.03.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 03:09:57 -0700 (PDT)
Date: Wed, 28 Sep 2022 19:09:50 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>, Gary Guo <gary@garyguo.net>,
	Kees Cook <keescook@chromium.org>, Petr Mladek <pmladek@suse.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH v10 14/27] vsprintf: add new `%pA` format specifier
Message-ID: <YzQdbi1xUNGxi+SM@google.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-15-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927131518.30000-15-ojeda@kernel.org>

On (22/09/27 15:14), Miguel Ojeda wrote:
> This patch adds a format specifier `%pA` to `vsprintf` which formats
> a pointer as `core::fmt::Arguments`. Doing so allows us to directly
> format to the internal buffer of `printf`, so we do not have to use
> a temporary buffer on the stack to pre-assemble the message on
> the Rust side.
> 
> This specifier is intended only to be used from Rust and not for C, so
> `checkpatch.pl` is intentionally unchanged to catch any misuse.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Acked-by: Petr Mladek <pmladek@suse.com>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Miguel Ojeda <ojeda@kernel.org>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
