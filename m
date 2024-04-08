Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85EA485C6C
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 13:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583326; cv=none; b=RGwovAz849HV1lUyDziuWBhHN2hn0Xl6fCwQrinINJs33FDNl4SK3DObm8H8eOudkG2LPZBuzUxXxAivyJ1Ax4w0zpeB6rFNGuR1U4uM73px5zNcCm0NI/pyqbLRvgr4lkKJdyUYlrtGTlUVOrVfj5pfBoRSXBgQOM1uog0a7gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583326; c=relaxed/simple;
	bh=QzID8QBM4d0TPssMG/Zyt2dw7OJJF0xwNDkHYAmuFSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iNQjIIrbTw//voDWWQxFqrKFcQeaSd9NLqSlOGi18jDSFrmGQlk38eOtCnnP4no4eXf3AjVYK4G32uNWHUD2cMX4/+0efZ8PMhhHEVMi2U+Y2BHgSGOZ+RoOJJYeU4xl8DAexVcwzsSp9L2+dA9onE0zAoL1M/U8lsWY6urkcFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 8 Apr 2024 15:35:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.8 046/273] netfilter: nf_tables: reject table flag and
 netdev basechain updates
Message-ID: <ZhPymMVOJRCLQaWc@calendula>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125310.727931386@linuxfoundation.org>
 <ZhPxo5aJctUtO4Go@calendula>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZhPxo5aJctUtO4Go@calendula>

On Mon, Apr 08, 2024 at 03:31:17PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 08, 2024 at 02:55:21PM +0200, Greg Kroah-Hartman wrote:
> > 6.8-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > [ Upstream commit 1e1fb6f00f52812277963365d9bd835b9b0ea4e0 ]
> > 
> > netdev basechain updates are stored in the transaction object hook list.
> > When setting on the table dormant flag, it iterates over the existing
> > hooks in the basechain. Thus, skipping the hooks that are being
> > added/deleted in this transaction, which leaves hook registration in
> > inconsistent state.
> > 
> > Reject table flag updates in combination with netdev basechain updates
> > in the same batch:
> > 
> > - Update table flags and add/delete basechain: Check from basechain update
> >   path if there are pending flag updates for this table.
> > - add/delete basechain and update table flags: Iterate over the transaction
> >   list to search for basechain updates from the table update path.
> > 
> > In both cases, the batch is rejected. Based on suggestion from Florian Westphal.
> > 
> > Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
> > Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 00288b31f734c..db233965631bb 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -1198,6 +1198,25 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
> >  #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
> >  					 __NFT_TABLE_F_WAS_AWAKEN)
> >  
> > +static bool nft_table_pending_update(const struct nft_ctx *ctx)
> > +{
> > +	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
> > +	struct nft_trans *trans;
> > +
> > +	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
> > +		return true;
> > +
> > +	list_for_each_entry(trans, &nft_net->commit_list, list) {
> > +		if ((trans->msg_type == NFT_MSG_NEWCHAIN ||
>                 ^.........................................^
> 
> Remove this, only update is narrowed down.

Apologies.

Patch is fine.
