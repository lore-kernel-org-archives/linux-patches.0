Received: from mail.tipi-net.de (mail.tipi-net.de [194.13.80.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59EF3955FE
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 10:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.13.80.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790246193; cv=none; b=TPX3oy5FT0jQwDJqKYbq51O1sN5kG24ovDyKF2zWalwyCeo89BNteyB4T5Q2iay6iInuV4Fveb+SoNdYio91aZ10EUg7bwvcBsgq/gVGgxN56DOCVLNNpgdWjeudrDS53PTmobDpUy4J8vnfZ5jQ990dJPxAlxGx2RvTequiOaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790246193; c=relaxed/simple;
	bh=NTeYQLsuf98Ic3vI+zEEghNcv6SNhi342hDMhrvnO4g=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=DwIwNXD2ptynStcp7y7eePreahauXAmaP3jeObnlo/MsZd6aLpNCS6fi5ESQSK4IBPaSvaj7WLMpO0FVaKbDsf1Zcoy45qraePp/HiSrYE4YRdzQu2DOkriS+bTnMCneftX0MdvfDy4X/o+iJfw0iFV6RjEMru7BdCs82tWngzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de; spf=pass smtp.mailfrom=tipi-net.de; dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b=scddT6GJ; arc=none smtp.client-ip=194.13.80.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tipi-net.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tipi-net.de header.i=@tipi-net.de header.b="scddT6GJ"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 8604FA4AAD;
	Thu, 24 Sep 2026 12:36:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tipi-net.de; s=dkim;
	t=1790246184; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=2ZlSsKFn6BuIGCgoF7TU+8VkNgBvyDMHIwsMO9aG6gQ=;
	b=scddT6GJVjBZAIf1mFOosImNGjmP9+wbEFrmrr6jbmNa9ySQIFJGUGvYDbJ8qePY14mpKp
	nrCzUgAM2PzceqQfu/wYHumgg1gxFWWvbrVAgVpCQ8F/Eg1+PzBynIrkmFGQbuRWIYNqHR
	npIwtTdepB56Jl/RGmidi8mq24xPY8B1aeUQPMg0kd6WUEJ6psLclDpOeD2QlQ4b0mTf1E
	/rYDIZ6//9RT3e2+hCHVY7iy+NDIPPbDhGo7Ba9o75o7LAkCftqzpf5VHaDJOsLLX5ycg7
	AoBG9OkfZqBSw0/pJr7iXCad1vqAA4427DfKvYhuDLZBBL7qtBVKhRd6xU6aIw==
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 24 Sep 2026 12:36:23 +0200
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
Message-ID: <222228376db00a8aa7a4bcab1b5659bc@tipi-net.de>
X-Sender: nb@tipi-net.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Last-TLS-Session-Version: TLSv1.3

Hi Greg, hi Karl

On 24.9.2026 09:28, Greg Kroah-Hartman wrote:
> On Thu, Sep 24, 2026 at 08:58:39AM +0200, Karl Mehltretter wrote:

> [...]

>> I would appreciate the BCMGENET maintainers' view on whether this 
>> page-pool
>> conversion is appropriate for 6.18.y.

I would rather have the page_pool conversion in 6.18.y. More fixes will
land on top of it, and carrying it is less work than adapting each of
them. The fix for the regression applies on top of it unchanged.

>> Please consider omitting patch 129 from 6.18.y and applying that 
>> adapted
>> version of patch 130 directly.
> 
> But when you update to a newer release, that memory increase will
> happen, right?  So why not fix the root problem upstream first?

The fix is on netdev, "net: bcmgenet: allocate RX buffers as page
fragments", with a Fixes tag for 7bc054c2d4ed:

   https://lore.kernel.org/netdev/20260924101922.2675127-1-nb@tipi-net.de

I was able to reproduce Karl's numbers on a CM4 with a 64 KiB page 
kernel
and fortunately the fix was straightforward.

> [...]

Regards
Nicolai
