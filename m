Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D145A25A2CE;
	Wed, 19 Feb 2025 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740000968; cv=none; b=SyghCiFYcYp4QMUnjPkTLZvaDvSYRx/Igsj7KaxediJfFcbWXH+aI1ZdP4plSgQViJe6bX0Def3FqiH+APwdMVU9y4kt18DJ41Wd2YoozfJhEVmHefEltLgOsarmSZFLIn47rlHVPNvBz5VPmUCexMTdwJAdvhhXUSo1+hpIkt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740000968; c=relaxed/simple;
	bh=H8cW+KqFza/9wuv7O8fJzMx0LlSrfigkACT10J58gp0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ItVvNDK6AkQ8AEAtmQg7It6KAim0EnksC0LRCc+2HAFbMXIG/M5caih+2c7LSaz5CIER/a9/9TrDkYhMnnzRFRfIkVffmWholHMbUlq5pQgrw6L0fbdSTiO+7WD9Kr6WvSPLA+Dn4H4zj9P9SNenjV+4qeWzHt6q1Rp5r9OBmRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T4oki23B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T4oki23B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D845C4CEEC;
	Wed, 19 Feb 2025 21:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740000968;
	bh=H8cW+KqFza/9wuv7O8fJzMx0LlSrfigkACT10J58gp0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T4oki23BOklJRKQRrSsBaXrq37NWTBXHfc2eQZ8rbrtekenigDrNgwdtQv8fa5lQ6
	 8Uqj41b6Qwb7u5iG0a//FcJ6gtmgp56YOAK8oUfVgFaX/PSwvRAs/x8a+RZB/ERbGx
	 U/PR9GcbTvnR2xd38uEIapiTTYgDghyJ/4aCxjWa3EauahKmyLI4QRtUEeED/TByYg
	 ys9Duj3bl7KmnJ4CWUi3uGwGWe6xgx2bEcvgG51rxyUuU5NaxoMLIJ6T9kOQBsACXQ
	 9gC9+mZXLqwYhTK/xFMPRUserlgFWiCyp8/ux31cjah/yzmv8z5GT38ajPCPp9Xo+M
	 iCuFWMZWQzhsg==
Date: Wed, 19 Feb 2025 13:36:07 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Sasha Levin
 <sashal@kernel.org>
Subject: Re: [PATCH 6.13 235/274] Revert "net: skb: introduce and use a
 single page frag cache"
Message-ID: <20250219133607.03a5add6@kernel.org>
In-Reply-To: <20250219082618.775483707@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
	<20250219082618.775483707@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 19 Feb 2025 09:28:09 +0100 Greg Kroah-Hartman wrote:
> 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Paolo Abeni <pabeni@redhat.com>
> 
> [ Upstream commit 011b0335903832facca86cd8ed05d7d8d94c9c76 ]
> 
> This reverts commit dbae2b062824 ("net: skb: introduce and use a single
> page frag cache"). The intended goal of such change was to counter a
> performance regression introduced by commit 3226b158e67c ("net: avoid
> 32 x truesize under-estimation for tiny skbs").
> 
> Unfortunately, the blamed commit introduces another regression for the
> virtio_net driver. Such a driver calls napi_alloc_skb() with a tiny
> size, so that the whole head frag could fit a 512-byte block.
> 
> The single page frag cache uses a 1K fragment for such allocation, and
> the additional overhead, under small UDP packets flood, makes the page
> allocator a bottleneck.
> 
> Thanks to commit bf9f1baa279f ("net: add dedicated kmem_cache for
> typical/small skb->head"), this revert does not re-introduce the
> original regression. Actually, in the relevant test on top of this
> revert, I measure a small but noticeable positive delta, just above
> noise level.
> 
> The revert itself required some additional mangling due to the
> introduction of the SKB_HEAD_ALIGN() helper and local lock infra in the
> affected code.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Fixes: dbae2b062824 ("net: skb: introduce and use a single page frag cache")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Link: https://patch.msgid.link/e649212fde9f0fdee23909ca0d14158d32bb7425.1738877290.git.pabeni@redhat.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

As already pointed out this was reverted
