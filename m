Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28AE2F3C39;
	Wed, 17 Sep 2025 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120294; cv=none; b=KnBMvgd4z77h8XQAXlHPK4lmjg+MVWt3sd+mXn205aAkwoqq8VJC7pd/E7Wl41hpRmEQQexef704XmbaGYgofL/z7QUxu0rY3caCUgSQNGyTL/Q+cOfCnh7BxJa8vDZ329JLsO8vJa95+07ITszYEAuAscgaqg9DeJLPNDNgyB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120294; c=relaxed/simple;
	bh=8KjO4m0Ymu+PN/DnnsesJpLMfmFaSzNo0E+0mjurkRI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n7wY60zTfntgtBd2dNcwqAup9ZugEGw1qpheTn2hqgaioOUqEtMhAbymbK8gMzBcMi5wQD1jeuhqUuSpBJ3ifzijiIdQt5ZEPi9nuko7nw4bjlu+NGBrZqvpEE2i7SHrMdogJPgc9G3eQCgUGF1nbNYGMnTCUM8saIwbw8PaShg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNvrBWXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNvrBWXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2028AC4CEF0;
	Wed, 17 Sep 2025 14:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758120293;
	bh=8KjO4m0Ymu+PN/DnnsesJpLMfmFaSzNo0E+0mjurkRI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cNvrBWXq5Um+BWzZNMneYrOKUwxL3GNhNieJHvsAsCjQdh4YOCCSQBgaN2XHIAlHl
	 4ghBNb/ntsuQEzmoMXMHWLNPnpHNytYXWd9K3+1qzdGFiwigbVfA6AbEgpEm5ybmR/
	 HXV6rwjPoz7IIWD8jYtojIB7FTXNMpQk/CxCJFuU=
Date: Wed, 17 Sep 2025 16:44:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"cao, lin" <lin.cao@amd.com>,
	"Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>,
	"Koenig, Christian" <Christian.Koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 100/101] drm/amdgpu: fix a memory leak in fence
 cleanup when unloading
Message-ID: <2025091737-caviar-skied-3e82@gregkh>
References: <20250917123336.863698492@linuxfoundation.org>
 <20250917123339.245422525@linuxfoundation.org>
 <BL1PR12MB5144611EB7684A4E01F4350BF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB5144611EB7684A4E01F4350BF717A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Wed, Sep 17, 2025 at 02:35:55PM +0000, Deucher, Alexander wrote:
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
> > Subject: [PATCH 6.6 100/101] drm/amdgpu: fix a memory leak in fence cleanup
> > when unloading
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Alex Deucher <alexander.deucher@amd.com>
> >
> > [ Upstream commit 7838fb5f119191403560eca2e23613380c0e425e ]
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
> Does 6.6 contain b61badd20b44 or a backport of it?  If not, then this patch is not applicable.

Yes, it is in 6.6.64.

thanks,

greg k-h
