Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B75422FDEA;
	Wed, 19 Feb 2025 21:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000939; cv=none; b=bEgYf4Tuq1WHVj88NZM8lsoY4s7FiQQqBJoOcHi57c/Qlnnbbz/LjejaWeLULOGwqsI1O4i0rup7rURacfwZ7MGCakEM/NsTnRmDwgUI7QCWSoj8ehW1guYz9GZpyrPOrNmb/+9CoEoT7DxvFE7xSYE46QOPn6mJjSg68Cz4b7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000939; c=relaxed/simple;
	bh=pjuj759a3WgH2woUkH0w7vXKDi28DXpEcEhZ4ffRUj0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOjIFvB6C8h5JOFE4tgE6hCwJklEpfh8jq/aepv6FHJskaqaM9CVD9W05Xy1vj5ONPizDQmmnvW9JoUySV06Q1F4cOquUupza1eSboRt5Sr9PTiKpoIKQ5g9M7cFI5H3luC2mJ8exYrFK8ruEpJKBmd9RqQdnD+8x8/ca63L68Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNXwZGW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNXwZGW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629D8C4CED1;
	Wed, 19 Feb 2025 21:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740000938;
	bh=pjuj759a3WgH2woUkH0w7vXKDi28DXpEcEhZ4ffRUj0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mNXwZGW+OoeYsv23nMUSz1kTTyRdbnSXSBiCOVhEKiK/7hZWXt5zUWkAivMPTnuN7
	 GDEkZBmPUuBCAoYRVztf53MtiBNklLDB6rpSJpV3ViMVhjIgUnuj8t4+z+c/OHtTAD
	 Vhf/DFsyz8QELE4atmcZQL40ESDY0vKh26VDdjufyr4IRiy2xojGoJO4wz+lMuNCcG
	 gxcUmlVh2J/uZjnxjzDENDcuoChDTnBWIVrlNR+/tNsVBjvFY9VVVggcbwh5hh3usv
	 BBEBLYyi5ny7FMtkJ5AA73ESTMmJMtFvkg3bRNKJSytgxYph+A5bKFcBP5uaSL/iPH
	 HpkLlB2w39/6w==
Date: Wed, 19 Feb 2025 13:35:37 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Joe Damato
 <jdamato@fastly.com>, Eric Dumazet <edumazet@google.com>, Kuniyuki Iwashima
 <kuniyu@amazon.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.13 232/274] net: make netdev_lock() protect
 netdev->reg_state
Message-ID: <20250219133537.65353d29@kernel.org>
In-Reply-To: <20250219082618.659985699@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
	<20250219082618.659985699@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:28:06 +0100 Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 5fda3f35349b6b7f22f5f5095a3821261d515075 ]
> 
> Protect writes to netdev->reg_state with netdev_lock().
> >From now on holding netdev_lock() is sufficient to prevent  
> the net_device from getting unregistered, so code which
> wants to hold just a single netdev around no longer needs
> to hold rtnl_lock.
> 
> We do not protect the NETREG_UNREGISTERED -> NETREG_RELEASED
> transition. We'd need to move mutex_destroy(netdev->lock)
> to .release, but the real reason is that trying to stop
> the unregistration process mid-way would be unsafe / crazy.
> Taking references on such devices is not safe, either.
> So the intended semantics are to lock REGISTERED devices.
> 
> Reviewed-by: Joe Damato <jdamato@fastly.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Link: https://patch.msgid.link/20250115035319.559603-3-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: 011b03359038 ("Revert "net: skb: introduce and use a single page frag cache"")
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop from all branches
