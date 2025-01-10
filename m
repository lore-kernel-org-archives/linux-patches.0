Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58BB1FA15C;
	Fri, 10 Jan 2025 09:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736503105; cv=none; b=qr/gWSE68laGKBH1MOCApZ6lxANIA5Kyj09EY5D+ak3+Y/hAd2ppHnv/8nm7ZqdjzWR2SYGkLUoJ/9loWTMA3X2hC76NovS6EbZh5fi8JIYR/cb2TfdFCe3mAsf6G7DAJV9T+sV6iamf08yrqDtA0v2HT46BDZpZqCk8cT+QRWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736503105; c=relaxed/simple;
	bh=xnEfmZGz01BZzJvC0nqz04XwGZCZpGqNiOM1y/AVQ3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0afg68W4yMNfK9bnVoIac6pkDqOzgYozv2l0UGpL9c0GMPwvWSVnFZgtiyGhQH6V5He/OPDOGXAxpsMpy3FG5JvLXz7k+uFCsjuj9iBwRmEE1LxuIqzSs1JOp9E456vRIU/w/MLFlENLlqPKy7NS/JMYh9EkR2HHIFD9IvqwLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pH+4dp4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pH+4dp4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B4DC4CED6;
	Fri, 10 Jan 2025 09:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736503104;
	bh=xnEfmZGz01BZzJvC0nqz04XwGZCZpGqNiOM1y/AVQ3A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pH+4dp4Zx4NbJ9VEq8kArf7NR4KLiPNCYHBV0muIgsymR2Elt7iGKPLVPTk1EAcZE
	 zmIX5ATAcTYb/eKObW0xWM+Tu3GLpFfE4UlHVDm4UuyKQRS8mtvc+yayXB/Dt74j/O
	 ddkgaaOrVQuFzwKdXC8WC1bBcFc4wmengUYSZ2n8=
Date: Fri, 10 Jan 2025 10:58:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ignat Korchagin <ignat@cloudflare.com>
Cc: Baoquan He <bhe@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Al Viro <viro@zeniv.linux.org.uk>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Pingfan Liu <piliu@redhat.com>, Klara Modin <klarasmodin@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Yang Li <yang.lee@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>, kernel-team@cloudflare.com
Subject: Re: [PATCH 6.6 079/222] x86, crash: wrap crash dumping code into
 crash related ifdefs
Message-ID: <2025011043-tiny-debit-4507@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151153.592449889@linuxfoundation.org>
 <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com>
 <2025010953-squeak-garlic-08de@gregkh>
 <CALrw=nHC27RRxG7aPzzGNaknaHiDzXKSL7o+MLCY=kjNFzWX3g@mail.gmail.com>
 <CALrw=nG+_KyvPiKBnZOVin4XL4fbwiKWj6=o2x0rMELQBpP9iQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALrw=nG+_KyvPiKBnZOVin4XL4fbwiKWj6=o2x0rMELQBpP9iQ@mail.gmail.com>

On Thu, Jan 09, 2025 at 08:44:43PM +0000, Ignat Korchagin wrote:
> On Thu, Jan 9, 2025 at 6:08 PM Ignat Korchagin <ignat@cloudflare.com> wrote:
> >
> > On Thu, Jan 9, 2025 at 6:07 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Thu, Jan 09, 2025 at 05:39:04PM +0000, Ignat Korchagin wrote:
> > > > Hi,
> > > >
> > > > > On 6 Jan 2025, at 15:14, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > I think this back port breaks 6.6 build (namely vmlinux.o link stage):
> > > >   LD [M]  net/netfilter/xt_nat.ko
> > > >   LD [M]  net/netfilter/xt_addrtype.ko
> > > >   LD [M]  net/ipv4/netfilter/iptable_nat.ko
> > > >   UPD     include/generated/utsversion.h
> > > >   CC      init/version-timestamp.o
> > > >   LD      .tmp_vmlinux.kallsyms1
> > > > ld: vmlinux.o: in function `__crash_kexec':
> > > > (.text+0x15a93a): undefined reference to `machine_crash_shutdown'
> > > > ld: vmlinux.o: in function `__do_sys_kexec_file_load':
> > > > kexec_file.c:(.text+0x15cef1): undefined reference to `arch_kexec_protect_crashkres'
> > > > ld: kexec_file.c:(.text+0x15cf28): undefined reference to `arch_kexec_unprotect_crashkres'
> > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > make[1]: *** [/home/ignat/git/test/mainline/linux-6.6.70/Makefile:1164: vmlinux] Error 2
> > > > make: *** [Makefile:234: __sub-make] Error 2
> > > >
> > > > The KEXEC config setup, which triggers above:
> > > >
> > > > # Kexec and crash features
> > > > #
> > > > CONFIG_CRASH_CORE=y
> > > > CONFIG_KEXEC_CORE=y
> > > > # CONFIG_KEXEC is not set
> > > > CONFIG_KEXEC_FILE=y
> > > > # CONFIG_KEXEC_SIG is not set
> > > > # CONFIG_CRASH_DUMP is not set
> > > > # end of Kexec and crash features
> > > > # end of General setup
> > >
> > > Odd, why has no one see this on mainline?  Are we missing a change
> > > somewhere or should this just be reverted for now?
> >
> > I actually tested the mainline with this config and it works, so I
> > think we're missing a change
> >
> > Ignat
> 
> >From the looks of it it is missing 02aff8480533 ("crash: split crash
> dumping code out from kexec_core.c")

Ok, I can duplicate this here now, but wow, backporting that commit is
not going to work.  Let me see if I can just revert a few things
instead...

thanks for the .config section, that helped out a lot!

greg k-h
