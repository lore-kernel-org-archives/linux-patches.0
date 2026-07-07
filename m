Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EA03ABD82;
	Tue,  7 Jul 2026 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783452787; cv=none; b=Rmjk0VF7mEjMSWJAkJ2RpPgVOizA55+AHePbrXLJNy/7tzGZ7j71k4LrwdoMVLvdtZykzLvpTnaoaGGvEgW5HAe2Kc4OmZwQf8UmwbWWbxc9MUCaIwmWo4bu6ihuTFGBs82lA2OO6Dn+o0qHJCjZm5M2/m/KIfhjXNPPOnVGnO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783452787; c=relaxed/simple;
	bh=zqXaGL1WegpPgS9YHEtX1vjznRiadERw8AIj5KrZ3ro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oE4IQXgLkokw6MQ7KpIRRWahVMkBtWpzHWl3yAvt9JXaIByeaZnz3fq0hSawofNuDmmOc06ULViR0iFBVBSExYQOmxWeZJvqvIckswoR6AnyAwEUdKJnEUG4NxLnZ2AfEtLKyd76/QlsYuwKuXX9RnoSqLsCLbHIR8HcMcF8hWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxsEsSqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxsEsSqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5031F000E9;
	Tue,  7 Jul 2026 19:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783452786;
	bh=Fe/6umyzToLaZtrJ4JHnGZFV0ohI62bEEghR3wxzTHE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XxsEsSqYmj//tA9FN88Ue5dzkQC6khP2BYtRFBi8Hjo7y7efC1sZSv8+aUVKE3PuQ
	 OxNmD3+WHqIDt0athOnEm/k3Sv6/Yxkbtp3nZ9wwi/yjCBb5GJbHjQOlSDF7CESNie
	 eY5VWieG9vx/C8xfIZK9OMMoG3ebCH896hN+rUOwkaYb/B7Im8D6d5BT2XBi6IFVHi
	 pRDS2CaSuuNATJU1w3HBqvVnGdGdehc5CMpS1U7jk1lYOwKNLJwifFqu3jGprgs+FB
	 ms63ltUWALwcIRqLibphlgpZSInetEVStJt7Z8OSq6G2/mda64yDftUhww+y1XJpxy
	 C/Rup602Y1Zlg==
Date: Tue, 7 Jul 2026 15:33:04 -0400
From: Sasha Levin <sashal@kernel.org>
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Dominik =?utf-8?Q?Wo=C5=BAniak?= <stalion@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 5.10 81/96] nfsd: check get_user() return when reading
 princhashlen
Message-ID: <ak1UcPv7GwgdmDIn@laps>
References: <8601edcd7c9bcc70e75f85a758f8818c57945d07.camel@decadent.org.uk>
 <20260706135124.draft-0004@kernel.org>
 <ba08a15b-e61b-453f-9331-adf17690d612@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ba08a15b-e61b-453f-9331-adf17690d612@oracle.com>

On Tue, Jul 07, 2026 at 09:18:14AM -0400, Chuck Lever wrote:
>On 7/6/26 10:08 AM, Sasha Levin wrote:
>>> I think this depends on commit 4552f4e3f2c9 "nfsd: change
>>> nfs4_client_to_reclaim() to allocate data" which went into 6.19.  In
>>> older stable branches this failure path appears to leak name.data.
>>
>> You're right - the new early return leaks name.data on every branch
>> lacking 4552f4e3f2c9, and the patch shipped in this round of releases
>> on all six branches.
>>
>> Could someone please send a tested backport of 4552f4e3f2c9 to all relevant
>> trees?
>
>Not wanting to duplicate effort, is that "someone" me ?

Looks like most of the conflict is due to a missing 89bd77cf436b ("nfsd: move
name lookup out of nfsd4_list_rec_dir()"). Ok to queue up both 89bd77cf436b and
4552f4e3f2c9?

-- 
Thanks,
Sasha
