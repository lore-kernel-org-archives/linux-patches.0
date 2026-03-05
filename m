Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD0830EF92;
	Thu,  5 Mar 2026 22:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772748487; cv=none; b=V1/WJR4SOpeaPP8mrOK5RJ5RNYhXFANBaVD2H5e9Z5LVCI2Fqivhyy64WZfNGT5c0gSiDQ8B0WkIFZLQ56FbbnKW+Lt6vZPFtP41ASoKk04MapE/zj1Ec3ic2Hmp3M+bDmjlsnQOZmaAPQlL8sfdRWlmXNR0IjrmHVsyXvJU5PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772748487; c=relaxed/simple;
	bh=StWo5LLhBff0BVoy0QIwwf+JJPKW3baLEVbZtt/X2fM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pj7ARCVbifpcbbnXMjxR+EA8M++oMcMd+1NhJ+jsIYdO7IFql7K1c/tg/Rgx1dbrdACEK6Ahgjjh7h5CCaQVS/tCLncoBNogplXC5Y5YcMdjs6t/Xm2k2tchtNSPV4H2xqmZ2fHd6xkA/j5q1QcYlxGsC5VPSgN8q1RVhO7lG+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvVPV65r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvVPV65r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8E0C116C6;
	Thu,  5 Mar 2026 22:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772748487;
	bh=StWo5LLhBff0BVoy0QIwwf+JJPKW3baLEVbZtt/X2fM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jvVPV65rwhU8NKn2mUvyRpGS6UVhrupbvf75lgy2kCgmRXJSLYkoKCiiG22g+KDxu
	 kI7y8gWBaTjShEBIPC/8K1RUAiDJBiVolDaLowSzNRBiuwQ3VOb0kZWkjzt4IdZRDT
	 AETHOPzryiUr3hf0Ibl+Ink6gKaRg+vuEutsMe9SzEhM8gLFq8cvwznjJAWyCLQQur
	 7BkOclbckQnOvdfrQsq8BeAuUdPRb8zPD+Xqibo7BU5K17HC8ypR/vmM8CcdrXKi0C
	 3ZXmA1dNWsLUJSmhNFTuz5AyHcODQ3mCsmxlRGCqKXdYEWyONs6BKSoFyvoEPyqWS4
	 +krmnZInLUj9A==
Date: Thu, 5 Mar 2026 15:08:01 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Message-ID: <20260305220801.GA3148061@ax162>
References: <20260302160955.2522727-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160955.2522727-1-sashal@kernel.org>

Hi Sasha,

On Mon, Mar 02, 2026 at 11:09:55AM -0500, Sasha Levin wrote:
> Jamie Iles (1):
>   i3c: remove i2c board info from i2c_dev_desc

You missed commit 6cbf8b38dfe3 ("i3c: fix uninitialized variable use in
i2c setup") as a fix for this one, as rightfully pointed out by clang:

  https://lore.kernel.org/177198114226.2577.15577566399399369654@d14e337afe00/

  $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/i3c/master.o
  drivers/i3c/master.c:2203:3: error: variable 'i2cdev' is uninitialized when used here [-Werror,-Wuninitialized]
   2203 |                 i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
        |                 ^~~~~~

I guess that report was missed because it was not actually addressed to
anyone?

FWIW, this patch appeared in a previous 5.15-rc release but Ben
rightfully pointed out it really was not necessary and Greg said he
would fix it up by hand:

  https://lore.kernel.org/2026011724-florist-brook-5f1f@gregkh/

Guess that never happened?

Cheers,
Nathan
