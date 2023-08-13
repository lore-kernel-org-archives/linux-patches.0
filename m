Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0989445
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 22:38:51 +0000 (UTC)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1qVJOs-0006Vk-J9; Mon, 14 Aug 2023 00:17:30 +0200
Date: Mon, 14 Aug 2023 00:17:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 6.4 090/206] netfilter: nf_tables: dont skip expired
 elements during walk
Message-ID: <20230813221730.GA22068@breakpoint.cc>
References: <20230813211724.969019629@linuxfoundation.org>
 <20230813211727.651202695@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230813211727.651202695@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> commit 24138933b97b055d486e8064b4a1721702442a9b upstream.

Just FYI, this change is not correct.

> There is an asymmetry between commit/abort and preparation phase if the
> following conditions are met:

> 1. set is a verdict map ("1.2.3.4 : jump foo")
> 2. timeouts are enabled

[..]

> --- a/net/netfilter/nft_set_pipapo.c
> +++ b/net/netfilter/nft_set_pipapo.c
> @@ -566,8 +566,7 @@ next_match:
>  			goto out;
>  
>  		if (last) {
> -			if (nft_set_elem_expired(&f->mt[b].e->ext) ||
> -			    (genmask &&
> +			if ((genmask &&
>  			     !nft_set_elem_active(&f->mt[b].e->ext, genmask)))
>  				goto next_match;

This part is bonkers, it papers over the real issue and introduces
another bug while at it (insertions for key K will fail if we have
a key K that is already expired).

A patch to resolve it is queued on the mailing list and I'll make sure
it gets passed to the net tree by this wednesday.

Sorry for the inconvenience, I hope this doesn't interefere with
-stable release plans and this is leaves enough time for
the fix to make it to -stable too.
