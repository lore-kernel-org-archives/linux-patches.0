Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58204289E13;
	Tue,  1 Sep 2026 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788275346; cv=none; b=VsYrR9TV2k+qkJdTeifcV5oFt9LaM1bri9dESd3ZGKXp7tkApAoiK16UTmDBybR37XqlG6zuYzR4xeUu8lifYKHMdv5d9GUtNs7spABU3kxgOInMQzJXT2janptQnJkrJGHxtVH3FyeuBARRl2lLSt98QGKed7oBKD8Xji4eSq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788275346; c=relaxed/simple;
	bh=JEbOp4Gv+dXWEfhB4S9KDJBdaC3V5EcD1S0bRwLf89Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j4OygSxNhzwDyfPSE++9nviTGDcthhB0s7vhOYJdwOhjCHXR//28ZFcF3/1hcxAgfLsjoxQsa90x3uEQGaFQLacE1wTHDGyKpA3Nyqdf/AUh+LfffTaP/6kVVGS0mdVi9wNAz3nKp5ct0ePrdq1zbWd+vYViuwJ4QO2DUF29cIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HgmkHC4K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HgmkHC4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8B21F00A3A;
	Tue,  1 Sep 2026 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788275344;
	bh=D7SXBMUeLLj2WoeOZ8MFjbeMY7N6yqBaPhWFITAaUL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HgmkHC4KsdEdALuOD02HLsUtjnaTD9XJa5pX0GZVNjE6sBJnuG+c5zXcFtuoI4guM
	 dSpWd88LdVWOvpmLfvjJYAudCfkNhv69fBqzCydZHGz7vxNcU2g/jIwGFQATaLKtGg
	 V/6j8RMg05ez8g+2PhFSHvCgss+/uvgWJMIPmtRac1BLvpmVb3fOcw0NB15moRMdzN
	 KqBl828NTzMFFEf/5aEeXY3/80AyYlskXai/cvYgycHA+LWB8YmkKbaSJFd7IVHx01
	 IJeSbP3ziBHamM6qbcIPmfVCQZMImGC0pSwV24WcdNzj6xCjGWaXGHi8gnuFrTl8zi
	 DYDCm0fjgLqvQ==
Date: Tue, 1 Sep 2026 11:09:02 -0400
From: Sasha Levin <sashal@kernel.org>
To: Sabrina Dubroca <sd@queasysnail.net>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>, john.fastabend@gmail.com,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.1] tls: reject the combination of TLS and
 sockmap
Message-ID: <apbqjuv6l20bTjQI@laps>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-596-sashal@kernel.org>
 <apacn0u4092axmXy@krikkit>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <apacn0u4092axmXy@krikkit>

On Tue, Sep 01, 2026 at 11:36:31AM +0200, Sabrina Dubroca wrote:
>2026-08-31, 09:30:24 -0400, Sasha Levin wrote:
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> [ Upstream commit 460e6486617c17dd19abe8f3fc67d9a6fa25f8ca ]
>>
>> TLS and sockmap (BPF psock) integration hides a lot of latent bugs.
>> Bugs which may be more or less relevant for real users but they
>> are definitely exploitable.
>>
>> We could not find anyone actively using this integration so let's
>> reject this config. Adding a TLS socket to a sockmap was already
>> rejected by sk_psock_init() through the inet_csk_has_ulp() check.
>> We need to reject the attempts to configure the TLS keys (rather
>> than adding the ULP itself) because checking prior to the ULP
>> installation is tricky without risking a race with sockmap getting
>> added in parallel (sockmap does not hold the socket lock).
>>
>> This patch is a minimal rejection of the feature. Subsequent patch
>> in the series will do a light dead code removal. Full cleanup would
>> require a major rewrite of the Tx path, we don't need skmsg any more.
>>
>> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
>> Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
>> Link: https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>
>> LLM Generated explanations, may be completely bogus:
>
>330L... wow.
>
>> ## Phase 1: Commit Message Forensics
>>
>> ### Step 1.1: Subject line
>> **Record:** `[tls]` / `reject` — reject the unsupported TLS + sockmap
>> (BPF psock) configuration.
>>
>> ### Step 1.2: Tags
>> **Record:**
>> - **Reviewed-by:** Jakub Sitnicki `<jakub@cloudflare.com>`
>> - **Reviewed-by:** Sabrina Dubroca `<sd@queasysnail.net>`
>> - **Link:**
>>   https://patch.msgid.link/20260614014102.461064-2-kuba@kernel.org
>> - **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>`
>> - No Fixes:, Reported-by:, Cc: stable@vger.kernel.org, or syzbot tags
>
>Yes, this was intentionally sent to net-next without a Fixes tag,
>because it's a "feature-level" change, so it kind of feels wrong to
>send that to stable (even if it's removing a feature that nobody seems
>to be using). OTOH the code is broken and not really fixable...

We have plenty of "fixes" that just drop a bunch of broken code :)

Happy to do either, just let me know.

-- 
Thanks,
Sasha
