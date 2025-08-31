Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B12326D4EF;
	Sun, 31 Aug 2025 17:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756660500; cv=none; b=SpZjjAyXOtV5jtQqdWCWPLKhd4pouB3yLhU2foSJBIQyI9GnpeXN19zskwROH0fSzHEzEKhwDRZUnZ5/DPW6ndXKq4jMw8haxDTMXO3/VgLsg4dTHn6p8kx5IHpnVUO5dIwGU29cmGReHaS14Pj6k46tOILiXgk/t2MGEH5T2OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756660500; c=relaxed/simple;
	bh=CCa+jzSOn6WzWuCDQPyBut8ZWYtn4bP2g8tFMkhIGPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3ROwSgyswBNP+79jzbjm+e8ab8z7p0Ae97xc473n16mYdXYJrO8RpURTpdduQy71wiN6rZyYzHGHyHl2gcyjm8JpGQMdxe2ZzUaSVKDZlygnJi9QSmOX4UW3B/O28dK1Iz4AxsMlI8JQBJ1G5E64e+WUjgNdE1co+oz8nRPd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJSkucR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJSkucR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAC2C4CEED;
	Sun, 31 Aug 2025 17:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756660499;
	bh=CCa+jzSOn6WzWuCDQPyBut8ZWYtn4bP2g8tFMkhIGPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BJSkucR8k2Zrl9c1cJhT+XpuGofsGck06N0GuUZGHy8R0N5bufjQ40NzaLXaeC3ps
	 i0W86BAiF14FrLqy4lwO/yy5CMMXSX3NAvXKviPA1cRENix2pAqEQWWTc0vGpezcQk
	 sc9cU27arvJYC4ZwELAu70AomdORP6waGOI1yVWyVqzzY5PGaaAhGOYoQBuONRrcut
	 Tv/Vt5/UuCL1FfgeO+hr2TxHbXyq+r3gehE6/X5ShrqU+MPymjB3dysopS0nTahui8
	 +Fe3Kg0ORh/okooWpporcvfVJLhddApzDNlAQFwkgkAqsbtsl38S0i579Xz0WXOhpd
	 rXVSiTRk4idiQ==
Date: Sun, 31 Aug 2025 13:14:58 -0400
From: Sasha Levin <sashal@kernel.org>
To: Stephan Gerhold <stephan.gerhold@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Dan Carpenter <dan.carpenter@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Rob Clark <rob.clark@oss.qualcomm.com>
Subject: Re: [PATCH 6.16 278/457] soc: qcom: mdt_loader: Fix error return
 values in mdt_header_valid()
Message-ID: <aLSDEihd4QV13dG1@laps>
References: <20250826110937.289866482@linuxfoundation.org>
 <20250826110944.250667129@linuxfoundation.org>
 <aLR9uVafCI6Xd8aC@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aLR9uVafCI6Xd8aC@linaro.org>

On Sun, Aug 31, 2025 at 06:52:09PM +0200, Stephan Gerhold wrote:
>Hi Greg,
>
>On Tue, Aug 26, 2025 at 01:09:22PM +0200, Greg Kroah-Hartman wrote:
>> 6.16-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Dan Carpenter <dan.carpenter@linaro.org>
>>
>> commit 9f35ab0e53ccbea57bb9cbad8065e0406d516195 upstream.
>>
>> This function is supposed to return true for valid headers and false for
>> invalid.  In a couple places it returns -EINVAL instead which means the
>> invalid headers are counted as true.  Change it to return false.
>>
>> Fixes: 9f9967fed9d0 ("soc: qcom: mdt_loader: Ensure we don't read past the ELF header")
>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Link: https://lore.kernel.org/r/db57c01c-bdcc-4a0f-95db-b0f2784ea91f@sabinyo.mountain
>> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>This patch breaks firmware loading on most Qualcomm platforms, see e.g.
>the replies from Val and Neil on the original patch [1, 2].
>
>There is a fix pending, which should soon land in mainline:
>https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?h=qcom-drivers-fixes-for-6.17&id=25daf9af0ac1bf12490b723b5efaf8dcc85980bc
>
>For the next 5.4-6.16 stable releases, could you pick up either the fix
>or revert this patch together with commit "soc: qcom: mdt_loader: Ensure
>we dont read past the ELF header"?
>
>The problematic commit ("soc: qcom: mdt_loader: Fix error return values
>in mdt_header_valid()") wasn't backported directly to 5.4-6.1, but a
>quick look suggests that Sasha squashed the problematic change in the
>manual backports of "soc: qcom: mdt_loader: Ensure we dont read past the
>ELF header" (at least for 5.4-5.15). I think we will need the fix for
>all trees (5.4-6.16), or we should revert the patch(es) to avoid the
>regression.

Oh, heh, when I backported it I got a warning from the compiler so I assumed it
was because of API differences on older trees, so I just fixed it up. Haven't
realized it was broken upstream too.

We can wait for the fix to land and take it in too.

-- 
Thanks,
Sasha
