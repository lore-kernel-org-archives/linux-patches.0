Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E6327FD71;
	Tue, 24 Jun 2025 10:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760077; cv=none; b=irhilUMK+3R0IQfnS+gvaexRC/pNG6JBwNlYIpTkgD9Dp2Shuhs/utDR4YJvg95q3ys22hPDeevFhnTfUBa+5vlOGLFSFa0nCBq5RD0e0E/jdxnBZk0gY60ubS+tSLX6Hko4RxVM/l77H+BWq/LgLTcRdIjke6V1UN1DsvQZPfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760077; c=relaxed/simple;
	bh=nrP7ZtDg8PghhrvJl12FrPeewB/my8icK6QKy2cwsKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TdWU5PJpnxo9d6fyzslPuMDwjX8YvGtwFeCN0LtXDZhDfI+Cjuo40U4Mjy8FJjH2th7F6Vz8Xa62JiNQw0nU2xN+t7SQErkZuK4iTwSXEk7jmU0LvifN20FB5Rz11O4ARfW6OMhDTTo84DYqL0sE49xBIWOpnsg3N7WGginMxD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nesixPWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nesixPWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90B0C4CEEE;
	Tue, 24 Jun 2025 10:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750760076;
	bh=nrP7ZtDg8PghhrvJl12FrPeewB/my8icK6QKy2cwsKI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nesixPWFd9q/ggOLi71qsoH+I6BbH8l2ORpuQof/QimdccCOXe6JsJwUCLnXc8IU/
	 rMJTBNEV61YhY6V9csCkyWrw56rf7x4JIAvS+bh61D2lAU107XD+x8BgZpal+8PjHn
	 tIhX9ja3h9rimLfkdrijxGK/45eQmoHrILB/Xit9CUUf1R/W+8ic34trdcK6GwMa/W
	 u/P/JlOsuXtwcdbwjZ6+pXDhhz/zjiSTq8A/JHcGkPVGE6g/TPVh9hDHin9s99dQij
	 wsBIbbUN3FlUdBLWqqd1XfdB2gL/p9Aapz0oW4iTpqe4Vgd76Omthh+Jh/4hJadA3X
	 C+XxUZMTV7sPQ==
Date: Tue, 24 Jun 2025 12:14:32 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>,
	Benno Lossin <lossin@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Alice Ryhl <aliceryhl@google.com>,
	Sasha Levin <sashal@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Christian Heusel <christian@heusel.eu>
Subject: Re: [PATCH 6.15 515/592] rust: devres: fix race in Devres::drop()
Message-ID: <aFp6iA8zwL9XX6US@pollux>
References: <20250623130700.210182694@linuxfoundation.org>
 <20250623130712.686988131@linuxfoundation.org>
 <DAUALX71J38F.2E1VBF0YH27KQ@kernel.org>
 <eYjMg1ry65KlJgUKnqEjkoG6RkGBk1xtTYP1Af8fRBlrZyO8jOIrnAPs209lnvPqLwwwI0uQimzOx-EjmuhPEQ==@protonmail.internalid>
 <025d9611-2a7f-40fd-9124-7b62fe6c5e84@leemhuis.info>
 <DAULY9E26AKQ.3DCD5IW7CWUI7@kernel.org>
 <ae03cf82-dfda-46fc-914d-2e329cd8d3da@leemhuis.info>
 <2025062439-scheming-scale-7ab0@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025062439-scheming-scale-7ab0@gregkh>

On Tue, Jun 24, 2025 at 10:03:42AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jun 24, 2025 at 10:24:46AM +0200, Thorsten Leemhuis wrote:
> > On 24.06.25 10:07, Benno Lossin wrote:
> > > I tried applying it on top of v6.15.3 and that also results in a
> > > conflict, but only in `bindgen_helpers.h` and `helpers.c`, so we can
> > > simply provide a fixed patch.
> > 
> > Yeah, that likely is needed to make Greg happy here.
> 
> For now I'll just go drop this commit and wait for it to be submitted in
> a series that actually builds.

I'll send a series based on v6.15.3.

The dependencies you already dropped, i.e.

	queue-6.15/rust-devres-fix-doctest-build-under-config_pci.patch
	queue-6.15/rust-devres-implement-devres-access.patch

won't be needed any more.
