Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02234B4873;
	Tue,  8 Sep 2026 22:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788907172; cv=none; b=Td2jht9aB+ACcNpirXhqYafg8Ar5KVH5mN+IaJwhOo2Vo+MSOVcc/W2GD/TnMQkJmhQa2tqdQ8UGq6UDwCcXU61JRWsw33wIpCK4AizKciH2kt601PlquRFamdRRMJVtHf+RCdPA3AI4JNzqbp5umelPrAdmjp216knTXSLXOdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788907172; c=relaxed/simple;
	bh=r5mFC1ExerVdXPciHEWiwOiT1M5CSPsCjTp2YApC88c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUWQFz6NojhLF+4rjMey98h0olXM9WazK4UJMAjU9RnnVIGF8dq9fylvXDUoJwC/5pMMB6bW3Ti0sBJGciDcSy0iJ20dlffS52ilpAR3BSmpWxp7Sf+Nvdhc7o5R9EVv6tZrrEsXfvHVPbXkFQq6iKSyDVfQ/iupf3PTVSKapYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWK4gAll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWK4gAll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA751F00ACA;
	Tue,  8 Sep 2026 22:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788907165;
	bh=cbygM747paiEXjVaFp37wg5/byKKVWR9uucHDvjh0no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWK4gAllHhQ9T7b3PIAogyMDIEDtsFkTAeFtEq3mwUhfg96F1zp5jxkl/81qZ3SdH
	 T49ww7JYDN4FUVxK+cf9FNTSTWq8lNBfdDYltel+zXx0FXkrjnQWcesFwFhZuScXYY
	 ti21vSMoRXkZ0oFlD7qASBfzoyZj8iKcdUWYSZmmuMtfl01TIy6g+1cLtbffqrlg0s
	 AVsL6tBiSGld2UlJLZta2yN7Myx/sKyS2HnvfINXPDFRy+oSzBPiJ+n5+Z0HLZpLq4
	 CSAMzEpXiLZZNJqkuPkDALHKe1pvHntpshCyOp12abqziHaD/urXk0uxdCBjflsDEI
	 c+dKG3QEWrMZQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	"NG, TZE YEE" <tze.yee.ng@altera.com>
Subject: Re: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks and list corruption bugs
Date: Tue,  8 Sep 2026 18:39:12 -0400
Message-ID: <2026-09-08-daily-reply-0005-stratix10-svc-mutex-bounce@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <34cef7ad-8730-4a49-b6f4-8307adc1e36f@altera.com>
References: <34cef7ad-8730-4a49-b6f4-8307adc1e36f@altera.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Agreed to apply this to 5.15y:
>
>    firmware: stratix10-svc: Add mutex in stratix10 memory management
>    [ upstream commit 85f96cbbbc67b59652b2c1ec394b8ddc0ddf1b0b ]
>
> Tested on an Intel Stratix 10 SoC Dev Kit (arm64, 4x Cortex-A53),
> v5.15.220, with KASAN, DEBUG_LIST, DEBUG_MUTEXES and DEBUG_ATOMIC_SLEEP
> enabled.

Thanks for the testing, but the cherry-pick build-breaks on both 5.15 and 5.10:
they're -std=gnu89 with -Wdeclaration-after-statement, and upstream's
guard(mutex)(&svc_mem_lock) lands after executable statements in
svc_pa_to_va(), stratix10_svc_send() and stratix10_svc_allocate_memory().
cleanup.h's guard() expands into a declaration there, which is a hard error
under C90.

Could you send a version that places the guard() among each block's leading
declarations instead, or takes/drops svc_mem_lock manually without
guard()/cleanup.h? Happy to take it from there.

-- 
Thanks,
Sasha
