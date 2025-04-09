Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FC25A2CA;
	Wed,  9 Apr 2025 07:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744184209; cv=none; b=GLWvSzIkmjjt/bZgHOe3mMUl4ofxDs/YsH1e4Ewkh9PoRmTVEHmCVR4urwMenEkUHMfW1beoQFm4xKhHcpBmk05QfdDolzmtr+6cNb1oVGkSIFZOLUUFzDXk0gcFBtxFlS9AIvCYNkWGo43O+9m/l9SDeiypINlw/87zfHULrMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744184209; c=relaxed/simple;
	bh=eiMl8cw8Y4EGk7zuG1n0Rg0KaUwFORE1+od021eDqU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEyFPDUR/lpLpMpFAoe5RcTpQVFPwf5UlU6TDwJI0hZP06oeBFaW8w+bHeC/5hE9i+G3Nj2I4DjeOlPy0FH/lVnOxC5nc3pqlYUQKrISupAd0yFTMWWfWzfCdRYO3eDasEKnVrlERC2A7kvgn615gOvOXJkWFHb9ywTTHr2L064=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycOPDYkA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycOPDYkA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D03C4CEE3;
	Wed,  9 Apr 2025 07:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744184208;
	bh=eiMl8cw8Y4EGk7zuG1n0Rg0KaUwFORE1+od021eDqU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ycOPDYkAysgEvQbAwmSl44P5n/yj1i2fNB3IarVcbd68k10tokCpQ/jfEl7ufZmn3
	 n1vpVkVzCkb5RZG1t/690u4W78UUVBmLvhoU/YSi1VshkTcNv6dJTicqb7ukxEBdfC
	 MNLNs5q3wDHWHK7PIOPH79pTMZgkss5cDUS/6Yaw=
Date: Wed, 9 Apr 2025 09:35:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 157/731] null_blk: generate null_blk configfs
 features string
Message-ID: <2025040903-unloader-landfall-c974@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104917.927471463@linuxfoundation.org>
 <ttwnzohgi7cwocpeu7ckjliv4ufg2hajvkx43nkygzj7i23ea3@hr4aul3pclz4>
 <2025040924-dynasty-studio-32d3@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025040924-dynasty-studio-32d3@gregkh>

On Wed, Apr 09, 2025 at 08:02:45AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 09, 2025 at 02:47:46AM +0000, Shinichiro Kawasaki wrote:
> > On Apr 08, 2025 / 12:40, Greg Kroah-Hartman wrote:
> > > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > > 
> > > [ Upstream commit 2cadb8ef25a6157b5bd3e8fe0d3e23f32defec25 ]
> > > 
> > > The null_blk configfs file 'features' provides a string that lists
> > > available null_blk features for userspace programs to reference.
> > > The string is defined as a long constant in the code, which tends to be
> > > forgotten for updates. It also causes checkpatch.pl to report
> > > "WARNING: quoted string split across lines".
> > > 
> > > To avoid these drawbacks, generate the feature string on the fly. Refer
> > > to the ca_name field of each element in the nullb_device_attrs table and
> > > concatenate them in the given buffer. Also, sorted nullb_device_attrs
> > > table elements in alphabetical order.
> > > 
> > > Of note is that the feature "index" was missing before this commit.
> > > This commit adds it to the generated string.
> > 
> > This patch and the following 3 patches for null_blk add a new feature for
> > debugging. I don't think they meet the criteria for backport to stable
> > kernels. I suggest to drop them.
> 
> Ok, these were in dependancy for a different change, let me see if I can
> rework things to remove them...

Fixed it up now and dropped these, thanks.

greg k-h
