Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37709374726;
	Mon, 20 Apr 2026 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776694333; cv=none; b=MUtzx4XjUL2DsbB1Z9RH9lmlwtHvIrYanKL5XMpIaz44qykmjz93u+78tMfEoPCCeG7uQI2Gpwmekgm57XuTHM7gRVXD06zOElw6wfmPS/K7sBqXUNPhKIVRpWht8u2WbEC1wbOIVVoGBnppQxCoA/Vvj2pET8UzFAnkmL+bjk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776694333; c=relaxed/simple;
	bh=KUP+V4uqfCUMaSGxnbv21QPHCD50bcmDKtIbRcY1gAU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rakqwsIb8G7fkPlTN48bg6Jq/c+LZCTuSYmsh3V0xcWulXhN8e75C9E9wmb3YY6BzS5XfvfDtTdl9kFeKUopZdGTIaZDn01IUUTUKRVwLFel40FPWrP0mSHxyPGahm3S1huSpxjlQJufRu83/O1QRwBVvs7la71MiTdFcnsrYYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fozhAgKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fozhAgKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345DDC19425;
	Mon, 20 Apr 2026 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776694332;
	bh=KUP+V4uqfCUMaSGxnbv21QPHCD50bcmDKtIbRcY1gAU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fozhAgKiO0oARp9McnWrXz36z+yMgW+gnevRQ3c/2puRTFLWSzQpxWvpGmWlsdS9y
	 ajwWMVjBWTi920FtX2Cfjo4jkBRZrVsdTW3+nMPucOTiCJETgzbdRwdOWLmZMpQsPt
	 eDORtrDe79ADrBDQQwa92qvlN4maUO+qNhmHus7pE28afezXitr4v3LGLZBlGV3ncY
	 0CTgkUC9cXHlsU8hhMAtUAHQK1EfuLmmOCa7kgxMUB4R3S9r7TvrFALt+SNOC9Vi7V
	 PGgJl/uXryxG8Ie6cfK8X13HjR/xrtItozEEGAVAQBSorsFP9KxAGnPejmTCOsFTy3
	 e8FrUslvEEf4w==
From: Thomas Gleixner <tglx@kernel.org>
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Calvin Owens <calvin@wbinvd.org>, Borislav Petkov <bp@alien8.de>, Sasha
 Levin <sashal@kernel.org>, fweisbec@gmail.com, mingo@kernel.org,
 akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] clockevents: Prevent timer interrupt
 starvation
In-Reply-To: <20260420131539.986432-78-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
 <20260420131539.986432-78-sashal@kernel.org>
Date: Mon, 20 Apr 2026 16:12:09 +0200
Message-ID: <87pl3ten5y.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Apr 20 2026 at 09:09, Sasha Levin wrote:
> From: Thomas Gleixner <tglx@kernel.org>
>
> [ Upstream commit d6e152d905bdb1f32f9d99775e2f453350399a6a ]
>
> Calvin reported an odd NMI watchdog lockup which claims that the CPU locked
> up in user space. He provided a reproducer, which sets up a timerfd based
> timer and then rearms it in a loop with an absolute expiry time of 1ns.
>
> As the expiry time is in the past, the timer ends up as the first expiring
> timer in the per CPU hrtimer base and the clockevent device is programmed
> with the minimum delta value. If the machine is fast enough, this ends up
> in a endless loop of programming the delta value to the minimum value
> defined by the clock event device, before the timer interrupt can fire,
> which starves the interrupt and consequently triggers the lockup detector
> because the hrtimer callback of the lockup mechanism is never invoked.
>
> As a first step to prevent this, avoid reprogramming the clock event device
> when:
>      - a forced minimum delta event is pending
>      - the new expiry delta is less then or equal to the minimum delta
>
> Thanks to Calvin for providing the reproducer and to Borislav for testing
> and providing data from his Zen5 machine.
>
> The problem is not limited to Zen5, but depending on the underlying
> clock event device (e.g. TSC deadline timer on Intel) and the CPU speed
> not necessarily observable.
>
> This change serves only as the last resort and further changes will be made
> to prevent this scenario earlier in the call chain as far as possible.
>
> [ tglx: Updated to restore the old behaviour vs. !force and delta <= 0 and
>   	fixed up the tick-broadcast handlers as pointed out by Borislav ]
>
> Fixes: d316c57ff6bf ("[PATCH] clockevents: add core functionality")

Please hold that off until

   4096fd0e8eae ("clockevents: Add missing resets of the next_event_forced flag")

hits Linus tree. It fixes above commit and is marked for stable. So
ideally you apply them together.

4096fd0e8eae will not apply to 7.0 and older. I'll provide you a updated
version once Linus pulled it.

Thanks,

        tglx
