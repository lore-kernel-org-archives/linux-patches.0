Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0721D1A08A8
	for <patches@lists.linux.dev>; Tue, 10 Dec 2024 12:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733835131; cv=none; b=qCQt3cQs358HiHdw/DhAQaMbOggspK5mUjxcwMhC4Ny+3TSbWHXA+3fH4OVsdDCDZELNQjlaEVUnEV30vTwuGF51Q5TkQVFo6SwG78HVoEzA2K54fVjdxXm1O7YpLQ69LS8jd6lYaEoU42wdDqE83vfUPnOz9NnlfE6Yw8l4o7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733835131; c=relaxed/simple;
	bh=OitKjX8hjWp0Ind9KDM0AFf0Pn9LoAnV/IyRUgKi2es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q0B+zR31sg1hDyYmbvZRukWwwsolrCU6X7KBNcTT4z9vPZXCqFUjwMqKkDsepzZNgEvClQV1Q4rI0V06tTQPk7BTJpGmeLogoMq+5zskrGf3h+rDVvlKKBoP+OXQ2aRvfCKFBy6jkX0OQh/x81v/llGDjfp62ghReXWkVjSoyHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=gpXFcbwd; arc=none smtp.client-ip=185.125.188.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="gpXFcbwd"
Received: from [192.168.5.25] (unknown [120.85.107.173])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id E5C5B3FEC5;
	Tue, 10 Dec 2024 12:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733835127;
	bh=2uQSvyYG99Md1d1mi4cGEDNI4JL6b9oPNRCXyTkoRAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=gpXFcbwdkpwTlV2J5huaB65d5gyrWWbgEYFqbe22Y0ZUut5cZC2L72xYos56tlrXm
	 SY9x2bo2byTs1C6IQCvCXsDuwRWLWj0j7s37rvsxiWTLsoAvZeq+ZKJ+g2K6Mu8Ib6
	 B13DdGDyT4rXvo8yl1rL8tLJQmiUCfms9ETRn/RHrfsnp0l1YMM9M29WWpu4fC0M1m
	 WF9pN/Ui3SQep39bSWH34LaWbUoucq//kSMBxirrkwmBLKBnKnKzWYYAVn/zY0rMTu
	 mFOgDqRr96vg7m4DFlF6imyIAbL5F62vbADXS+Pt8bVzbsEY0k5Ix/0ObOByRHSWfH
	 8zBYqc4Ks3B8A==
Message-ID: <976417ca-51c0-4d31-82dc-95eb28fc299a@canonical.com>
Date: Tue, 10 Dec 2024 20:51:56 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stble-kernel][5.15.y][5.10.y][PATCH v2] serial: sc16is7xx: the
 reg needs to shift in regmap_noinc
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, sashal@kernel.org,
 hvilleneuve@dimonoff.com
References: <20241210113126.46056-1-hui.wang@canonical.com>
 <2024121020-abstract-ashy-cbe6@gregkh>
Content-Language: en-US
From: Hui Wang <hui.wang@canonical.com>
In-Reply-To: <2024121020-abstract-ashy-cbe6@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 12/10/24 20:15, Greg KH wrote:
> On Tue, Dec 10, 2024 at 07:31:26PM +0800, Hui Wang wrote:
>> Recently we found the fifo_read() and fifo_write() are broken in our
>> 5.15 and 5.4 kernels after cherry-pick the commit e635f652696e
>> ("serial: sc16is7xx: convert from _raw_ to _noinc_ regmap functions
>> for FIFO"), that is because the reg needs to shift if we don't
>> cherry-pick a prerequisite commit 3837a0379533 ("serial: sc16is7xx:
>> improve regmap debugfs by using one regmap per port").
>>
>> It is hard to backport the prerequisite commit to 5.15.y and 5.10.y
>> due to the significant conflict. To be safe, here fix it by shifting
>> the reg as regmap_volatile() does.
> Please try, submit the series of upstream commits first and then if it's
> too rough, we can evaluate it later.  As-is, I can't take this, sorry.
OK, got it, I will have a try.
> greg k-h
