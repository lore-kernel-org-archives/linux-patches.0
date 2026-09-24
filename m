Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C30F35BDC2
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 08:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790237459; cv=none; b=galczov+52g50qRlMrI0V0vb3ccj17mMAdqi2zjOAfS+mQZ5Ed+vZ6EHacMOLz1b5Xk7ZOmYSJWK0796NK7YkX1yH9PWqoMN/623hWkyxac69tiuPuVL+b5/jZXvgG7sutuRG7BCTwJ8UFOUE4+47xz8Gw9kdVso7Swkz1mCroY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790237459; c=relaxed/simple;
	bh=M9DLzBsC/kmPzotkCWu7Vfezv+7isEBbZYFAMOMtkSM=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=gc4s9zzy9vXxYVTxrC+St4kD/VBc6tL6LNKr7Hp2InadF8Y2ZALYIIRFuKwvQD4BZ3Llpky9vJoAaRE87XGfCwIjzxGMUn+5tKCY2Gn/3W4H3WbShFx/Hm1j9NcCVsPstX2moDkkavwH5KHvwHnMyqRVNrZ/uLozVZ6IlBUpwHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=nMYTjKBD; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="nMYTjKBD"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0C4C8A4AAD;
	Thu, 24 Sep 2026 10:10:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1790237451; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=03E15lf2Odsx2dSXpnaC4f3m1J1FQ7fdkgcJqb90RfY=;
	b=nMYTjKBDyOfdRV6ddfWdetJBJjtb4vb+oFsonA4EiMHmLKH4wxpNncaLHPTFWabz/mKSA1
	6Gn+20PNSWplZue4LBswZJfBm9blin9frMcrfdNnlivlxQC7ijC7ZhVkrOYLmc0Rr483iW
	qIN90cjpEEqCua9Y78iND4zYx3o5l6cWyosn9w53I8lj0dcx4TgO92eNIa0rjXgq60B92V
	vLZ86FBZ8p9fhOeqZfkfyl5bAcHgBXrKxfPB0eF7nUEVjN8qO4RTpelfJg7jDnUXuHaAtX
	WGzpM8RiCIZK2xfULwnziB5jSrrvvt5KFgjvANFXLNuJmFr7+qTl0I5r24zHTg==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 10:10:49 +0200
From: Nicolai Buchwitz <nb@tipi-net.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, stable@vger.kernel.org,
 patches@lists.linux.dev, Justin Chen <justin.chen@broadcom.com>, Doug Berger
 <opendmb@gmail.com>, Florian Fainelli <florian.fainelli@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, netdev@vger.kernel.org, Jakub
 Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 129/398] net: bcmgenet: convert RX path to page_pool
In-Reply-To: <2026092430-contently-pungent-f0cc@gregkh>
References: <20260923140643.441954610@linuxfoundation.org>
 <20260923140646.783275824@linuxfoundation.org>
 <20260924065839.56793-1-kmehltretter@gmail.com>
 <2026092430-contently-pungent-f0cc@gregkh>
Message-ID: <ecf28c4f181b2fcb3b15e27daac07c9a@tipi-net.de>
X-Sender: nb@tipi-net.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Greg

On 24.9.2026 09:28, Greg Kroah-Hartman wrote:
> On Thu, Sep 24, 2026 at 08:58:39AM +0200, Karl Mehltretter wrote:
>> I have a small objection to taking patch 129 into 6.18.y only as a
>> dependency for patch 130.
>> 
>> My LLM agent helped me running these tests.
>> 
>> On a 64 KiB arm64 kernel in a custom QEMU Pi 400 model with functional
>> GENET v5 DMA, patch 129 increased the socket receive-memory charge per
>> 512-byte UDP datagram from 2,752 to 65,792 bytes.
>> 
>> With the same 512 KiB socket receive-buffer limit, this reduced the 
>> number
>> of queued datagrams from 190 to 7 and increased socket receive-buffer 
>> drops
>> from 810 to 993 per 1,000 datagrams. I obtained the same result in 
>> five
>> bursts.
>> 
>> The page-pool conversion otherwise worked in this test, and physical 
>> Pi 400
>> testing with 4 KiB pages found no correctness failure. However, patch 
>> 130
>> was also verified on the Pi 400 to work without patch 129 after a 
>> small
>> contextual adaptation.
>> 
>> I would appreciate the BCMGENET maintainers' view on whether this 
>> page-pool
>> conversion is appropriate for 6.18.y.
>> 
>> Please consider omitting patch 129 from 6.18.y and applying that 
>> adapted
>> version of patch 130 directly.
> 
> But when you update to a newer release, that memory increase will
> happen, right?  So why not fix the root problem upstream first?

Agree. I will have a look at Karl's regression report and probably sent
patches via netdev with cc stable.

> [...]

Regards
Nicolai
