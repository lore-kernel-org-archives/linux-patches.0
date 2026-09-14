Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFA7331A65;
	Mon, 14 Sep 2026 09:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789378700; cv=none; b=qf7lC/yHvabwZjqDF5hPc94OY454xVEaFmLgdGhEGT4HtON0mcthfGwpdRebMrYzKfbsE/k/lpH2aaSlmQGBWMbrVeyHEMm4Azd3lki1WW1EFiOfGgu4ZMDS0gkxziVjhcrdt8Ws8tj1OTY6Gy/SVzqmkU/11lINVUvFg740WJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789378700; c=relaxed/simple;
	bh=fAuoBfBSXVu8qGEJhcGZWXyYVreFrZS4nXbHeXHaaV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tm2o4juQBNvda3Sl2aCanCBYdeaSvOUFXIQBkk1LBQfvtiSrLgoe1l5pwuLNHJ1Co6a3AvJEn0IyEyuKJoWy51/tFaYGNzhyo37omJEsmF4JtQOdyxrykZECJVTRCjR2b87xlHUMj7AQ94SI8eY3/RyekZqlwA4I0rb/LdQ0XX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zo7bWvrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zo7bWvrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA501F00893;
	Mon, 14 Sep 2026 09:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789378699;
	bh=UCTO2o4zNe6jB1gcf/7XmEqrf9Chx3zJ9uwM/TQdr10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zo7bWvrkKp7+V6n6Ik/2vP2RvNrQ+00D2T3+TQO+1tMRqhI+dfawHoIEtkWXf+Y//
	 ejyR0t76I83r6HirabV42vTYEd7NauUNY6y/Hx0wZ3m3WHXLQm84pgnyre1aVI4eur
	 hB6hhXM5s56UyZHAYc6k/977Jo2hhvx3OWXSc5Sk=
Date: Mon, 14 Sep 2026 11:38:09 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Wentao Guan <guanwentao@uniontech.com>
Cc: pschneider1968@googlemail.com, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
Message-ID: <2026091451-gauging-grumbly-41dc@gregkh>
References: <ef6ea817-371a-4038-a73d-274fece32f4b@googlemail.com>
 <20260912220531.858986-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912220531.858986-1-guanwentao@uniontech.com>

On Sun, Sep 13, 2026 at 06:05:31AM +0800, Wentao Guan wrote:
> Hi,
> 
> > Am 12.09.2026 um 08:36 schrieb Greg Kroah-Hartman:
> > > This is the start of the stable review cycle for the 6.18.52 release.
> > > There are 1518 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > Builds, boots and seems to works on my 2-socket Ivy Bridge Xeon E5-2697v2 server.
> > However, I do see the same strange dmesg warnings that I see in 6.12.110-rc1:
> > 
> > [    2.397237] Driver 'sr' needs updating - please use bus_type methods
> > ...
> > [   84.031323] Driver 'ses' needs updating - please use bus_type methods
> >
> > And again, these warning are new in this rc, they did not appear in 6.18.51.
> 
> Thanks for your report, i see the warning is related to the commit series:
> ("scsi: core: sysfs: Make use of bus callbacks")
> ... As it message describe ...
>     .probe(), .remove() and .shutdown() to eventually remove these. Until
>     all SCSI drivers are converted, this results in a runtime warning about
>     the drivers needing an update because there is a bus probe function and
>     a driver probe function. The in-tree drivers are fixed by the following
>     commits.
> ...

Yeah, that's a mess, I'll go drop this from 6.18 and 6.12 queues for
now, thanks for the review!

greg k-h
