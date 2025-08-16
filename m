Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D05123ABA8;
	Sat, 16 Aug 2025 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755349783; cv=none; b=gXFZUpCCWnEz8IophaQk6D6tFEaImVOws2V+ogzieiY09SvdE6PXUwqi59yeam6r8pLYMov5udSIzlrjdeoACQmSykGobU61jVkPCQHoFnBgRKVCigZgDApjoV3O6DByAbFd2bdKI1hkP97LpFyiI+dWYChQrv8ukcyEtK2i7qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755349783; c=relaxed/simple;
	bh=RXm2Vt0T9jqt6AGzgaAol55AR4+xfBGD75KcrLl6ly0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0Gbf75chaTxZLfiwUIX0UZKxDYyAqFEpRnNsfHHYKW2ytY1iK/j0eCo/YfVXJyo2TTy4AjDuibOmR9rJLt8uRwjLiQFWS/zGeo2Xef6cSYz5a8y9xvcxB87iRWLXKKPxi2SQebMtp88UxydsMKsqRQcQBWLxVlVNA+AZbexbMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEtarw52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEtarw52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C108BC4CEF1;
	Sat, 16 Aug 2025 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755349782;
	bh=RXm2Vt0T9jqt6AGzgaAol55AR4+xfBGD75KcrLl6ly0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SEtarw52WizcAsKlRyLgdsW7aIqFDzDVT79bFKmO1GwC/P8qvTTK1SGFWpN0U6TZJ
	 cs6EeHunLXJcI3oB3qVuZ7B4Mh8xKamkCgYs35wBCMKaWsDJC0KspBnb2XOkggSTSs
	 HDtGD9E+X4cD9bdcfOeg/52Hc8M27w0EPHT9vxrseoRDJ3jtL9tsfe2+q8+nGT1n9q
	 /Locfdv1tJWL7TIZ/yGf7TJ+WDqLg8NO1cpjnMMvDEUzFakMu+Qxwdttf797MbAi5Q
	 dybmweHpvAt31u+mqgFVRY7zgbcbcOpSAT4AvCQL2+GDmWVKLT1why3O/NqjzX5sEG
	 g+L5azbj3N/cQ==
Date: Sat, 16 Aug 2025 09:09:40 -0400
From: Sasha Levin <sashal@kernel.org>
To: Sebastian Reichel <sebastian.reichel@collabora.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Yongbo Zhang <giraffesnn123@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	krzysztof.kozlowski@linaro.org, Hans de Goede <hansg@kernel.org>
Subject: Re: [PATCH AUTOSEL 6.16 73/85] usb: typec: fusb302: fix scheduling
 while atomic when using virtio-gpio
Message-ID: <aKCDFPz7g1vVJ9nw@lappy>
References: <20250804002335.3613254-1-sashal@kernel.org>
 <20250804002335.3613254-73-sashal@kernel.org>
 <3m7xyylzbchxe6jtblcat6gq4nqam5ifq65wzrq3kknz6yqyfe@atyst565drka>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3m7xyylzbchxe6jtblcat6gq4nqam5ifq65wzrq3kknz6yqyfe@atyst565drka>

On Mon, Aug 04, 2025 at 08:07:27PM +0200, Sebastian Reichel wrote:
>Hello Sasha,
>
>On Sun, Aug 03, 2025 at 08:23:22PM -0400, Sasha Levin wrote:
>> From: Yongbo Zhang <giraffesnn123@gmail.com>
>>
>> [ Upstream commit 1c2d81bded1993bb2c7125a911db63612cdc8d40 ]
>>
>> When the gpio irqchip connected to a slow bus(e.g., i2c bus or virtio
>> bus), calling disable_irq_nosync() in top-half ISR handler will trigger
>> the following kernel BUG:
>>
>> BUG: scheduling while atomic: RenderEngine/253/0x00010002
>> ...
>> Call trace:
>>  dump_backtrace+0x0/0x1c8
>>  show_stack+0x1c/0x2c
>>  dump_stack_lvl+0xdc/0x12c
>>  dump_stack+0x1c/0x64
>>  __schedule_bug+0x64/0x80
>>  schedule_debug+0x98/0x118
>>  __schedule+0x68/0x704
>>  schedule+0xa0/0xe8
>>  schedule_timeout+0x38/0x124
>>  wait_for_common+0xa4/0x134
>>  wait_for_completion+0x1c/0x2c
>>  _virtio_gpio_req+0xf8/0x198
>>  virtio_gpio_irq_bus_sync_unlock+0x94/0xf0
>>  __irq_put_desc_unlock+0x50/0x54
>>  disable_irq_nosync+0x64/0x94
>>  fusb302_irq_intn+0x24/0x84
>>  __handle_irq_event_percpu+0x84/0x278
>>  handle_irq_event+0x64/0x14c
>>  handle_level_irq+0x134/0x1d4
>>  generic_handle_domain_irq+0x40/0x68
>>  virtio_gpio_event_vq+0xb0/0x130
>>  vring_interrupt+0x7c/0x90
>>  vm_interrupt+0x88/0xd8
>>  __handle_irq_event_percpu+0x84/0x278
>>  handle_irq_event+0x64/0x14c
>>  handle_fasteoi_irq+0x110/0x210
>>  __handle_domain_irq+0x80/0xd0
>>  gic_handle_irq+0x78/0x154
>>  el0_irq_naked+0x60/0x6c
>>
>> This patch replaces request_irq() with devm_request_threaded_irq() to
>> avoid the use of disable_irq_nosync().
>>
>> Signed-off-by: Yongbo Zhang <giraffesnn123@gmail.com>
>> Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>> Link: https://lore.kernel.org/r/20250526043433.673097-1-giraffesnn123@gmail.com
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>
>I suggest to wait wait a bit with backporting this commit until the
>discussion I just started has been resolved (also applies to all the
>other stable kernel releases you included this patch for):
>
>https://lore.kernel.org/linux-usb/m7n22g5fsfvpjz4s5d6zfcfddrzrj3ixgaqehrjkg7mcbufvjc@s4omshvxtkaf/

I'll drop it, thanks!


-- 
Thanks,
Sasha
