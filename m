Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14931DFC0;
	Fri,  3 Nov 2023 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joWmgmH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B241C433C7;
	Fri,  3 Nov 2023 16:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699030395;
	bh=yAGnEZ1ePwa03Pod66Nx3M1cyUgoNh1w3/xnLR0bJ0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=joWmgmH1ttEcNufjFhn0haJZpB42lvkpWWAXBpSfwo+KgKn9ECWFLGSzf/cmYiY1b
	 tNdH/LAa8ikuZRW201blqNkMlPE7+2oxTmlpgkjUBZhTekcdBp+gO5JBEL+RwDRgKS
	 FovKNizCmz9T6z9YQ0kWx5kyUctf0mRUVnf9fFjIs3PjuAhfRd5L+2TLQUCGVzNGE6
	 fC3+idYgLxQX6swSQwGiTceZ3rr6g80E+Snh2q52GZRdeJvoKj6LuL4A1D1dLQr5sQ
	 vxwV5WJLhdbWnCMSf0JdXykkrOcH4C1ek8Qi1lVz9QvZhWeCqytqZPw6S2hjBI/KGj
	 8umck03UyNkZw==
Date: Fri, 3 Nov 2023 09:53:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
	kuba@kernel.org, pabeni@redhat.com, ndesaulniers@google.com,
	trix@redhat.com, 0x7f454c46@gmail.com, fruggeri@arista.com,
	noureddine@arista.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH net] tcp: Fix -Wc23-extensions in tcp_options_write()
Message-ID: <20231103165312.GA3670349@dev-arch.thelio-3990X>
References: <20231031-tcp-ao-fix-label-in-compound-statement-warning-v1-1-c9731d115f17@kernel.org>
 <ZUStrQCqBjBBB6dc@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUStrQCqBjBBB6dc@infradead.org>

Hi Christoph,

On Fri, Nov 03, 2023 at 01:22:05AM -0700, Christoph Hellwig wrote:
> On Tue, Oct 31, 2023 at 01:23:35PM -0700, Nathan Chancellor wrote:
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
> > Add a semicolon after the label to create an empty statement, which
> > resolves the warning or error for all compilers.
> 
> Can you please just split the A0 handlig into a separate helper, which
> shuld make the whole thing a lot cleaner?

Is something like this (I think I got all the pointer manipulation
correct...) what you had in mind? I am happy to send that as a v2 if the
netdev folks would prefer it over this small change (along with some
guidance about the function name, if it should be something different).

Cheers,
Nathan

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index f558c054cf6e..6f2a5e3bb7b3 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -601,6 +601,43 @@ static void bpf_skops_write_hdr_opt(struct sock *sk, struct sk_buff *skb,
 }
 #endif
 
+static void process_tcp_ao_options(struct tcp_sock *tp,
+				   const struct tcp_request_sock *tcprsk,
+				   struct tcp_out_options *opts,
+				   struct tcp_key *key, __be32 **ptr)
+{
+#ifdef CONFIG_TCP_AO
+	u8 maclen = tcp_ao_maclen(key->ao_key);
+
+	if (tcprsk) {
+		u8 aolen = maclen + sizeof(struct tcp_ao_hdr);
+
+		*(*ptr)++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
+			          (tcprsk->ao_keyid << 8) |
+			          (tcprsk->ao_rcv_next));
+	} else {
+		struct tcp_ao_key *rnext_key;
+		struct tcp_ao_info *ao_info;
+
+		ao_info = rcu_dereference_check(tp->ao_info,
+			lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
+		rnext_key = READ_ONCE(ao_info->rnext_key);
+		if (WARN_ON_ONCE(!rnext_key))
+			return;
+		*(*ptr)++ = htonl((TCPOPT_AO << 24) |
+			          (tcp_ao_len(key->ao_key) << 16) |
+			          (key->ao_key->sndid << 8) |
+			          (rnext_key->rcvid));
+	}
+	opts->hash_location = (__u8 *)(*ptr);
+	*ptr += maclen / sizeof(**ptr);
+	if (unlikely(maclen % sizeof(**ptr))) {
+		memset(*ptr, TCPOPT_NOP, sizeof(**ptr));
+		(*ptr)++;
+	}
+#endif
+}
+
 /* Write previously computed TCP options to the packet.
  *
  * Beware: Something in the Internet is very sensitive to the ordering of
@@ -629,37 +666,7 @@ static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
 		opts->hash_location = (__u8 *)ptr;
 		ptr += 4;
 	} else if (tcp_key_is_ao(key)) {
-#ifdef CONFIG_TCP_AO
-		u8 maclen = tcp_ao_maclen(key->ao_key);
-
-		if (tcprsk) {
-			u8 aolen = maclen + sizeof(struct tcp_ao_hdr);
-
-			*ptr++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
-				       (tcprsk->ao_keyid << 8) |
-				       (tcprsk->ao_rcv_next));
-		} else {
-			struct tcp_ao_key *rnext_key;
-			struct tcp_ao_info *ao_info;
-
-			ao_info = rcu_dereference_check(tp->ao_info,
-				lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
-			rnext_key = READ_ONCE(ao_info->rnext_key);
-			if (WARN_ON_ONCE(!rnext_key))
-				goto out_ao;
-			*ptr++ = htonl((TCPOPT_AO << 24) |
-				       (tcp_ao_len(key->ao_key) << 16) |
-				       (key->ao_key->sndid << 8) |
-				       (rnext_key->rcvid));
-		}
-		opts->hash_location = (__u8 *)ptr;
-		ptr += maclen / sizeof(*ptr);
-		if (unlikely(maclen % sizeof(*ptr))) {
-			memset(ptr, TCPOPT_NOP, sizeof(*ptr));
-			ptr++;
-		}
-out_ao:
-#endif
+		process_tcp_ao_options(tp, tcprsk, opts, key, &ptr);
 	}
 	if (unlikely(opts->mss)) {
 		*ptr++ = htonl((TCPOPT_MSS << 24) |
