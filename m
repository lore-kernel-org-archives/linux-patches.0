Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13CA3563FA
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 16:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776875482; cv=none; b=p2nVVd+HkuaMq5/wYXAXAz3IjYkObafeOinp6O1XTA0mfm5JVEQEyMoGoJzsuO2lwj/SQ9nGskSXx1Nix3EBVLwcQf69zc7ZM3OTO3u3kRo68Q6d4hiIVbbSQGfIC5p4r7GRR6sNkCJjypMVTbRxMBnOkPtK62SjLV/ky4kJHYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776875482; c=relaxed/simple;
	bh=peUBD5m08sTT67ZtgWka59qlYKJAljWCivBd1RqFQ6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GotDQ80rXvvQFEAZ87U/EFyKh3pFYQT6vCvmVDkz5vVOj8NE5GlVP+zOZ2RNzPkMGFznIktpm5TOvNULdeubVEXG6pBHbmUAVZKfcnWqK5N6x3LvIVxCeBpimADNaHzPM5gDsjo1xMYsekXD/QBgSOaQtEymBTX9ZOm/eepY1Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=SYmly0FW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="SYmly0FW"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id D20B120B6F01; Wed, 22 Apr 2026 09:31:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D20B120B6F01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1776875481;
	bh=yYcs3ciRPXLdYtHD830pxRSz6Am6DIQ9YVpyqqk8OZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SYmly0FWM/3NduJBTSSY6wMj3HXYtWSraZqnyM//IW8Tm60Y09h9ExihlqQuVJVdt
	 dwq+x6QjkchLy8GAyrRJ0bC7EovDXbx55/PqE4ktSNGBaKlrnO54skxB60PnqLqVfC
	 r7scKS4+iYdLIzpGfwI+ADg1o29ifhg+A5tMbAQo=
Date: Wed, 22 Apr 2026 09:31:21 -0700
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>, kys@microsoft.com,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	longli@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0-6.18] net: mana: hardening: Validate
 adapter_mtu from MANA_QUERY_DEV_CONFIG
Message-ID: <aej32XgkE1gzSa4D@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260420132314.1023554-1-sashal@kernel.org>
 <20260420132314.1023554-44-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420132314.1023554-44-sashal@kernel.org>

On Mon, Apr 20, 2026 at 09:17:18AM -0400, Sasha Levin wrote:
> From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> 
> [ Upstream commit d7709812e13d06132ddae3d21540472ea5cb11c5 ]
> 
> As a part of MANA hardening for CVM, validate the adapter_mtu value
> returned from the MANA_QUERY_DEV_CONFIG HWC command.
> 
> The adapter_mtu value is used to compute ndev->max_mtu via:
> gc->adapter_mtu - ETH_HLEN. If hardware returns a bogus adapter_mtu
> smaller than ETH_HLEN (e.g. 0), the unsigned subtraction wraps to a
> huge value, silently allowing oversized MTU settings.
> 
> Add a validation check to reject adapter_mtu values below
> ETH_MIN_MTU + ETH_HLEN, returning -EPROTO to fail the device
> configuration early with a clear error message.
> 
> Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
> Link: https://patch.msgid.link/20260326173101.2010514-1-ernis@linux.microsoft.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> FOR backporting:
> - Fixes a concrete integer underflow bug (adapter_mtu - ETH_HLEN wraps
>   to ~4GB)
> - Small, surgical fix (6 lines of logic)
> - Obviously correct bounds check
> - No regression risk
> - Accepted by netdev maintainer
> - Author is regular driver contributor
> - Affects widely-used Azure MANA driver
> - Security-relevant in CVM environments
> 
> 2.53.0

Thanks Sasha, this is good for stable.

This should also carry a Fixes tag:

Fixes: 80f6215b450e ("net: mana: Add support for jumbo frame")

The code was introduced in v6.4-rc1, so the backport applies
to 6.6.y and later stable trees.

Acked-by: Erni Sri Satya Vennela ernis@linux.microsoft.com
