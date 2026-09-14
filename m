Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B3538DC7F;
	Mon, 14 Sep 2026 09:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789379583; cv=none; b=C3YQjrZFEMi4pcwaXbrLcBArTfpCPa7SFtSWgjtpsZCwwj9gRHueIbBPmXmq0OHjSGbuWztmBQL83iBU8rrtAHl3HO2zXuw7WgvYRSz5v+OVu7DqBKsXelN+dV1G56O486U9sZHv+6TDjVIPr31FKiTHgaMEqc7cZFU3pVaUZUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789379583; c=relaxed/simple;
	bh=5x08LahkL1ZjvAF3mgyiGGGd9CiXEMeF7kH7bMYQ1Ek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fi1mrPaByBBFnbd3AmQONADFAa59mRwyqqIjVfYwuUOtD3X1Mu1cMcJKr5VyN4k1vvvA2JKLhUPBpf45JSXTJhzxLrn/NVv9azubuhno8JlYj3tJNkRnk7GkYwUC4uyoN6pOslEvLFb1UYnKv9ufeKHcJe9z12CeAMC4kwSFuu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K/rITtuD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K/rITtuD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2477E1F000FF;
	Mon, 14 Sep 2026 09:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789379582;
	bh=oyOUlQXv66US/FYuRTk5ah49Av0eIv9DsYAcWUY/2/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K/rITtuDXeDDr39CCx3atx1kzI7DwgSAn993svs+jAHXAe0utzPdjKFr+cC8ODjvH
	 LQJo2J6ZW+fwM8FjJPzm42mtEVXpV5QC1ynRTSATPVHtlZvqP6Zfzf6yv9iCQzqv6a
	 w/tPVlh9za+6ztHXp1Hd0CpiL2EHxcCoqlP2ETXM=
Date: Mon, 14 Sep 2026 11:52:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 1360/1424] net_sched: act_skbmod: use RCU in
 tcf_skbmod_dump()
Message-ID: <2026091437-angelic-haiku-e550@gregkh>
References: <20260912065607.279695368@linuxfoundation.org>
 <20260912065637.721099003@linuxfoundation.org>
 <20260913192609.2581-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913192609.2581-1-kmehltretter@gmail.com>

On Sun, Sep 13, 2026 at 09:26:09PM +0200, Karl Mehltretter wrote:
> Please hold this patch unless a 6.6 backport of upstream commit
> 3016024d7514 ("net_sched: add back BH safety to tcf_lock") can also be
> included.
> 
> This patch replaces spin_lock_bh() with spin_lock() in
> tcf_skbmod_init(). A rate estimator can take the same lock from timer
> softirq context, so the timer can interrupt action replacement while it
> holds the lock and deadlock on it.
> 
> I reproduced this on 6.6.157-rc1 in QEMU with lockdep: after the estimator
> timer ran, replacing an indexed skbmod action reported inconsistent softirq
> locking on tcfa_lock between est_timer() and tcf_skbmod_init().
> 
> With only the skbmod hunk from 3016024d7514 applied, restoring
> spin_lock_bh()/spin_unlock_bh(), the same test produced no lockdep
> warning.

Thanks, I'll drop this for now from the 6.6 and older queues based on
this review.

greg k-h
