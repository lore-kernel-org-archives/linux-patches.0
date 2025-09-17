Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A1323418;
	Wed, 17 Sep 2025 14:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758120340; cv=none; b=Xndxh5ALNZUiv2DVUb7pNDUAKB1MQFtI9h7mW3A5xCvaMfFYTojh9ifaxEte9gbsmTKg5hjqygdn1rHzaGhUdKTj4x7ZyJxhB/YXwN6dxt6/PWaAhS7asc7dxMmbH2kA20eTVepEDWCZQZoGnCBm/yohbTkqOrduOdjClmMcsH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758120340; c=relaxed/simple;
	bh=K0fbgx5CxJqnoI8GO2NkYJVO60jkzfKR+LU/SiYpOts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ihrsVwS20+u3nG3xMoOkTX1/YWIaRHK4n89oAfaiY3Dxq0xZTxcOzC132AMhqDkxKM6sf3s14sRcD/f3YaY2gPd5NnvADVaeXrFW/arSL6H8f+9Vf01ZK/6N2PfsP6bMvv5xeP3cZfVp1FgPEXYzndnbPgOAlNF1muRi4Gu663k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wul7mTJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wul7mTJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BB3C4CEE7;
	Wed, 17 Sep 2025 14:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758120339;
	bh=K0fbgx5CxJqnoI8GO2NkYJVO60jkzfKR+LU/SiYpOts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wul7mTJydneeUTGkb7Fc327PKVHI/5G96YpYfEoYC2h3GMxTIRqMHbI+OC17rfAKZ
	 1GwB2nw/+MGsw1Qkmp81U0C0EUJCZSNQUfW0mFWkILHamB1yd8gtANCkzIAVX1/Zgo
	 qmdK+wJb8z+Ui3hnNCq/+FM2UZd44E8VkGcXQlUE=
Date: Wed, 17 Sep 2025 16:45:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"cao, lin" <lin.cao@amd.com>,
	"Prosyak, Vitaly" <Vitaly.Prosyak@amd.com>,
	"Koenig, Christian" <Christian.Koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup
 when unloading
Message-ID: <2025091727-zit-unfasten-a64f@gregkh>
References: <20250917123329.576087662@linuxfoundation.org>
 <20250917123331.416162682@linuxfoundation.org>
 <BL1PR12MB51449335D2432734B3C149DEF717A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB51449335D2432734B3C149DEF717A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Wed, Sep 17, 2025 at 02:33:39PM +0000, Deucher, Alexander wrote:
> [AMD Official Use Only - AMD Internal Distribution Only]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Wednesday, September 17, 2025 8:36 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev;
> > cao, lin <lin.cao@amd.com>; Prosyak, Vitaly <Vitaly.Prosyak@amd.com>; Koenig,
> > Christian <Christian.Koenig@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.1 75/78] drm/amdgpu: fix a memory leak in fence cleanup when
> > unloading
> >
> > 6.1-stable review patch.  If anyone has any objections, please let me know.
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
> Does 6.1 contain b61badd20b44 or a backport of it?  If not, then this patch is not applicable.

Yes, it is in 6.1.127.

thanks,

greg k-h
