Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522037E5FF;
	Fri,  4 Sep 2026 12:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788524238; cv=none; b=dsYM8eOMWHqp1dC+2nt4OILe91XGDgmyUZUEunytMXp1V+scek2vBSb98VTIv9UoW+FYddb106FA3j77HE9jEFFf0/VtmShNnPgPsP+Xdh8PRYvYpRYHHlMJLQqmCdQRXh0YpsFzPPdBMGQ9hZR0T9On3fTNnGJXlJpCeMDCGpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788524238; c=relaxed/simple;
	bh=GQ+iJdR8aM95rSh1IsT9B9KxQ4e04ps0MbsoW6wSGns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VTV6UFp/kxS0De18F6mEx0QKA1YQ2YJ+h8DHvKF85dO89dOZikxm89TyR6Eg09zIiSdVnnit6Cp08FnVrSucPXujpFQ1qQoYhs8aV8iTPjjkJM6bI1P1gHsUcpbY1yTt2ED8t0BcF5PlienDYYKbRJqh2gRXfJQz2LePU27bFDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUazOP2o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUazOP2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 913241F00A3E;
	Fri,  4 Sep 2026 12:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788524236;
	bh=D6rN5EHBtO/4eo6xmiA0dpvMYpNq2Ecf/p9kM+qb+68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=yUazOP2opzE8VoeoC4flCKKkHNJVwKNKUt+Uoh/tXYmHmvVVjpdJEX5ewoTzteDkB
	 IMXoqsKrW2Grn+4GN6nLo9RhQ4AANZrroD4ZU+/olFON+qL5pTNSa6K6/A8XZDcViY
	 MN8DDxpMQo0RWDphhkLUIYrU2kfShhZSRJKVr0fU=
Date: Fri, 4 Sep 2026 14:15:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 5.10 28/43] xfrm: espintcp: fix UAF during close
Message-ID: <2026090409-hesitant-hug-bd90@gregkh>
References: <20260831133358.571886287@linuxfoundation.org>
 <20260831133359.883892832@linuxfoundation.org>
 <20260904095158.GA83164@j66a10360.sqa.eu95>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260904095158.GA83164@j66a10360.sqa.eu95>

On Fri, Sep 04, 2026 at 05:51:58PM +0800, D. Wythe wrote:
> On Mon, Aug 31, 2026 at 03:35:36PM +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Sabrina Dubroca <sd@queasysnail.net>
> > 
> > commit deb232e884877bf10b4ce2580909eedec986c284 upstream.
> > 
> > ZDI reported and analyzed a race condition during close for espintcp
> > sockets:
> > 
> >     espintcp_close() frees emsg->skb via kfree_skb() without holding
> >     any socket lock. Concurrently, the xfrm_trans_reinject work queue
> >     invokes esp_output_tcp_finish() -> espintcp_push_skb() ->
> >     espintcp_push_msgs() -> skb_send_sock_locked(), which reads the
> >     same skb as a data source.
> > 
> > Fix this by adding a synchronize_rcu() call after resetting sk_prot,
> > since esp_output_tcp_finish() runs under RCU and won't use a socket
> > with sk_prot == &tcp_prot.  Simply taking the socket lock in
> > espintcp_close() could lead to leaks, if esp_output_tcp_finish()
> > re-adds an skb in the slot we just freed. After this, the existing
> > barrier() is no longer needed.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> > Reported-by: zdi-disclosures@trendmicro.com
> > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > Reviewed-by: Breno Leitao <leitao@debian.org>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/xfrm/espintcp.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > --- a/net/xfrm/espintcp.c
> > +++ b/net/xfrm/espintcp.c
> > @@ -506,7 +506,8 @@ static void espintcp_close(struct sock *
> >  	strp_stop(&ctx->strp);
> >  
> >  	sk->sk_prot = &tcp_prot;
> > -	barrier();
> > +
> > +	synchronize_rcu();
> 
> 
> This backport depends on upstream
> 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"),
> which is not in 5.15.y. Without it, esp_find_tcp_sk() still
> returns the cached x->encap_sk based only on sk_state == TCP_ESTABLISHED
> (no tcp_is_ulp_esp() check), so new readers keep racing with
> espintcp_close()'s kfree_skb on ctx->partial.emsg->skb — the UAF issue
> this patch is supposed to fix.
> 
> Reproduced on 5.15.219+ (with this patch applied), KASAN trimmed:
> 
>   BUG: KASAN: use-after-free in __skb_send_sock+0x6cf/0x7b0
>   Workqueue: events xfrm_trans_reinject
> 
>   Reader:
>     __skb_send_sock <- espintcp_push_msgs <- espintcp_push_skb <-
>     esp_output_tcp_encap_cb <- xfrm_trans_reinject
> 
>   Free:
>     espintcp_close <- inet_release <- __sock_release <- sock_close <-
>     __fput
> 
>   Object: skbuff_head_cache (size 224), i.e. struct sk_buff.
> 
> Provenance: the static analysis (missing-prerequisite chain, code-path
> derivation) and the KASAN reproducer above were both produced by our
> internal AI-assisted backport triage pipeline. I have personally
> reviewed the reasoning line-by-line against the 5.15.y source, re-ran
> the reproducer end-to-end, and confirm the finding — sending it upstream
> on that basis.

That's LLM output, what do you mean to say here to fix this?  Please
send a patch...

thanks,

greg k-h
