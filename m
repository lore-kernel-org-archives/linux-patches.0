Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C822C3757;
	Sun,  6 Sep 2026 13:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788701627; cv=none; b=fMcs/7t8vmLzM0Ri4mW4yDLsv//VTo+vqIDPjIUxxwV9a5Hmu391+lZjU8fO3c+/W6FtSN8Y39nX4W/N9B1d3Tcwt1LT1E/eGSwQvj5tRUvI2U8asIfVceuShQJMezBizTGaZb8NegozGYvxYtx6KAOhFRwB2F30yPmUi/nO3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788701627; c=relaxed/simple;
	bh=Va2SHxJ17Ev5FlL75d7M0OHI1VbW7G+PUIjoCAg6Jl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGoBnUwHXszmNj0RNIFqpre49Aeh0brJcuC9tlY+aOFXPvevKqWdex/hv4Cy3TidGyCW9+khzcPNcosKVtiHfaMShJCeP8qxVuB9UYF6f3aLFqUbOZgdFPGUXMVfHSnshKbPUL6YMplVn7vJrDR5T3Plto62AxdaudGlgUSGTgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XAT09bNv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XAT09bNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A061F00A3F;
	Sun,  6 Sep 2026 13:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788701621;
	bh=l6MtV0hZe75kl5QD1VkWsSunVgfexHQsQwVERUyFo9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAT09bNvtUeqdR3iHV0Guo/E4Xdc4vOGj5gOjpVUVM+AKrXNz+QPSDuyHWsqg3FeO
	 Dn3oSzmUSwTM5/tnaBcZgYX4rIXSM/OJ+GBqld9DFSkkDbTu96cqB3uQ9gW0YhbsLt
	 sktztEB98dDUjrOVuNogCTd1rr3Qo3s0mcWu7b2c57GHJbDtTlY6eiUzZSUfvBZsnS
	 CbU+wCjtOD+mx8yGj71rwa4KixIWYNHAMglehsPJ0Hymf7ZVXrcl3wwucQ6sanyqdN
	 iauxFx5l7y7dzFSf9i0iEjlcIX6issTmMsKAGkWVlhtQ9oaGW/GJl+SWSU8BeNHVmD
	 SHUn3BuhX66ow==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Breno Leitao <leitao@debian.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>
Subject: Re: [PATCH 5.10 28/43] xfrm: espintcp: fix UAF during close
Date: Sun,  6 Sep 2026 09:32:47 -0400
Message-ID: <2026-09-05-daily-reply-0017-espintcp-uaf-prereqs-5-15-5-10@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904095158.GA83164@j66a10360.sqa.eu95>
References: <20260904095158.GA83164@j66a10360.sqa.eu95>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This backport depends on upstream
> 028363685bd0 ("espintcp: remove encap socket caching to avoid reference leak"),
> which is not in 5.15.y. Without it, esp_find_tcp_sk() still
> returns the cached x->encap_sk based only on sk_state == TCP_ESTABLISHED
> (no tcp_is_ulp_esp() check), so new readers keep racing with

Thanks for the repro!

028363685bd0 ("espintcp: remove encap socket caching to avoid reference
leak") doesn't cherry-pick cleanly onto 5.15.y or 5.10.y though:
esp_find_tcp_sk()/esp6_find_tcp_sk() there still open-code &tcp_hashinfo
instead of the netns-ified tcp_death_row.hashinfo, so it needs a real
hand-adapted patch rather than an automatic conflict resolution. Could
you post 5.15/5.10 backports for it?

On the second prerequisite, e1512c1db9e8 ("espintcp: Fix race condition
in espintcp_close()"): that needs disable_work_sync(), which only exists
from v6.10's workqueue disable/enable series. Backporting that whole
chain to 6.6/6.1/5.15/5.10 just to unlock one espintcp fix isn't
proportionate.

-- 
Thanks,
Sasha
