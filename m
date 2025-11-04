Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206862A1BB;
	Tue,  4 Nov 2025 00:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762215970; cv=none; b=WhjIDlcmTdR1zJiOj89wLjaY8RVgmIMrS6+HHJnZ9KbeItlTlFLNuVQYxa5g5F6jRLe5vJHuoy610MQ5dg2Uopq4dU3T1lUFGMYlHEtw5mMKQqG9APp3wCUObmcjXx/dA/d8l9EilHGmYjAXNTMaNbsmtmIcRZ+ReKVPpQhIJng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762215970; c=relaxed/simple;
	bh=Bs1E/iPbvREfZ+wf8shPmjiAN3iesDcEtsodNw/AwWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S4Z+VLKK4/HB7SdvOa7quLGQKS05jCxXcgvkDc7SEP5d96s5rvSOi2viPFpuNeRYmJj24GQqrMCPfplHoJ2WuL6bVtwPzd3hgkZ/lxzclRcIr9jWWLktls0swJg/zkcoDBh59Bvgw7NkSmFjb2s9ZBCXVPhqGPn4BMwJmxynipE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4/kFgYQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4/kFgYQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFFC8C4CEE7;
	Tue,  4 Nov 2025 00:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762215970;
	bh=Bs1E/iPbvREfZ+wf8shPmjiAN3iesDcEtsodNw/AwWU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j4/kFgYQyFL8sTyk7xpOQp2z2YsNUBecgSfSylcMCi/3dUT+HDBIST6uVMU23TWlX
	 KxhfKD1lYoMVfrdmHHRIg0sERPGSHaj1Zuz2v0RRxrOs0o+InX9nf0fjsrzIWRr6DG
	 5tuCNY1sPvfKKz+uvIKhYw7lyPLAc0bnyREwKnFnkWgxf+a3HynnM/pcOdxqJelxLN
	 RPsw/XqHAqk6qpyzih/jksClk8Ug2nqG30G0D5Vk5agdprcGUmIpVC3KwjqfOCNyEg
	 YADl0S+ZFC/3XkEvujfmmuqMIwGyW3kXajUxXzp9O+4rszoU6yevB2my+/a8/4r20o
	 Q/AVSaeVUCgVQ==
Date: Mon, 3 Nov 2025 19:26:08 -0500
From: Sasha Levin <sashal@kernel.org>
To: Daniel Wagner <dwagner@suse.de>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Daniel Wagner <wagi@kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>,
	justin.tee@broadcom.com, nareshgottumukkala83@gmail.com,
	paul.ely@broadcom.com, sagi@grimberg.me, kch@nvidia.com,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 6.17-5.15] nvmet-fc: avoid scheduling association
 deletion twice
Message-ID: <aQlIII1UWi6FcYOz@laps>
References: <20251009155752.773732-1-sashal@kernel.org>
 <20251009155752.773732-15-sashal@kernel.org>
 <8bed9f7a-ad84-40e8-a275-09b19a917155@flourine.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8bed9f7a-ad84-40e8-a275-09b19a917155@flourine.local>

On Fri, Oct 10, 2025 at 09:39:05AM +0200, Daniel Wagner wrote:
>Hi Sasha,
>
>On Thu, Oct 09, 2025 at 11:54:41AM -0400, Sasha Levin wrote:
>> From: Daniel Wagner <wagi@kernel.org>
>>
>> [ Upstream commit f2537be4f8421f6495edfa0bc284d722f253841d ]
>>
>> When forcefully shutting down a port via the configfs interface,
>> nvmet_port_subsys_drop_link() first calls nvmet_port_del_ctrls() and
>> then nvmet_disable_port(). Both functions will eventually schedule all
>> remaining associations for deletion.
>>
>> The current implementation checks whether an association is about to be
>> removed, but only after the work item has already been scheduled. As a
>> result, it is possible for the first scheduled work item to free all
>> resources, and then for the same work item to be scheduled again for
>> deletion.
>>
>> Because the association list is an RCU list, it is not possible to take
>> a lock and remove the list entry directly, so it cannot be looked up
>> again. Instead, a flag (terminating) must be used to determine whether
>> the association is already in the process of being deleted.
>>
>> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>> Closes: https://lore.kernel.org/all/rsdinhafrtlguauhesmrrzkybpnvwantwmyfq2ih5aregghax5@mhr7v3eryci3/
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Signed-off-by: Daniel Wagner <wagi@kernel.org>
>> Signed-off-by: Keith Busch <kbusch@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This patch is part of a whole series:
>
>https://lore.kernel.org/all/20250902-fix-nvmet-fc-v3-0-1ae1ecb798d8@kernel.org/
>
>IMO, all should all be backported:
>
>db5a5406fb7e nvmet-fc: move lsop put work to nvmet_fc_ls_req_op
>f2537be4f842 nvmet-fc: avoid scheduling association deletion twice
>10c165af35d2 nvmet-fcloop: call done callback even when remote port is gone
>891cdbb162cc nvme-fc: use lock accessing port_state and rport state

Ack, thanks!

-- 
Thanks,
Sasha
