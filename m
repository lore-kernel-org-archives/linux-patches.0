Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38C662A
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 11:43:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355ECC433C8;
	Sat, 22 Jul 2023 11:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690026207;
	bh=6Xf+k8zPjvPWGOfOq+ugj5rX3AEggB3v4zSBYR6lUVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F+UWySnfQXczNTVc813Esac68o761t58Tcx25BPV2bm6KsbwM2dFsollOdmmIg8sn
	 +cwbw0EjHXjl4bdt1cNQM5MrzpZNa8dB9/kYnk92QBg2pObfqdqQJzqT9dOltjxfWU
	 zoEI3W+88PGlasanf/czLDmbA5raK2OC2jZ4k3s4=
Date: Sat, 22 Jul 2023 13:43:25 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas Backlund <tmb@tmb.nu>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	"Pelloux-Prayer, Pierre-Eric" <Pierre-eric.Pelloux-prayer@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Pelloux-Prayer@vger.kernel.org
Subject: Re: [PATCH 6.4 213/292] drm/ttm: never consider pinned BOs for
 eviction&swap
Message-ID: <2023072207-bagginess-opal-a71f@gregkh>
References: <ccf59286-1698-3f02-e472-edda5208c58d@tmb.nu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ccf59286-1698-3f02-e472-edda5208c58d@tmb.nu>

On Fri, Jul 21, 2023 at 04:51:01PM +0000, Thomas Backlund wrote:
> Den 2023-07-21 kl. 19:05, skrev Greg Kroah-Hartman:
> > From: Christian König <christian.koenig@amd.com>
> > 
> > commit a2848d08742c8e8494675892c02c0d22acbe3cf8 upstream.
> > 
> > There is a small window where we have already incremented the pin count
> > but not yet moved the bo from the lru to the pinned list.
> > 
> > Signed-off-by: Christian König <christian.koenig@amd.com>
> > Reported-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.com>
> > Tested-by: Pelloux-Prayer, Pierre-Eric <Pierre-eric.Pelloux-prayer@amd.com>
> > Acked-by: Alex Deucher <alexander.deucher@amd.com>
> > Cc: stable@vger.kernel.org
> > Link: https://patchwork.freedesktop.org/patch/msgid/20230707120826.3701-1-christian.koenig@amd.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >   drivers/gpu/drm/ttm/ttm_bo.c |    6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > --- a/drivers/gpu/drm/ttm/ttm_bo.c
> > +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> > @@ -517,6 +517,12 @@ static bool ttm_bo_evict_swapout_allowab
> >   {
> >   	bool ret = false;
> >   
> > +	if (bo->pin_count) {
> > +		*locked = false;
> > +		*busy = false;
> > +		return false;
> > +	}
> > +
> >   	if (bo->base.resv == ctx->resv) {
> >   		dma_resv_assert_held(bo->base.resv);
> >   		if (ctx->allow_res_evict)
> > 
> 
> 
> This one will trigger GPF and needs a follow-up fix that is not upstream 
> yet:
> https://patchwork.freedesktop.org/patch/547897/
> 
> as reported on LKML in thread:
> [bug/bisected] commit a2848d08742c8e8494675892c02c0d22acbe3cf8 cause 
> general protection fault, probably for non-canonical address 
> 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN NOPTI

Thanks for letting me know, I've dropped this from the queues now.
Please let us know when we should add it back.

greg k-h
