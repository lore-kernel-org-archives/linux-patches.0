Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31519A95E;
	Tue, 25 Nov 2025 14:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764079933; cv=none; b=CNRA382MW3K6fLWJiamuZH9taOeNvpBrOY43Okf9pxNbYCR5jljQkgLxtIVApcTbpG2Rd9ZA9MwJotCvwehP1yuxbnrtFQRufQrryCHQEou8xgeEwCeE78+CLSt1tLJmKP1MqegbzuioSLTvzmKOH5aIYFC5qfboRISgKb+Op5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764079933; c=relaxed/simple;
	bh=QhgpD+9vvbH0qtF2rgazlBx30kjP9eig7ASRBbV5NAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jpBswZkyS4Q7xvU96S/P0dyvIp0smcrteQhEkNYFdRqIj3bOVIS13exi5nlfjeYAArJN2dV8SEXH+DkcCBjRYzn3CpnVjL5RsrFkxX9LRfjL+l21L5HBYd5z/I49jgEqTvsfG9yXtMl8QtUwBWTwpw6ESMYY/7GAAQoD3OPRwQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=ml8Z3B8a; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="ml8Z3B8a"
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id DE9EF5C40D;
	Tue, 25 Nov 2025 15:12:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1764079930;
	bh=QhgpD+9vvbH0qtF2rgazlBx30kjP9eig7ASRBbV5NAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ml8Z3B8ajG9wnGGQi5rrb2LrASOMiVc4D67mx2UzCCdmnhx+E25mu7aWwjFNb+kx7
	 uBTF+uRg2QJQwyp6MxlDF8DkQ+hNGYUZFeoeHU7euSqnccYSU1TLC1IQbxe26JSRrN
	 KXZUv033iRMQoc+SpbOiAG/pHDI3aq9Dbi6YhjRBJ6Cs/k9vOeTo1JjWthggKwh6EN
	 1n0vJ1hUHgt13KJtRN3Ji3hZmTWdsXh3KBY2KtMjGiVBH5iD63Lrkz4SakM5V5+2rc
	 R9z1Nys7YTrA8SmLmGpIvRnaBX3AnTNXsDWKtJTYBtQelZSASM6WcINiYSu8SFKs6Y
	 LAEY/tKvkgkvQ==
Date: Tue, 25 Nov 2025 15:12:08 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Joerg Roedel <joerg.roedel@amd.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH] iommupt: Fix unlikely flows in increase_top()
Message-ID: <qvvxh7pn3i6l4bsfyvgjcjc7mozivdbkkfybhwt7b32gvt23r4@yx5lczkiibpq>
References: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-93d0836a0e54+aee-iommupt_increase_fix_jgg@nvidia.com>

On Thu, Nov 20, 2025 at 02:47:42PM -0400, Jason Gunthorpe wrote:
> Since increase_top() does it's own READ_ONCE() on top_of_table, the
> caller's prior READ_ONCE() could be inconsistent and the first time
> through the loop we may actually already have the right level if two
> threads are racing map.
> 
> In this case new_level will be left uninitialized.
> 
> Further all the exits from the loop have to either commit to the new top
> or free any memory allocated so the early return must be a goto err_free.
> 
> Make it so the only break from the loop always sets new_level to the right
> value and all other exits go to err_free. Use pts.level (the pts
> represents the top we are stacking) within the loop instead of new_level.
> 
> Fixes: dcd6a011a8d5 ("iommupt: Add map_pages op")
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/aRwgNW9PiW2j-Qwo@stanley.mountain
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/generic_pt/iommu_pt.h | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)

Applied, thanks.
