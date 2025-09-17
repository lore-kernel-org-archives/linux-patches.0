Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB023195EA;
	Wed, 17 Sep 2025 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120320; cv=none; b=lzCp5mWZM1nvNrruhUOefN76vSxIBQ7aVM8dEimNU+7Iv4cZfZeeojpkt8HubEETvTaiqimqQAYfLPa52ztqQwsn9IYGq+2WnRIH3Bq98DgRiWBBAILSmKDKp6FgZ0sui9epV4tZP40/GT24LtbgyKtXIVcbnQOD5U4eUwsiHxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120320; c=relaxed/simple;
	bh=Br8i+zA9KHjC8IhyjMAdBVOLelHY6tmyjUO0KNKTqug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNJS+jkgpSMaOJfjVQZfpiUoRuO6EK5s16GJUSJK1V/6hhWSvzpxqfn5vb9NVwCvG4bTKBh1cWvufyMHy0Kx7qGSE9jS4kANtUaEoHdGWUp1fxu+QuGiNsUIQHSsMm6bJMjv9D/kkWQ+PfNcgtuqq0DO97V7GxLY6LHvI2OKW90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edPpVoB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edPpVoB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98A2C4CEE7;
	Wed, 17 Sep 2025 14:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758120319;
	bh=Br8i+zA9KHjC8IhyjMAdBVOLelHY6tmyjUO0KNKTqug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=edPpVoB4Zg0/OWohnIzmdDvmRW95dMESbMOeNwO3PylzyLhE3st9gmRCvezpWmAu3
	 A7GptrIuz7Xx3gS/sFUGodQr8In4mRUbM7PyBg6mK3cXEDwcDERQASVRWuG+vN+2Oc
	 jEODuUjYxNE6IUcFJWTdz+59tdm/kjTciTAfVtec=
Date: Wed, 17 Sep 2025 16:45:16 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"cao, lin" <lin.cao@amd.com>,
	"Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>,
	"Koenig, Christian" <Christian.Koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 140/140] drm/amdgpu: fix a memory leak in fence
 cleanup when unloading
Message-ID: <2025091705-massive-easel-553d@gregkh>
References: <20250917123344.315037637@linuxfoundation.org>
 <20250917123347.745396297@linuxfoundation.org>
 <BL1PR12MB5144DD691B4246E3F70302BCF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB5144DD691B4246E3F70302BCF717A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Wed, Sep 17, 2025 at 02:36:32PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Wednesday, September 17, 2025 8:35 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev;
> > cao, lin <lin.cao@amd.com>; Prosyak, Vitaly <Vitaly.Prosyak@amd.com>; Koenig,
> > Christian <Christian.Koenig@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.12 140/140] drm/amdgpu: fix a memory leak in fence cleanup
> > when unloading
> >
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Alex Deucher <alexander.deucher@amd.com>
> >
> > commit 7838fb5f119191403560eca2e23613380c0e425e upstream.
> >
> > Commit b61badd20b44 ("drm/amdgpu: fix usage slab after free") reordered when
> > amdgpu_fence_driver_sw_fini() was called after that patch,
> > amdgpu_fence_driver_sw_fini() effectively became a no-op as the sched entities
> > we never freed because the ring pointers were already set to NULL.  Remove the
> > NULL setting.
> >
> > Reported-by: Lin.Cao <lincao12@amd.com>
> > Cc: Vitaly Prosyak <vitaly.prosyak@amd.com>
> > Cc: Christian König <christian.koenig@amd.com>
> > Fixes: b61badd20b44 ("drm/amdgpu: fix usage slab after free")
> 
> 
> Does 6.12 contain b61badd20b44 or a backport of it?  If not, then this patch is not applicable.

Yes, it is in 6.12.4

thanks,

greg k-h
