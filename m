Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F047480DCA;
	Wed, 19 Aug 2026 17:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787160004; cv=none; b=akclcbKKl/aVd8/P53hxPnrhqE6coq8caMG1f8EWwEKFr4E1n1SeJrHMQ7OCfpvs3HelKfy70PE1HBaHgG5t3+f0yR7s0mOkwh/bbrhU46e9dNPPie2/EaesKoibhA7JaHAUFg/LaN9bwer7lFylQSrJ6PKgs5idmhptYu8X4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787160004; c=relaxed/simple;
	bh=jvxiEYRrmggKX7kx/G5XFWGHjjWkdzorGZ1YvYqkz74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J29J5NLf1WwAtNlY5xBimEPZZ6n4YjSkdMO2SA2I//HlO435DfcFWWG7aVZjt9XDKStbObr2tbRpLFhEW7NG0dDGRSgqo8Lca0wGdQ3sTLuOThI4QbUdZ3N2uNaJy9io1Jc52/RJAGn+NohcGAEVEff3Qbe+ZawP+otIYjQntjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lex2M6vZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lex2M6vZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425341F32F04;
	Wed, 19 Aug 2026 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787159993;
	bh=7rMFLa90kTxl59HsMCtKysqK67JUqkgOg9yODloB4rA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lex2M6vZZVgWDrOWPusT1Vt0gN8VJDfdnQDUj4EiUqnEDLR32IEkaQNhK146yTs58
	 sBqUBiJzo4g63UvxU2qNG04P1xXtr4gLPyaK8dfSOh2XhSEvAiHz8dnVa4EhoL9Wsa
	 bYSdPC0LB2/Fh6jsJG2G1ChoCTknZP5pORaElRBwCEEIhUO5vrRGv52HSmTL42nqpc
	 PpR0t0aBM6hmqUt0p4yV2huvBkMyvc0vjRUejvK7vrsX+YFIp4aPlYHq2WVg0AGufa
	 xtwrR2JZyiph76CyNCOuEzRYGtyAk8/ULoVIro5vYMwBqCmJdB11teYid+DYe5Bc9c
	 vHdI4qFOhCezw==
Date: Wed, 19 Aug 2026 13:19:51 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Maoyi Xie <maoyixie.tju@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time
 namespace for IORING_ENTER_ABS_TIMER
Message-ID: <aoXlt3pcqsqfp52s@laps>
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
 <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
 <8e853555-604e-46e5-8e25-a5f80b88e51c@kernel.dk>
 <ahG9meYUQ-YLDwHN@laps>
 <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <afe1ad86-3454-4092-88d0-bd9753a1b2c8@kernel.dk>

On Sat, May 23, 2026 at 08:55:43AM -0600, Jens Axboe wrote:
>On 5/23/26 8:45 AM, Sasha Levin wrote:
>> On Sat, May 23, 2026 at 08:23:13AM -0600, Jens Axboe wrote:
>>> On 5/20/26 5:40 AM, Jens Axboe wrote:
>>>> On 5/20/26 5:18 AM, Sasha Levin wrote:
>>>>> From: Maoyi Xie <maoyixie.tju@gmail.com>
>>>>>
>>>>> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
>>>>>
>>>>> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
>>>>> timespec from the caller via ext_arg->ts. It arms an ABS mode
>>>>> hrtimer in __io_cqring_wait_schedule(). The conversion path in
>>>>> io_uring/wait.c parses ext_arg->ts inline rather than going
>>>>> through io_parse_user_time(). It therefore does not pick up the
>>>>> time namespace conversion added by the previous patch.
>>>>
>>>> Once again - If you auto-pick this one, please also do the other one in
>>>> the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
>>>> do just one of them.
>>>
>>> And once again, no reply. What is going on with stable these days?
>>
>> Jens, as I've mentioned in the previous mail, I handle the AUTOSEL
>> mails weeks after I originally sent them out for reviews.
>
>And you think that's working fine? I would suggest that's a terrible
>process. How are maintainers supposed to deal with that? Patches x and y
>are autoselected and an email is sent out. Maintainers react to that,
>either saying "no don't pick X" or "if you pick Y, please also do Z".
>The expectation would then be a reply that says "ok, doing that" or
>whatever might be appropriate there. Instead, it's just silence. And now
>I have to follow-up MULTIPLE times to ensure the right thing is being
>done. We're about 2 weeks into this particular incidence, and
>hilariously, I still have no idea what the state is on your end. Did it
>get dropped? Did the other one I asked for get picked up? Nobody knows!

Hey Jens,

So I took some time to figure it out, and I want to try out a slightly different process to address the concerns you've raised.

Instead of weekly AUTOSEL dumps, I'm just going to do them for a given release
after Linus tags it (so I'm going to do all of 7.2 in one go), about a week
after the release, and targetting just the LTS trees to reduce the number of
commits we backport.

This will make it easier for me to handle the volume of mails, and also reduce
the number of reviews folks do since we can skip the most recent stable (not
LTS) tree.

What are your thoughts on this change?

-- 
Thanks,
Sasha
