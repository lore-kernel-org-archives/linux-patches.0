Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD2F9D6
	for <patches@lists.linux.dev>; Sun, 18 Feb 2024 08:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708246112; cv=none; b=TmhGyQTWeg78F83F0SPCEkdviblid3L8/w+oPqssEw4oum+gJZ6v3WI6igiJxXAIsjNwjCqQlB45updwAfn4ej1Ex9qTIk5lLY5DxyFBDtQn4w+FbII87M2k7mLYVTcXYbHGiqRvK3NPcEk/fx/Jg5IZey8mnRBreWlLSeWDnRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708246112; c=relaxed/simple;
	bh=+sdpSx4f+5o2nlespScZ4ZTiysQaF51sbUgkJdpSr14=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=M8K2fCKgP8+nXTyxOwWxaPy38/4aAcyaPCe3Taxa3UcnbxF1DE5zgqCZlDK5ODETD3btiBIXPEib0nvtsUheRccsRMiwNA1TnbYe0lW7NLdeOVmVLCKS6hSGAxDlrJMb6hKmI9IPpSoZehZRtgSZKnZ0kH6JcPW+OhSfRSM0TSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TczmY4qXxzXh9R;
	Sun, 18 Feb 2024 16:46:37 +0800 (CST)
Received: from kwepemm600013.china.huawei.com (unknown [7.193.23.68])
	by mail.maildlp.com (Postfix) with ESMTPS id 73B041402CF;
	Sun, 18 Feb 2024 16:48:27 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemm600013.china.huawei.com (7.193.23.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 18 Feb 2024 16:48:26 +0800
Subject: Re: [PATCH 5.4 058/194] mtd: Fix gluebi NULL pointer dereference
 caused by ftl notifier
To: Martin Kepplinger-Novakovic <martink@posteo.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
CC: <patches@lists.linux.dev>, ZhaoLong Wang <wangzhaolong1@huawei.com>,
	Richard Weinberger <richard@nod.at>, Miquel Raynal
	<miquel.raynal@bootlin.com>, Sasha Levin <sashal@kernel.org>,
	<linux-mtd@lists.infradead.org>, <vigneshr@ti.com>,
	<dpervushin@embeddedalley.com>, <Artem.Bityutskiy@nokia.com>,
	<linux-kernel@vger.kernel.org>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, Henri Roosen <Henri.Roosen@ginzinger.com>, Melchior
 Franz <Melchior.Franz@ginzinger.com>
References: <20240122235719.206965081@linuxfoundation.org>
 <20240122235721.687806578@linuxfoundation.org>
 <fdfcc3b6e1a884bb986acf072bcc13611eae8bdd.camel@posteo.de>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <a53aacd3-4270-2d80-f14c-8cfd763e4404@huawei.com>
Date: Sun, 18 Feb 2024 16:48:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <fdfcc3b6e1a884bb986acf072bcc13611eae8bdd.camel@posteo.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600013.china.huawei.com (7.193.23.68)

在 2024/2/9 15:09, Martin Kepplinger-Novakovic 写道:
> Am Montag, dem 22.01.2024 um 15:56 -0800 schrieb Greg Kroah-Hartman:
>> 5.4-stable review patch.  If anyone has any objections, please let me
>> know.
>>
>> ------------------
>>
>> From: ZhaoLong Wang <wangzhaolong1@huawei.com>
>>
>> [ Upstream commit a43bdc376deab5fff1ceb93dca55bcab8dbdc1d6 ]
>>

[...]

>> diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
>> index 0c05f77f9b21..dd0d0bf5f57f 100644
>> --- a/drivers/mtd/mtd_blkdevs.c
>> +++ b/drivers/mtd/mtd_blkdevs.c
>> @@ -533,7 +533,7 @@ static void blktrans_notify_add(struct mtd_info
>> *mtd)
>>   {
>>          struct mtd_blktrans_ops *tr;
>>   
>> -       if (mtd->type == MTD_ABSENT)
>> +       if (mtd->type == MTD_ABSENT || mtd->type == MTD_UBIVOLUME)
>>                  return;
>>   
>>          list_for_each_entry(tr, &blktrans_majors, list)
>> @@ -576,7 +576,7 @@ int register_mtd_blktrans(struct mtd_blktrans_ops
>> *tr)
>>          list_add(&tr->list, &blktrans_majors);
>>   
>>          mtd_for_each_device(mtd)
>> -               if (mtd->type != MTD_ABSENT)
>> +               if (mtd->type != MTD_ABSENT && mtd->type !=
>> MTD_UBIVOLUME)
>>                          tr->add_mtd(tr, mtd);
>>   
>>          mutex_unlock(&mtd_table_mutex);
> 
> Hi Greg, hi patch-developers,
> 
> wait a second. this already went into v5.4.268 but still: Doesn't this
> break userspace?
> 
> According to
> https://lore.kernel.org/lkml/441107100.23734.1697904580252.JavaMail.zimbra@nod.at/
> where this solution seems to come from, the behaviour changes: "no
> mtdblock (hence, also no FTLs) on top of gluebi."
> 
> I fell accross this because of an out-of-tree module that does
> sys_mount() an mtdblock, so I won't complain about my code specifically
> :) But doesn't it break mounting, say, jffs2 inside an ubi via
> mtdblock? If so, is this really something that you want to see
> backported to old kernels?
> 
> Or differently put: Has this patch been picked up for old stable
> kernels by scripts or by a human?
> 
> I just want to make sure, and who knows, it might help others too, who
> would just do a (possibly dangerous?) revert in their trees.
> 

This change does affect the mounting(mtdblock based on gluebi) behavior 
in userspace. It was picked into stable versions because the fixed 
problem is serious and easy to be reproduced, I guess.
A temporary solution is that modify mounting source target in userspace, 
just replace mtdblock with mtd char device. For example, mount -t jffs2 
mtd0 /mnt
