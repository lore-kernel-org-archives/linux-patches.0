Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D712BFC80;
	Fri,  4 Jul 2025 11:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751630162; cv=none; b=CDkKL7Dlq3l+qKu/jeuGKHZqMV7Y/QDBqqSdiQytP6WpSZ1DJKvIgLrSFvx/ag1QbjnQ2Ao97MF3Cas/i0UneQfxMDKpR3goIKOhtRdTsl0BVg/CAcxs4FlR7QHWDFVQj/LrePSyF30PlqE8Xg5QX3pdxCqtfvTz4ruVHKhSFWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751630162; c=relaxed/simple;
	bh=rXWDCCMYAhLH+BgXTBRczuV5gMjcdVfTHrkH1Uy7EAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nwVH1LqzdDVWM1KgcpFxJ/3avuo9Wat+LrhqwhY2ZANzWbNqaJJZd10RWiLEGtPGqyqLaMdA+02OMfWKVpZBz8o6N8nMofKqSDlbFFp+t4ss+XUTXcxpaTSk5518r8z5VUbNKNaN+4YEtIkh+/OmGI/ohJ5vFlXU2I8e7HBBj+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S9g7TkHQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S9g7TkHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAAF7C4CEEF;
	Fri,  4 Jul 2025 11:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751630161;
	bh=rXWDCCMYAhLH+BgXTBRczuV5gMjcdVfTHrkH1Uy7EAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=S9g7TkHQMw3PhWfMkWN4q6aEkMM6m0I5mYhMMNYLoTTWTrg4nHh5ijwBjqt9Vv4CD
	 VZwgu33QyGsTOA1NIIIO7ZSQKOWJej9uYqFLfbZg5vFFaS0Nwaa2cnTqJU/Aqot6Ju
	 4TonSc/owwToLuGBt0/vJVXBcAbq+FA3/6ScUxIAmIU6clbYMuD4fpFnaDRkCBCPyH
	 /xZ4+XJiAlhtnHuAF5Zzab2rXeorVGqNIj+8/EDaXb1TuYAw1fce2raztUksht0QVk
	 dody9SPg5jp0/7HAC8NsmTwUivcPpHF5FzZ0HnHSkJfkDfBYBR1EvhdtWa9SE1BPtX
	 VpJyMWBjsXOEQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,  patches@lists.linux.dev,  Pratyush Yadav
 <pratyush@kernel.org>,  Miquel Raynal <miquel.raynal@bootlin.com>,  Mark
 Brown <broonie@kernel.org>,  Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/218] spi: spi-mem: Extend spi-mem operations
 with a per-operation maximum frequency
In-Reply-To: <20250703144004.692234510@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
	<20250703144004.692234510@linuxfoundation.org>
Date: Fri, 04 Jul 2025 13:55:59 +0200
Message-ID: <mafs04ivs186o.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Hi Greg,

On Thu, Jul 03 2025, Greg Kroah-Hartman wrote:

> 6.12-stable review patch.  If anyone has any objections, please let me know.

This and patches 213, 214, and 215 seem to be new features. So why are
they being added to a stable release?

>
> ------------------
>
> From: Miquel Raynal <miquel.raynal@bootlin.com>
>
> [ Upstream commit 0fefeade90e74bc8f40ab0e460f483565c492e28 ]
>
> In the spi subsystem, the bus frequency is derived as follows:
> - the controller may expose a minimum and maximum operating frequency
> - the hardware description, through the spi peripheral properties,
>   advise what is the maximum acceptable frequency from a device/wiring
>   point of view.
> Transfers must be observed at a frequency which fits both (so in
> practice, the lowest maximum).
>
> Actually, this second point mixes two information and already takes the
> lowest frequency among:
> - what the spi device is capable of (what is written in the component
>   datasheet)
> - what the wiring allows (electromagnetic sensibility, crossovers,
>   terminations, antenna effect, etc).
>
> This logic works until spi devices are no longer capable of sustaining
> their highest frequency regardless of the operation. Spi memories are
> typically subject to such variation. Some devices are capable of
> spitting their internally stored data (essentially in read mode) at a
> very fast rate, typically up to 166MHz on Winbond SPI-NAND chips, using
> "fast" commands. However, some of the low-end operations, such as
> regular page read-from-cache commands, are more limited and can only be
> executed at 54MHz at most. This is currently a problem in the SPI-NAND
> subsystem. Another situation, even if not yet supported, will be with
> DTR commands, when the data is latched on both edges of the clock. The
> same chips as mentioned previously are in this case limited to
> 80MHz. Yet another example might be continuous reads, which, under
> certain circumstances, can also run at most at 104 or 120MHz.
>
> As a matter of fact, the "one frequency per chip" policy is outdated and
> more fine grain configuration is needed: we need to allow per-operation
> frequency limitations. So far, all datasheets I encountered advertise a
> maximum default frequency, which need to be lowered for certain specific
> operations. So based on the current infrastructure, we can still expect
> firmware (device trees in general) to continued advertising the same
> maximum speed which is a mix between the PCB limitations and the chip
> maximum capability, and expect per-operation lower frequencies when this
> is relevant.
>
> Add a `struct spi_mem_op` member to carry this information. Not
> providing this field explicitly from upper layers means that there is no
> further constraint and the default spi device maximum speed will be
> carried instead. The SPI_MEM_OP() macro is also expanded with an
> optional frequency argument, because virtually all operations can be
> subject to such a limitation, and this will allow for a smooth and
> discrete transition.
>
> For controller drivers which do not implement the spi-mem interface, the
> per-transfer speed is also set acordingly to a lower (than the maximum
> default) speed when relevant.
>
> Acked-by: Pratyush Yadav <pratyush@kernel.org>
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> Link: https://patch.msgid.link/20241224-winbond-6-11-rc1-quad-support-v2-1-ad218dbc406f@bootlin.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
[...]

-- 
Regards,
Pratyush Yadav
