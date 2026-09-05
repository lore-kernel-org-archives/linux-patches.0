Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC33C3033CB;
	Sat,  5 Sep 2026 11:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788607070; cv=none; b=a7xOHDqgxylc5BmN3m6abC+qq+5HjCBBC4pWY/BVXFaWcm2aVcxCpuFgkNo+j8pgPJxeQntBXRotRjlid+SeTiEuo0w/wFPccjpzmfI8qIooxUgvlveUBB29D397lIr4bdQDznnCnbmkk0kIvu7gDfOP1dtBrkev6Dtjk42ah5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788607070; c=relaxed/simple;
	bh=2L7y5IPt0MZIizYNAqUo5Z5y3MPc9o64xtzjVFo2LWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUpuYX0c7thlRJvPvDyv3mu3D7o3e8fYagG3T2oSBeSEvQKscKMIDM2Ug6YSgwadRJbYjJgM7dzLwNGcG+5YtWFOJT6B48xFqLQU9o83EC1oSebnIQNbPeyQDggEgCB6ValRKCKuOzdG36agXKDyWooBcKFDUjUAmY61O8AlBBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwECcIhH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwECcIhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05A41F00A3D;
	Sat,  5 Sep 2026 11:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788607068;
	bh=KptmeXg+7v8IpatA7BIrQGvikH9X+UtnlnOjLO9epqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OwECcIhH/s9VjOs47n0yKYkzMt6YTuMJiwpUVpzwxaXgE6c2/f2KdSXetVzi2rPxl
	 GiDhcWisaENfmTM+apIZcGpe1wJ19cNV+apfEMWWIoBDMfINskLbrfbH57EW/xOXAw
	 pw0aRsoBgoevsmItlpWNxCAGE/oliBo9AnAGyiMo=
Date: Sat, 5 Sep 2026 13:16:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 5.10 28/43] xfrm: espintcp: fix UAF during close
Message-ID: <2026090558-issue-factoid-6115@gregkh>
References: <20260831133358.571886287@linuxfoundation.org>
 <20260831133359.883892832@linuxfoundation.org>
 <20260904095158.GA83164@j66a10360.sqa.eu95>
 <2026090409-hesitant-hug-bd90@gregkh>
 <20260905101704.GA47841@j66a10360.sqa.eu95>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260905101704.GA47841@j66a10360.sqa.eu95>

On Sat, Sep 05, 2026 at 06:17:04PM +0800, D. Wythe wrote:
> On Fri, Sep 04, 2026 at 02:15:30PM +0200, Greg Kroah-Hartman wrote:
> > On Fri, Sep 04, 2026 at 05:51:58PM +0800, D. Wythe wrote:
> > > On Mon, Aug 31, 2026 at 03:35:36PM +0200, Greg Kroah-Hartman wrote:
> > > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: Sabrina Dubroca <sd@queasysnail.net>
> > > > 
> > > > commit deb232e884877bf10b4ce2580909eedec986c284 upstream.
> > > > 
> > > > ZDI reported and analyzed a race condition during close for espintcp
> > > > sockets:
> > > > 
> > > >     espintcp_close() frees emsg->skb via kfree_skb() without holding
> > > >     any socket lock. Concurrently, the xfrm_trans_reinject work queue
> > > >     invokes esp_output_tcp_finish() -> espintcp_push_skb() ->
> > > >     espintcp_push_msgs() -> skb_send_sock_locked(), which reads the
> > > >     same skb as a data source.
> > > > 
> > > > Fix this by adding a synchronize_rcu() call after resetting sk_prot,
> > > > since esp_output_tcp_finish() runs under RCU and won't use a socket
> > > > with sk_prot == &tcp_prot.  Simply taking the socket lock in
> > > > espintcp_close() could lead to leaks, if esp_output_tcp_finish()
> > > > re-adds an skb in the slot we just freed. After this, the existing
> > > > barrier() is no longer needed.
> > > > 
> > > > Cc: stable@vger.kernel.org
> > > > Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> > > > Reported-by: zdi-disclosures@trendmicro.com
> > > > Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> > > > Reviewed-by: Breno Leitao <leitao@debian.org>
> > > > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > ---
> > > >  net/xfrm/espintcp.c |    3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > 
> > > > --- a/net/xfrm/espintcp.c
> > > > +++ b/net/xfrm/espintcp.c
> > > > @@ -506,7 +506,8 @@ static void espintcp_close(struct sock *
> > > >  	strp_stop(&ctx->strp);
> > > >  
> > > >  	sk->sk_prot = &tcp_prot;
> > > > -	barrier();
> > > > +
> > > > +	synchronize_rcu();
> > > 
> > > 
> > > This backport depends on upstream
> > > 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"),
> > > which is not in 5.15.y. Without it, esp_find_tcp_sk() still
> > > returns the cached x->encap_sk based only on sk_state == TCP_ESTABLISHED
> > > (no tcp_is_ulp_esp() check), so new readers keep racing with
> > > espintcp_close()'s kfree_skb on ctx->partial.emsg->skb — the UAF issue
> > > this patch is supposed to fix.
> > > 
> > > Reproduced on 5.15.219+ (with this patch applied), KASAN trimmed:
> > > 
> > >   BUG: KASAN: use-after-free in __skb_send_sock+0x6cf/0x7b0
> > >   Workqueue: events xfrm_trans_reinject
> > > 
> > >   Reader:
> > >     __skb_send_sock <- espintcp_push_msgs <- espintcp_push_skb <-
> > >     esp_output_tcp_encap_cb <- xfrm_trans_reinject
> > > 
> > >   Free:
> > >     espintcp_close <- inet_release <- __sock_release <- sock_close <-
> > >     __fput
> > > 
> > >   Object: skbuff_head_cache (size 224), i.e. struct sk_buff.
> > > 
> > > Provenance: the static analysis (missing-prerequisite chain, code-path
> > > derivation) and the KASAN reproducer above were both produced by our
> > > internal AI-assisted backport triage pipeline. I have personally
> > > reviewed the reasoning line-by-line against the 5.15.y source, re-ran
> > > the reproducer end-to-end, and confirm the finding — sending it upstream
> > > on that basis.
> > 
> > That's LLM output, what do you mean to say here to fix this?  Please
> > send a patch...
> 
> Hi Greg,
> 
> Sorry about the confusion. Just to clarify, this is not raw LLM output.
> I only included that note to be transparent and avoid any controversy,
> as the issue wasn't initially discovered by myself.
> 
> We actually already have a patch prepared for this, but the situation is
> a bit more complicated.
> 
> The fix actually has two prerequisite dependencies:
> 
> Commit 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"), as mentioned earlier.
> Commit e1512c1db9e8 ("espintcp: Fix race condition in espintcp_close()"), which relies on disable_work_sync() — an API that
> does not exist in the 5.10 tree.
> 
> To avoid expanding the blast radius, we chose to use an alternative
> approach in espintcp to replace the implementation of commit
> e1512c1db9e8: introducing a stopped flag and protecting both the flag
> check and schedule_work() under the existing out_queue.lock spinlock,
> achieving the same atomic synchronization effect as
> disable_work_sync().
> 
> However, doing this inevitably leads to code divergence between upstream
> and this tree for xfrm. I'm not sure what the xfrm folks' stance is on
> this. If the community feels this is overly complicated, I think it's
> also totally fine to just leave the patch here.

Please always take the upstream commits when ever possible.  But the
disable_work_sync() stuff is messier, so if you just wait a few more
months, it's not going to be an issue as the 5.10.y tree will be
end-of-life by then :)

So, why not move to a newer kernel tree now?

thanks,

greg k-h
