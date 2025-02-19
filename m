Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354F523C8B2;
	Wed, 19 Feb 2025 21:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000955; cv=none; b=pxi6Sv61R7hzg96BXLJM6NqK9WWYmtbZCcOInSU4AlPstDwKFZMDLlArci5ENa+wqFFPdGOYmc846kK3qY7WFcHZPRjLLVmpNpH0v2eNFOAXxaaanU8ckpX6xJdSQEouv+mRZMbISyn0SvzhYXTgqAoAQdTudvg/ooUKI7rtAt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000955; c=relaxed/simple;
	bh=S4iDQ4g8NHW6rPD6c9xr/H2QlLfA+OqBdFPT1FPCwpw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+6I/GmHnOmPIw3Sd3q9fXpsiT6y4ssk82OAal8wmTgNkD5JQWgw8Lm6bM54SMa0+GPvgWpOqJpFyfvoexHGov19elu03pgrIJ3yTsJpaRfvB/6ugAxf5CAVOpNoBL6I3E3y8IGxIetd9V7JlVfIC+9IhE9wKRhl4sSAbsoNYVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0DaXoqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0DaXoqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70042C4CED1;
	Wed, 19 Feb 2025 21:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740000954;
	bh=S4iDQ4g8NHW6rPD6c9xr/H2QlLfA+OqBdFPT1FPCwpw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c0DaXoqsHzW2/9cJZqiusvdtZqXyROkBdDdAgsG0cyNhPcBPl8Y/PY0JORpuGX3sE
	 dO/xjsazS1GSVxNYGeh17e3g56lvxD8WVHV6Wrmu3PsptkpFWyr5eJ9rbMdkUF2YA1
	 5rAUUYcDhrxYTZvvkykaVJFHqIXGnLkHWTRlz2ZSYogwZjvwJCA6LJXZwA3YvuzPuQ
	 pmknhZWl/1jY/W1iCHv9osPMPWPxjlYUXv2H58osXsZyFpxrPWA3XSaut2pjqSSQzs
	 hKbYhRMjQ8htxX0EhkT/TkOadSfr50hdRWjdxr9E0UAF/qHwznvu+8C//g1OcUOWfh
	 QanOnd+pyaQtQ==
Date: Wed, 19 Feb 2025 13:35:53 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Joe Damato
 <jdamato@fastly.com>, Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 234/274] net: protect netdev->napi_list with
 netdev_lock()
Message-ID: <20250219133553.55120b32@kernel.org>
In-Reply-To: <20250219082618.736918558@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
	<20250219082618.736918558@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:28:08 +0100 Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 1b23cdbd2bbc4b40e21c12ae86c2781e347ff0f8 ]
> 
> Hold netdev->lock when NAPIs are getting added or removed.
> This will allow safe access to NAPI instances of a net_device
> without rtnl_lock.
> 
> Create a family of helpers which assume the lock is already taken.
> Switch iavf to them, as it makes extensive use of netdev->lock,
> already.
> 
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Link: https://patch.msgid.link/20250115035319.559603-6-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

please drop
