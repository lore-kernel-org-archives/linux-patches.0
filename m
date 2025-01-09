Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857B018787A;
	Thu,  9 Jan 2025 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736446051; cv=none; b=buWoAF0KCodbDBvd8WzrPiVIrQzpcurxxxQraYXl4ZCBcq+ivxLk+85nSL2uqIszVpEiUudRV7aWQziOEEbySjrHP3yclE0pebV1TUsSXGVhGOkbsXwt9KL58PPTXIdcUulv0UluW3K8v9hHKIMjoyAuyID2yQptTdkcBIWLe5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736446051; c=relaxed/simple;
	bh=OkHFzeIsLhWoYh8fGBm4/RKyfw62VM11fJCKYt7uPwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZsteGSsGSydtCnDR1jGmaROCW7mX5dbpnrCBQHJiIiq5s+Wb5lWrUBBKI+DFhGcw3bVsiTSs+IuWfn1isvPyCkY4sIUuZWJ0XvFjzSDU0Emwe2L4VuSH7WUi/VRXJEcXsCXh+Q7ZrfCPz1yl4tAaP7xcUbU1aJwi9fGy4fC7OCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWP2gS8J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWP2gS8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76745C4CED2;
	Thu,  9 Jan 2025 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736446051;
	bh=OkHFzeIsLhWoYh8fGBm4/RKyfw62VM11fJCKYt7uPwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dWP2gS8JhFqRndh0+2KzeLcIkmXPeJYjF57ZsU+/4oEkXSkVZXhFZUxyVtqZFgkuH
	 20qiNTq/PR1J4iKma43cxNICHsyInNqzIjEbmTLaihQqSv27iQCTZmzbWLpvoJVUQ3
	 82E3ip6LUsWJy++MW9TnY8o3RdH0+S0MVY+PPahU=
Date: Thu, 9 Jan 2025 19:07:28 +0100
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
Message-ID: <2025010953-squeak-garlic-08de@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151153.592449889@linuxfoundation.org>
 <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DB3A6D3-0D3A-4682-B4FA-407B2D3263B2@cloudflare.com>

On Thu, Jan 09, 2025 at 05:39:04PM +0000, Ignat Korchagin wrote:
> Hi,
> 
> > On 6 Jan 2025, at 15:14, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > 
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> I think this back port breaks 6.6 build (namely vmlinux.o link stage):
>   LD [M]  net/netfilter/xt_nat.ko
>   LD [M]  net/netfilter/xt_addrtype.ko
>   LD [M]  net/ipv4/netfilter/iptable_nat.ko
>   UPD     include/generated/utsversion.h
>   CC      init/version-timestamp.o
>   LD      .tmp_vmlinux.kallsyms1
> ld: vmlinux.o: in function `__crash_kexec':
> (.text+0x15a93a): undefined reference to `machine_crash_shutdown'
> ld: vmlinux.o: in function `__do_sys_kexec_file_load':
> kexec_file.c:(.text+0x15cef1): undefined reference to `arch_kexec_protect_crashkres'
> ld: kexec_file.c:(.text+0x15cf28): undefined reference to `arch_kexec_unprotect_crashkres'
> make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> make[1]: *** [/home/ignat/git/test/mainline/linux-6.6.70/Makefile:1164: vmlinux] Error 2
> make: *** [Makefile:234: __sub-make] Error 2
> 
> The KEXEC config setup, which triggers above:
> 
> # Kexec and crash features
> #
> CONFIG_CRASH_CORE=y
> CONFIG_KEXEC_CORE=y
> # CONFIG_KEXEC is not set
> CONFIG_KEXEC_FILE=y
> # CONFIG_KEXEC_SIG is not set
> # CONFIG_CRASH_DUMP is not set
> # end of Kexec and crash features
> # end of General setup

Odd, why has no one see this on mainline?  Are we missing a change
somewhere or should this just be reverted for now?

thanks,

greg k-h
