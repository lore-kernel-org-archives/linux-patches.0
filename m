Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48F34C821;
	Tue, 28 Oct 2025 17:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673664; cv=none; b=Bvov0VGqyJz6JG4YRhTdYmnu5DLQVyyI721JQojg3aH93SM5s/Cd8vt8vZos17vnfpC5M9yYS5tb8f60j1udoOSZ8pJGZFAfdyJ0SE/OKn9M5aBkI/VyWz8Hnpug2TNVau8clA0YvnR6jTKCsW0swewWnT+nl7doAMqO08nO/qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673664; c=relaxed/simple;
	bh=Cf95w80aUdBCexcAXXklVfncQajwu0vJl7eWpjuz120=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UzoA3Pqtz0u0EwYNJXjfiGA4FdAvBw32BVyIybT6KIfbwV9tZSHhVGnkDfJH4mSWIHYUT3onbHYRQZy8l7unfQbZ4e3/VeaFOuAZZz4fuWG5WIr8dRMT5xnWHTPxewjJpPsE1ADDfkbyjtkCDrR1poztYvk07QyBFkTHLw+lFaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b2nS80rP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b2nS80rP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7711CC4CEE7;
	Tue, 28 Oct 2025 17:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761673663;
	bh=Cf95w80aUdBCexcAXXklVfncQajwu0vJl7eWpjuz120=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b2nS80rP0T20ccHauAlWnqkCpTXh+lxp06dydw70FiFbZOkURPrwzQPiFlKQXJpDQ
	 9GlU5pgZodK7khU5a3Y7SHRv0+ydEpMhp7Xxroge7zYmIfIUN6SWtToe+ijInmYFdB
	 TsyU01hZm0IcnWZFvpGra89rRDPj8P+A1zE5KQFESZTdhlTqkCaLrlo76fOum6xS9V
	 RT30RsCm57QhhOKbkejmY9WU2K78zxjLPyXqU78qqVKlT8DbtP5r2qaOc2VcXBNcft
	 9te8eMunTbcHGf+NQ2KO3CcGDJiOiuDPXQoFR5oyLpA5/yGlDnpumQbIV2JFmUO2sW
	 u7FRTRCO+3NLA==
Date: Tue, 28 Oct 2025 13:47:42 -0400
From: Sasha Levin <sashal@kernel.org>
To: Brian Masney <bmasney@redhat.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>, Peng Fan <peng.fan@nxp.com>,
	mturquette@baylibre.com, sboyd@kernel.org, arm-scmi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.12] clk: scmi: migrate round_rate() to
 determine_rate()
Message-ID: <aQEBvswDDxZ0r-0t@laps>
References: <20251026144958.26750-1-sashal@kernel.org>
 <20251026144958.26750-39-sashal@kernel.org>
 <aP6rvQD-bwSkhfU5@redhat.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aP6rvQD-bwSkhfU5@redhat.com>

On Sun, Oct 26, 2025 at 07:16:13PM -0400, Brian Masney wrote:
>Hi Sasha,
>
>On Sun, Oct 26, 2025 at 10:49:17AM -0400, Sasha Levin wrote:
>> From: Brian Masney <bmasney@redhat.com>
>>
>> [ Upstream commit 80cb2b6edd8368f7e1e8bf2f66aabf57aa7de4b7 ]
>>
>> This driver implements both the determine_rate() and round_rate() clk
>> ops, and the round_rate() clk ops is deprecated. When both are defined,
>> clk_core_determine_round_nolock() from the clk core will only use the
>> determine_rate() clk ops.
>>
>> The existing scmi_clk_determine_rate() is a noop implementation that
>> lets the firmware round the rate as appropriate. Drop the existing
>> determine_rate implementation and convert the existing round_rate()
>> implementation over to determine_rate().
>>
>> scmi_clk_determine_rate() was added recently when the clock parent
>> support was added, so it's not expected that this change will regress
>> anything.
>>
>> Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
>> Reviewed-by: Peng Fan <peng.fan@nxp.com>
>> Tested-by: Peng Fan <peng.fan@nxp.com> #i.MX95-19x19-EVK
>> Signed-off-by: Brian Masney <bmasney@redhat.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Please drop this commit from all stable backports.

Ack, thanks for the review!

-- 
Thanks,
Sasha
