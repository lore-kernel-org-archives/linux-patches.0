Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C0D214A71
	for <patches@lists.linux.dev>; Fri, 14 Feb 2025 09:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.10.202.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739523967; cv=none; b=IKztmO6QDwxkGZeO+PKPUnNZwarw78zUlZTsgk00XfX/q7/PTEoF+Bj301UVMC/BC15WLXplZMKDL4TI4rNiYx9mwBYfXh/qIWT1Kj7a5FfM3vwkfayWxdfpknCS7jYw+WCdRXJQ1nDbhXJbAl+mFmXWn8Hw192hOxSBnVTGq0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739523967; c=relaxed/simple;
	bh=8IP/Y7JOxbzUNbzXb/jNEk0rXPjp3Hj74KI9OIC0hm0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lrwqqv5er+oHCT6AxgH7t5qFgApW6A8FH9CLxY8jlUnj07JgJHemtAAaEWv9K92PrC14mYa3MtuP+RZEGdawmGVnH3vKnQ6ab1ZYdQGCjOmosOFqaOeiIAXgiUSTfA9sZIDt7iGrQv906HVbpWMFwK5MVvHVWnlJEXJZ4wxoRtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com; spf=pass smtp.mailfrom=applied-asynchrony.com; arc=none smtp.client-ip=85.10.202.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Received: from tux.applied-asynchrony.com (p5ddd71dc.dip0.t-ipconnect.de [93.221.113.220])
	by mail.itouring.de (Postfix) with ESMTPSA id 2A49D12566F;
	Fri, 14 Feb 2025 10:06:03 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id EE20E60189381;
	Fri, 14 Feb 2025 10:06:02 +0100 (CET)
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org
References: <20250213142440.609878115@linuxfoundation.org>
 <e7096ec2-68db-fc3e-9c48-f20d3e80df72@applied-asynchrony.com>
 <2025021459-guise-graph-edb3@gregkh>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <5b51c818-86c0-bc91-cb96-90cd63ca394f@applied-asynchrony.com>
Date: Fri, 14 Feb 2025 10:06:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <2025021459-guise-graph-edb3@gregkh>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2025-02-14 09:42, Greg Kroah-Hartman wrote:
> On Fri, Feb 14, 2025 at 09:32:06AM +0100, Holger Hoffstätte wrote:
>> On 2025-02-13 15:22, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 6.13.3 release.
>>> There are 443 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>
>> Builds & runs fine BUT fails to suspend to RAM 99.99% of the time (basically
>> one success but never again). Display powers down but fans stay on.
>>
>> Tested on multiple systems, all x64. I first suspected amdgpu because why not :)
>> but it also fails on a system without amdgpu, so that's not it.
>>
>> Reverting to 6.13.2 immediately fixes everything.
>>
>> Common symptom on all machines seems to be
>>
>> [  +0.000134] Disabling non-boot CPUs ...
>> [  +0.000072] Error taking CPU15 down: -16
>> [  +0.000002] Non-boot CPUs are not disabled
>>
>> "Error taking down CPUX" is always the highest number of CPU, i.e.
>> 15 on my 16-core Zen2 laptop, 3 on my 4-core Sandybridge etc.
>>
>> I started to revert suspects but no luck so far:
>> - acpi parsing order
>> - amdgpu backlight quirks
>> - timers/hrtimers
>>
>> Suggestions for other suspects are welcome.
> 
> Can you run 'git bisect' to try to find the offending change?

Can do later today but this is going to take a while - slow HW. :(

-h
