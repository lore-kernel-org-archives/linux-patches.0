Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F30E375ADE;
	Wed,  1 Apr 2026 11:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775043882; cv=none; b=d0uRXZSiGZZZh/SEVg1LfYHRbmZIddgi5mPhUMK/4/tSaPgUCO/fjQ32k3vtaX5VGRTm5vpHeTLy5nLiFw05OeQqtJk6dZ/nHZ70EFXh7P9ah0hwKJa9ljSPhCI/TwdGrpwoNSlhO0FzRuweagtCPnKkQxSI8WLM3CO77gLajlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775043882; c=relaxed/simple;
	bh=4C5Ms/kSSh+TQIeAk+1DYtjiUFwHDZRGHYeT5Sm5z8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pY+uIK11NcU/7Xk34mBgR6fEoNZWFFhg7yBIs4iOXlCsy7LOt3JG4pNCJSXPhCmHjn+fk9rz+4yWiTGvWSuQPC92YfRkZz01DEO/LkQvSlJ5HhvKkJgFqrG186EkbwmMmQ6Jk0gxk3II0X0VSepYtTluFBmqbwbp+tcl29/HgPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qz8Lr9Sh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qz8Lr9Sh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19DAC4CEF7;
	Wed,  1 Apr 2026 11:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775043882;
	bh=4C5Ms/kSSh+TQIeAk+1DYtjiUFwHDZRGHYeT5Sm5z8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qz8Lr9ShSCNL4pRSaEur2Oc9cfl21HVJVW5GKQ48JPC6lJc8Oa/x/levm/gK0gMDn
	 4fVRcpEuPJGkaePVsEwnAgJRA0fh5WFxf9jZCnS1/BjZU+NVz7ek7Myezmsh3b4Kfl
	 IYJRrk8fcmIHJjI+FnrB8B1SQzPR4pJpb2w4eARk=
Date: Wed, 1 Apr 2026 13:44:39 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Cc: Eduard Zingerman <eddyz87@gmail.com>,
	Paul Chaignon <paul.chaignon@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 034/244] bpf: Fix u32/s32 bounds when ranges cross
 min/max boundary
Message-ID: <2026040115-dose-aerobics-7c6d@gregkh>
References: <20260331161741.651718120@linuxfoundation.org>
 <20260331161742.960922011@linuxfoundation.org>
 <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf>

On Wed, Apr 01, 2026 at 02:22:58PM +0800, Shung-Hsi Yu wrote:
> Cc Eduard and Paul since they know this change better.
> 
> On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eduard Zingerman <eddyz87@gmail.com>
> > 
> > [ Upstream commit fbc7aef517d8765e4c425d2792409bb9bf2e1f13 ]
> > 
> > Same as in __reg64_deduce_bounds(), refine s32/u32 ranges
> > in __reg32_deduce_bounds() in the following situations:
> ...
> 
> Hi Greg,
> 
> This patch is causing the following BPF selftests to fail
> 
>   #222 reg_bounds_crafted
>   #222/27 reg_bounds_crafted/(u64)[0x7fffffffffffffff; 0xffffffff00000000] (s64)<op> 0
>   #222/28 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffffffffffff; 0xffffffff00000000]
>   #222/29 reg_bounds_crafted/(u64)[0x7fffffff00000001; 0xffffffff00000000] (s64)<op> 0
>   #222/30 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffff00000001; 0xffffffff00000000]
>   #222/59 reg_bounds_crafted/(s64)[0xffffffff00000001; 0] (u64)<op> 0xffffffff00000000
>   #222/60 reg_bounds_crafted/(s64)0xffffffff00000000 (u64)<op> [0xffffffff00000001; 0]
>   #222/79 reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> 0
>   #222/80 reg_bounds_crafted/(s64)0 (u64)<op> [S64_MIN; 0]
>   #262 reg_bounds_rand_consts_s64_u64
> 
> The failure is caused by the selftests' expectation not aligning to the
> stable 6.12 behavior. I believe the easier way out is to drop this, then
> wait for [1] to land and pick it up in stable (or I'll try to backport
> and send). That should address the root cause of what this patch is
> trying to workaround.
> 
> 1: https://lore.kernel.org/bpf/d4fe45f8bd5c6a48efd2ba3b66932bf7eb5aa020.1774025082.git.paul.chaignon@gmail.com/

Now dropped, thanks.

greg k-h
