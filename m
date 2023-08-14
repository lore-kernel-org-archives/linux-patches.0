Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9076C139
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 16:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFFE8C433C8;
	Mon, 14 Aug 2023 16:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692029476;
	bh=lMjlapqeyDzouK7rBxj3XpLytHXl61DbEVPIrXEm/Cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GRy/tMndOIDvb4+cNw875AafCPE/NdBqhjGP64kJGA93iLmZTGzACbbngw9yz98Ga
	 jjTTvsE2XIjX+Wy2vfC7jFJ12H4Z9j9rVnrAgZBuKiUgFXd7Bpibk51AdPBF3zAie0
	 epGnvlUonikjtRU2tgCUSJqi1wxrdiIAF5qyums4=
Date: Mon, 14 Aug 2023 18:11:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 6.4 090/206] netfilter: nf_tables: dont skip expired
 elements during walk
Message-ID: <2023081404-quality-shindig-552b@gregkh>
References: <20230813211724.969019629@linuxfoundation.org>
 <20230813211727.651202695@linuxfoundation.org>
 <20230813221730.GA22068@breakpoint.cc>
 <2023081418-goes-vitally-3c6f@gregkh>
 <ZNpLHwZ6VlaJjQD1@calendula>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZNpLHwZ6VlaJjQD1@calendula>

On Mon, Aug 14, 2023 at 05:41:19PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 14, 2023 at 05:14:48PM +0200, Greg Kroah-Hartman wrote:
> > On Mon, Aug 14, 2023 at 12:17:30AM +0200, Florian Westphal wrote:
> > > Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > From: Florian Westphal <fw@strlen.de>
> > > > 
> > > > commit 24138933b97b055d486e8064b4a1721702442a9b upstream.
> > > 
> > > Just FYI, this change is not correct.
> > > 
> > > > There is an asymmetry between commit/abort and preparation phase if the
> > > > following conditions are met:
> > > 
> > > > 1. set is a verdict map ("1.2.3.4 : jump foo")
> > > > 2. timeouts are enabled
> > > 
> > > [..]
> > > 
> > > > --- a/net/netfilter/nft_set_pipapo.c
> > > > +++ b/net/netfilter/nft_set_pipapo.c
> > > > @@ -566,8 +566,7 @@ next_match:
> > > >  			goto out;
> > > >  
> > > >  		if (last) {
> > > > -			if (nft_set_elem_expired(&f->mt[b].e->ext) ||
> > > > -			    (genmask &&
> > > > +			if ((genmask &&
> > > >  			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
> > > >  				goto next_match;
> > > 
> > > This part is bonkers, it papers over the real issue and introduces
> > > another bug while at it (insertions for key K will fail if we have
> > > a key K that is already expired).
> > > 
> > > A patch to resolve it is queued on the mailing list and I'll make sure
> > > it gets passed to the net tree by this wednesday.
> > > 
> > > Sorry for the inconvenience, I hope this doesn't interefere with
> > > -stable release plans and this is leaves enough time for
> > > the fix to make it to -stable too.
> > 
> > Is there an upstream fix for this yet?  If so, I can pull it into the
> > stable tree, or should I drop this one for now and wait for the real
> > fix?  It's your call.
> 
> I'd suggest: Drop it for 5.10, 5.15 and 6.1, because these versions
> are still missing the full series.
> 
> Keep it for 6.4 (this already have the full series with fixed) the
> incremental fix that is flying upstream will event amend this patch.
> 
> In summary:
> 
> - drop it for 5.10, 5.15 and 6.1
> - keep it for 6.4

Ok, thanks, now dropped for those trees.

greg k-h
