Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2FC2E11A6;
	Thu,  2 Apr 2026 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775126772; cv=none; b=qvir2MyUCY0cP2Dni6Vx1OqKO42/6Um1yauqPIVrTOlcBZcBzbgeYDIJmOPnVl7XeCXRa/CRpPICQZd5PPdp6m/2rv9xxxDTN62akIg10rve2Jw2zf3DD79PjGq3oWP6gZyetfORW/XaTIRhiwrjWPHAb3ao8CyeDbBDr12hh1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775126772; c=relaxed/simple;
	bh=vzDS3JoUILSmnI6P6uyOuIz5nDm96dIT0N4s0lT/1Wg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KwVnozk+spkLHMvJx02jFFHuGNKGfYa/gXy6NbcAEO8VxLmBmspfX5IB5mYZh1rJ6RPhy3NQc14NJs+KxwHk5yfA/kyxLvKAPW+yOIBKUtfpT2fB6rukg8rsOephZQRSLNO+oMB9OIO2YAJeP/BNANUvJ7alSkV34VvI0riYXR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHX7CEQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHX7CEQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00366C116C6;
	Thu,  2 Apr 2026 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775126772;
	bh=vzDS3JoUILSmnI6P6uyOuIz5nDm96dIT0N4s0lT/1Wg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xHX7CEQDkQJgEeM2hL6qgBNvz1UWFgqCHBTqcBdJjw4O4pAy6U9B2gfddg7bXb7u6
	 FbLtO38yp7YM7TAB6z3tdrbGHv2X8ptMbooA5/g8ogfLay45KAlgcV5xJiokcdH6Bu
	 PNWVmLevMvSE9E04OPFgyIPZrGoxjNt4tz1SXpvE=
Date: Thu, 2 Apr 2026 12:46:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Chaignon <paul.chaignon@gmail.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	stable <stable@vger.kernel.org>, patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 034/244] bpf: Fix u32/s32 bounds when ranges cross
 min/max boundary
Message-ID: <2026040240-friday-gurgling-7088@gregkh>
References: <20260331161741.651718120@linuxfoundation.org>
 <20260331161742.960922011@linuxfoundation.org>
 <i4c753x3y67ek3r7dp774pcmaaaid3gvxcsvdssosdingre4in@od45qzitwtrf>
 <2026040115-dose-aerobics-7c6d@gregkh>
 <CAADnVQLSfDtqeLFw=DjG-dG=xD_qS7p2LHsT9jAxO5aAK0YJig@mail.gmail.com>
 <ac1LCTbV5ZnqUgG0@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac1LCTbV5ZnqUgG0@mail.gmail.com>

On Wed, Apr 01, 2026 at 06:42:49PM +0200, Paul Chaignon wrote:
> On Wed, Apr 01, 2026 at 07:32:26AM -0700, Alexei Starovoitov wrote:
> > On Wed, Apr 1, 2026 at 4:44 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Apr 01, 2026 at 02:22:58PM +0800, Shung-Hsi Yu wrote:
> > > > Cc Eduard and Paul since they know this change better.
> > > >
> > > > On Tue, Mar 31, 2026 at 06:19:44PM +0200, Greg Kroah-Hartman wrote:
> > > > > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Eduard Zingerman <eddyz87@gmail.com>
> > > > >
> > > > > [ Upstream commit fbc7aef517d8765e4c425d2792409bb9bf2e1f13 ]
> > > > >
> > > > > Same as in __reg64_deduce_bounds(), refine s32/u32 ranges
> > > > > in __reg32_deduce_bounds() in the following situations:
> > > > ...
> > > >
> > > > Hi Greg,
> > > >
> > > > This patch is causing the following BPF selftests to fail
> > > >
> > > >   #222 reg_bounds_crafted
> > > >   #222/27 reg_bounds_crafted/(u64)[0x7fffffffffffffff; 0xffffffff00000000] (s64)<op> 0
> > > >   #222/28 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffffffffffff; 0xffffffff00000000]
> > > >   #222/29 reg_bounds_crafted/(u64)[0x7fffffff00000001; 0xffffffff00000000] (s64)<op> 0
> > > >   #222/30 reg_bounds_crafted/(u64)0 (s64)<op> [0x7fffffff00000001; 0xffffffff00000000]
> > > >   #222/59 reg_bounds_crafted/(s64)[0xffffffff00000001; 0] (u64)<op> 0xffffffff00000000
> > > >   #222/60 reg_bounds_crafted/(s64)0xffffffff00000000 (u64)<op> [0xffffffff00000001; 0]
> > > >   #222/79 reg_bounds_crafted/(s64)[S64_MIN; 0] (u64)<op> 0
> > > >   #222/80 reg_bounds_crafted/(s64)0 (u64)<op> [S64_MIN; 0]
> > > >   #262 reg_bounds_rand_consts_s64_u64
> > > >
> > > > The failure is caused by the selftests' expectation not aligning to the
> > > > stable 6.12 behavior. I believe the easier way out is to drop this, then
> > > > wait for [1] to land and pick it up in stable (or I'll try to backport
> > > > and send). That should address the root cause of what this patch is
> > > > trying to workaround.
> > > >
> > > > 1: https://lore.kernel.org/bpf/d4fe45f8bd5c6a48efd2ba3b66932bf7eb5aa020.1774025082.git.paul.chaignon@gmail.com/
> > >
> > > Now dropped, thanks.
> > 
> > I suggest ignoring the selftest failures.
> > The patch is necessary for stable and backports.
> > It's fixing a real issue.
> 
> The selftest is failing because we're missing commit 1f8fe377855b
> ("bpf: Improve bounds when s64 crosses sign boundary") in v6.12. It's
> the s64 counterpart to the s32 patch backported here.
> 
> In bpf-next, we have both the s64 and the s32 patches. The s32 patch
> also updates the reg_bounds_crafted selftest to cover the logic for
> both the s64 and s32 patches. If we backport only the s32 patch, the
> updated selftest fails.
> 
> I can send v6.12 backports for both the s32 and s64 patchsets if that
> helps. There are a couple minor conflicts when backporting the new
> selftests. Or we can just cherry-pick 1f8fe377855b alone.
> 

I'll keep this dropped for now as I have no idea what 1f8fe377855b is,
as that's not a valid git id in Linus's tree.

Can you send the 2 patches needed here and I will queue them up.

thanks,

greg k-h
