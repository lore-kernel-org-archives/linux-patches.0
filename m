Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40F366
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 04:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB86C43398
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 04:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673498146;
	bh=cEC/8ycHGZmpawhW7zGWVnL8kp2g8DOTp2ORTPKCtng=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gy/l+QWlxi0g5fUp/WnP6YFAjXGGVCSx+2MFYxgTDi4zSYDZPkr6/xf+IGijc/mNj
	 hZz9TbiWaf4WzoU/AoJjnTI856yRZOI0CFUJ1vB5s5KfJkxLiffgS0Xk6dEk29sPpb
	 Znc1+F/vByrSsCHqUNJEOUH9wZZvoqBjBJDAIH+vfVzCyPsjiqeeR0PRkzDTbcVyRx
	 AAD8BVzT2p3cnlNkKX6WSsV5famPo7RpKsIGxvtQn12IoEKbiCKwGIYGKnhnDgxOlV
	 ucUWxfStgoLFngC+Bfnw9lQC0i+m+nH/WN6ezvYURPBQ4WGAIPhoiviVqV2SJgIp4a
	 Zuwq7ZkywohuA==
Received: by mail-oi1-f178.google.com with SMTP id h185so14457336oif.5
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 20:35:45 -0800 (PST)
X-Gm-Message-State: AFqh2kroNazEcv+oH439ghx1UcSHCnXx0qBSxdXi0JUnS6Do1QIe0jS5
	L2mjGNfplVZPHGdW21vTFU7K/afMuxNzZFoVAzk=
X-Google-Smtp-Source: AMrXdXsv4uFA2ckMcPSKcLyd59iRAkaYtzx3HgzCgDZGW9c0li9O94jf5ZN16WBncqaFzqsZn9xLrJ45AEfChZuqpgQ=
X-Received: by 2002:a05:6808:1510:b0:364:5d10:7202 with SMTP id
 u16-20020a056808151000b003645d107202mr422189oiw.194.1673498145165; Wed, 11
 Jan 2023 20:35:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230109204520.539080-1-ojeda@kernel.org> <20230109204520.539080-3-ojeda@kernel.org>
 <CAK7LNATVJ5e=DnbJ++03iEMk0bN3-UvODBLkEKcYdSnJZa_tmA@mail.gmail.com>
In-Reply-To: <CAK7LNATVJ5e=DnbJ++03iEMk0bN3-UvODBLkEKcYdSnJZa_tmA@mail.gmail.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 12 Jan 2023 13:35:08 +0900
X-Gmail-Original-Message-ID: <CAK7LNASDu+i4G88TYYa6feg-bha-_cLv1si_ujuSMbWuyUve0Q@mail.gmail.com>
Message-ID: <CAK7LNASDu+i4G88TYYa6feg-bha-_cLv1si_ujuSMbWuyUve0Q@mail.gmail.com>
Subject: Re: [PATCH 3/6] kbuild: rust_is_available: add check for `bindgen` invocation
To: Miguel Ojeda <ojeda@kernel.org>
Cc: linux-kbuild@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Nicolas Schier <nicolas@fjasle.eu>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Alexandru Radovici <msg4alex@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 12, 2023 at 1:33 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> On Tue, Jan 10, 2023 at 5:45 AM Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> > `scripts/rust_is_available.sh` calls `bindgen` with a special
> > header in order to check whether the `libclang` version in use
> > is suitable.
> >
> > However, the invocation itself may fail if, for instance, `bindgen`
> > cannot locate `libclang`. This is fine for Kconfig (since the
> > script will still fail and therefore disable Rust as it should),
> > but it is pretty confusing for users of the `rustavailable` target
> > given the error will be unrelated:
> >
> >     ./scripts/rust_is_available.sh: 21: arithmetic expression: expecting primary: "100000 *  + 100 *  + "
> >     make: *** [Makefile:1816: rustavailable] Error 2
> >
> > Instead, run the `bindgen` invocation independently in a previous
> > step, saving its output and return code. If it fails, then show
> > the user a proper error message. Otherwise, continue as usual
> > with the saved output.
> >
> > Since the previous patch we show a reference to the docs, and
> > the docs now explain how `bindgen` looks for `libclang`,
> > thus the error message can leverage the documentation, avoiding
> > duplication here (and making users aware of the setup guide in
> > the documentation).
> >
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Reported-by: fvalenduc (@fvalenduc)
> > Reported-by: Alexandru Radovici <msg4alex@gmail.com>
> > Link: https://lore.kernel.org/rust-for-linux/CAKwvOdm5JT4wbdQQYuW+RT07rCi6whGBM2iUAyg8A1CmLXG6Nw@mail.gmail.com/
> > Link: https://github.com/Rust-for-Linux/linux/issues/934
> > Link: https://github.com/Rust-for-Linux/linux/pull/921
> > Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> > ---
> >  scripts/rust_is_available.sh | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/scripts/rust_is_available.sh b/scripts/rust_is_available.sh
> > index c907cf881c2c..cd87729ca3bf 100755
> > --- a/scripts/rust_is_available.sh
> > +++ b/scripts/rust_is_available.sh
> > @@ -108,8 +108,29 @@ if [ "$rust_bindings_generator_cversion" -gt "$rust_bindings_generator_min_cvers
> >  fi
> >
> >  # Check that the `libclang` used by the Rust bindings generator is suitable.
> > +#
> > +# In order to do that, first invoke `bindgen` to get the `libclang` version
> > +# found by `bindgen`. This step may already fail if, for instance, `libclang`
> > +# is not found, thus inform the user in such a case.
> > +set +e
> > +bindgen_libclang_output=$(LC_ALL=C "$BINDGEN" $(dirname $0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null)
> > +bindgen_libclang_code=$?
> > +set -e
> > +if [ $bindgen_libclang_code -ne 0 ]; then
> > +       echo >&2 "***"
> > +       echo >&2 "*** Running '$BINDGEN' to check the libclang version (used by the Rust"
> > +       echo >&2 "*** bindings generator) failed with code $bindgen_libclang_code. This may be caused by"
> > +       echo >&2 "*** a failure to locate libclang. See output and docs below for details:"
> > +       echo >&2 "***"
> > +       echo >&2 "$bindgen_libclang_output"
> > +       echo >&2 "***"
> > +       exit 1
> > +fi
> >
>
>
> Instead of toggling -e, why don't you write like this?
>
>
> if ! bindgen_libclang_output=$(LC_ALL=C "$BINDGEN" $(dirname
> $0)/rust_is_available_bindgen_libclang.h 2>&1); then
>        [snip]
> fi
>


I meant this:



if ! bindgen_libclang_output=$(LC_ALL=C "$BINDGEN" $(dirname
$0)/rust_is_available_bindgen_libclang.h 2>&1 >/dev/null); then
       [snip]
fi




(">/dev/null" was lost in the previous email)




-- 
Best Regards
Masahiro Yamada
