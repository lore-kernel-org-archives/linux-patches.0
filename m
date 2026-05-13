Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224EE30675C;
	Wed, 13 May 2026 15:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778685855; cv=none; b=PrXIAcPjGKZ15K36TdJos4JpLr3Zzh1Y8pZVwACBqx+gnu1mszL9Q8SbKP67YdRY5SzacUmYsSlKqdpacqkf9ZEFB3qqx+jRRoja6AoJajMX8P3AQu06RS0WzlNl1UsEFrqTLhq1nVo1IV0wOeCYgIoYUbrgabeqYdxoVVh2JW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778685855; c=relaxed/simple;
	bh=z/ROMN57zsJum37G7d9c4N7yUdv80iHQ/ETZTmXaTrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hluQlkLw78izjEo2w212C1I05R2gxXaS0fVetLFC7MCysAmaOgkANqytIL0QJdtuq7bknLgiN9dd7vuEBFY6Ymxx7o3FIDQ2caxV2HLtvzjiPRTy1LAhC41KJmj4rfpiK1u1crsMMz+OpWQq3P5IbuvB/o5mHVhh+nSMPYfUBlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f/MEXwMH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f/MEXwMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5FEC2BCB3;
	Wed, 13 May 2026 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778685854;
	bh=z/ROMN57zsJum37G7d9c4N7yUdv80iHQ/ETZTmXaTrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f/MEXwMHiANgoHBAaRI55FX12SKFAhgWlGwrv43qrzEe65LvS7jT1pljwpzIX685L
	 26EZoAub8O3V6NlcJiKAO3ZGRIwraTc01I2gniaXq9ZsINKdRtZwE1znryg3jWRBFZ
	 gwc2q7hMUNnkZfXVIsF73PXxvF8YfSiNvr3twRz0=
Date: Wed, 13 May 2026 17:24:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: Stephano Cetola <stephano@cetola.net>,
	Jiri Slaby <jirislaby@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Chris Mason <clm@meta.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7.0 247/307] sched_ext: Skip tasks with stale task_rq in
 bypass_lb_cpu()
Message-ID: <2026051344-thrower-kept-0a66@gregkh>
References: <20260512173940.117428952@linuxfoundation.org>
 <20260512173945.338221208@linuxfoundation.org>
 <2f509cbf-f14f-4dfc-8ba9-d53dc10e0aad@kernel.org>
 <2026051301-tusk-parcel-15ee@gregkh>
 <67725402aaddb935a94d2cd751f317e6bb844654.camel@cetola.net>
 <2026051342-canon-apply-bf42@gregkh>
 <agSUmB_A7tECRrtp@gpd4>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agSUmB_A7tECRrtp@gpd4>

On Wed, May 13, 2026 at 05:11:20PM +0200, Andrea Righi wrote:
> Hi Greg,
> 
> On Wed, May 13, 2026 at 04:56:56PM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 13, 2026 at 07:39:22AM -0700, Stephano Cetola wrote:
> > > On Wed, 2026-05-13 at 13:58 +0200, Greg Kroah-Hartman wrote:
> > > > 
> > > > This is odd that it doesn't show up in my test builds/runs.  I'll go
> > > > drop this now, and push out a -rc2, thanks!
> > > > 
> > > > greg k-h
> > > 
> > > One of my build machines was able to build 7.0.7_rc1 successfully. The
> > > only difference I see is that it does not have:
> > > CONFIG_SCHED_CLASS_EXT=y
> > 
> > Which somehow doesn't get enabled with `make allmodconfig` :(
> 
> Do you have DEBUG_INFO_BTF disabled?

Yup.

> I think allmodconfig selects CONFIG_DEBUG_INFO_NONE=y => CONFIG_DEBUG_INFO_BTF=n
> => CONFIG_SCHED_CLASS_EXT=n, because:
> 
> config SCHED_CLASS_EXT
> ...
>         depends on BPF_SYSCALL && BPF_JIT && DEBUG_INFO_BTF

Probably, anyway, that's why my 'allmodconfig' builds did not catch
this, and my "build a sane kernel that can boot" builds also did not.

thanks,

greg k-h
