Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8CC28E12;
	Mon,  6 Nov 2023 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVpno2AD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6326C433C8;
	Mon,  6 Nov 2023 15:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699286288;
	bh=mdCc81ZkKWiCWgh0DtK923uhvIGiH7XK/k1z5kL2ckc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jVpno2ADWZzo2xf5ZUTtn0YL9/ygi4EpKLhqUMgJow50tSO1nxdvrrC2av4reY9CE
	 aCNR/Ks5ICeomvaqfiOel5d9nG5SS9mZHe3jlroaKuN+vrWWCs97gwzYTEcD2IDcKM
	 v8sX8al7SpfPBoSwW+vjtSqXZ85J0aeAWiCTImGWQSY4dB+X+TamwBbPXVTbLhdWkE
	 Dm39mJ8u8jYxZN7J4eLXDH4ko7fmrUklGnmooQ6uRk9ithUWd0zRY/Zr5mMh7p0LOi
	 OoRSIOBPovrjb53n4nalOPH5FQwzjorT8cBOP+inXtCB1V8U6OmNxBIV19xHpFXvf+
	 ITxTKa9mM8iIg==
Date: Mon, 6 Nov 2023 08:58:06 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
	pabeni@redhat.com, ndesaulniers@google.com, trix@redhat.com,
	0x7f454c46@gmail.com, noureddine@arista.com, hch@infradead.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH net v2] tcp: Fix -Wc23-extensions in tcp_options_write()
Message-ID: <20231106155806.GA1181828@dev-arch.thelio-3990X>
References: <20231106-tcp-ao-fix-label-in-compound-statement-warning-v2-1-91eff6e1648c@kernel.org>
 <CANn89i+GF=4QuVMevE7Ur2Zi0nDjBujMHWJayURR9fbcr+McnA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+GF=4QuVMevE7Ur2Zi0nDjBujMHWJayURR9fbcr+McnA@mail.gmail.com>

On Mon, Nov 06, 2023 at 04:52:52PM +0100, Eric Dumazet wrote:
> On Mon, Nov 6, 2023 at 4:36 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Clang warns (or errors with CONFIG_WERROR=y) when CONFIG_TCP_AO is set:
> >
> >   net/ipv4/tcp_output.c:663:2: error: label at end of compound statement is a C23 extension [-Werror,-Wc23-extensions]
> >     663 |         }
> >         |         ^
> >   1 error generated.
> >
> > On earlier releases (such as clang-11, the current minimum supported
> > version for building the kernel) that do not support C23, this was a
> > hard error unconditionally:
> >
> >   net/ipv4/tcp_output.c:663:2: error: expected statement
> >           }
> >           ^
> >   1 error generated.
> >
> > While adding a semicolon after the label would resolve this, it is more
> > in line with the kernel as a whole to refactor this block into a
> > standalone function, which means the goto a label construct can just be
> > replaced with a simple return. Do so to resolve the warning.
> >
> > Closes: https://github.com/ClangBuiltLinux/linux/issues/1953
> > Fixes: 1e03d32bea8e ("net/tcp: Add TCP-AO sign to outgoing packets")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > Please let me know if this function should have a different name. I
> > think I got all the changes of the function shuffle correct but some
> > testing would be appreciated.
> >
> > Changes in v2:
> > - Break out problematic block into its own function so that goto can be
> >   replaced with a simple return, instead of the simple semicolon
> >   approach of v1 (Christoph)
> > - Link to v1: https://lore.kernel.org/r/20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org
> > ---
> >  net/ipv4/tcp_output.c | 69 ++++++++++++++++++++++++++++-----------------------
> >  1 file changed, 38 insertions(+), 31 deletions(-)
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index 0d8dd5b7e2e5..3f8dc74fbf40 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -601,6 +601,43 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
> >  }
> >  #endif
> >
> > +static void process_tcp_ao_options(struct tcp_sock *tp,
> > +                                  const struct tcp_request_sock *tcprsk,
> > +                                  struct tcp_out_options *opts,
> > +                                  struct tcp_out_options *opts,
> 
> ptr has a different type than in the caller, this is a bit confusing
> 
> I would use
> 
> static __be32 * process_tcp_ao_options(struct tcp_sock *tp, const
> struct tcp_request_sock *tcprsk,
>                   struct tcp_out_options *opts,struct tcp_key *key, __be32 *ptr)

Ah, this suggestion is much better, thanks. I'll make this adjustment
and send a v3 later today in case others have any suggested changes (I
know netdev prefers waiting 24 hours for another revision but I'd like
to get this warning cleared up by -rc1 so it does not proliferate into
other trees and I sent v1 almost a week ago).

> > +{
> > +#ifdef CONFIG_TCP_AO
> > +       u8 maclen = tcp_ao_maclen(key->ao_key);
> > +
> > +       if (tcprsk) {
> > +               u8 aolen = maclen + sizeof(struct tcp_ao_hdr);
> > +
> > +               *(*ptr)++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
> > +                                 (tcprsk->ao_keyid << 8) |
> > +                                 (tcprsk->ao_rcv_next));
> 
> 
>                  *ptr++ = ...
> 
> (and in all other *ptr uses in this helper)
> 
> > +       } else {
> > +               struct tcp_ao_key *rnext_key;
> > +               struct tcp_ao_info *ao_info;
> > +
> > +               ao_info = rcu_dereference_check(tp->ao_info,
> > +                       lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
> > +               rnext_key = READ_ONCE(ao_info->rnext_key);
> > +               if (WARN_ON_ONCE(!rnext_key))
> > +                       return;
> > +               *(*ptr)++ = htonl((TCPOPT_AO << 24) |
> > +                                 (tcp_ao_len(key->ao_key) << 16) |
> > +                                 (key->ao_key->sndid << 8) |
> > +                                 (rnext_key->rcvid));
> > +       }
> > +       opts->hash_location = (__u8 *)(*ptr);
> > +       *ptr += maclen / sizeof(**ptr);
> > +       if (unlikely(maclen % sizeof(**ptr))) {
> > +               memset(*ptr, TCPOPT_NOP, sizeof(**ptr));
> > +               (*ptr)++;
> > +       }
> > +#endif
> 
>     return ptr;
> +}
> > +
> >  /* Write previously computed TCP options to the packet.
> >   *
> >   * Beware: Something in the Internet is very sensitive to the ordering of
> > @@ -629,37 +666,7 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
> >                 opts->hash_location = (__u8 *)ptr;
> >                 ptr += 4;
> >         } else if (tcp_key_is_ao(key)) {
> > -#ifdef CONFIG_TCP_AO
> > -               u8 maclen = tcp_ao_maclen(key->ao_key);
> > -
> > -               if (tcprsk) {
> > -                       u8 aolen = maclen + sizeof(struct tcp_ao_hdr);
> > -
> > -                       *ptr++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
> > -                                      (tcprsk->ao_keyid << 8) |
> > -                                      (tcprsk->ao_rcv_next));
> > -               } else {
> > -                       struct tcp_ao_key *rnext_key;
> > -                       struct tcp_ao_info *ao_info;
> > -
> > -                       ao_info = rcu_dereference_check(tp->ao_info,
> > -                               lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
> > -                       rnext_key = READ_ONCE(ao_info->rnext_key);
> > -                       if (WARN_ON_ONCE(!rnext_key))
> > -                               goto out_ao;
> > -                       *ptr++ = htonl((TCPOPT_AO << 24) |
> > -                                      (tcp_ao_len(key->ao_key) << 16) |
> > -                                      (key->ao_key->sndid << 8) |
> > -                                      (rnext_key->rcvid));
> > -               }
> > -               opts->hash_location = (__u8 *)ptr;
> > -               ptr += maclen / sizeof(*ptr);
> > -               if (unlikely(maclen % sizeof(*ptr))) {
> > -                       memset(ptr, TCPOPT_NOP, sizeof(*ptr));
> > -                       ptr++;
> > -               }
> > -out_ao:
> > -#endif
> > +               process_tcp_ao_options(tp, tcprsk, opts, key, &ptr);
> 
> ptr = process_tcp_ao_options(tp, tcprsk, opts, key, ptr);
> 
> 
> >         }
> >         if (unlikely(opts->mss)) {
> >                 *ptr++ = htonl((TCPOPT_MSS << 24) |
> >
> > ---
> > base-commit: c1ed833e0b3b7b9edc82b97b73b2a8a10ceab241
> > change-id: 20231031-tcp-ao-fix-label-in-compound-statement-warning-ebd6c9978498
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >
