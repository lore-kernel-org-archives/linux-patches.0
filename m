Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6542AF16;
	Wed, 10 Apr 2024 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712758287; cv=none; b=g90mVm5VBO6h/QpBhh7sLVVSIeMJkjt2kThUme6SJ/QPfIU4CIDgoMF3k+13HEX1EWjXVhuxUWS4GWrKeS3/jtXaTFZGhYQZJ+D/i6J+AXUt4DAHwEyEgAQy7lNlqQufSDUsDGewzcT5OoOC5ThuydE9m8dPBJ/wx0jxnyPk+Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712758287; c=relaxed/simple;
	bh=iC8pANLoVkXWOBffF7q0ttCOLYpuhzCv8jeK3aUilqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K8OP7Jj5a901jjj9ES14HRgzNnuf+jAp9YdRdT/qVDSnjAdVe/jgO0siL0/O/Gt5kHjx81BLIoCbXC92GDBHhjqCWNh5UzgAysFysBoTqxRl5dcfIb5NDddn20MEtCUUi49jtj680AGF804hKbFDqmEA+NvVALzaObXbjRrZW48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1LA7jIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1LA7jIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C37C433C7;
	Wed, 10 Apr 2024 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712758287;
	bh=iC8pANLoVkXWOBffF7q0ttCOLYpuhzCv8jeK3aUilqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T1LA7jIlEiFcGu5A5ozvtKDHhJKFY38pL2KVSAMfF7nTB6JXEFsDvffriSJb2OAnf
	 X7Hmrse8/FT+mptd+nvk6FTp1L6QAlDKdaHV61B0Wd4i8W0AdeVIRKdzVTCPlv92Gi
	 D56tOGn70mQO7lHq4ku6aiS3DKwrfIzA4WELLVCw=
Date: Wed, 10 Apr 2024 16:11:24 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Pascal Ernster <git@hardfalcon.net>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
Message-ID: <2024041047-upright-smudgy-c380@gregkh>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
 <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
 <2024041024-boney-sputter-6b71@gregkh>
 <CAMj1kXHjwJnfjVgm=cOaJtJ=mF-mTLaoDM0wQyvvjL3ps9JEog@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHjwJnfjVgm=cOaJtJ=mF-mTLaoDM0wQyvvjL3ps9JEog@mail.gmail.com>

On Wed, Apr 10, 2024 at 08:43:24AM +0200, Ard Biesheuvel wrote:
> On Wed, 10 Apr 2024 at 07:46, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Apr 10, 2024 at 07:34:33AM +0200, Borislav Petkov wrote:
> > > On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> > > > Just to make sure this doesn't get lost: This patch causes the kernel to not
> > > > boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> > > > machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> > >
> > > I see your .config there. How are you booting the VMs? qemu cmdline?
> > >
> > > Ard, anything missing in the backport?
> > >
> > > I'm busy and won't be able to look in the next couple of days...
> >
> > As reverting seems to resolve this, I'll go do that after my morning
> > coffee kicks in...
> 
> Fair enough. I'll look into this today, but I guess you're on a tight
> schedule with this release.
> 
> Please drop the subsequent patch as well:
> 
> x86/efistub: Remap kernel text read-only before dropping NX attribute
> 
> as it assumes that all code reachable from the startup entrypoint is
> in .head.text and this will no longer be the case.

Given this is the only report, and it seems to be with an "odd" linker,
I'll leave it in for now to keep in sync with 6.9-rc.  If this is a
problem, we can revert the commits in a later release at any time.

thanks,

greg k-h
