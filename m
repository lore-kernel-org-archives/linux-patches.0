Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7EC6FBF
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 03:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752550050; cv=none; b=HVr/8JfwvUq+5cmmewNbLRb/6u8eHA099Evt0wR6ePnV5zHNC40bbouVYfNO5v3rrMPzDa6vh89O0zGiZMpfNzkKPEUGN2djLUgoeJx3QlG2IRtlfsbs3dP2U7YUe1dQt7R5DU7Sanbg50kNBqLKUU4wzHhi8PH1la2tT0/jIeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752550050; c=relaxed/simple;
	bh=jOUqALX7QVyNYt5Xu05hH9z7mutVD909x5PM0TEzNss=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sQViqwqP48wefethEYeNbhs+hbxsIk0WStETngZR6XSSBjeTkI5Y1RNWiTsFz8xNGsfxJbAG3ir7BdS0EpVfMcl6Pt28MlNeZePoV37McQ03jXpVCSY3tIpVNxbKpFsbg0ltBIFyVPbFMo2bstjxBapkwRB59w2Jd6fGn2hgDmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4bh4LT6xjJz29drm;
	Tue, 15 Jul 2025 11:24:49 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id BB54C1A0191;
	Tue, 15 Jul 2025 11:27:26 +0800 (CST)
Received: from kwepemn100006.china.huawei.com (7.202.194.109) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 11:27:21 +0800
Received: from [10.174.176.245] (10.174.176.245) by
 kwepemn100006.china.huawei.com (7.202.194.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 15 Jul 2025 11:27:19 +0800
Message-ID: <b767d89b-ab77-4681-9eb3-a0590e7c97fe@huawei.com>
Date: Tue, 15 Jul 2025 11:27:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 087150] Input atkbd - skip ATKBD_CMD_GETID in
 translated mode
To: Hans de Goede <hdegoede@redhat.com>
CC: <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	<patches@lists.linux.dev>, <yesh25@mail2.sysu.edu.cn>, <mail@gurevit.ch>,
	<egori@altlinux.org>, <anton@cpp.in>, <dmitry.torokhov@gmail.com>,
	<sashal@kernel.org>
References: <456b5d9c-f72a-4bfe-a72a-b5cc0f15eb70@huawei.com>
 <afeadd0a-d341-46ee-9634-01c5122b416a@redhat.com>
Content-Language: en-US
From: Wang Hai <wanghai38@huawei.com>
In-Reply-To: <afeadd0a-d341-46ee-9634-01c5122b416a@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemn100006.china.huawei.com (7.202.194.109)



On 2025/7/14 22:40, Hans de Goede wrote:
> Hi,
> 
> On 14-Jul-25 15:49, Wang Hai wrote:
>>
>>
>> On 1970/1/1 8:00,  wrote:
>>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>>   From Hans de Goede hdegoede@redhat.com
>>>
>>> [ Upstream commit 936e4d49ecbc8c404790504386e1422b599dec39 ]
>>>
>>> There have been multiple reports of keyboard issues on recent laptop models
>>> which can be worked around by setting i8042.dumbkbd, with the downside
>>> being this breaks the capslock LED.
>>>
>>> It seems that these issues are caused by recent laptops getting confused by
>>> ATKBD_CMD_GETID. Rather then adding and endless growing list of quirks for
>>> this, just skip ATKBD_CMD_GETID alltogether on laptops in translated mode.
>>>
>>> The main goal of sending ATKBD_CMD_GETID is to skip binding to ps2
>>> micetouchpads and those are never used in translated mode.
>>>
>>> Examples of laptop models which benefit from skipping ATKBD_CMD_GETID
>>>
>>>    HP Laptop 15s-fq2xxx, HP laptop 15s-fq4xxx and HP Laptop 15-dy2xxx
>>>     models the kbd stops working for the first 2 - 5 minutes after boot
>>>     (waiting for EC watchdog reset)
>>>
>>>    On HP Spectre x360 13-aw2xxx atkbd fails to probe the keyboard
>>>
>>>    At least 9 different Lenovo models have issues with ATKBD_CMD_GETID, see
>>>     httpsgithub.comyescallopatkbd-nogetid
>>>
>>> This has been tested on
>>>
>>> 1. A MSI B550M PRO-VDH WIFI desktop, where the i8042 controller is not
>>>      in translated mode when no keyboard is plugged in and with a ps2 kbd
>>>      a AT Translated Set 2 keyboard devinputevent# node shows up
>>>
>>> 2. A Lenovo ThinkPad X1 Yoga gen 8 (always has a translated set 2 keyboard)
>>>
>>> Reported-by Shang Ye yesh25@mail2.sysu.edu.cn
>>> Closes httpslore.kernel.orglinux-input886D6167733841AE+20231017135318.11142-1-yesh25@mail2.sysu.edu.cn
>>> Closes httpsgithub.comyescallopatkbd-nogetid
>>> Reported-by gurevitch mail@gurevit.ch
>>> Closes httpslore.kernel.orglinux-input2iAJTwqZV6lQs26cTb38RNYqxvsink6SRmrZ5h0cBUSuf9NT0tZTsf9fEAbbto2maavHJEOP8GA1evlKa6xjKOsaskDhtJWxjcnrgPigzVo=@gurevit.ch
>>> Reported-by Egor Ignatov egori@altlinux.org
>>> Closes httpslore.kernel.orgall20210609073333.8425-1-egori@altlinux.org
>>> Reported-by Anton Zhilyaev anton@cpp.in
>>> Closes httpslore.kernel.orglinux-input20210201160336.16008-1-anton@cpp.in
>>> Closes httpsbugzilla.redhat.comshow_bug.cgiid=2086156
>>> Signed-off-by Hans de Goede hdegoede@redhat.com
>>> Link httpslore.kernel.orgr20231115174625.7462-1-hdegoede@redhat.com
>>> Signed-off-by Dmitry Torokhov dmitry.torokhov@gmail.com
>>> Signed-off-by Sasha Levin sashal@kernel.org
>>> ---
>>
>> Hi, Hans
>>
>> I noticed there's a subsequent bugfix [1] for this patch, but it hasn't been merged into the stable-6.6 branch. Based on the bugfix description, the issue should exist there as well. Would you like this patch to be merged into the stable-6.6 branch?"
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=9cf6e24c9fbf17e52de9fff07f12be7565ea6d61
> 
> Yes, if you can submit that patch for inclusion into the 6.6 stable branch
> that would be good.
> 
> Regards,
> 
> Hans
> 
> 
Hi, Hans

I noticed that the 5.4, 5.10, 5.15, 6.1, and 6.6 stable branches all
require this. I’ve just submitted the fix patch—could you review it
when you have time?

https://lore.kernel.org/stable/20250715031442.16528-1-wanghai38@huawei.com/T/#u

Regards,

Wang Hai
