Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E762046BA
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 18:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733856305; cv=none; b=hK/0s5LtplnAujZGXyauu/F6rMWRiNVqZgvtKi+1IN4D4Gm7TQlVnx77SaPN3C6ZVXxLYsIZ0gSQco5KubeIUK1ToUm84NdInR+BEjk74m+rh1fbUcE7Nif613GhBUce/iKKwyKoDXMP5ZOPoLSEcKiQioD1DLIPuJMxS8mt2JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733856305; c=relaxed/simple;
	bh=j+Z1qvM5ugs6/4cGw47Qw9wyUTYQHQGjrgLVpwHAnWM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pVlK1N+JXyiPLdZedV7l81Qiq2cHZpRtPaJmKzrxsspkvDHZpjMe5N8AGV/iBXglDwohL73hXXZwhZN6+dxX5qYkHnIKluVB3vadgdlCHZPdNlVdUwbqEz73iSWfLeOXgSqS1FS2cYPyTQCWf0RvA10X6syv5pnPRl5rdBPz6+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=I6FRQRAU; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="I6FRQRAU"
Date: Tue, 10 Dec 2024 13:44:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733856301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ilz04oS/JfHaPRfW+yjAezYUtWHIZRjfnXEUvByXN4I=;
	b=I6FRQRAUef0SbSJ2zYdP1i5mfSM0/LuBOLJKnrpkdd/iNdHF8ffacVHW8ZsCMbt7w6Vq+5
	8Vl6A1oCZrdP0HR/54vGSkzE4/UZK6bLKpV5L7nmSNloh7aO5XBp6Dd7PjKyeKPg+vNIf9
	WomVJYTYpyXH+VALEXQt3P50TgJT8fM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-bcachefs@vger.kernel.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bcachefs: Add empty statement between label and
 declaration in check_inode_hash_info_matches_root()
Message-ID: <qnfn3xzh6ve5cukeugxucloynbstf2itos3ddlmzu2w4sp7md7@7bkk2byif2ja>
References: <20241210-bcachefs-fix-declaration-after-label-err-v1-1-22c705fc47e8@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210-bcachefs-fix-declaration-after-label-err-v1-1-22c705fc47e8@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 10, 2024 at 11:12:07AM -0700, Nathan Chancellor wrote:
> Clang 18 and newer warns (or errors with CONFIG_WERROR=y):
> 
>   fs/bcachefs/str_hash.c:164:2: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
>     164 |         struct bch_inode_unpacked inode;
>         |         ^
> 
> In Clang 17 and prior, this is an unconditional hard error:
> 
>   fs/bcachefs/str_hash.c:164:2: error: expected expression
>     164 |         struct bch_inode_unpacked inode;
>         |         ^
>   fs/bcachefs/str_hash.c:165:30: error: use of undeclared identifier 'inode'
>     165 |         ret = bch2_inode_unpack(k, &inode);
>         |                                     ^
>   fs/bcachefs/str_hash.c:169:55: error: use of undeclared identifier 'inode'
>     169 |         struct bch_hash_info hash2 = bch2_hash_info_init(c, &inode);
>         |                                                              ^
>   fs/bcachefs/str_hash.c:171:40: error: use of undeclared identifier 'inode'
>     171 |                 ret = repair_inode_hash_info(trans, &inode);
>         |                                                      ^
> 
> Add an empty statement between the label and the declaration to fix the
> warning/error without disturbing the code too much.

This is different than what I would have done, and I like it :)

> 
> Fixes: 2519d3b0d656 ("bcachefs: bch2_str_hash_check_key() now checks inode hash info")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202412092339.QB7hffGC-lkp@intel.com/
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> If you would prefer to fix this in a different way, just consider this
> an additional report.
> ---
>  fs/bcachefs/str_hash.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/bcachefs/str_hash.c b/fs/bcachefs/str_hash.c
> index ed3c852fc0befa69fabe90ab83d439986be36b42..f5977c5c67430688c8a2a31fa39115f231d5a167 100644
> --- a/fs/bcachefs/str_hash.c
> +++ b/fs/bcachefs/str_hash.c
> @@ -160,7 +160,7 @@ static int check_inode_hash_info_matches_root(struct btree_trans *trans, u64 inu
>  	bch_err(c, "%s(): inum %llu not found", __func__, inum);
>  	ret = -BCH_ERR_fsck_repair_unimplemented;
>  	goto err;
> -found:
> +found:;
>  	struct bch_inode_unpacked inode;
>  	ret = bch2_inode_unpack(k, &inode);
>  	if (ret)
> 
> ---
> base-commit: dd7d7f29a7c77d02264097e7b42073a902765c49
> change-id: 20241210-bcachefs-fix-declaration-after-label-err-b16b57d634fb
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
