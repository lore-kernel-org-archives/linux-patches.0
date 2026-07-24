Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A252437466;
	Fri, 24 Jul 2026 11:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784891866; cv=none; b=L1CinjtvBYaQcXY1S/+M/ZWOft2jFcPMfKky9CEMDcw5zPNCmF10VhuNy8sgPX8mhVsHuwKjAudwZxXe0Z0EP8Fg2pJ6Iz1OgO2ptXBvJ9ZZ+jy/VF63NuLXCafVQq65ON+kh/wotcy3dXQL40m7bvdsJ+RPF4HbmI2J3HcILuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784891866; c=relaxed/simple;
	bh=XMCBwN4tia+NmUVzMFnMOIF4mYL0kCd/2HrBQpNdnv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opifAcnBZzaB5ULk/5cEJ36ehH8kLtf0HYEJ7H1ZtzThO0bj2iDel93VWOMk/Dtjs2eGQhonyT5PR4QHofPqOM4e0FapBol6AhUrrt5uVzWlQsf6BTiFWBwvMglYyB7lVHuCUdyPtNTylFJakASq07ULssKEEzJvqKKKhnvJeE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZLH5HOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZLH5HOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31081F01833;
	Fri, 24 Jul 2026 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784891863;
	bh=uaIIae6LTUEISFa7Af1EjvWvdFoEvFR+bAmr/z1eo2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cZLH5HOmfARoYbSWcOJG9BOa7U70I55RWMIFVgQPOmjs6VpniKuU+SfH005DENh7s
	 ZHgRpuXaOObVV+r72ZA6ICzByK/oOqEXPtoTM3od3pOj3U3514ymQsT2rVeTmR1Q2U
	 2dI/Mv3uDv71OfoZuFQWG8BleEGsXRABM+XwoRIk=
Date: Fri, 24 Jul 2026 13:17:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>, Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>, Xin Liu <bird@lzu.edu.cn>,
	Huihui Huang <hhhuang@smu.edu.sg>, Ren Wei <n05ec@lzu.edu.cn>
Subject: Re: [PATCH 5.10 137/699] tracing: Prevent out-of-bounds read in glob
 matching
Message-ID: <2026072416-pluck-oppressed-c051@gregkh>
References: <20260721152355.667394603@linuxfoundation.org>
 <20260721152358.800887633@linuxfoundation.org>
 <1d60d21d-ea26-4502-afee-c49c750df1e9@pobox.com>
 <2026072339-reshuffle-blizzard-42e9@gregkh>
 <759ee068-9519-4cfa-9be5-1deb0d9fc877@pobox.com>
 <20260723114247.00a3f66d@gandalf.local.home>
 <3308ea85-4ae5-4c5d-bfba-67bf7164a5d9@pobox.com>
 <20260724071902.7469bfe5b1f9bfd3bced2cc0@kernel.org>
 <ae1aec5a-9142-4f81-b03b-dc8d8f4018a2@pobox.com>
 <f27a8c9a-6538-4d24-9e80-c98c94431e3f@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f27a8c9a-6538-4d24-9e80-c98c94431e3f@pobox.com>

On Thu, Jul 23, 2026 at 05:08:11PM -0700, Barry K. Nathan wrote:
> On 7/23/26 4:43 PM, Barry K. Nathan wrote:
> > On 7/23/26 3:19 PM, Masami Hiramatsu (Google) wrote:
> > > On Thu, 23 Jul 2026 09:57:56 -0700
> > > "Barry K. Nathan"<barryn@pobox.com> wrote:
> > > 
> > > > On 7/23/26 8:42 AM, Steven Rostedt wrote:
> > > > > On Thu, 23 Jul 2026 08:32:23 -0700
> > > > > "Barry K. Nathan"<barryn@pobox.com> wrote:
> > > > > 
> > > > > > In the process of testing, troubleshooting, and eventually bisecting this,
> > > > > > I've tried rebuilding the kernel from scratch maybe 6 or 7 times now. I've
> > > > > > tried on two different build systems so far, and it seems deterministic
> > > > > > that the build succeeds without this patch and fails with it.
> > > > > When you say "from scatch", do you create a new directory and build there?
> > > > > 
> > > > > Is it reproducible with a "make mrproper"? (Need to copy the .config
> > > > > elsewhere to not lose it)
> > > > > 
> > > > > As I don't see anything in this patch that would cause filp_close to be
> > > > > unresolved. Sounds like a bad object was added somewhere.
> > > Yeah, or BTFIDS command (tools/bpf/resolve_btfids/resolve_btfids) may
> > > be broken?
> > 
> > This turned out to be the answer. 5.10.y needs these two commits to fix
> > resolve_btfids:
> > 
> > 22e8ebe35a2e: tools/resolve_btfids: Fix some error messages
> > 5aad03685185: tools/resolve_btfids: Emit warnings and patch zero id for missing symbols
> > 
> > (Alternately, 5aad03685185 could be fixed up by hand and applied alone,
> > instead of applying 22e8ebe35a2e as a prerequisite. Probably cleaner to
> > just apply both commits though.)
> > 
> > Applying both of these on top of 5.10.261-rc2 fixes the build for me
> > and results in a working kernel, which I am now using to send this email.
> 
> I forgot to mention, 5.15 and later already have these two patches
> (I think they were merged into mainline in 5.15-rc1), so it's only
> 5.10 that needs them.

Ok, both now added to the 5.10.y queue, thanks!

greg k-h
