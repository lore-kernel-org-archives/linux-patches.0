Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335E324B17;
	Thu, 26 Feb 2026 13:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772112249; cv=none; b=Id/oxhWYQHP1DAnhPHNkZwxNJx59iu2V1GaUNqcKfhsBbkDaQ7YAkGuAQVuOuQ4M3YGreYlLh+N2mw/z9zbHE8p1+M3o5+CXtk7knad2RgElR+BUyX56PghSHdu9ijA+xpbr7eYLEFVDwoJl+yKypEcEOCr1eMqWnuFgzsOV63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772112249; c=relaxed/simple;
	bh=V81ePgAuGbagKH3XEQaK1KD4LuOQ/zN2cLnjJuL8eKE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=En+SzFqhZWJkc4AF85PTx95MSN35+oYZPOtGoZpsSAwU/hVDfbzVkXy8IF1QsVlHLl7pXQ0DgoQHlAjJWxbbS7TlX75PSNLonBFrb3J2jFk9jHzfkCMjiNNjudPJBDdKBmEXkgBWZ8H0m0+OhreefiTSu0k3+9v3lHf0LHozAWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEnwdmPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEnwdmPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147C0C116C6;
	Thu, 26 Feb 2026 13:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772112249;
	bh=V81ePgAuGbagKH3XEQaK1KD4LuOQ/zN2cLnjJuL8eKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aEnwdmPjeRqSD4W0QDHtDv1V0eCLZHktwSMw4CfpTgfjggrWInH6aV5ifHB/34CrZ
	 Pa3SMIKFXY99GuovK1ZtrnHvtfu/id52zvix8GOmeMjDrG9CHRssbrxBPz0YleY4Mw
	 9bLarrfuumy0vCmugB0GY9d/lebwNwFmNYm1PKkCqpy7b7vuCl9ZOfgnM0m+Byf1Y7
	 hI9qNUBqrbOnXZTe5NwrGXsYLJxWw9SVvtn/h3eo6oI1G/kvDp6CS3E+dp4Szsgjqi
	 L+Nr9O/kX+JWjFM68X+Oz4BFha7mwPSI84SLWqI2FBwvqPDG0zDN6GtbHmhnu0TsXF
	 iL/er81Gp++sQ==
Date: Thu, 26 Feb 2026 08:24:07 -0500
From: Sasha Levin <sashal@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.19-6.1] mmc: rtsx: reset power state on suspend
Message-ID: <aaBJd1ns_vZKzVN-@laps>
References: <20260219020422.1539798-1-sashal@kernel.org>
 <20260219020422.1539798-17-sashal@kernel.org>
 <CAPDyKFoPehkeOD1-U2CGd_1Owt2Ai6+28Epabz6wGnYVq6k=YA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAPDyKFoPehkeOD1-U2CGd_1Owt2Ai6+28Epabz6wGnYVq6k=YA@mail.gmail.com>

On Thu, Feb 19, 2026 at 11:27:35AM +0100, Ulf Hansson wrote:
>On Thu, 19 Feb 2026 at 03:04, Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Matthew Schwartz <matthew.schwartz@linux.dev>
>>
>> [ Upstream commit eac85fbd0867c25ac517f58fae401d65c627edff ]
>>
>> When rtsx_pci suspends, the card reader hardware powers off but the sdmmc
>> driver's prev_power_state remains as MMC_POWER_ON. This causes sd_power_on
>> to skip reinitialization on the next I/O request, leading to DMA transfer
>> timeouts and errors on resume 20% of the time.
>>
>> Add a power_off slot callback so the PCR can notify the sdmmc driver
>> during suspend. The sdmmc driver resets prev_power_state, and sd_request
>> checks this to reinitialize the card before the next I/O.
>>
>> Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
>> Link: https://patch.msgid.link/20260105060236.400366-2-matthew.schwartz@linux.dev
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>NAK.
>
>This patch is reverted in mainline, as it's not the proper fix.

Dropped, thanks.

-- 
Thanks,
Sasha
