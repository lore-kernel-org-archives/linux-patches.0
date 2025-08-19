Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F91DF74F;
	Tue, 19 Aug 2025 12:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755605752; cv=none; b=ep0tpn2J1kU8kXF8qaRgiRAV20ADSwrXDcz17jsOZnZOp3rB/QvNyD5cDbyxhbND/1QaQD+vKSxaZEeSQdxWv8dnGUpjZEmiRMj/CCury1l5t4nZR+XD4Cc/4Q5RQwrmt9iqWDTs6kdApfP2snVBp6/v9WnzAWuaJf4J59kfIq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755605752; c=relaxed/simple;
	bh=zS1BlQyIl02rXzTpMGL+bn7rhhFP+gwL/hpnPej1x2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JYtzB6myhW/VgOB3hix0B0RbyEKroQ4bc6NEkDP+303PCTDBC2518KrKthBYK5x4jk4srT8bTNfC6MD2dreSs/fzNLwT6p3ahzgypKgXCih9vUMoya9nY9T2UYudkUTA4S0AKglMwyC7v8VF7gX/kPQvmJlMQY7yUJAWlzIxDEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywzNfYOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywzNfYOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444B4C4CEF1;
	Tue, 19 Aug 2025 12:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755605751;
	bh=zS1BlQyIl02rXzTpMGL+bn7rhhFP+gwL/hpnPej1x2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ywzNfYOt1B47JwwE/jsR6BeACC8G/m1bJ2tSByVeXtgicgj8Ue30UZjWlzqgIn5uU
	 jlPSu0qFt1MtDMAelwblpXPQZZCb92nVZnNZe6bi7RSk0Y5pM7f97jKTC/agKgv9Jo
	 MVhJ/S+787rK2DCdk8Y3dFsDx58djsg3rVFliwzM=
Date: Tue, 19 Aug 2025 14:15:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thorsten Leemhuis <linux@leemhuis.info>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Ben Hutchings <benh@debian.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 209/570] bootconfig: Fix unaligned access when
 building footer
Message-ID: <2025081935-tannery-luncheon-c512@gregkh>
References: <20250818124505.781598737@linuxfoundation.org>
 <20250818124513.854983152@linuxfoundation.org>
 <9ac42b4c-5cae-47f7-98c4-ffe0d5194e67@leemhuis.info>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9ac42b4c-5cae-47f7-98c4-ffe0d5194e67@leemhuis.info>

On Tue, Aug 19, 2025 at 08:56:20AM +0200, Thorsten Leemhuis wrote:
> On 18.08.25 14:43, Greg Kroah-Hartman wrote:
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <benh@debian.org>
> > 
> > [ Upstream commit 6ed5e20466c79e3b3350bae39f678f73cf564b4e ]
> > 
> > Currently we add padding between the bootconfig text and footer to
> > ensure that the footer is aligned within the initramfs image.
> > However, because only the bootconfig data is held in memory, not the
> > full initramfs image, the footer may not be naturally aligned in
> > memory.
> 
> This change broke the build for me in both 6.16.y and 6.15.y (did not
> try 6.12.y, guess it has the same problem)[1]. Reverting it or applying
> 26dda57695090e ("tools/bootconfig: Cleanup bootconfig footer size
> calculations") [v6.17-rc1] fixed things for me.
> 
> Ciao, Thorsten
> 
> [1] see
> https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/stable-rc/fedora-42-x86_64/09440377-stablerc-stablerc-releases/builder-live.log.gz
> 
> main.c: In function ‘apply_xbc’:
> main.c:442:41: error: ‘BOOTCONFIG_FOOTER_SIZE’ undeclared (first use in this function)
>   442 |         static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
>       |                                         ^~~~~~~~~~~~~~~~~~~~~~
> main.c:442:41: note: each undeclared identifier is reported only once for each function it appears in
> main.c:442:23: error: expression in static assertion is not an integer
>   442 |         static_assert(sizeof(footer) == BOOTCONFIG_FOOTER_SIZE);
>       |                       ^~~~~~
> make: *** [Makefile:21: bootconfig] Error 1

Thanks for the info, I'll go drop this from all queues now.

greg k-h
