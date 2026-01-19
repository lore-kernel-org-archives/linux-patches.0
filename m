Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7095280A52;
	Mon, 19 Jan 2026 11:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768821331; cv=none; b=m2f+5K0Dy3S3YMc4ZYljR1UD1sh0AWafEUswQb7PvhdxwPOHKK6jUeDqNEfar14NlwzCbIaN8SEkW3TWa7sWaGl+VEQsGrFQ7JglQRYt9qH8bjXSFApondEIhHrdl5K1xJcyOQyZBMklue+DXOd5jPPwJGSQDpv5Ws89qRowIR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768821331; c=relaxed/simple;
	bh=Q5L9VM9ErkjApesPY/jY+hDGgTywtx+xieULrd4/H44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rxT5PtZokTGilidLwueYLcsES334zK1nC0UxrMdTcOiKufvRhv0yIM8UnsPRfQh6xXNZVkBPrVhLMc6ONPo4hG/UnV89y+0a9Qd/F7pQhIylUqb/waroXcVTzcLIYF78PXGHREBvyjzCVFAZV7TtBCcJqQ8SvFtm7Xoyl2keHbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcAyiuJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcAyiuJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BD2C19423;
	Mon, 19 Jan 2026 11:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768821331;
	bh=Q5L9VM9ErkjApesPY/jY+hDGgTywtx+xieULrd4/H44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fcAyiuJMsuL4LhNMlPkMbQCZ+Wc6tL454zFyk6ZJqVOyH0KkH5UZfa9ZxWlfCJbm9
	 dTm6d2KcsnsBAtC1IvueX9hYzAlr6WiJn0bOMgEYE1UJ4O+lTRIVIC9U4zWVzx5IWA
	 gxezrI+UWHd7lZ/Dy0MiSAmuLvhcP9yiIBdTH6ho=
Date: Mon, 19 Jan 2026 12:15:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Kevin Hao <kexin.hao@windriver.com>,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 5.10 335/451] net: macb: Relocate mog_init_rings()
 callback from macb_mac_link_up() to macb_open()
Message-ID: <2026011921-nugget-brunt-a836@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164243.014159406@linuxfoundation.org>
 <ddc7d38473d222cd9c2e332a387989d3af50d6e4.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddc7d38473d222cd9c2e332a387989d3af50d6e4.camel@decadent.org.uk>

On Sun, Jan 18, 2026 at 03:49:39PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:48 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Xiaolei Wang <xiaolei.wang@windriver.com>
> > 
> > commit 99537d5c476cada9cf75aef9fa75579a31faadb9 upstream.
> [...]
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -654,7 +654,6 @@ static void macb_mac_link_up(struct phyl
> >  		/* Initialize rings & buffers as clearing MACB_BIT(TE) in link down
> >  		 * cleared the pipeline and control registers.
> >  		 */
> > -		bp->macbgem_ops.mog_init_rings(bp);
> >  		macb_init_buffers(bp);
> >  
> >  		for (q = 0, queue = bp->queues; q < bp->num_queues; ++q, ++queue)
> > @@ -2287,6 +2286,8 @@ static void gem_init_rings(struct macb *
> >  	unsigned int q;
> >  	int i;
> >  
> > +	bp->macbgem_ops.mog_init_rings(bp);
> > +
> 
> This is in the wrong function; it needs to be inserted in macb_open() as
> in the upstream version.

Now dropped.

thanks,

greg k-h
