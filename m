Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7221038643C;
	Mon, 23 Mar 2026 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774269489; cv=none; b=HgZjwbTp/7vz7DxlE/xtbFNEVvDye3kdfgojDMDAACo80Arse/kryAJJs1+0J38zufgvgCSs8D3Cq6a0ap40UwNbfSDNeiLZq3E+nI9lmQchpj89R3ASN65IUvn8nY4aQz9iRl+jnJYZLgDtkA2yALjjaj7bbv/tBrXF4K1Sybk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774269489; c=relaxed/simple;
	bh=rkx+d/cCup4mYc8hIEmm49s0orQZ9+5H/BGP8P6UdMI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSAS9vA4V2a7y732TibwkVxlvqGX0WBvcC6yeOqs/piY18/3K2faJQ/r8P5o7myzT3SAAE3+WkYbg4TuMtgVRyIcN7n8pNuQHQJGYWFNnRXJOdFpRTfTp2u+OEodRHNnCJPwRZfZF9EJpg9+hZE+AUZxC7Q+7ddUYrtAUdMNHh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nnyzGq3O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nnyzGq3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A21C2BCB1;
	Mon, 23 Mar 2026 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774269489;
	bh=rkx+d/cCup4mYc8hIEmm49s0orQZ9+5H/BGP8P6UdMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nnyzGq3OikkxSI6RE07xpwTs56qwH7VpWX91JO4Tedr5fiDGB8QpFlrPxPTORJA0f
	 FIUf+wkxKj1ZXfRgsExPWvLIbKwPETPT0wmhGPv8sGkm9VmhJU2ZYHvvxHDljIihZP
	 1qpUksXJwu2+NuhONKC5HP8JDQi8JLfyUFW0CQUA=
Date: Mon, 23 Mar 2026 13:37:46 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: cve@kernel.org, Li hongliang <1468888505@139.com>,
	srinivasan.shanmugam@amd.com, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, alexander.deucher@amd.com,
	Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
	sashal@kernel.org, guchun.chen@amd.com,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.1.y] drm/amdgpu: Fix potential out-of-bounds access in
 'amdgpu_discovery_reg_base_init()'
Message-ID: <2026032335-muster-chump-60f7@gregkh>
References: <20260323071052.4068410-1-1468888505@139.com>
 <f2d125ce-8cb9-4ae8-8f55-0b5a78e66f83@amd.com>
 <2026032346-ruse-dork-baf3@gregkh>
 <bd383c94-8350-420c-adbf-cc02a9918a37@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd383c94-8350-420c-adbf-cc02a9918a37@amd.com>

On Mon, Mar 23, 2026 at 01:28:24PM +0100, Christian König wrote:
> Hi Greg,
> 
> On 3/23/26 11:32, Greg KH wrote:
> > On Mon, Mar 23, 2026 at 10:51:18AM +0100, Christian König wrote:
> >> Hi Li,
> >>
> >> On 3/23/26 08:10, Li hongliang wrote:
> >>> From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
> >>>
> >>> [ Upstream commit cdb637d339572398821204a1142d8d615668f1e9 ]
> >>>
> >>> The issue arises when the array 'adev->vcn.vcn_config' is accessed
> >>> before checking if the index 'adev->vcn.num_vcn_inst' is within the
> >>> bounds of the array.
> >>>
> >>> The fix involves moving the bounds check before the array access. This
> >>> ensures that 'adev->vcn.num_vcn_inst' is within the bounds of the array
> >>> before it is used as an index.
> >>>
> >>> Fixes the below:
> >>> drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c:1289 amdgpu_discovery_reg_base_init() error: testing array offset 'adev->vcn.num_vcn_inst' after use.
> >>
> >> well this patch only fixed a compiler warning and has not much practical value otherwise.
> >>
> >> Why are you sending this for inclusion into the 6.1 kernel?
> > 
> > Perhaps because it was assigned to CVE-2024-27042?  If this is ONLY a
> > compiler warning fix, and NOT an actual vulnerability fix, please let
> > cve@kernel.org know about that and they will revoke this CVE.
> 
> Thanks a lot for pointing that out, adding cve@kernel.org.
> 
> As far as I can see the CVE-2024-27042 is not valid or at least not correctly categorized.
> 
> It is correct that there is a potential array overrun in amdgpu_discovery_reg_base_init(), but that function is used to parse a VBIOS table from a flash EEPROM located on the HW and not user input.
> 
> If an attacker already had the ability to modify that EEPROM he could just overwrite the VBIOS code were parts are directly executed at bootup and/or driver load. So this problem here wouldn't be needed at all.
> 
> It is good that this warning is fixed, but as far as I can see there is no reason whatsoever to backport it nor to assign a CVE entry for it.

Now rejected, thanks!

greg k-h
