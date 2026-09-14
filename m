Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EBB43BDD8;
	Mon, 14 Sep 2026 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382301; cv=none; b=V1l+cplGMX+vgB0guOlN8Qs5n8/ni7d838903dyajc80ATnFadQzyMKhUprKrzMC618Cfrd86XL2N+gf8D6UQbcEMc4WIAuxdw0mBfIKrV12gIQGNwc2UTPfPQcQQ44555IALTYwiMdifKtv03r0eCFOkkOKJI8EOrq7W7huVbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382301; c=relaxed/simple;
	bh=whUB1yhzHxRr3nRoZ/adT8M0yAcswBs5gdIVCaZFZD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WygpjvOc3QCOLchnaOTM8JYVbPBHdHCsYA7vsfd6CLwtV2CjErVKGH0mIhl/L+x1niaQZDPLVZeofQj8fmjpfJ2UWPi/1nu3rH7o6CJsfrGf7BKDqrE/c+TGBbKBoNjTuduxj/5JdV4PB5Iqd3masVWSgU9zIHhvu0plUPWRenE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4xtUqa7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4xtUqa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CE71F000FF;
	Mon, 14 Sep 2026 10:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789382299;
	bh=EbFzNn+2M8jjWoot68ZL9RXuYAZW2hXryadFLldTWok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I4xtUqa7QP/ZRJ5/Av5Rj5iTNLkWhHau27ZBHXWHVsBvbwtSuwLS/9YD7+NmE+L/2
	 LhvLH0pjd5ltqDon0FfQjZh9ClIUsBqfXp8P3QqChkl4Py1UhMHEjKUGofQ51M4M/S
	 wJjmomO6/NsxSh0t9OxVgdEtFfv8h5bh7bPHBiAQ=
Date: Mon, 14 Sep 2026 12:38:10 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Sergei Litvin <litvindev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 702/935] scripts/tags.sh: Prevent binary files
 appearing in cscope.files
Message-ID: <2026091400-prevent-collie-7e61@gregkh>
References: <20260912065526.833703348@linuxfoundation.org>
 <20260912065542.937384676@linuxfoundation.org>
 <CANiq72mEfbYd=Xz+f2MXku3RHt_oH7KJBi0iSHCOD47oPDo9=w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72mEfbYd=Xz+f2MXku3RHt_oH7KJBi0iSHCOD47oPDo9=w@mail.gmail.com>

On Sun, Sep 13, 2026 at 05:09:58PM +0200, Miguel Ojeda wrote:
> On Sat, Sep 12, 2026 at 9:00 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 5.15-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Sergei Litvin <litvindev@gmail.com>
> >
> > [ Upstream commit a9b93c34625a27bed5dc0f80ee2a359ceb955172 ]
> >
> > When executing the command `make COMPILED_SOURCE=1 cscope`, the resulting
> > `cscope.files` file contains filenames with the extensions *.rlib, *.rmeta,
> > and *.so.
> >
> > To fix this, modify the regular expression in the `all_compiled_sources()`
> > function so that only files with the extensions *.h, *.c, *.S, and *.rs are
> > accepted.
> >
> > The issue has been introduced by commit 4f491bb6ea2a ("scripts/tags.sh:
> > collect compiled source precisely") which implemented the parsing of
> > compiled sources from *.cmd files instead of using the "find" command.
> >
> > Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")
> > Signed-off-by: Sergei Litvin <litvindev@gmail.com>
> > Acked-by: Miguel Ojeda <ojeda@kernel.org>
> > Tested-by: Nicolas Schier <n.schier@fritz.com>
> > Reviewed-by: Nicolas Schier <n.schier@fritz.com>
> > Link: https://patch.msgid.link/20260714083331.69482-1-litvindev@gmail.com
> > [nsc: cleaned-up commit message line breaks and removed cc trailers]
> > Signed-off-by: Nicolas Schier <nsc@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> (Same comment as for 5.10.y) Before 6.1 there was no Rust, so in
> principle this may not be needed (at least for the `*.rlib`, `*.rmeta`
> and the Rust `*.so`s from proc macros), but it shouldn't hurt.

Thanks for the review, I'll just leave it as is :)

greg k-h
