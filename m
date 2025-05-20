Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210262F37;
	Tue, 20 May 2025 14:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749891; cv=none; b=agxjxtLW2HfJHEGDGdVrusKKyoUkg2ZD9tgs+MxAItSvRsClJcEwnRUMMaXIrZDXVNGaIkrjrvVc/p05hktm6JLQCyoQts8whlmg76u4XIcPLPzk+tfj8IlHGvjz/HPmYWhfYYUi435xuEd5wzWOtftticq8SQx/f4jzIdLknZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749891; c=relaxed/simple;
	bh=VgDUsWQh9mJ8cHhZPRAtRTcBXf6NeJtKdNxp+2kehWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ciXDQ94kUZE1a8KW3CBaiUw1sL4/w1xUpqqagXQ38GiTuh+yGqxh4TKqeMyIPQTaOGxT1XCJB062UcLfcaX6l6sAoISot+T5qH78YpImztF4srCfRR0lXDSwiHDFC3h1LEih8QKSeUU3HKhcZd26cc31NGzjmYKwXIFrjMSn3rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JTCtQwdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JTCtQwdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B247FC4CEEF;
	Tue, 20 May 2025 14:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747749890;
	bh=VgDUsWQh9mJ8cHhZPRAtRTcBXf6NeJtKdNxp+2kehWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JTCtQwdyidM6pLDCi79WvGZpz7jCqUd+nRz7nld6DZUJFUHc+zlC4bR6Hn9bsB1wX
	 KaticX7V/hO2295lHp5hLHcDFDr+AABnFHPxvOzRrZhh2bICRZCzyzJ+uikiZcrTyh
	 Ej4P9kmreibTSTLerjdGokH03Bf+zSdq0bK/7vq9ZmfNw9TqjZgKZlzlVeyosKpLKj
	 tsJwF+5C700BfJCzL4Jj/YL8gaGJubGp+cSs+QAY3Dhf3cXilDqxZ91oecoB4BXxez
	 qBcCk9WST7H9kWuRFkhogHGjGjoVrdgmoDcWGcfW8PjMffjyIp/tRLyMId8ypMPlOP
	 RN5h9QlACoPhQ==
Date: Tue, 20 May 2025 10:04:49 -0400
From: Sasha Levin <sashal@kernel.org>
To: =?utf-8?Q?Micha=C5=82?= Pecio <michal.pecio@gmail.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Jonathan Bell <jonathan@raspberrypi.org>,
	Oliver Neukum <oneukum@suse.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	mathias.nyman@intel.com, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.14 08/15] usb: xhci: Don't trust the EP Context
 cycle bit when moving HW dequeue
Message-ID: <aCyMAdNzTPgS0urL@lappy>
References: <20250512180352.437356-1-sashal@kernel.org>
 <20250512180352.437356-8-sashal@kernel.org>
 <20250512231628.7f91f435@foxbook>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250512231628.7f91f435@foxbook>

On Mon, May 12, 2025 at 11:16:28PM +0200, Michał Pecio wrote:
>On Mon, 12 May 2025 14:03:43 -0400, Sasha Levin wrote:
>> From: Michal Pecio <michal.pecio@gmail.com>
>>
>> [ Upstream commit 6328bdc988d23201c700e1e7e04eb05a1149ac1e ]
>>
>> VIA VL805 doesn't bother updating the EP Context cycle bit when the
>> endpoint halts. This is seen by patching xhci_move_dequeue_past_td()
>> to print the cycle bits of the EP Context and the TRB at hw_dequeue
>> and then disconnecting a flash drive while reading it. Actual cycle
>> state is random as expected, but the EP Context bit is always 1.
>>
>> This means that the cycle state produced by this function is wrong
>> half the time, and then the endpoint stops working.
>>
>> Work around it by looking at the cycle bit of TD's end_trb instead
>> of believing the Endpoint or Stream Context. Specifically:
>>
>> - rename cycle_found to hw_dequeue_found to avoid confusion
>> - initialize new_cycle from td->end_trb instead of hw_dequeue
>> - switch new_cycle toggling to happen after end_trb is found
>>
>> Now a workload which regularly stalls the device works normally for
>> a few hours and clearly demonstrates the HW bug - the EP Context bit
>> is not updated in a new cycle until Set TR Dequeue overwrites it:
>>
>> [  +0,000298] sd 10:0:0:0: [sdc] Attached SCSI disk
>> [  +0,011758] cycle bits: TRB 1 EP Ctx 1
>> [  +5,947138] cycle bits: TRB 1 EP Ctx 1
>> [  +0,065731] cycle bits: TRB 0 EP Ctx 1
>> [  +0,064022] cycle bits: TRB 0 EP Ctx 0
>> [  +0,063297] cycle bits: TRB 0 EP Ctx 0
>> [  +0,069823] cycle bits: TRB 0 EP Ctx 0
>> [  +0,063390] cycle bits: TRB 1 EP Ctx 0
>> [  +0,063064] cycle bits: TRB 1 EP Ctx 1
>> [  +0,062293] cycle bits: TRB 1 EP Ctx 1
>> [  +0,066087] cycle bits: TRB 0 EP Ctx 1
>> [  +0,063636] cycle bits: TRB 0 EP Ctx 0
>> [  +0,066360] cycle bits: TRB 0 EP Ctx 0
>>
>> Also tested on the buggy ASM1042 which moves EP Context dequeue to
>> the next TRB after errors, one problem case addressed by the rework
>> that implemented this loop. In this case hw_dequeue can be enqueue,
>> so simply picking the cycle bit of TRB at hw_dequeue wouldn't work.
>>
>> Commit 5255660b208a ("xhci: add quirk for host controllers that
>> don't update endpoint DCS") tried to solve the stale cycle problem,
>> but it was more complex and got reverted due to a reported issue.
>>
>> Cc: Jonathan Bell <jonathan@raspberrypi.org>
>> Cc: Oliver Neukum <oneukum@suse.com>
>> Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
>> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
>> Link: https://lore.kernel.org/r/20250505125630.561699-2-mathias.nyman@linux.intel.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>Hi,
>
>This wasn't tagged for stable because the function may potentially
>still be affected by some unforeseen HW bugs, and previous attempt
>at fixing the issue ran into trouble and nobody truly knows why.
>
>The problem is very old and not critically severe, so I think this
>can wait till 6.15. People don't like minor release regressions.

I'll drop it, thanks!

-- 
Thanks,
Sasha
