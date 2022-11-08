Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386DA6AA6
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 17:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539EBC433D6;
	Tue,  8 Nov 2022 17:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667928244;
	bh=Y6Ryl9oZa2ISdQBf49JkwE28vnGmSUeJ0iARZBq+FK4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vq9Uvv9J4tUCm0hNqvMZIIwRsNSWyPCHwY3yc3w5LepROTghTUzEEu4XP1svCgUt3
	 qRaWxtUhJ+J9Pe0qlSwNsgldrFWISU6kwJeDdyFGXujWHFqP58TOoe/fs11e5m3Q86
	 CwEkQIHrtRX/xQ66hPp0kxJOo9Nuos/7VQo2ATvQ=
Date: Tue, 8 Nov 2022 18:24:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Kevin Tian <kevin.tian@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 003/197] drm/i915/gvt: Add missing
 vfio_unregister_group_dev() call
Message-ID: <Y2qQsNt6VAJBL9rU@kroah.com>
References: <20221108133354.787209461@linuxfoundation.org>
 <20221108133354.938359604@linuxfoundation.org>
 <20221108091651.716e3124.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108091651.716e3124.alex.williamson@redhat.com>

On Tue, Nov 08, 2022 at 09:16:51AM -0700, Alex Williamson wrote:
> On Tue,  8 Nov 2022 14:37:21 +0100
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > 
> > [ Upstream commit f423fa1bc9fe1978e6b9f54927411b62cb43eb04 ]
> > 
> > When converting to directly create the vfio_device the mdev driver has to
> > put a vfio_register_emulated_iommu_dev() in the probe() and a pairing
> > vfio_unregister_group_dev() in the remove.
> > 
> > This was missed for gvt, add it.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: 978cf586ac35 ("drm/i915/gvt: convert to use vfio_register_emulated_iommu_dev")
> > Reported-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Link: https://lore.kernel.org/r/0-v1-013609965fe8+9d-vfio_gvt_unregister_jgg@nvidia.com
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/gpu/drm/i915/gvt/kvmgt.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > index e3cd58946477..dacd57732dbe 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1595,6 +1595,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
> >  
> >  	if (WARN_ON_ONCE(vgpu->attached))
> >  		return;
> > +	vfio_unregister_group_dev(&vgpu->vfio_device);
> >  	intel_gvt_destroy_vgpu(vgpu);
> >  }
> >  
> 
> Nak, the v6.0 backport for this also needs to call
> vfio_uninit_group_dev().  kvmgt had missed both calls, but at the time
> of f423fa1bc9fe this latter missing call had already been replaced by
> vfio_put_device() in a5ddd2a99a7a, where cb9ff3f3b84c had implemented a
> device release function with this call.  The correct backport should be:
> 
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index e3cd58946477..2404d856f764 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1595,6 +1595,8 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>  
>  	if (WARN_ON_ONCE(vgpu->attached))
>  		return;
> +	vfio_unregister_group_dev(&vgpu->vfio_device);
> +	vfio_uninit_group_dev(&vgpu->vfio_device);
>  	intel_gvt_destroy_vgpu(vgpu);
>  }
>  
> Kevin, Yi, please confirm.  Thanks,

Can you submit a real backport for this?  I'll go drop this one for now.

thanks,

greg k-h
