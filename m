Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3AE4E1D5;
	Wed, 20 Mar 2024 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710952172; cv=none; b=e3G0DECwf+aRQHVA75Vq0e+9GIb4CXWNPi8DprxEnj0IyqG7jFVPwW+ihPHw76SDgd27qyyN2JYjBNRPYnvzQEVhBf8Y1uKkFoKJkIm0TbS3KjA9ntrhqqKDNGnyndrWZcmddwUrsKV68FLqSKY1aChlK2+9VjXTwqzQEIuXmpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710952172; c=relaxed/simple;
	bh=s6j5OTj/cWvdBWtWXyISEbqo2PuTUp5fqmDFLZlIea0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T1qhT20fhvSNEhunrkaMygUB5OmuT8Ns3XAW1m0NSStcLWtKitrdFPloHtwR0FriR4G4gw91MpuiJaR5mpqx0jZzcc3YU+TOTIm97Iv+HaNtya2rtQoOFbSAVL6jpnPg2r4+V8z4B5nl4CECq6FLl/eh8TSd7stLHnANEWjVQRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XChYqn3h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XChYqn3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CF7C433F1;
	Wed, 20 Mar 2024 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710952172;
	bh=s6j5OTj/cWvdBWtWXyISEbqo2PuTUp5fqmDFLZlIea0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XChYqn3hqxA7r1TAxQT7DOQKuIHUjVwsmEJtvFgt+kuKHFsPslkvrOM8Q1imaqspd
	 WmAJJQPbWzFEbJfXz+gbbQOJSHvX6HBmueYVXugVKAwJIlLNolVF1bd1yunu1+dT1C
	 77ywABRV+AkcHtJjeeia0qoWG32JT9ckVocnlhiKIrurOLwc/BG8lMotb/6DsDIe6q
	 sVM3ANaSAcN6uSEOzGTftqV3WOTVLCNblTAkkFsu0qfUVIqkIcukM2JP1nNwE6WyY3
	 1jONuu6RLuYFdJITW9DR7n/SN5HGhvmXcf9bh6U0/fyB7ZMPQmDKBylz5ohhV0yuYt
	 4SUf2rcTfYdGg==
Date: Wed, 20 Mar 2024 11:38:12 -0400
From: Sasha Levin <sashal@kernel.org>
To: Ralph Siemsen <ralph.siemsen@linaro.org>
Cc: gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: v4.19 backport request for crypto af_alg
Message-ID: <ZfsC5FvYwg85nc9o@sashalap>
References: <20240320143143.1643630-1-ralph.siemsen@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240320143143.1643630-1-ralph.siemsen@linaro.org>

On Wed, Mar 20, 2024 at 10:31:43AM -0400, Ralph Siemsen wrote:
>I have found a regression in userspace behaviour after commit 67b164a871a
>got backported into 4.19.306 as commit 19af0310c8767. The regression
>can be fixed by backporting two additional commits, detailed below.
>
>The regression can be reproduced with the following sequence:
>
>echo some text > plain.txt
>openssl enc -k mysecret -aes-256-cbc -in plain.txt -out cipher.txt -engine afalg
>
>It fails intermittently with the message "error writing to file", but
>this error is a bit misleading, the actual problem is that the kernel
>returns -16 (EBUSY) on the encoding operation.
>
>The EBUSY comes from the newly added in-flight check. This check is correct,
>however it fails on 4.19 kernel, because it is missing two earlier commits:
>
>f3c802a1f3001 crypto: algif_aead - Only wake up when ctx->more is zero
>21dfbcd1f5cbf crypto: algif_aead - fix uninitialized ctx->init
>
>I was able to cherry-pick those into 4.19.y, with just a minor conflict
>in one case. With those applied, the openssl command no longer fails.
>
>Similar fixes are likely needed in 5.4.y, however I did not test this.
>
>No change is needed in 5.10 or newer, as the two commits are present.
>
>Please add the two commits to 4.19.y (and probably also 5.4.y).

I'll add both to 4.19. They already exist in 5.4. Thanks!

-- 
Thanks,
Sasha
