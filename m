Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0613C2D
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 10:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788603755; cv=none; b=oSzhdFQ57nImKQLXMRvWG+YwyTrlbYkoUlVpvaCH0kt3F78dDVwQ/qtya3oCyqPS5/Mlg6sbe9yTBY2ncrvaYL9kTorVwwk0mIZrwC2uFIo7rJ2jtyveWxQp5UVYHHWzYGHoMYG1y9VrZB9OTjdovh6fiAUDaiPU9euNYPUFwRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788603755; c=relaxed/simple;
	bh=3KNj/R7KYC6Zziw5jEB1qygNDTJatM/loAz/jQBWuJA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEeAYa6JAfuPcXx/w7NL21yxQF74+NrzGBLyuaWN4bM3qXKneLQQnJTuMFupNoyBwgJvK5oZecQijuHqKfgCflaCrMt7SVa272X7jM9js4rHPP2bazipzATz72Twb5M0gacaGDRQQ+Qr9lVOHORGQlTFdh1bkE3lFUVLRFucLpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=wSajH08w; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="wSajH08w"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788603744; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=2eP3KCWIc7gStt5fjI//Pxfe5oYZySF3OBJ8UfVxGIQ=;
	b=wSajH08wTEA238nENtCPxhx1ZgBa5y1/5vrJ5HkX4/NRirgKRzH5m7gdBUk1hGAwOz4JhY5cvRKLJWsb83F2T+mgPHKINAi+GP8JSWRqevx3CrPF23Lgt1wIIqRXud2Rjy/yjlDBK2aVsL3P3oabPKttE47uDXYuGZT7RO1Tqrc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XAKnuHb_1788603424;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0XAKnuHb_1788603424 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 05 Sep 2026 18:17:05 +0800
Date: Sat, 5 Sep 2026 18:17:04 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com    >
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "D. Wythe" <alibuda@linux.alibaba.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 5.10 28/43] xfrm: espintcp: fix UAF during close
Message-ID: <20260905101704.GA47841@j66a10360.sqa.eu95>
References: <20260831133358.571886287@linuxfoundation.org>
 <20260831133359.883892832@linuxfoundation.org>
 <20260904095158.GA83164@j66a10360.sqa.eu95>
 <2026090409-hesitant-hug-bd90@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2026090409-hesitant-hug-bd90@gregkh>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Sep 04, 2026 at 02:15:30PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Sep 04, 2026 at 05:51:58PM +0800, D. Wythe wrote:
> > On Mon, Aug 31, 2026 at 03:35:36PM +0200, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Sabrina Dubroca <sd@queasysnail.net>
> > > 
> > > commit deb232e884877bf10b4ce2580909eedec986c284 upstream.
> > > 
> > > ZDI reported and analyzed a race condition during close for espintcp
> > > sockets:
> > > 
> > >     espintcp_close() frees emsg->skb via kfree_skb() without holding
> > >     any socket lock. Concurrently, the xfrm_trans_reinject work queue
> > >     invokes esp_output_tcp_finish() -> espintcp_push_skb() ->
> > >     espintcp_push_msgs() -> skb_send_sock_locked(), which reads the
> > >     same skb as a data source.
> > > 
> > > Fix this by adding a synchronize_rcu() call after resetting sk_prot,
> > > since esp_output_tcp_finish() runs under RCU and won't use a socket
> > > with sk_prot == &tcp_prot.  Simply taking the socket lock in
> > > espintcp_close() could lead to leaks, if esp_output_tcp_finish()
> > > re-adds an skb in the slot we just freed. After this, the existing
> > > barrier() is no longer needed.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> > > Reported-by: zdi-disclosures@trendmicro.com
> > > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > > Reviewed-by: Breno Leitao <leitao@debian.org>
> > > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  net/xfrm/espintcp.c |    3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > --- a/net/xfrm/espintcp.c
> > > +++ b/net/xfrm/espintcp.c
> > > @@ -506,7 +506,8 @@ static void espintcp_close(struct sock *
> > >  	strp_stop(&ctx->strp);
> > >  
> > >  	sk->sk_prot = &tcp_prot;
> > > -	barrier();
> > > +
> > > +	synchronize_rcu();
> > 
> > 
> > This backport depends on upstream
> > 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"),
> > which is not in 5.15.y. Without it, esp_find_tcp_sk() still
> > returns the cached x->encap_sk based only on sk_state == TCP_ESTABLISHED
> > (no tcp_is_ulp_esp() check), so new readers keep racing with
> > espintcp_close()'s kfree_skb on ctx->partial.emsg->skb — the UAF issue
> > this patch is supposed to fix.
> > 
> > Reproduced on 5.15.219+ (with this patch applied), KASAN trimmed:
> > 
> >   BUG: KASAN: use-after-free in __skb_send_sock+0x6cf/0x7b0
> >   Workqueue: events xfrm_trans_reinject
> > 
> >   Reader:
> >     __skb_send_sock <- espintcp_push_msgs <- espintcp_push_skb <-
> >     esp_output_tcp_encap_cb <- xfrm_trans_reinject
> > 
> >   Free:
> >     espintcp_close <- inet_release <- __sock_release <- sock_close <-
> >     __fput
> > 
> >   Object: skbuff_head_cache (size 224), i.e. struct sk_buff.
> > 
> > Provenance: the static analysis (missing-prerequisite chain, code-path
> > derivation) and the KASAN reproducer above were both produced by our
> > internal AI-assisted backport triage pipeline. I have personally
> > reviewed the reasoning line-by-line against the 5.15.y source, re-ran
> > the reproducer end-to-end, and confirm the finding — sending it upstream
> > on that basis.
> 
> That's LLM output, what do you mean to say here to fix this?  Please
> send a patch...

Hi Greg,

Sorry about the confusion. Just to clarify, this is not raw LLM output.
I only included that note to be transparent and avoid any controversy,
as the issue wasn't initially discovered by myself.

We actually already have a patch prepared for this, but the situation is
a bit more complicated.

The fix actually has two prerequisite dependencies:

Commit 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"), as mentioned earlier.
Commit e1512c1db9e8 ("espintcp: Fix race condition in espintcp_close()"), which relies on disable_work_sync() — an API that
does not exist in the 5.10 tree.

To avoid expanding the blast radius, we chose to use an alternative
approach in espintcp to replace the implementation of commit
e1512c1db9e8: introducing a stopped flag and protecting both the flag
check and schedule_work() under the existing out_queue.lock spinlock,
achieving the same atomic synchronization effect as
disable_work_sync().

However, doing this inevitably leads to code divergence between upstream
and this tree for xfrm. I'm not sure what the xfrm folks' stance is on
this. If the community feels this is overly complicated, I think it's
also totally fine to just leave the patch here.

Thanks,
D. Wythe

> 
> thanks,
> 
> greg k-h
