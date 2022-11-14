Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEEC33C1
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 14:30:14 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id v1so18550895wrt.11
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 06:30:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pjAZXPWFwUWF4bRhlxD1onJIHJFxfMMKMm0x3TCqqZU=;
        b=5N3NIL/Ec+N9TyD3Efh46xlGxbVBpwr1USNSj5r2SN3KeYY90D9RpJaFN7PVZ54B5d
         hLvLQBRiUe4D3dUuKuomaQYVnWgAD2U9RJ/vBxwNBZAqN0EoKh2A4Yy2CyhhAwMqr11x
         BhtZj1uOra7QQtt/gDDkpIrqXI5WMO7BCTvLC2jctJkwzH42WkbUOrd5qmCV5MlDu6Xp
         8BlGTrQ200LyIKSxNfPUGM6yBTwz9TzbkuOWToTL2x5MMRP6/iynKqDYfk0CQ7HgsMD5
         jax+ub/EEApgaaksiwaIad+9ocUUrr63CgWD+Mt1UXLU0w3lnjKjZuJtRQF1ciLMcwmG
         GxOA==
X-Gm-Message-State: ANoB5pkYu3KA7QaA6wg5AI+vc0+oRdOWhUzMmAih+f63ot5pajn5B7zN
	YC55q2YCGdpc63RwcCjmp2afWk+3uZg=
X-Google-Smtp-Source: AA0mqf7CR9SBlgWFkwPEpQTvMHRvCZhUfiwBWoMbTojfBHXhH3jNX3iOEqN5DNm0hGb1l8NHDriQ4w==
X-Received: by 2002:adf:aa8c:0:b0:236:9bad:3da0 with SMTP id h12-20020adfaa8c000000b002369bad3da0mr7506064wrc.234.1668436212687;
        Mon, 14 Nov 2022 06:30:12 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id r2-20020a5d6942000000b0022e47b57735sm9816098wrw.97.2022.11.14.06.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:30:12 -0800 (PST)
Date: Mon, 14 Nov 2022 14:30:10 +0000
From: Wei Liu <wei.liu@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH v1 25/28] rust: add `build_error` crate
Message-ID: <Y3JQ8qsaV/DN3OJ7@liuwe-devbox-debian-v2>
References: <20221110164152.26136-1-ojeda@kernel.org>
 <20221110164152.26136-26-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110164152.26136-26-ojeda@kernel.org>

On Thu, Nov 10, 2022 at 05:41:37PM +0100, Miguel Ojeda wrote:
> From: Gary Guo <gary@garyguo.net>
[...]
> diff --git a/rust/build_error.rs b/rust/build_error.rs
> new file mode 100644
> index 000000000000..0ff6b33059aa
> --- /dev/null
> +++ b/rust/build_error.rs
> @@ -0,0 +1,24 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Build-time error.
> +//!
> +//! This crate provides a function `build_error`, which will panic in

a const function `build_error`

Without this I read it as a "normal non-const function".

> +//! compile-time if executed in const context, and will cause a build error
> +//! if not executed at compile time and the optimizer does not optimise away the
> +//! call.
> +//!

I can work out what the code does, but I also happen to know what Rust's
const means and its behaviour in non-const context. Other kernel
developers may not. Even so the description is a bit difficult for me to
parse.

Maybe a few sentences about const and its behaviours can help?

Thanks,
Wei.

> +//! It is used by `build_assert!` in the kernel crate, allowing checking of
> +//! conditions that could be checked statically, but could not be enforced in
> +//! Rust yet (e.g. perform some checks in const functions, but those
> +//! functions could still be called in the runtime).
> +
> +#![no_std]
> +
> +/// Panics if executed in const context, or triggers a build error if not.
> +#[inline(never)]
> +#[cold]
> +#[export_name = "rust_build_error"]
> +#[track_caller]
> +pub const fn build_error(msg: &'static str) -> ! {
> +    panic!("{}", msg);
> +}
