Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBB6438482;
	Wed,  8 Jul 2026 12:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783512348; cv=none; b=mqpUSf38oYN/9EbWvyksb2H1E13HxZK9r18494baGw27swixBC79we6OzxjLusmNGgTQby9fM1ixlkz4589+kjbIVfLXifp5WYXRsD/Gie78H7V/aN8ZAb9I3NTEatLeEeJZcQFwTQx2N3CgSbMO44LqSq9XvHBBSKmfuF1d79Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783512348; c=relaxed/simple;
	bh=uxI1ZBFZOkqXRdJ3Hxod2MQCp0b4beKrfoz37cROuhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d27BT9TQYlzRPovhm++8D75NEe1PUnb8YvybPcJ9zH51VKqr5vygZH04nb/duPRtx67jnnp8iGieoJQM9vp2Wer/eiro1SfYkBDqRSIX3LAgDcvvjBxyTy+nUGc81S1QF0FFkyGPa346AB9FgEn5HLKso7v4CCeWkvDWmGYzsHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=npcxt4Hx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="npcxt4Hx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF111F000E9;
	Wed,  8 Jul 2026 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783512346;
	bh=C1qnEtn4dtAM9rsKwQarVAULLYlM6Bnhmz+OOhd4+/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=npcxt4HxcB45PpPUGdf43bCuaZAORklyij+1j9fx+vL+K3ob8LUd5Kg9Dp0Hoe5to
	 QP53gJ10dyilh74g1wMFt9Z2V9Yh7tjpD1ulaQKaS7J4lbU7vPPcAsBVkF5lLPpy1a
	 ZcL7n9zj9p2++f0x1bHLzB+4IbLGmFJGmOawMBziOhdaVzY6SUhVq5nozRzNNjysNg
	 X4lHdxcsvZ1T291/1fdZl80bqhV/X8FBkijS52KhpEsDdz7hDKPzcPjHqrZX+vcUQX
	 xmGBTcN/gIM7Bk83tKYHJOtGq2ZB9Tg8+hGwgFAqO6mYL2c8+roWnride9aBx8Vh4o
	 XKEs/PBIifAGQ==
Date: Wed, 8 Jul 2026 08:05:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Dominik =?utf-8?Q?Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 81/96] nfsd: check get_user() return when reading
 princhashlen
Message-ID: <ak49GYepsuRSyu1b@laps>
References: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
 <20260706135124.draft-0004@kernel.org>
 <ba08a15b-e61b-453f-9331-adf17690d612@oracle.com>
 <ak1UcPv7GwgdmDIn@laps>
 <9516338c-50c0-4e0b-a8e8-5af82e6d0412@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9516338c-50c0-4e0b-a8e8-5af82e6d0412@oracle.com>

On Tue, Jul 07, 2026 at 03:35:56PM -0400, Chuck Lever wrote:
>On 7/7/26 3:33 PM, Sasha Levin wrote:
>> On Tue, Jul 07, 2026 at 09:18:14AM -0400, Chuck Lever wrote:
>>> On 7/6/26 10:08 AM, Sasha Levin wrote:
>>>>> I think this depends on commit 4552f4e3f2c9 "nfsd: change
>>>>> nfs4_client_to_reclaim() to allocate data" which went into 6.19.  In
>>>>> older stable branches this failure path appears to leak name.data.
>>>>
>>>> You're right - the new early return leaks name.data on every branch
>>>> lacking 4552f4e3f2c9, and the patch shipped in this round of releases
>>>> on all six branches.
>>>>
>>>> Could someone please send a tested backport of 4552f4e3f2c9 to all
>>>> relevant
>>>> trees?
>>>
>>> Not wanting to duplicate effort, is that "someone" me ?
>>
>> Looks like most of the conflict is due to a missing 89bd77cf436b ("nfsd:
>> move
>> name lookup out of nfsd4_list_rec_dir()"). Ok to queue up both
>> 89bd77cf436b and
>> 4552f4e3f2c9?
>>
>
>Those don't look like Rocket Science (tm), so go ahead.

Now queued up, thanks!

-- 
Thanks,
Sasha
