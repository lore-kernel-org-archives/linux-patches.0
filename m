Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFE7AD4A
	for <patches@lists.linux.dev>; Fri, 27 Oct 2023 06:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=applied-asynchrony.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from tux.applied-asynchrony.com (p5b2e826a.dip0.t-ipconnect.de [91.46.130.106])
	by mail.itouring.de (Postfix) with ESMTPSA id 16F67CF194E;
	Fri, 27 Oct 2023 08:55:06 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 8B34EF01600;
	Fri, 27 Oct 2023 08:55:05 +0200 (CEST)
Subject: Re: [PATCH 6.5 211/285] btrfs: scrub: fix grouping of read IO
To: Qu Wenruo <wqu@suse.com>, Sam James <sam@gentoo.org>,
 gregkh@linuxfoundation.org
Cc: dsterba@suse.com, patches@lists.linux.dev, stable@vger.kernel.org,
 linux-btrfs@vger.kernel.org
References: <87fs1x1p93.fsf@gentoo.org>
 <02e8fca0-43bd-ad60-6aec-6bcc74d594ee@applied-asynchrony.com>
 <740c38b1-60eb-41da-93e0-7d7671f0b3fc@suse.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <f5299d83-cff0-df11-9775-f3d0adc5d998@applied-asynchrony.com>
Date: Fri, 27 Oct 2023 08:55:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <740c38b1-60eb-41da-93e0-7d7671f0b3fc@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2023-10-26 23:01, Qu Wenruo wrote:
> 
> 
> On 2023/10/27 00:30, Holger Hoffstätte wrote:
>> On 2023-10-26 15:31, Sam James wrote:
>>> 'btrfs: scrub: fix grouping of read IO' seems to intorduce a
>>> -Wmaybe-uninitialized warning (which becomes fatal with the kernel's
>>> passed -Werror=...) with 6.5.9:
>>>
>>> ```
>>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scrub.c: In function ‘scrub_simple_mirror.isra’:
>>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scrub.c:2075:29: error: ‘found_logical’ may be used uninitialized [-Werror=maybe-uninitialized[https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html#index-Wmaybe-uninitialized]]
>>>   2075 |                 cur_logical = found_logical + BTRFS_STRIPE_LEN;
>>> /var/tmp/portage/sys-kernel/gentoo-kernel-6.5.9/work/linux-6.5/fs/btrfs/scrub.c:2040:21: note: ‘found_logical’ was declared here
>>>   2040 |                 u64 found_logical;
>>>        |                     ^~~~~~~~~~~~~
>>> ```
>>
>> Good find! found_logical is passed by reference to queue_scrub_stripe(..) (inlined)
>> where it is used without ever being set:
>>
>> ...
>>      /* Either >0 as no more extents or <0 for error. */
>>      if (ret)
>>          return ret;
>>      if (found_logical_ret)
>>          *found_logical_ret = stripe->logical;
>>      sctx->cur_stripe++;
>> ...
>>
>> Something is missing here, and somehow I don't think it's just the top-level
>> initialisation of found_logical.
> 
> This looks like a false alert for me.
> 
> @found_logical is intentionally uninitialized to catch any uninitialized usage by compiler.
> 
> It would be set by queue_scrub_stripe() when there is any stripe found.

Can you show me where the reference is set before the quoted if block?
The warning happens because according to the compiler this is exactly not what's
happening, and I did not see any initializing write either.

thanks,
Holger
