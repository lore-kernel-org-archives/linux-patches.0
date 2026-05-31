Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1102238E8B1
	for <patches@lists.linux.dev>; Sun, 31 May 2026 15:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780241723; cv=none; b=azt1skLWXlpALeeYBsLsrBrJtBUJG0Pftb3lC+K883fb7ApSl+5okJ2i84uPXmscdaxpDc643bJv1XhHVnHQSsHsHIBybOptTdxmA3ntAHqIcTXD2wMrHuEpEAttaYIn75S64Hf/xTtepEXUkoR7SoDpRkbbrLLbId8G6E+SlmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780241723; c=relaxed/simple;
	bh=Sz2DmgnbadyAo3Dz86pJGRgTp2LYw+19Ug46KEiSCB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OHJV2tQ5eOL21Kgf5zyr87UvfNziLlMcXOCzcuYi0Cma4lVoKEpGLSVevnQZg0d0nHxMHuqf2Hiafk8wzk73TgvYOv9gDGvzzzke18kIPnRCbqjYjBM8r+haq1w5nHDPE7HyOWE42WKZjxLrzIrM/z6gkF6hJgl77eE3ZdRWfTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from [10.88.16.7] (unknown [193.43.11.2])
	(Authenticated sender: kovalevvv)
	by air.basealt.ru (Postfix) with ESMTPSA id 4E77C2336D;
	Sun, 31 May 2026 18:35:19 +0300 (MSK)
Message-ID: <fc9b0b14-be90-71be-17a8-695549dedd5d@basealt.ru>
Date: Sun, 31 May 2026 18:35:18 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.10 095/589] ALSA: usb-audio: fix null pointer
 dereference on pointer cs_desc
To: Ben Hutchings <ben@decadent.org.uk>, Chengfeng Ye <cyeaa@connect.ust.hk>,
 Takashi Iwai <tiwai@suse.de>
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 stable <stable@vger.kernel.org>
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160227.194081368@linuxfoundation.org>
 <ca469f4a22fe4688bbf88c355d074ae5be16a621.camel@decadent.org.uk>
Content-Language: en-US
From: Vasiliy Kovalev <kovalev@altlinux.org>
In-Reply-To: <ca469f4a22fe4688bbf88c355d074ae5be16a621.camel@decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/26 15:33, Ben Hutchings wrote:
> On Sat, 2026-05-30 at 17:59 +0200, Greg Kroah-Hartman wrote:
>> 5.10-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Chengfeng Ye <cyeaa@connect.ust.hk>
>>
>> commit b97053df0f04747c3c1e021ecbe99db675342954 upstream.
>>
>> The pointer cs_desc return from snd_usb_find_clock_source could
>> be null, so there is a potential null pointer dereference issue.
>> Fix this by adding a null check before dereference.
>>
>> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
>> Link: https://lore.kernel.org/r/20211024111736.11342-1-cyeaa@connect.ust.hk
>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> Fixes: 1dc669fed61a ("ALSA: usb-audio: UAC2: support read-only freq control")
>> [ kovalev: bp to fix CVE-2021-47211; added Fixes tag; the null
>>    check was added into both UAC2 and UAC3 branches since the
>>    older kernel still has the clock source lookup split between
>>    snd_usb_find_clock_source() and snd_usb_find_clock_source_v3()
>>    (see upstream commit 9ec730052fa2) ]
> 
> In the upstream version the return statement was added in
> snd_usb_set_sample_rate_v2v3(), so set_sample_rate_v2v3() will do:
> 
>          cur_rate = snd_usb_set_sample_rate_v2v3(chip, fmt, clock, rate);  // = 0
>          if (cur_rate < 0) ...                              // false
>          if (!cur_rate)                                     // true
>                  cur_rate = prev_rate;
>          if (cur_rate != rate) ...
>   validation:
>          if (!uac_clock_source_is_valid(chip, fmt, clock))  // true because clock soure is missing
>                  return -ENXIO;
> 
> so it will ultimately return -ENXIO.
> 
> Whereas this backport puts the return statements in
> set_sample_rate_v2v3(), so it directly returns 0 i.e. silently fails.
> Shouldn't these be changed to return -ENXIO?
> 
> Ben.

Hi Ben,
You're right. In 5.10 set_sample_rate_v2v3() is a single function, so 
return 0 here is consumed as success by snd_usb_pcm_prepare(), diverging 
from upstream which ends up at -ENXIO via !uac_clock_source_is_valid().

v2 sent: 
https://lore.kernel.org/all/20260531152950.191924-1-kovalev@altlinux.org/

-- 
Thanks,
Vasiliy
