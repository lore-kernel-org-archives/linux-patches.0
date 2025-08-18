Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6555D25C81E
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 06:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755499682; cv=none; b=Ns1khXdexpp/lYSa7B3NgVGTUiYjGdrTgu3mR8g2djXcGTXabLymz5IL4P7E/C8ywwp/pEUm+zRYQCW/qgWLVMaAc3t2v7gvUf82lm7REVvmAFiGLGj0Vkex0HCzEAKLeHHXTzqexxdLPbI6hVh00IyaYUauSSnjHjdReW1nJak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755499682; c=relaxed/simple;
	bh=4f6LJZiRndmUfvc5xeffNXg78yFNRvxk90kZiuVnZPQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VB+Qon9zUCwc0Xp44SAC8VxSZbShDuycQZqCm5Gi/SxUhdy1bELbyik7eNQpkMVdnQWpaiccVqLbf9zzPjThHNNBPcIxbxqXwgGnKsVJkrXquWPBsjaLUzf1mrwPIEc/aLEaVxtRjllrd0K1FwkG1MJABQld3txWJahHvdX5YhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Q0tN71tK; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Q0tN71tK"
Received: from [10.95.64.75] (unknown [167.220.238.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0CC072113343;
	Sun, 17 Aug 2025 23:47:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0CC072113343
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1755499680;
	bh=AJvrjplhI4XgVj15uOIDsZ9E1MSOHTMWF+jfyprUxbk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Q0tN71tKJGZv2Fo4TL+Tp2ywMwcSJrXeYrLgOZgOyf/EwtJsC+/t22OLYKkkdpptJ
	 Sl62RW6qH3wqQDnlpvpECFxiGy0+4SOK4IGFtjHqhRhuB0TLBKEUPq0mYx1MHmh+NO
	 KoLwu3+W6C/44470wMFIW0JsDZleFTSQ3uDwnxR0=
Message-ID: <fbf3a795-bf18-4970-a320-ec06e0758d3b@linux.microsoft.com>
Date: Mon, 18 Aug 2025 12:17:56 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 020/158] tools/hv: fcopy: Fix irregularities with
 size of ring buffer
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Saurabh Sengar <ssengar@linux.microsoft.com>, Long Li
 <longli@microsoft.com>, Wei Liu <wei.liu@kernel.org>
References: <20250722134340.596340262@linuxfoundation.org>
 <20250722134341.490321531@linuxfoundation.org>
 <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
 <2025072316-mop-manhood-b63e@gregkh>
 <08158da3-82a0-4eb0-a805-87afe34e288a@linux.microsoft.com>
 <2025081834-bullfrog-elixir-6a96@gregkh>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <2025081834-bullfrog-elixir-6a96@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/18/2025 11:22 AM, Greg Kroah-Hartman wrote:
> On Mon, Aug 18, 2025 at 10:54:10AM +0530, Naman Jain wrote:
>>
>>
>> On 7/23/2025 12:12 PM, Greg Kroah-Hartman wrote:
>>> On Tue, Jul 22, 2025 at 08:29:07PM +0530, Naman Jain wrote:
>>>>
>>>>
>>>> On 7/22/2025 7:13 PM, Greg Kroah-Hartman wrote:
>>>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>>>>
>>>>> ------------------
>>>>>
>>>>> From: Naman Jain <namjain@linux.microsoft.com>
>>>>>
>>>>> commit a4131a50d072b369bfed0b41e741c41fd8048641 upstream.
>>>>>
>>>>> Size of ring buffer, as defined in uio_hv_generic driver, is no longer
>>>>> fixed to 16 KB. This creates a problem in fcopy, since this size was
>>>>> hardcoded. With the change in place to make ring sysfs node actually
>>>>> reflect the size of underlying ring buffer, it is safe to get the size
>>>>> of ring sysfs file and use it for ring buffer size in fcopy daemon.
>>>>> Fix the issue of disparity in ring buffer size, by making it dynamic
>>>>> in fcopy uio daemon.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
>>>>> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
>>>>> Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
>>>>> Reviewed-by: Long Li <longli@microsoft.com>
>>>>> Link: https://lore.kernel.org/r/20250711060846.9168-1-namjain@linux.microsoft.com
>>>>> Signed-off-by: Wei Liu <wei.liu@kernel.org>
>>>>> Message-ID: <20250711060846.9168-1-namjain@linux.microsoft.com>
>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>>>> ---
>>>>
>>>>
>>>> Hello Greg,
>>>> Please don't pick this change yet. I have shared the reason in the other
>>>> thread:
>>>> "Re: Patch "tools/hv: fcopy: Fix irregularities with size of ring buffer"
>>>> has been added to the 6.12-stable tree"
>>>
>>> Ok, I have dropped this from the 6.12.y tree now.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Hello Greg,
>> Can you please consider picking this change for next release of 6.12 kernel.
>> The dependent change [1] is now part of 6.12 kernel, so we need this change
>> to fix fcopy in 6.12 kernel.
>>
>> [1]: Drivers: hv: Make the sysfs node size for the ring buffer dynamic
> 
> What are the exact git commit ids you want to have applied here?  [1]
> does not reference much to me :)
> 
> thanks,
> 
> greg k-h

My bad :)

Please pick the commit a4131a50d072 ("tools/hv: fcopy: Fix 
irregularities with size of ring buffer") in next 6.12 release, which is 
supposed to fix fcopy.


The commit which added the missing dependency is now already part of 
v6.12.42 kernel
c7f864d34529 ("Drivers: hv: Make the sysfs node size for the ring buffer 
dynamic")

Earlier, when I requested you to drop the change from backport list 
because above change was not part of latest 6.12 kernel.

Regards,
Naman
