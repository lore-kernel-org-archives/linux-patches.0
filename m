Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08D387344;
	Mon, 23 Mar 2026 10:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774261977; cv=none; b=dnl5qNC0q2gd9OFltScAs01Kib+vpQoO5SLeIEfk3z2LzgFEbCRtVOLUtGODmurn1/dSsFCbYrTDjN8QdISMa+f3r79lWCw2+wCO4C5e2ASS7jR3lxL79Dv23OAdC0ntDt+aJKmi3B1Gkc9qajpIZcFZFUokn6cEZxmv7i8AXuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774261977; c=relaxed/simple;
	bh=nu9KpscKUDBHHpMe1GSngED3iiYBegN779XB3oiDq/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLCHIVSL/OfKH9Ttk5/6fXn6qa4REglHAtc6OcMF/Ac2+tFfn7RvpFAbQraMIbUqZQ019EdBReaU3ffiZrw2Bo2iT+9ZyQ3BaPaXpOScyd0q6Pp3Tfg84WfOq9uPX0TWzi5mGM8RkdrJ2nGqVCTE+vaO2BJsi23mQ6g2Qc1Nc5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04wGH4mC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04wGH4mC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155C6C4CEF7;
	Mon, 23 Mar 2026 10:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774261976;
	bh=nu9KpscKUDBHHpMe1GSngED3iiYBegN779XB3oiDq/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=04wGH4mC1KfLOSBXHPTRJfNUuxnMmyK+Lsx5lpOWNqMYwWDLirA8niGIkoAcmghVA
	 jyiXRHixl+6ydXRyru9sEQgDb3javn5DMXGxej+/A5KEl6Ghpvpk5JMDhhfo10luEX
	 KFngbqFlqN/0lTu76BpXagjLE/N7QY7WCsuJpGDI=
Date: Mon, 23 Mar 2026 11:32:35 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Li hongliang <1468888505@139.com>, srinivasan.shanmugam@amd.com,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	alexander.deucher@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
	daniel@ffwll.ch, sashal@kernel.org, guchun.chen@amd.com,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.1.y] drm/amdgpu: Fix potential out-of-bounds access in
 'amdgpu_discovery_reg_base_init()'
Message-ID: <2026032346-ruse-dork-baf3@gregkh>
References: <20260323071052.4068410-1-1468888505@139.com>
 <f2d125ce-8cb9-4ae8-8f55-0b5a78e66f83@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f2d125ce-8cb9-4ae8-8f55-0b5a78e66f83@amd.com>

On Mon, Mar 23, 2026 at 10:51:18AM +0100, Christian König wrote:
> Hi Li,
> 
> On 3/23/26 08:10, Li hongliang wrote:
> > From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
> > 
> > [ Upstream commit cdb637d339572398821204a1142d8d615668f1e9 ]
> > 
> > The issue arises when the array 'adev->vcn.vcn_config' is accessed
> > before checking if the index 'adev->vcn.num_vcn_inst' is within the
> > bounds of the array.
> > 
> > The fix involves moving the bounds check before the array access. This
> > ensures that 'adev->vcn.num_vcn_inst' is within the bounds of the array
> > before it is used as an index.
> > 
> > Fixes the below:
> > drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1289 amdgpu_discovery_reg_base_init() error: testing array offset 'adev->vcn.num_vcn_inst' after use.
> 
> well this patch only fixed a compiler warning and has not much practical value otherwise.
> 
> Why are you sending this for inclusion into the 6.1 kernel?

Perhaps because it was assigned to CVE-2024-27042?  If this is ONLY a
compiler warning fix, and NOT an actual vulnerability fix, please let
cve@kernel.org know about that and they will revoke this CVE.

thanks,

greg k-h
