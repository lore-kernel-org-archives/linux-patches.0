Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 677AD184;
	Sat, 23 May 2026 14:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779547548; cv=none; b=bsCnzJ35dX+iup28WCk88G3eai/jzuK02t6RfyOAqzdtGhjZ8aHZ0+/U+lWUIcwInAAFqwHtrGRU1tOGlx/eA4DkILCm7Eq9n6ZfbW8uzz7FW3DyqvQ30uAqktUxtRrEVDbfRaA7XfVS0sWx1uKfnVnf3jYQJ/S2fHCHleyjwzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779547548; c=relaxed/simple;
	bh=3KapAMEhFbW5iLotfVFfoK5rgjJsRu0/xq6ZpIlmZqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ag4/YgPz5Ls3jDTCbiPWub4IQDqbwicU8BmZDl6yUBLgjp1pM+nJV3MgcrWlnAAoRnf3gCD8NxmB4v6riWpSMt1Ermr0WcirDdtEwpV2/p+PXyQUnELLL/6i/LBT2rC9lvTQpdTPmOgVNuQZx49jtI4Zp1gZE0eswhLV6iUzPKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Av/FM2N4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Av/FM2N4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87FA1F000E9;
	Sat, 23 May 2026 14:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779547547;
	bh=ugrIX6lHrkiGVRyINmdCm7JBkpTewfM03MXVkmbj1XI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Av/FM2N4AsXd0kq/E2I3mhcFi0q49y3XDqsqFiaaK5r45vAYS5KaOtYDRhK3a7E8J
	 yFaGzFyJQH4XdiZReOzhS4gE3mq9PkXnJoduY5jauXy2ak2Ud3Yngv87RXsQy1xW4H
	 4kH+ABpK8lx6SwLNjjlak1J4b7nDM1hK98ufV8N1sdFdnGDjMiQ3C2GUuKrcTrfW5q
	 3DDgpYAvKcWuTiBjB+XgWY9PQaOgOFKtLaj8zcO8moUWf/efM4QbAE8djSJW1aFdUl
	 qqKHjIFRtvGQAnXAm9I6z5zx/NEu8AgYhFf/U3cQ4wZlz8zX0iKWBevpv5CRurhq8s
	 js5E0ZtA+K/Dg==
Date: Sat, 23 May 2026 10:45:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <ahG9meYUQ-YLDwHN@laps>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>

On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>On 5/20/26 5:40 AM, Jens Axboe wrote:
>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>
>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>
>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>> through io_parse_user_time(). It therefore does not pick up the
>>> time namespace conversion added by the previous patch.
>>
>> Once again - If you auto-pick this one, please also do the other one in
>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>> do just one of them.
>
>And once again, no reply. What is going on with stable these days?

Jens, as I've mentioned in the previous mail, I handle the AUTOSEL mails weeks
after I originally sent them out for reviews.

The volume of mails and patches makes it really difficult to give prompt
answers here. I have no idea if 9cc6bac1bebf8310d2950d1411a91479e86d69a1
applies cleanly, whether I need to ask for a backport, or whether I should just
drop 45d2b37a37ab9848 until I sit down and get to this batch of AUTOSEL
commits.

If this process doesn't work well for you, I'm happy top skip all
non-stable-tagged commits for io_uring. This is supposed to be only a best
effort attempt to catch commits that slipped through the cracks.

-- 
Thanks,
Sasha
