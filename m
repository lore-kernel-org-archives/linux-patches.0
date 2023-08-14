Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF5CC2C1
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 15:57:25 +0000 (UTC)
Received: from [78.30.34.192] (port=51654 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1qVZh2-003wZp-7B; Mon, 14 Aug 2023 17:41:22 +0200
Date: Mon, 14 Aug 2023 17:41:19 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 6.4 090/206] netfilter: nf_tables: dont skip expired
 elements during walk
Message-ID: <ZNpLHwZ6VlaJjQD1@calendula>
References: <20230813211724.969019629@linuxfoundation.org>
 <20230813211727.651202695@linuxfoundation.org>
 <20230813221730.GA22068@breakpoint.cc>
 <2023081418-goes-vitally-3c6f@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2023081418-goes-vitally-3c6f@gregkh>
X-Spam-Score: -1.9 (-)

On Mon, Aug 14, 2023 at 05:14:48PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Aug 14, 2023 at 12:17:30AM +0200, Florian Westphal wrote:
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > From: Florian Westphal <fw@strlen.de>
> > > 
> > > commit 24138933b97b055d486e8064b4a1721702442a9b upstream.
> > 
> > Just FYI, this change is not correct.
> > 
> > > There is an asymmetry between commit/abort and preparation phase if the
> > > following conditions are met:
> > 
> > > 1. set is a verdict map ("1.2.3.4 : jump foo")
> > > 2. timeouts are enabled
> > 
> > [..]
> > 
> > > --- a/net/netfilter/nft_set_pipapo.c
> > > +++ b/net/netfilter/nft_set_pipapo.c
> > > @@ -566,8 +566,7 @@ next_match:
> > >  			goto out;
> > >  
> > >  		if (last) {
> > > -			if (nft_set_elem_expired(&f->mt[b].e->ext) ||
> > > -			    (genmask &&
> > > +			if ((genmask &&
> > >  			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
> > >  				goto next_match;
> > 
> > This part is bonkers, it papers over the real issue and introduces
> > another bug while at it (insertions for key K will fail if we have
> > a key K that is already expired).
> > 
> > A patch to resolve it is queued on the mailing list and I'll make sure
> > it gets passed to the net tree by this wednesday.
> > 
> > Sorry for the inconvenience, I hope this doesn't interefere with
> > -stable release plans and this is leaves enough time for
> > the fix to make it to -stable too.
> 
> Is there an upstream fix for this yet?  If so, I can pull it into the
> stable tree, or should I drop this one for now and wait for the real
> fix?  It's your call.

I'd suggest: Drop it for 5.10, 5.15 and 6.1, because these versions
are still missing the full series.

Keep it for 6.4 (this already have the full series with fixed) the
incremental fix that is flying upstream will event amend this patch.

In summary:

- drop it for 5.10, 5.15 and 6.1
- keep it for 6.4

Thanks
