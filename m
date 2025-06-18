Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F1E16A95B;
	Wed, 18 Jun 2025 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750259513; cv=none; b=KSmpi3xmTVZvLyhVJSLyD9ZR74tabGKyGvnA1ry/C22lWXU8ibo10hgjMShbwFFU3DG9uc88SvKBY8IOFo23sh7J+vG5cYHHDDrHKhzLUHcgSiTGXpI9IZB6l2VsCDJdcgh9V+fVuYPxA+iGNgO+/ZCDjNSgp113J2nsXUpbdZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750259513; c=relaxed/simple;
	bh=Wzjwsii8yfmolxkQkAgPYhRM7Z6/qgUkeAnXTcoCpI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ggNCdubnmBuviq1elUQcBv6lPdOiGo8Qd3mOJhmYpdY05Aea/DIULvqzZJK/rxE9EqlVXRx8xSnHFvAiP2lbRVFTYRn+CtAMOHbXCa6DnMKJkxGq/JGSTtFSg084SZWflnQTzpoU02FE7EujhhnMIDFcNA+vF6LxhKpUHYf2o50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lt1GhWFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lt1GhWFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B024C4CEF0;
	Wed, 18 Jun 2025 15:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750259513;
	bh=Wzjwsii8yfmolxkQkAgPYhRM7Z6/qgUkeAnXTcoCpI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lt1GhWFdXGvw/76cv1ejyxtlWvo27KOCHf7dFV6dHavnMPdRL4A/VL1rB5aOiplVh
	 dLY7uNPH/1/fdcngFvNd8+pdFr6c9+mKgxsvKjJ8rvjJeMkcUe49vyEQ9EP5KAv7gW
	 sCtbdbiPHGCdMRnb9TLNI5n94cjLq9YSD64VZYnF4tK/lr2VjwBCPJ4wVBl/vF3Xph
	 oOktN++khB2MAHlHz2BMV9LPHJOSHPOYgVfrk14Hj7APsG3qzBh8MTKpx7xRXkDIYk
	 SwAhiSwGAGRccJtMIoRPKEjzJ0kpuvi128kKL9YlpASiEFmZjNz6VycDMJvrmcV5Fs
	 qxrJr5FvyHVdw==
Date: Wed, 18 Jun 2025 11:11:51 -0400
From: Sasha Levin <sashal@kernel.org>
To: Johan Hovold <johan@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Subject: Re: [PATCH AUTOSEL 6.15 092/110] genirq: Retain disable depth for
 managed interrupts across CPU hotplug
Message-ID: <aFLXN5Rbx_egQBeB@lappy>
References: <20250601232435.3507697-1-sashal@kernel.org>
 <20250601232435.3507697-92-sashal@kernel.org>
 <aELf3QmuEJOlR7Dv@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <aELf3QmuEJOlR7Dv@hovoldconsulting.com>

On Fri, Jun 06, 2025 at 02:32:29PM +0200, Johan Hovold wrote:
>On Sun, Jun 01, 2025 at 07:24:14PM -0400, Sasha Levin wrote:
>> From: Brian Norris <briannorris@chromium.org>
>>
>> [ Upstream commit 788019eb559fd0b365f501467ceafce540e377cc ]
>>
>> Affinity-managed interrupts can be shut down and restarted during CPU
>> hotunplug/plug. Thereby the interrupt may be left in an unexpected state.
>> Specifically:
>>
>>  1. Interrupt is affine to CPU N
>>  2. disable_irq() -> depth is 1
>>  3. CPU N goes offline
>>  4. irq_shutdown() -> depth is set to 1 (again)
>>  5. CPU N goes online
>>  6. irq_startup() -> depth is set to 0 (BUG! driver expects that the interrupt
>>     		     	      	        still disabled)
>>  7. enable_irq() -> depth underflow / unbalanced enable_irq() warning
>>
>> This is only a problem for managed interrupts and CPU hotplug, all other
>> cases like request()/free()/request() truly needs to reset a possibly stale
>> disable depth value.
>>
>> Provide a startup function, which takes the disable depth into account, and
>> invoked it for the managed interrupts in the CPU hotplug path.
>>
>> This requires to change irq_shutdown() to do a depth increment instead of
>> setting it to 1, which allows to retain the disable depth, but is harmless
>> for the other code paths using irq_startup(), which will still reset the
>> disable depth unconditionally to keep the original correct behaviour.
>>
>> A kunit tests will be added separately to cover some of these aspects.
>>
>> [ tglx: Massaged changelog ]
>>
>> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: Brian Norris <briannorris@chromium.org>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> Link: https://lore.kernel.org/all/20250514201353.3481400-2-briannorris@chromium.org
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This one breaks suspend of laptops like the Lenovo ThinkPad T14s. Issue
>was just reported here by Alex:
>
>	https://lore.kernel.org/lkml/24ec4adc-7c80-49e9-93ee-19908a97ab84@gmail.com/
>
>Please drop from all stable queues for now.

Will do, thanks!

-- 
Thanks,
Sasha
