Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38B219CD1D;
	Thu, 10 Oct 2024 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728582213; cv=none; b=goTqJfJFP3Jvub/6FGwGlFOvbLuAr0LFeUJdHFFTUqfn3VhxUt0sGAkvbqmIHSbJQqVF6pH5ETCEGnvWptvoObi/TMT8P2dgc4pRbfKErAKo94h0NyzlpAJasA3cQcOHVL/jId/420y6Wh40VBCq59rckosA9f6X2TDrBrslKN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728582213; c=relaxed/simple;
	bh=RMXsM9+daLz0wDlNHh/0NCwE/l30K6rBnwaZjnhUduA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oT5mbTznaFhkPYHwqDxIcZcU3734uG2risjbqz+ShVWueAzmjNntt29YtXBYOiYQiHUd44imxKPf82ZQ2q+sWBvpS6+qMXPXuMTUwu8je8TbThfXl5+o6PbkTQzfdEarZunOoELn7KhHGrwQpHEOd/pvzIk1AjhPFoRDzSUNaVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MmxR6ljD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MmxR6ljD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7225C4CEC5;
	Thu, 10 Oct 2024 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728582213;
	bh=RMXsM9+daLz0wDlNHh/0NCwE/l30K6rBnwaZjnhUduA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MmxR6ljDZQNaWsEGh7lI3NoP4YGIF6dWWnYUA8Agmgo8+GqnzBrafKDgimmEhJ2ry
	 6x3dON7Jwnhb2c5BZzwPshbhzha8PFSYiH25FRM1LCKZqIMDZNHajfecrd0AUTYekj
	 Cx9fFrSWP5lRSRWJdCnWdXeWroZ3kc+Pr/j9tZIYOY/BcDH45JqyAm3zaKnhz/rPs1
	 ig03hT4DRM+FFDVHJvXMo8rJ8LClpUbU8jbjVj8675Onmp6oMVwnh9qYLzY1SHpKP4
	 j+4dQ5nfuH0AH2bxM+8k90zuf5D1acObMwGe8kRH2a29LZ7kM7vPx2uJXewtKgSF+c
	 MiWyH8PYUXmeg==
Date: Thu, 10 Oct 2024 12:43:31 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: patches@lists.linux.dev, devicetree@vger.kernel.org,
	Saravana Kannan <saravanak@google.com>,
	linux-kernel@vger.kernel.org, David Gow <davidgow@google.com>,
	Guenter Roeck <linux@roeck-us.net>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] of: Skip kunit tests when arm64+ACPI doesn't populate
 root node
Message-ID: <172858218311.2064946.5279211050619703517.robh@kernel.org>
References: <20241009204133.1169931-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241009204133.1169931-1-sboyd@kernel.org>


On Wed, 09 Oct 2024 13:41:31 -0700, Stephen Boyd wrote:
> A root node is required to apply DT overlays. A root node is usually
> present after commit 7b937cc243e5 ("of: Create of_root if no dtb
> provided by firmware"), except for on arm64 systems booted with ACPI
> tables. In that case, the root node is intentionally not populated
> because it would "allow DT devices to be instantiated atop an ACPI base
> system"[1].
> 
> Introduce an OF function that skips the kunit test if the root node
> isn't populated. Limit the test to when both CONFIG_ARM64 and
> CONFIG_ACPI are set, because otherwise the lack of a root node is a bug.
> Make the function private and take a kunit test parameter so that it
> can't be abused to test for the presence of the root node in non-test
> code.
> 
> Use this function to skip tests that require the root node. Currently
> that's the DT tests and any tests that apply overlays.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/r/6cd337fb-38f0-41cb-b942-5844b84433db@roeck-us.net
> Link: https://lore.kernel.org/r/Zd4dQpHO7em1ji67@FVFF77S0Q05N.cambridge.arm.com [1]
> Fixes: 893ecc6d2d61 ("of: Add KUnit test to confirm DTB is loaded")
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  drivers/of/of_kunit_helpers.c | 15 +++++++++++++++
>  drivers/of/of_private.h       |  3 +++
>  drivers/of/of_test.c          |  3 +++
>  drivers/of/overlay_test.c     |  3 +++
>  4 files changed, 24 insertions(+)
> 

Applied, thanks!

