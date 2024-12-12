Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A57211719;
	Thu, 12 Dec 2024 12:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734005486; cv=none; b=NSE9eIuNXrUQWe4/M5TPj1NmxoP58xBBO/aBaDEoMIA6kWx5AK3+T8bvmCq/4XZUtf3mv1fQt6eNVYHhw7A+YrSB4JrieSSkXIkT0UvjpuZPXhmHT2gShsBFvpCcDzSgbaeOIiy4KQ04EN3+j1rXATrSaNEU2jwf76v+3vqF6Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734005486; c=relaxed/simple;
	bh=z4IR5aQ9BHMU6pLPaRemCvtw3/mCLG8VNTuWpfCN/AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P6zn5m+7tVrwC2Sa78XOvHUBmQw4o3Z5MXxnfR+3w1gGozuvyt6+H537MXWCrXzT1p946r7hGEYGETZHBFlqwVci+2CsSLkDzL6ta7/aIUc1pNOBCR2uoz4M2o1vBa7DSjzoN0JERKiaCiuh/9drSY2C1uoLWI91eTnqZ5ZLCU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=frbRjRAE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="frbRjRAE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59249C4CECE;
	Thu, 12 Dec 2024 12:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734005484;
	bh=z4IR5aQ9BHMU6pLPaRemCvtw3/mCLG8VNTuWpfCN/AU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=frbRjRAEc9YR6sD/8xPGdYfwG5V+e0P74CnQSqB7cvBGcKUMyPUOSg4HkYVm7xqmt
	 u6p81YPyIkCsQfMFMibxy+ccs4tYjrYQCaNUPullQU8pFFnuB6W5LHOy5WIDhBPL6E
	 J1ghkjfTUTGJI8+DxbJCskR1eBruPGkIDwh0ccd4=
Date: Thu, 12 Dec 2024 13:11:20 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: wayne.lin@amd.com, patches@lists.linux.dev, jerry.zuo@amd.com,
	zaeem.mohamed@amd.com, daniel.wheeler@amd.com,
	alexander.deucher@amd.com, stable@vger.kernel.org,
	harry.wentland@amd.com, sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
	airlied@gmail.com, daniel@ffwll.ch, amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] drm/amd/display: Don't refer to dc_sink in
 is_dsc_need_re_compute
Message-ID: <2024121206-shelve-contusion-6db0@gregkh>
References: <20241211101544.2121147-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211101544.2121147-1-jianqi.ren.cn@windriver.com>

On Wed, Dec 11, 2024 at 06:15:44PM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Wayne Lin <wayne.lin@amd.com>
> 
> [ Upstream commit fcf6a49d79923a234844b8efe830a61f3f0584e4 ]
> 
> [Why]
> When unplug one of monitors connected after mst hub, encounter null pointer dereference.
> 
> It's due to dc_sink get released immediately in early_unregister() or detect_ctx(). When
> commit new state which directly referring to info stored in dc_sink will cause null pointer
> dereference.
> 
> [how]
> Remove redundant checking condition. Relevant condition should already be covered by checking
> if dsc_aux is null or not. Also reset dsc_aux to NULL when the connector is disconnected.
> 
> Reviewed-by: Jerry Zuo <jerry.zuo@amd.com>
> Acked-by: Zaeem Mohamed <zaeem.mohamed@amd.com>
> Signed-off-by: Wayne Lin <wayne.lin@amd.com>
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> ---
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 4 ++++
>  1 file changed, 4 insertions(+)

You sent this 3 times, all different, so I have no idea what to do.

Ok, I give up.  I'm deleting ALL of your pending stable patches from my
review queue now due to all of the problems that these have had.

Please work with a more experienced kernel developer at your company to
get these backports correct, and complete, and send them as a patch
series with the correct information and documentation as to what is
going on, so that we have a chance to get this right.

thanks,

greg k-h
