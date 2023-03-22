Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0138F58
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 18:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pneM1iKBldwm07CiyE2tReaQ4kBY/JdcBsq7MfQvOl0=; b=dfhdcJmmA9LPV0Q6VSEifeeuBi
	3sIu352OsPIwgGuf4hkJ6WqcaRnTDtxGNMr6RiT520TD3OvsNbSknwDkdxufBa31SUmbY1bNKPvbn
	mNIv4vzGKw/KjJe/FxrAu4MHtYxviDbL0MdvMH9mtk8yzRkGPXUFq7ipnr78DoivZfylCmBpQFM1F
	czoADtwM3JV/0v4Zf74uSDKnC7/qJ5sI+H6QmbMAe7GcOYLiZ2juJYE9F45FVU3Yw6dG3m0Fzh/lh
	pHTqn/Ds6EnqglkcZi08kehpIWEz4kX7XSIupFLZo7yK88BFsbjOYXj6lURNY55CtS/qJ6J5BI3TQ
	CkX3kY8Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pf2pW-00Gx8K-0g;
	Wed, 22 Mar 2023 18:04:58 +0000
Date: Wed, 22 Mar 2023 11:04:58 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: colin.i.king@gmail.com, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
	pmladek@suse.com, david@redhat.com, petr.pavlu@suse.com,
	prarit@redhat.com
Cc: christophe.leroy@csgroup.eu, song@kernel.org, dave@stgolabs.net,
	a.manzanares@samsung.com, fan.ni@samsung.com,
	vincent.fu@samsung.com
Subject: Re: [PATCH v3] stress-module: stress finit_module() and
 delete_module()
Message-ID: <ZBtDSh6f+rWqFLtC@bombadil.infradead.org>
References: <20230322032350.3439056-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322032350.3439056-1-mcgrof@kernel.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, Mar 21, 2023 at 08:23:50PM -0700, Luis Chamberlain wrote:
> Example uses:
> 
> sudo ./stress-ng --module 1 --module-name xfs
> sudo ./stress-ng --module 1 --module-name xfs --module-sharedfd

The use case with --module 8192 was causing some errors from
stress-ng having unexpected bail out messages before ramp up.

> diff --git a/stress-module.c b/stress-module.c
> new file mode 100644
> index 00000000..cee581bd
> --- /dev/null
> +++ b/stress-module.c
> +			//snprintf(module_path, strlen(module_path), "%s/%s/%s",
> +			snprintf(module_path, PATH_MAX*2, "%s/%s/%s",
> +				 dirname_default_prefix,
> +				 u.release, module);
> +			ret = 0;

I forgot to remove this stray comment.

> +	/*
> +	 * We're not stressing the modules.dep --> module path lookup,
> +	 * just the finit_module() calls and so only do the lookup once.
> +	 */
> +	if (args->instance != 0) {
> +		if (!module_path_found)
> +			return EXIT_SUCCESS;
> +	}

So here was the reason for the complaints, Although changing this to
return just EXIT_NO_RESOURCE cures the warning, I don't think the
non instance 0 workers are doing anything then. Is that right Collin?

  Luis
