Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C691D12E0;
	Sat, 31 Aug 2024 05:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725081360; cv=none; b=tBXH3MvOhlze+k8zNF04AArMKLAIXCicf32Mxzcerlfne//RjiOQdja69DZIBAIFSi4mBGYuS4B0+JkPB1R6yOWbyGdMJ1GZc61duDLMDvMm2dqY82sHGhkPcreWcGpEkZEtC9blfLO4ECIsdVzYmvBNAoxH67rXr04qDLMnEPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725081360; c=relaxed/simple;
	bh=eQyGWvxbnuak2OM3KuRSOxCHYGa3wrlalVf8AGGQSCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KZfg+DIhexKBzG3dMVV5q3901UgWwYi3WNrSBdgAPn7ihcX1EAj7pQ9oHNqzZD5aEG6Z7dUN5iZPgjTumx2zmPmlzeCVkNK8fjF/AVvNkhkBsh0fBhAGRmdN4ZSs2CissG91YGHCRUFX/g3DHPiODJQOjWfL7Sx9H/UmPzobXGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XDfbX9AU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XDfbX9AU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942C1C4CEC0;
	Sat, 31 Aug 2024 05:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725081360;
	bh=eQyGWvxbnuak2OM3KuRSOxCHYGa3wrlalVf8AGGQSCs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XDfbX9AUCl1/+yQ+5VTYvUt0ip/em/zwfZittCmaD2qlDHYXQwmWOldBzZuH+rzRr
	 cyyGH8do7kR08k6iVyZU9MVp1E7Ffk5VkRwjRMjFw6kjgIAAWhJQ2PX6hkIMccx+Na
	 4uwziuu0DnNhrZtDaHBKaEKiJqXDhy/GiWacqH4Y=
Date: Sat, 31 Aug 2024 07:15:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Willem de Bruijn <willemb@google.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>,
	kernel-team@cloudflare.com
Subject: Re: [PATCH 6.6 046/139] selftests/net: fix uninitialized variables
Message-ID: <2024083143-haiku-unkempt-9642@gregkh>
References: <20240709110658.146853929@linuxfoundation.org>
 <20240709110659.948165869@linuxfoundation.org>
 <8B1717DB-8C4A-47EE-B28C-170B630C4639@cloudflare.com>
 <2024083021-cytoplasm-width-3e44@gregkh>
 <015f481d-fd0a-48d5-a712-0df224d6d937@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <015f481d-fd0a-48d5-a712-0df224d6d937@nvidia.com>

On Fri, Aug 30, 2024 at 04:40:39PM -0700, John Hubbard wrote:
> On 8/30/24 4:06 AM, Greg Kroah-Hartman wrote:
> > On Thu, Jul 11, 2024 at 04:31:45PM +0100, Ignat Korchagin wrote:
> > > Hi,
> > > > On 9 Jul 2024, at 12:09, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > 
> > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > ------------------
> > > > 
> > > > From: John Hubbard <jhubbard@nvidia.com>
> > > > 
> > > > [ Upstream commit eb709b5f6536636dfb87b85ded0b2af9bb6cd9e6 ]
> > > > 
> > > > When building with clang, via:
> > > > 
> > > >     make LLVM=1 -C tools/testing/selftest
> > > > 
> > > > ...clang warns about three variables that are not initialized in all
> > > > cases:
> > > > 
> > > > 1) The opt_ipproto_off variable is used uninitialized if "testname" is
> > > > not "ip". Willem de Bruijn pointed out that this is an actual bug, and
> > > > suggested the fix that I'm using here (thanks!).
> > > > 
> > > > 2) The addr_len is used uninitialized, but only in the assert case,
> > > >    which bails out, so this is harmless.
> > > > 
> > > > 3) The family variable in add_listener() is only used uninitialized in
> > > >    the error case (neither IPv4 nor IPv6 is specified), so it's also
> > > >    harmless.
> > > > 
> > > > Fix by initializing each variable.
> > > > 
> > > > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> > > > Reviewed-by: Willem de Bruijn <willemb@google.com>
> > > > Acked-by: Mat Martineau <martineau@kernel.org>
> > > > Link: https://lore.kernel.org/r/20240506190204.28497-1-jhubbard@nvidia.com
> > > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > ---
> > > > tools/testing/selftests/net/gro.c                 | 3 +++
> > > > tools/testing/selftests/net/ip_local_port_range.c | 2 +-
> > > > tools/testing/selftests/net/mptcp/pm_nl_ctl.c     | 2 +-
> > > > 3 files changed, 5 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
> > > > index 30024d0ed3739..b204df4f33322 100644
> > > > --- a/tools/testing/selftests/net/gro.c
> > > > +++ b/tools/testing/selftests/net/gro.c
> > > > @@ -113,6 +113,9 @@ static void setup_sock_filter(int fd)
> > > > next_off = offsetof(struct ipv6hdr, nexthdr);
> > > > ipproto_off = ETH_HLEN + next_off;
> > > > 
> > > > + /* Overridden later if exthdrs are used: */
> > > > + opt_ipproto_off = ipproto_off;
> > > > +
> > > 
> > > This breaks selftest compilation on 6.6, because opt_ipproto_off is not
> > > defined in the first place in 6.6
> > 
> > So should it be reverted or fixed up?
> 
> It should be fixed up. And that's what we already did, last month:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?id=6b05ad408f09a1b30dc279d35b1cd238361dc856

Ah, thanks, forgot about that!

greg k-h
