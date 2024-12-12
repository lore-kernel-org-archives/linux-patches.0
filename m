Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B13B1F2C37
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 14:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734012023; cv=none; b=L2MFz6Q2bSmsZJcoBUEshDzjUHkwXfOKEQyvVyAk5X20O5pvJx2tnMiSd7VOYvIl8eEAUDoTFdkcoPmcSJ5coqhJIuqmunuLHog//sAPM7Shlywd1ruKDfzHZT+o0dvQmxSs1nPVa8SFyZm4fzokyrRlmmwJcpkGahrnC6aPn/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734012023; c=relaxed/simple;
	bh=lNCBRPoLNPpljo8RxnmpUh4q9jftwnwwb48Ww0eBwpY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=REF8grLJAmMkywu5c0EywYGB3nzVDGwjWibtJ3zJ9DoOxWd/Ppn8XdOTaZqK9caZ5dqJ9TcWrGjFhuYkJ/IuzImBIQP6dqXFJxUT7PGgFQZZUPT1czXWxisrcMJzgsHy0DSQM6vvFcwxRB6jRLfLOJTSWQ2XtpQer2ao8LuHHfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=ITVXryt5; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="ITVXryt5"
Received: from [192.168.5.25] (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 313793F1A5;
	Thu, 12 Dec 2024 14:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1734012011;
	bh=WZ58zHaR9lbhtQsKoQ/uFiPaFEgJveHhxAu+3tMJ0+o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=ITVXryt5a+2Luk2nW6ddnvR7nZjxTKrZmAASEv5+Omm9V0N/9REy3lyFf2LYor38W
	 IgtnchBleIP4N5HT+kNo+Q9tJFsdhoU56FnuLC3uyPq4/GcAb3WR+VOx1bkhVMHS1N
	 YfxBSH4IgWaO0cD+6N7iCRjVkEi6P/LbjdIluP5ZZ/T86uiGAvGy9EzPimv8ZiWqP6
	 viyc0O8ndY+pTotCDMPV1TVCCYTsTKr+HTtkGRlzco2YbCPK7wLlfNBD5WQEXWTr1I
	 qLx4Vsrow8EbjViQwmDAQVLN4IBlfGKSw6/aTKMjKNMlIp/q36AAAQkHo0AQ8OxGrm
	 xeLDjd6U3kY5g==
Message-ID: <900e507b-b3ec-4d2f-b210-8c06b2b64c26@canonical.com>
Date: Thu, 12 Dec 2024 22:00:00 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-kernel][5.15.y][PATCH 0/5] Fix a regression on sc16is7xx
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, sashal@kernel.org,
 hvilleneuve@dimonoff.com
References: <20241211042545.202482-1-hui.wang@canonical.com>
 <2024121241-civil-diligence-dc09@gregkh>
Content-Language: en-US
From: Hui Wang <hui.wang@canonical.com>
In-Reply-To: <2024121241-civil-diligence-dc09@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/12/24 21:44, Greg KH wrote:
> On Wed, Dec 11, 2024 at 12:25:39PM +0800, Hui Wang wrote:
>> Recently we found the fifo_read() and fifo_write() are broken in our
>> 5.15 kernel after rebase to the latest 5.15.y, the 5.15.y integrated
>> the commit e635f652696e ("serial: sc16is7xx: convert from _raw_ to
>> _noinc_ regmap functions for FIFO"), but it forgot to integrate a
>> prerequisite commit 3837a0379533 ("serial: sc16is7xx: improve regmap
>> debugfs by using one regmap per port").
>>
>> And about the prerequisite commit, there are also 4 commits to fix it,
>> So in total, I backported 5 patches to 5.15.y to fix this regression.
>>
>> 0002-xxx and 0004-xxx could be cleanly applied to 5.15.y, the remaining
>> 3 patches need to resolve some conflict.
>>
>> Hugo Villeneuve (5):
>>    serial: sc16is7xx: improve regmap debugfs by using one regmap per port
>>    serial: sc16is7xx: remove wasteful static buffer in
>>      sc16is7xx_regmap_name()
>>    serial: sc16is7xx: remove global regmap from struct sc16is7xx_port
>>    serial: sc16is7xx: remove unused line structure member
>>    serial: sc16is7xx: change EFR lock to operate on each channels
>>
>>   drivers/tty/serial/sc16is7xx.c | 185 +++++++++++++++++++--------------
>>   1 file changed, 107 insertions(+), 78 deletions(-)
> How well did you test this series?  It seems you forgot about commit
> 133f4c00b8b2 ("serial: sc16is7xx: fix TX fifo corruption"), right?
>
> Please do better testing and resend a working set of patches.

Okay, got it.

Thanks.

>
> thanks,
>
> greg k-h
