Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B100B223DFB;
	Mon, 25 Aug 2025 20:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756153139; cv=none; b=AhTc6ZsemxJ6d0X5mFEhvhKqGo5guvK3DgDMtpztrouY1WPUrE+zzTOGlJW3jSN0P8zps5vywpByq8BvxIcx226EJhT6CxGSRzzk4O0X2o//GBrEgRqnHO7nqN7JWshBSpkud/f2jc3rrjHhy5OhT0J6jL9a7Y3xFInjf0N5eAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756153139; c=relaxed/simple;
	bh=RnQT2Jq69c863sbfZ4VHtKk/qPD5yfUvI35BE8N2aow=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aPlZkA6fKpDCzCT5f+1Zent4Xzxjn1ahXgcusQwjGWjuPfXcXGTTAStNtLRJSwyy5Um/78mSIT0gKMmwNoPjhzYclnDxyXOkKhbBgotjKcgt4JipQT4jo7W9UwzcK/JZn8U6dZ06TVdancojj8XJxUZgVuaPs2ghEBfjVzlWdso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UTb2K5R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UTb2K5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC89FC4CEED;
	Mon, 25 Aug 2025 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756153139;
	bh=RnQT2Jq69c863sbfZ4VHtKk/qPD5yfUvI35BE8N2aow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0UTb2K5Rc0+DRzx/gbgUarCDsuSVVFc77YCj4snPuZGNZGla2yNKKTIW14eNutYbf
	 pC2jPL0zPHegbNsnuJGP7xDf19vR2CnqPmEs/a2VCNAYVHimgzH7dHUAJdRcs8h/FG
	 ydGauTjFaa+DwiBrg7KEgE8RQNuoJ9l5LQyWnoEE=
Date: Mon, 25 Aug 2025 22:18:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Xiao, Jack" <Jack.Xiao@amd.com>, "Gao, Likun" <Likun.Gao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map bo
Message-ID: <2025082530-gory-outsmart-d4eb@gregkh>
References: <20250818124505.781598737@linuxfoundation.org>
 <20250818124524.452481295@linuxfoundation.org>
 <BL1PR12MB5144F2E3EB31673E0B78B8B7F73EA@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144F2E3EB31673E0B78B8B7F73EA@BL1PR12MB5144.namprd12.prod.outlook.com>

On Mon, Aug 25, 2025 at 02:04:11PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, August 18, 2025 8:48 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev;
> > Xiao, Jack <Jack.Xiao@amd.com>; Gao, Likun <Likun.Gao@amd.com>; Deucher,
> > Alexander <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.16 482/570] drm/amdgpu: fix incorrect vm flags to map bo
> >
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Jack Xiao <Jack.Xiao@amd.com>
> >
> > [ Upstream commit 040bc6d0e0e9c814c9c663f6f1544ebaff6824a8 ]
> >
> > It should use vm flags instead of pte flags to specify bo vm attributes.
> >
> > Fixes: 7946340fa389 ("drm/amdgpu: Move csa related code to separate file")
> 
> I accidently tagged this with the wrong fixes tag.  This patch should not go to anything other than 6.17.  Sorry for the confusion.  Please revert for older kernels.

So no stable releases at all?

And can you send a revert, this is already in released kernels.

thanks,

greg k-h
