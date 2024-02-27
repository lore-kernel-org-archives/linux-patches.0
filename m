Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EBA13AA2F
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 13:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041336; cv=none; b=U9gEa75/H+7fxyZzhDkoHXygnFQmnjkxJVj54rwkdnn4E2Id11shiZpn9Mp+rtv/7HqSGKdtd9sKnOwJj9FEgbdT4QninFVN1AYQo3qUawovwEnLrG/hbl0ZQibeJFToBCrKtZiXAAUgil6gtdPfRDGY0Wiofz/YY9GNvWTLSew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041336; c=relaxed/simple;
	bh=6OR8pYM7suBpE4VlEJa7l0D5FXGcWyQjXvn2iIAyXQk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=kWbMv6O/IAGSroG3x+pTwGebBE/F3qxBTMCWTYyxQCt7yYg+KfUVxjRfED7XuhtBWDMAAJfZ28EP1Y/Clp85b0ia8M7ewAlqz9tfsJBChz44frsvsyf5rEN7prSLCL2zLAC6FkQxJ8Q2caAoB2Dmv3zDOfkuePq5eKwLeCHkrxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Tkdtk66WYzqhms;
	Tue, 27 Feb 2024 21:41:34 +0800 (CST)
Received: from dggpeml500021.china.huawei.com (unknown [7.185.36.21])
	by mail.maildlp.com (Postfix) with ESMTPS id AAFF1140336;
	Tue, 27 Feb 2024 21:42:11 +0800 (CST)
Received: from [10.174.177.174] (10.174.177.174) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 21:42:11 +0800
Message-ID: <5a95aeb6-d070-fb3e-d619-8f26164b293c@huawei.com>
Date: Tue, 27 Feb 2024 21:42:10 +0800
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
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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
>
> Queued up now, thanks!
>
> greg k-h
>
5.4.y and older will regenerate the buddy on error, so this is not needed.


-- 
With Best Regards,
Baokun Li
.

