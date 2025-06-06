Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA25213E7A;
	Fri,  6 Jun 2025 12:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749213153; cv=none; b=tjB3eP/VMfuJWXzedi4oI5xc4GG3T6Bbfha3sXnNf+dvf/HPmXRb5cQzisxnL1tpx5H58UfaoWGbPJfcsMXuy+nPxFk7RnLDpVAUoHhCPtSHDWcVWcV+6MxUq3QQ4GCi16DYgnQzSD+0cIRIa0wFLTQ3vs/cLbBCd3WVF2RFhnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749213153; c=relaxed/simple;
	bh=PNTM9e0vJhXMOaOlrgN0eJ6RCfLv95PaA3skUkIbaLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XXB2/1A+HjWZA7YoSf1Vp5yhtpJ5yLFFe+bLAnh8N/hBXbGBhwjJR7jP/RoFkAKwlTatxFhfTSdUT1G0tCbSO2r9+h0UvrTx50VSKU80W9TZMNE4r4sOBZE4nkdX8Gz3X1WvIe4mwMUb36aTpLSedv8laboqfFKaffiGj/wdd3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CVqrVVfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CVqrVVfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C81C4CEEB;
	Fri,  6 Jun 2025 12:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749213152;
	bh=PNTM9e0vJhXMOaOlrgN0eJ6RCfLv95PaA3skUkIbaLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVqrVVfCo5lRiWF/yTc2KkGAnzUBdKUnY/E0/uW2KsVM1DKeNmhvjEqjiqkxGW9EO
	 Ay99FjxewkAYgK40NjjTR5n2+evtmC7r+Pd/HGxRYLe1j34CKxqjlsr7ypagSdgG3X
	 TLw2f454o9jv4gkToaKATOa2HaHruKzwwRiF2x4uxXTq7VBC4xILTzMVaSrINchezR
	 DO1C0g018cudAnGU3QMQBArJAG3zT7hXVsBSSL/gNpDBA65d+UfTB5eupOvXFVkuJV
	 ge6Qr5dEnHDgyl3lWRpRKKr93No5GNHpwXn11OeOcebCrxQB1dbOEMd1qf+z+oPMl1
	 /dAdq5qYRMKfQ==
Received: from johan by xi.lan with local (Exim 4.97.1)
	(envelope-from <johan@kernel.org>)
	id 1uNWFJ-0000000071Z-0Iw3;
	Fri, 06 Jun 2025 14:32:29 +0200
Date: Fri, 6 Jun 2025 14:32:29 +0200
From: Johan Hovold <johan@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>, matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Subject: Re: [PATCH AUTOSEL 6.15 092/110] genirq: Retain disable depth for
 managed interrupts across CPU hotplug
Message-ID: <aELf3QmuEJOlR7Dv@hovoldconsulting.com>
References: <20250601232435.3507697-1-sashal@kernel.org>
 <20250601232435.3507697-92-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250601232435.3507697-92-sashal@kernel.org>

On Sun, Jun 01, 2025 at 07:24:14PM -0400, Sasha Levin wrote:
> From: Brian Norris <briannorris@chromium.org>
> 
> [ Upstream commit 788019eb559fd0b365f501467ceafce540e377cc ]
> 
> Affinity-managed interrupts can be shut down and restarted during CPU
> hotunplug/plug. Thereby the interrupt may be left in an unexpected state.
> Specifically:
> 
>  1. Interrupt is affine to CPU N
>  2. disable_irq() -> depth is 1
>  3. CPU N goes offline
>  4. irq_shutdown() -> depth is set to 1 (again)
>  5. CPU N goes online
>  6. irq_startup() -> depth is set to 0 (BUG! driver expects that the interrupt
>     		     	      	        still disabled)
>  7. enable_irq() -> depth underflow / unbalanced enable_irq() warning
> 
> This is only a problem for managed interrupts and CPU hotplug, all other
> cases like request()/free()/request() truly needs to reset a possibly stale
> disable depth value.
> 
> Provide a startup function, which takes the disable depth into account, and
> invoked it for the managed interrupts in the CPU hotplug path.
> 
> This requires to change irq_shutdown() to do a depth increment instead of
> setting it to 1, which allows to retain the disable depth, but is harmless
> for the other code paths using irq_startup(), which will still reset the
> disable depth unconditionally to keep the original correct behaviour.
> 
> A kunit tests will be added separately to cover some of these aspects.
> 
> [ tglx: Massaged changelog ]
> 
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Link: https://lore.kernel.org/all/20250514201353.3481400-2-briannorris@chromium.org
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This one breaks suspend of laptops like the Lenovo ThinkPad T14s. Issue
was just reported here by Alex:

	https://lore.kernel.org/lkml/24ec4adc-7c80-49e9-93ee-19908a97ab84@gmail.com/

Please drop from all stable queues for now.

Johan
