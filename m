Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FCE25DB13;
	Tue, 24 Jun 2025 10:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760353; cv=none; b=W8PHYzNyEJbJQUU4yMOTIi9emd2zEcK1+hpT+A+fwPlVY2zLsX0VZw5nJCD1d9nk5m3a3rlEW8Sxkz9Rj4v5OmA2hoxgICQ7jrLctpZ6aM1pMHyNN2l6DBQtT935zDJZioOFWBnDYBqlHr7D5j2YJO+dNHSV5bialBvDsPi3+XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760353; c=relaxed/simple;
	bh=iWbqKwDTOe7uCugpjf2vh/zTmrUgw7bz0C7fMras7Vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=alPqSeCB6OBkRF1EBg2C3OPYddwa3I6b9+MgGQxJp6kdw8y0//wwn5LurIDApaPWLz58Gq80XNS2pKwQpzvbeLGxHLPhR7BjpfqmLNO5vcL0XC7x++aHuVNpBmswuhJLNr/8alEobvo/7jbsQP7Zp6Aj+ul0kiRhVNrDrpn/kYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2h7929y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2h7929y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85184C4CEE3;
	Tue, 24 Jun 2025 10:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750760352;
	bh=iWbqKwDTOe7uCugpjf2vh/zTmrUgw7bz0C7fMras7Vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2h7929yX2WSzxLh6fzqVrf6VuXl/6uHtVksDAcBR4c/p4qLr5b+5vu4Q+20ebqhf
	 N8YRAUp+29aJD68V4jvOJveZMUKAYNfiTB/D9bM2oEBNVvZBmpFEhQJiCZyC/Qn/xY
	 NG029Ar9Y30vFPYMVKKVPe1houz8da77H0VXUNL8=
Date: Tue, 24 Jun 2025 11:19:08 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
	Benno Lossin <lossin@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Christian Heusel <christian@heusel.eu>
Subject: Re: [PATCH 6.15 515/592] rust: devres: fix race in Devres::drop()
Message-ID: <2025062455-rogue-flagship-54a4@gregkh>
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130712.686988131@linuxfoundation.org>
 <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
 <eYjMg1ry65KlJgUKnqEjkoG6RkGBk1xtTYP1Af8fRBlrZyO8jOIrnAPs209lnvPqLwwwI0uQimzOx-EjmuhPEQ==@protonmail.internalid>
 <025d9611-2a7f-40fd-9124-7b62fe6c5e84@leemhuis.info>
 <DAULY9E26AKQ.3DCD5IW7CWUI7@kernel.org>
 <ae03cf82-dfda-46fc-914d-2e329cd8d3da@leemhuis.info>
 <2025062439-scheming-scale-7ab0@gregkh>
 <aFp6iA8zwL9XX6US@pollux>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFp6iA8zwL9XX6US@pollux>

On Tue, Jun 24, 2025 at 12:14:32PM +0200, Danilo Krummrich wrote:
> On Tue, Jun 24, 2025 at 10:03:42AM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Jun 24, 2025 at 10:24:46AM +0200, Thorsten Leemhuis wrote:
> > > On 24.06.25 10:07, Benno Lossin wrote:
> > > > I tried applying it on top of v6.15.3 and that also results in a
> > > > conflict, but only in `bindgen_helpers.h` and `helpers.c`, so we can
> > > > simply provide a fixed patch.
> > > 
> > > Yeah, that likely is needed to make Greg happy here.
> > 
> > For now I'll just go drop this commit and wait for it to be submitted in
> > a series that actually builds.
> 
> I'll send a series based on v6.15.3.
> 
> The dependencies you already dropped, i.e.
> 
> 	queue-6.15/rust-devres-fix-doctest-build-under-config_pci.patch
> 	queue-6.15/rust-devres-implement-devres-access.patch
> 
> won't be needed any more.
> 

Great, thanks for doing that.

greg k-h
