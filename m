Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505C9143883;
	Thu,  1 Aug 2024 05:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488495; cv=none; b=kq2xSoh06lnPD8nw/fJqyoqqr0b/OCGKrWDS74doJ1HSCmnJvuJ9a3sX9M5q377fdR5flTHAHdNDRnug2DkMt07ZfV8LzQ8jHGpeAwv2aPcyV88YE43k42TXpWqw7nuGqtGZsgdG/OT4WQVKDCdNMuNKlx/lr0mIVqWSXDS9bbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488495; c=relaxed/simple;
	bh=ps+wc1QwyfUolpRk3qvMgokBT3mBGAnwtY+M4K/Z1IQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AB7SrTOBIbfuU94COXGiPwH2OwRcTyQVL917hmm1sMqthKiwbd1IY6xsTlo3sFUom+itqMiCZDR+tPZikJklStB9NA3cjELRQ7uZyX/hgrI3yhBP1xsTv2J1OMg9pigVHy94HbH3nfawM+8YlehHVZp0BeLe04yjORVIxbYN+sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSEV7RJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSEV7RJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43620C4AF0A;
	Thu,  1 Aug 2024 05:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722488494;
	bh=ps+wc1QwyfUolpRk3qvMgokBT3mBGAnwtY+M4K/Z1IQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rSEV7RJ7fkEMQJQOhk0Hau6SPYP1ec5ZCHaXOmN/AfiTWXX69Jr9Cbv1x4803npgB
	 b/4V5TJoOJIBY8JUYoJL56rk0LQ13BVeUGAz4tsk8iOniepgnJlY11+ljfENQ8ZsOE
	 NUnYUJpNWcuYWzD4yBYrxalZFlrv72xktuxEUkpM=
Date: Thu, 1 Aug 2024 07:01:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	Paul Luse <paul.e.luse@linux.intel.com>, Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: Re: [PATCH 6.10 678/809] md/raid1: set max_sectors during early
 return from choose_slow_rdev()
Message-ID: <2024080111-poet-bok-e8d4@gregkh>
References: <20240730151724.637682316@linuxfoundation.org>
 <20240730151751.683503374@linuxfoundation.org>
 <974b072b-9696-42c9-8cec-f68454eedc33@o2.pl>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <974b072b-9696-42c9-8cec-f68454eedc33@o2.pl>

On Wed, Jul 31, 2024 at 09:43:58PM +0200, Mateusz Jończyk wrote:
> W dniu 30.07.2024 o 17:49, Greg Kroah-Hartman pisze:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Mateusz Jończyk <mat.jonczyk@o2.pl>
> >
> > commit 36a5c03f232719eb4e2d925f4d584e09cfaf372c upstream.
> >
> > Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
> > when that drive has a write-mostly flag set. During such an attempt,
> > the following assertion in bio_split() is hit:
> >
> > 	BUG_ON(sectors <= 0);
> >
> > Call Trace:
> > 	? bio_split+0x96/0xb0
> > 	? exc_invalid_op+0x53/0x70
> > 	? bio_split+0x96/0xb0
> > 	? asm_exc_invalid_op+0x1b/0x20
> > 	? bio_split+0x96/0xb0
> > 	? raid1_read_request+0x890/0xd20
> > 	? __call_rcu_common.constprop.0+0x97/0x260
> > 	raid1_make_request+0x81/0xce0
> > 	? __get_random_u32_below+0x17/0x70
> > 	? new_slab+0x2b3/0x580
> > 	md_handle_request+0x77/0x210
> > 	md_submit_bio+0x62/0xa0
> > 	__submit_bio+0x17b/0x230
> > 	submit_bio_noacct_nocheck+0x18e/0x3c0
> > 	submit_bio_noacct+0x244/0x670
> >
> > After investigation, it turned out that choose_slow_rdev() does not set
> > the value of max_sectors in some cases and because of it,
> > raid1_read_request calls bio_split with sectors == 0.
> >
> > Fix it by filling in this variable.
> >
> > This bug was introduced in
> > commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> > but apparently hidden until
> > commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best rdev from read_balance()")
> > shortly thereafter.
> >
> > Cc: stable@vger.kernel.org # 6.9.x+
> > Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> > Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
> > Cc: Song Liu <song@kernel.org>
> > Cc: Yu Kuai <yukuai3@huawei.com>
> > Cc: Paul Luse <paul.e.luse@linux.intel.com>
> > Cc: Xiao Ni <xni@redhat.com>
> > Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> > Link: https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonczyk@o2.pl/
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Hello,
> 
> FYI there is a second regression in Linux 6.9 - 6.11, which occurs with RAID
> component devices with a write-mostly flag when a new device is added
> to the array. (A write-mostly flag on a device specifies that the kernel is to
> avoid reading from such a device, if possible. It is enabled only manually with
> a mdadm command line switch and can be beneficial when devices are of
> different speed). The kernel than reads from the wrong component device
> before it is synced, which may result in data corruption.
> 
> Link: https://lore.kernel.org/lkml/9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl/T/
> 
> This is not caused by this patch, but only linked by similar functions and the
> write-mostly flag being involved in both cases. The issue is that without this
> patch, the kernel will fail to start or keep running a RAID array with a single
> write-mostly device and the user will not be able to add another device to it,
> which triggered the second regression.
> 
> Paul was of the opinion that this first patch should land nonetheless.
> I would like you to decide whether to ship it now or defer it.

Is there a fix for this anywhere?  If not, being in sync with Linus's
tree is probably the best solution for now.

thanks,

greg k-h
