Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0CA97F47D
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 13:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583086; cv=none; b=U2bs3ADXVvh3jKicIppWiUa4Jo0DmQu0i6dwu2bhCB49mdPmeTG479pGY4LFFaXZI4+hqhh4jSIW8qFDuKNkqDOkeWiePR3ai+fQfETOeBNHxbZvkgP7vkNN9bePleXHb0FXZzOHYjdLBQlp3cUshK6EB/dxhJVGUF3L40A4Ei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583086; c=relaxed/simple;
	bh=DAhJAiO2i2a2A4qNmC6sTn4NX9CYgw9Pum8hB3Y5ddA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S483JyC7Xidfe99tI65RU2xjhB9eUF/EOfIhyOLAWdkCaBOyxeLs/bvXigvCAIZZGeILnDxg91ZybDz/MZMD9tZH2stnXMO+qLTPaxFavcJHH8qSd0Wr0cTuZy44U047Lgxu2csof0P7TW+Ifs8oMrWNuRFC/ncTtjdXIlIlIBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Mon, 8 Apr 2024 15:31:15 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.8 046/273] netfilter: nf_tables: reject table flag and
 netdev basechain updates
Message-ID: <ZhPxo5aJctUtO4Go@calendula>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125310.727931386@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240408125310.727931386@linuxfoundation.org>

On Mon, Apr 08, 2024 at 02:55:21PM +0200, Greg Kroah-Hartman wrote:
> 6.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ Upstream commit 1e1fb6f00f52812277963365d9bd835b9b0ea4e0 ]
> 
> netdev basechain updates are stored in the transaction object hook list.
> When setting on the table dormant flag, it iterates over the existing
> hooks in the basechain. Thus, skipping the hooks that are being
> added/deleted in this transaction, which leaves hook registration in
> inconsistent state.
> 
> Reject table flag updates in combination with netdev basechain updates
> in the same batch:
> 
> - Update table flags and add/delete basechain: Check from basechain update
>   path if there are pending flag updates for this table.
> - add/delete basechain and update table flags: Iterate over the transaction
>   list to search for basechain updates from the table update path.
> 
> In both cases, the batch is rejected. Based on suggestion from Florian Westphal.
> 
> Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
> Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++++++++++++++-
>  1 file changed, 30 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 00288b31f734c..db233965631bb 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1198,6 +1198,25 @@ static void nf_tables_table_disable(struct net *net, struct nft_table *table)
>  #define __NFT_TABLE_F_UPDATE		(__NFT_TABLE_F_WAS_DORMANT | \
>  					 __NFT_TABLE_F_WAS_AWAKEN)
>  
> +static bool nft_table_pending_update(const struct nft_ctx *ctx)
> +{
> +	struct nftables_pernet *nft_net = nft_pernet(ctx->net);
> +	struct nft_trans *trans;
> +
> +	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
> +		return true;
> +
> +	list_for_each_entry(trans, &nft_net->commit_list, list) {
> +		if ((trans->msg_type == NFT_MSG_NEWCHAIN ||
                ^.........................................^

Remove this, only update is narrowed down.

Thanks.

> +		     trans->msg_type == NFT_MSG_DELCHAIN) &&
> +		    trans->ctx.table == ctx->table &&
> +		    nft_trans_chain_update(trans))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
>  static int nf_tables_updtable(struct nft_ctx *ctx)
>  {
>  	struct nft_trans *trans;
> @@ -1221,7 +1240,7 @@ static int nf_tables_updtable(struct nft_ctx *ctx)
>  		return -EOPNOTSUPP;
>  
>  	/* No dormant off/on/off/on games in single transaction */
> -	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
> +	if (nft_table_pending_update(ctx))
>  		return -EINVAL;
>  
>  	trans = nft_trans_alloc(ctx, NFT_MSG_NEWTABLE,
> @@ -2619,6 +2638,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
>  		}
>  	}
>  
> +	if (table->flags & __NFT_TABLE_F_UPDATE &&
> +	    !list_empty(&hook.list)) {
> +		NL_SET_BAD_ATTR(extack, attr);
> +		err = -EOPNOTSUPP;
> +		goto err_hooks;
> +	}
> +
>  	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
>  	    nft_is_base_chain(chain) &&
>  	    !list_empty(&hook.list)) {
> @@ -2848,6 +2874,9 @@ static int nft_delchain_hook(struct nft_ctx *ctx,
>  	struct nft_trans *trans;
>  	int err;
>  
> +	if (ctx->table->flags & __NFT_TABLE_F_UPDATE)
> +		return -EOPNOTSUPP;
> +
>  	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
>  				   ctx->family, chain->flags, extack);
>  	if (err < 0)
> -- 
> 2.43.0
> 
> 
> 
