Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB83613AA4F
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 13:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709039859; cv=none; b=fTEuk/ziTKouU8uO3ZeiYj8GwBmyBgX9hw4+bJLmc76qM/cXMHz90+r0wVkqov0dgSv5b8GinTkm31ERYgrcjwwa60MS58AJ0HkADYlfobNXCyNcWmp7nuNyanebf3mJ6yF2KmFSLNQW/IChVI3U/arkwdCrSXNLHdYHoOjXei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709039859; c=relaxed/simple;
	bh=g//9Wfph9PR+E/M7UmpiiisxUrd9b3nntV9wAlwtASs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=QwjAcma6FNcWMq++ykIXkko/RpJ/kwAvUXnZ44/J39jUzqnMXO5tz78pEJEySciGFkavgiAg575N5DOLhrB4ztn76MsP6v/vzpz4LRnz4pa4JRbbM2tTu0aHGVL1XXMsIF+bAY0zibcc/fE/Su9p6grIspg/zp6EZiPFymaSV8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TkdJL0Qdnz1Q99v;
	Tue, 27 Feb 2024 21:15:14 +0800 (CST)
Received: from dggpeml500021.china.huawei.com (unknown [7.185.36.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 9BB2D1400DD;
	Tue, 27 Feb 2024 21:17:28 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 21:17:28 +0800
Message-ID: <7ad7f528-de58-fbe9-c5aa-d75dd7f8ffb7@huawei.com>
Date: Tue, 27 Feb 2024 21:17:27 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 5.15 2/2] ext4: avoid bb_free and bb_fragments
 inconsistency in mb_free_blocks()
Content-Language: en-US
To: Greg KH <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <sashal@kernel.org>, <tytso@mit.edu>,
	<jack@suse.cz>, <patches@lists.linux.dev>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, Baokun Li <libaokun1@huawei.com>
References: <20240227130050.805571-1-libaokun1@huawei.com>
 <20240227130050.805571-2-libaokun1@huawei.com>
 <2024022725-broadly-gave-6b16@gregkh>
From: Baokun Li <libaokun1@huawei.com>
In-Reply-To: <2024022725-broadly-gave-6b16@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)

On 2024/2/27 21:06, Greg KH wrote:
> On Tue, Feb 27, 2024 at 09:00:50PM +0800, Baokun Li wrote:
>> commit 2331fd4a49864e1571b4f50aa3aa1536ed6220d0 upstream.
>>
>> After updating bb_free in mb_free_blocks, it is possible to return without
>> updating bb_fragments because the block being freed is found to have
>> already been freed, which leads to inconsistency between bb_free and
>> bb_fragments.
>>
>> Since the group may be unlocked in ext4_grp_locked_error(), this can lead
>> to problems such as dividing by zero when calculating the average fragment
>> length. Hence move the update of bb_free to after the block double-free
>> check guarantees that the corresponding statistics are updated only after
>> the core block bitmap is modified.
>>
>> Fixes: eabe0444df90 ("ext4: speed-up releasing blocks on commit")
>> CC:  <stable@vger.kernel.org> # 3.10
>> Suggested-by: Jan Kara <jack@suse.cz>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> Reviewed-by: Jan Kara <jack@suse.cz>
>> Link: https://lore.kernel.org/r/20240104142040.2835097-5-libaokun1@huawei.com
>> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
>> ---
>>   fs/ext4/mballoc.c | 39 +++++++++++++++++++++------------------
>>   1 file changed, 21 insertions(+), 18 deletions(-)
> We also need this for 5.10.y and older, right?
Yes, I'm working on adapting the patch for older versions.
>
> Queued up now, thanks!
>
> greg k-h
>
-- 
With Best Regards,
Baokun Li
.
