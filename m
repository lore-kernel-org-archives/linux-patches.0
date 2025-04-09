Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E455B1D7999;
	Wed,  9 Apr 2025 06:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744178661; cv=none; b=H1oIfH3Y5t64004l4gRpr6cUDjjOPxbapBlMiz3liJ9mjggVqSeKBw5Wg05LUqRBdaRjR4BjNCxXVkKkevxTYSm9gc4//1R+hUmyo+ZZUevQeOZVEVGw1ndTi/6z3zgpoLfruAbe/RgHozjplscDDEs6Gy4UXXHIpSuAHbfqXbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744178661; c=relaxed/simple;
	bh=NVXvi704lpNNBXadZZQwIK7carHtZZXA1sXKsSL2oUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h1RhIxYV/hwuvi1RKGAalF0aG4EOYQJB/Z6y9p24xB/PHRt+pJU0UUlWB+SK2aDIvYP+tnnRZRVGHiTL49JdP8lW6r8R2BXsXZDQnjN9TLBN306/+pI5R+9pOSqhb1DomHJT1Itnjx/AhcfzxKoV4Tqqe36qXxSNpnWBV/kvcNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfkV8USq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfkV8USq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0064C4CEE3;
	Wed,  9 Apr 2025 06:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744178660;
	bh=NVXvi704lpNNBXadZZQwIK7carHtZZXA1sXKsSL2oUk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mfkV8USqB6vuXM8e5Uw6ZsNuA2755XnHaR1ULfMxYqND5IDpXs7+hz4Vq0fT9KMsM
	 hLX0VF+B97zNDpTUi6YjGELMsK8Tn6GQnh7SADFMktWTTl8GfjafXr5T3UJflEQzPD
	 0+9zw0xEacZXGK6U77K1i8XNH3LpyLzitCYFeQOU=
Date: Wed, 9 Apr 2025 08:02:45 +0200
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
Message-ID: <2025040924-dynasty-studio-32d3@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <20250408104917.927471463@linuxfoundation.org>
 <ttwnzohgi7cwocpeu7ckjliv4ufg2hajvkx43nkygzj7i23ea3@hr4aul3pclz4>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ttwnzohgi7cwocpeu7ckjliv4ufg2hajvkx43nkygzj7i23ea3@hr4aul3pclz4>

On Wed, Apr 09, 2025 at 02:47:46AM +0000, Shinichiro Kawasaki wrote:
> On Apr 08, 2025 / 12:40, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> > 
> > [ Upstream commit 2cadb8ef25a6157b5bd3e8fe0d3e23f32defec25 ]
> > 
> > The null_blk configfs file 'features' provides a string that lists
> > available null_blk features for userspace programs to reference.
> > The string is defined as a long constant in the code, which tends to be
> > forgotten for updates. It also causes checkpatch.pl to report
> > "WARNING: quoted string split across lines".
> > 
> > To avoid these drawbacks, generate the feature string on the fly. Refer
> > to the ca_name field of each element in the nullb_device_attrs table and
> > concatenate them in the given buffer. Also, sorted nullb_device_attrs
> > table elements in alphabetical order.
> > 
> > Of note is that the feature "index" was missing before this commit.
> > This commit adds it to the generated string.
> 
> This patch and the following 3 patches for null_blk add a new feature for
> debugging. I don't think they meet the criteria for backport to stable
> kernels. I suggest to drop them.

Ok, these were in dependancy for a different change, let me see if I can
rework things to remove them...

thanks,

greg k-h
