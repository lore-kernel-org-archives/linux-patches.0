Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1CF31EF38F
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 05:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755494656; cv=none; b=f8UUTXS+qbKFDHYzYDzD+Gm8HCvcd9F8ZhldQh07Y3hakcEO5VWtos+pCLQ752IucwCAmLjVl5Jm25oyUQu6zDE84bnJgVRajifjT2RQ22zIfaOBKu6ozIN71V9bT+7pTo1UtNG6PdmBNBgSdmEcvfJf7hxWn8VqI+FA/TTT1j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755494656; c=relaxed/simple;
	bh=8wiTb8fNRCyJIgqWCW1b/sRAjqR2MPIo8lU+lkseZwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wgbbkf65RF8RFMg+nwYyr1UFs266nWu4rjPlGPApDYsAFv/V7FUyfHvhw/1kLLTxz2EUC9tQWVkKEGMVcPkZ88ZA0gWzaN7tmbJ1S+EBjkLBPyezS5QUFMBLtuWQ5oyN8OUdvcKix4H8wK8KoFX2Yo1kThQQUY+AGjwEz+rh8ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=PXxm8rsX; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PXxm8rsX"
Received: from [10.95.64.75] (unknown [167.220.238.11])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4955A2054677;
	Sun, 17 Aug 2025 22:24:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4955A2054677
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1755494653;
	bh=w32BJLaKNHTQrrElu97ALQTnN3hLaYFd8VqACkOW/7c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PXxm8rsXcylV2Dq1hm91H6anT1vqFiJM4T8mFAgoD0D2ty6CKE9vDNLiWXLgNuiVP
	 aGKu66s6oJGc3TTFB+VYZS9PcMQx9UpVt1+P5zteza2qgoi2FGAKjegi85f/kZpJAp
	 SAsUTHs/an7JrVn+NR4aFPAYc+itFaDk9WCNBNkA=
Message-ID: <08158da3-82a0-4eb0-a805-87afe34e288a@linux.microsoft.com>
Date: Mon, 18 Aug 2025 10:54:10 +0530
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
 <longli@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Naman Jain <namjain@linux.microsoft.com>
References: <20250722134340.596340262@linuxfoundation.org>
 <20250722134341.490321531@linuxfoundation.org>
 <d9be2bb3-5f84-4182-91e8-ec1a4abd8f5f@linux.microsoft.com>
 <2025072316-mop-manhood-b63e@gregkh>
Content-Language: en-US
From: Naman Jain <namjain@linux.microsoft.com>
In-Reply-To: <2025072316-mop-manhood-b63e@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/23/2025 12:12 PM, Greg Kroah-Hartman wrote:
> On Tue, Jul 22, 2025 at 08:29:07PM +0530, Naman Jain wrote:
>>
>>
>> On 7/22/2025 7:13 PM, Greg Kroah-Hartman wrote:
>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Naman Jain <namjain@linux.microsoft.com>
>>>
>>> commit a4131a50d072b369bfed0b41e741c41fd8048641 upstream.
>>>
>>> Size of ring buffer, as defined in uio_hv_generic driver, is no longer
>>> fixed to 16 KB. This creates a problem in fcopy, since this size was
>>> hardcoded. With the change in place to make ring sysfs node actually
>>> reflect the size of underlying ring buffer, it is safe to get the size
>>> of ring sysfs file and use it for ring buffer size in fcopy daemon.
>>> Fix the issue of disparity in ring buffer size, by making it dynamic
>>> in fcopy uio daemon.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 0315fef2aff9 ("uio_hv_generic: Align ring size to system page")
>>> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
>>> Reviewed-by: Saurabh Sengar <ssengar@linux.microsoft.com>
>>> Reviewed-by: Long Li <longli@microsoft.com>
>>> Link: https://lore.kernel.org/r/20250711060846.9168-1-namjain@linux.microsoft.com
>>> Signed-off-by: Wei Liu <wei.liu@kernel.org>
>>> Message-ID: <20250711060846.9168-1-namjain@linux.microsoft.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> ---
>>
>>
>> Hello Greg,
>> Please don't pick this change yet. I have shared the reason in the other
>> thread:
>> "Re: Patch "tools/hv: fcopy: Fix irregularities with size of ring buffer"
>> has been added to the 6.12-stable tree"
> 
> Ok, I have dropped this from the 6.12.y tree now.
> 
> thanks,
> 
> greg k-h

Hello Greg,
Can you please consider picking this change for next release of 6.12 
kernel. The dependent change [1] is now part of 6.12 kernel, so we need 
this change to fix fcopy in 6.12 kernel.

[1]: Drivers: hv: Make the sysfs node size for the ring buffer dynamic

Please let me know if you want me to send a patch for back-port separately.

Regards,
Naman

