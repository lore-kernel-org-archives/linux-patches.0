Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E5F2BE03B;
	Wed, 16 Jul 2025 20:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752696176; cv=none; b=N/IKEPNtSrQg8R5jzMVVKKP1hc8qqrAlxA2A+2Jtx1ldzurtrzgzb4gvwwy780yphYsgbmu4hAYevcft2wD81EOcm/cL0snp/9u/1dIcbeJcaQLBe1XyY9IQGEU2SXqVgiuaqMaaZSJCIL27/NDjY395cJoqQMq/OIv/r/Gsb0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752696176; c=relaxed/simple;
	bh=/VIpHxppoSDtA6B/euDaxZupotZfIjwZ2wJ60Z88lrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsrZ/5bE1lq7jkHmMXJ5rg7pRBl2rhHd/b/OCvT3YFneO+bPjdfMZqpZIpzKCtlHzlh1wCMa7zYnADRnGW8MOrOofvVppQBxTVK8jvCZsqLEtn81fcCO4isrLHwFqRSX8m5FYQH1BuXz2jla8jktaXGR88y2qVWvRNNLpy46XZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UrEI8Q4a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UrEI8Q4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80EEFC4CEE7;
	Wed, 16 Jul 2025 20:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752696176;
	bh=/VIpHxppoSDtA6B/euDaxZupotZfIjwZ2wJ60Z88lrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UrEI8Q4ay4GMr5GqbOQ8Pf3vGwrLWG/tQDGcdcdJSgLH7mNYyDgEmYPjYDzxceabE
	 l5kHuFMh/wIBcA6PQu64k1mMK53wOUZhbjmgFN0gKOQoJJXQKMTRFVZoRDKDaJeBl1
	 +AoaidezL8zIfGD3SdWohkUGWLNDCX7hKBsBwtENU3K7ielESD0EndLjgvRjEQZFFl
	 +dRKrSK3f11T8SlYZUXSd31MKWRVS5UOCoMQp+AAcbb2T1GXX3fnNNXrltTlCY+e5F
	 RNnxPFHCaXCKxg0A6Ej+aNMagY+t1PNE3eW+5zCn4ImpF1AswODcvh0AGqKpQGXlo7
	 4jetbT4gvgOYQ==
Date: Wed, 16 Jul 2025 16:02:51 -0400
From: Nathan Chancellor <nathan@kernel.org>
To: Charles Keepax <ckeepax@opensource.cirrus.com>
Cc: Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>, linux-sound@vger.kernel.org,
	patches@opensource.cirrus.com, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] ASoC: SDCA: Fix uninitialized use of name in
 sdca_irq_populate()
Message-ID: <20250716200251.GB4010969@ax162>
References: <20250715-sdca_interrupts-fix-const-uninit-warning-v1-1-cc031c913499@kernel.org>
 <aHdh8LOJblKP01rd@opensource.cirrus.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHdh8LOJblKP01rd@opensource.cirrus.com>

On Wed, Jul 16, 2025 at 09:25:20AM +0100, Charles Keepax wrote:
> On Tue, Jul 15, 2025 at 08:34:21PM -0700, Nathan Chancellor wrote:
> > After a recent change in clang to strengthen uninitialized warnings [1],
> > it points out that name is used uninitialized in sdca_irq_populate():
> > 
> >   sound/soc/sdca/sdca_interrupts.c:388:6: error: variable 'name' is uninitialized when used here [-Werror,-Wuninitialized]
> >     388 |                                         name, ret);
> >         |                                         ^~~~
> > 
> > Remove name and use the name member in the interrupt variable, as that
> > is the proper string to print.
> > 
> > Fixes: b126394d9ec6 ("ASoC: SDCA: Generic interrupt support")
> > Link: https://github.com/llvm/llvm-project/commit/2464313eef01c5b1edf0eccf57a32cdee01472c7 [1]
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> 
> A fix is already pending for this one:
> 
> https://lore.kernel.org/linux-sound/20250715151723.2964336-3-ckeepax@opensource.cirrus.com/T/#u
> 
> Although they are identical so don't mind which gets merged :-)

Whoops, I should have checked for duplicates like I usually do...

I see Mark has merged your change now so we are all good here.

https:///git.kernel.org/broonie/sound/c/71562278a189af2ca202eafa0ab71a9b68469207

Cheers,
Nathan
