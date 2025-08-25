Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CD8288511;
	Mon, 25 Aug 2025 20:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756153103; cv=none; b=Q3EG8dffkgq85nQvuG7zbOdUFbtNR3mmg8e51BWX1PovXx0G249fB2gBKdEFS5uxiy8ON5o8YRFdjCk3yCZREw9zZhpkVXMFz2ai4RRcXVw1vNImsGSnIUf/FaBmLmKZ7B23GRRr/xnacXSWAdX+fLIKv2BmDXcf4nL2+wmH4NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756153103; c=relaxed/simple;
	bh=R8LG7/Fjb2k8AuYElz6WhqCpr4XGp4nctijttxN3LuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snk498nKHjQ0qQnspspADR+1ZeZGJtQj8KmC7DWNxir8ZCWTOL8s2lXTxj2VTIFYcckh9ZLAdr/45+L2hQhtHqoHlD1azdsXXkJKJtSzCnyLNK5hXJ+yOSjTTGQgWhj46/2Y0WbPnkN0irFEUxcncFwzizdj7hsHKrVnHR7bg84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsK60+Qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsK60+Qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA50C116B1;
	Mon, 25 Aug 2025 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756153103;
	bh=R8LG7/Fjb2k8AuYElz6WhqCpr4XGp4nctijttxN3LuE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TsK60+Qwpmbzezf1xS+8WYpSUqm0dPjA91/UMRHo/XrJKfYAQcGYlj4zZCjOdVVFf
	 IQawvub03ugDEoHZDDQmPwjtw6911v/JtHbCM3fmAb4Fig114jjrU5m3qV0fT40VPM
	 NIyib9D4IyYe2U9u5VchX5639K4kHg21aJLYBACY=
Date: Mon, 25 Aug 2025 22:18:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Xiao, Jack" <Jack.Xiao@amd.com>, "Gao, Likun" <Likun.Gao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.15 438/515] drm/amdgpu: fix incorrect vm flags to map bo
Message-ID: <2025082507-scientist-trustless-9a5b@gregkh>
References: <20250818124458.334548733@linuxfoundation.org>
 <20250818124515.286695172@linuxfoundation.org>
 <BL1PR12MB5144A729CC4218D2F6DCFE5FF73EA@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5144A729CC4218D2F6DCFE5FF73EA@BL1PR12MB5144.namprd12.prod.outlook.com>

On Mon, Aug 25, 2025 at 02:04:37PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Monday, August 18, 2025 8:47 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev;
> > Xiao, Jack <Jack.Xiao@amd.com>; Gao, Likun <Likun.Gao@amd.com>; Deucher,
> > Alexander <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 6.15 438/515] drm/amdgpu: fix incorrect vm flags to map bo
> >
> > 6.15-stable review patch.  If anyone has any objections, please let me know.
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

6.15 is end-of-life, sorry.
