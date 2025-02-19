Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D192586FF;
	Wed, 19 Feb 2025 21:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000946; cv=none; b=YtZNnCyXWaU4w5b+NM2L47AC0pIsm8YflMJbI0+ZOdeYjNIo0aDsIKs56CfdzCenu+Mfd3qeRTDJ+7o8Yt1NcSeqWJ5niaysSYE85KO/poHnF5wxQxNcRU56BDtpTtOuH7xh9h0NV8mbmLRtQ/ZqtzQvd2bfyxAZxvf97DmVst4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000946; c=relaxed/simple;
	bh=7C9BEP6U2zRFLQpRp50+wSeN3pw3cG+SdQl/AqbfcO0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KfBMzy6xvAVJa/OFp9pLeT3tcey7eFfV/BYtFn9VghsI9vyBLqBTbGkEYroYs7gjse4bLBj4X67/dDM4D4cWOkeV0lcv9F+To3O59A/Q39oXbttnn7D7p1Ew4StM7y+Pi3aRnFt5p25Rz3dZJuu69c4CLpusN9A9hcCf3A5NXjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxJ8sjm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxJ8sjm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD32CC4CED1;
	Wed, 19 Feb 2025 21:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740000946;
	bh=7C9BEP6U2zRFLQpRp50+wSeN3pw3cG+SdQl/AqbfcO0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UxJ8sjm927AC5nCVPqT4eD5hldn8oYTw/4AcBuC7Vz+AteeNRkr0Ue6jWfLaeEnrZ
	 o+ahWg1aExuQ2i1xhxH6iskEZwr14DtJzn8+eHhjO6Dott34um5wDUuwF6DH75Poek
	 y22G48qvNspbKqoEHSQQUUBKVvIMZsD+iSMhsBPRmbAPtt8KImgOBM/QZhUXHoCy45
	 aedf1hPgy2iwqtIr1uHPkhXeo6AABOa/+REohJeA5Rkc6ux9adQdHxVDsDh5HcVMs4
	 g6TLS5Mck6u3tg+VTzTaHvUv7iOk+c4tK/qeAVgqrcjaDRuihIoTJlF8jGMsaz7aXk
	 V/+vrgOF6jdsw==
Date: Wed, 19 Feb 2025 13:35:45 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Joe Damato
 <jdamato@fastly.com>, Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 233/274] net: add netdev->up protected by
 netdev_lock()
Message-ID: <20250219133545.489a4141@kernel.org>
In-Reply-To: <20250219082618.698868926@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
	<20250219082618.698868926@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:28:07 +0100 Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 5112457f3d8e41f987908266068af88ef9f3ab78 ]
> 
> Some uAPI (netdev netlink) hide net_device's sub-objects while
> the interface is down to ensure uniform behavior across drivers.
> To remove the rtnl_lock dependency from those uAPIs we need a way
> to safely tell if the device is down or up.
> 
> Add an indication of whether device is open or closed, protected
> by netdev->lock. The semantics are the same as IFF_UP, but taking
> netdev_lock around every write to ->flags would be a lot of code
> churn.
> 
> We don't want to blanket the entire open / close path by netdev_lock,
> because it will prevent us from applying it to specific structures -
> core helpers won't be able to take that lock from any function
> called by the drivers on open/close paths.
> 
> So the state of the flag is "pessimistic", as in it may report false
> negatives, but never false positives.
> 
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Link: https://patch.msgid.link/20250115035319.559603-5-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

please drop
