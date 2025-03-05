Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F3033C9;
	Wed,  5 Mar 2025 14:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741183444; cv=none; b=mx5fcySQ/KvKwivOGGahfbYtc3Sq6zmGzezTXU/NTs+WBwX/RFtWLHyluiR+fjyuYoiA2D9Tok07nbfBDeAUZB1k3hgdJpP7C9ooWuzeQT7bQaCTuy3P56LZvU6zjjXIgRgYTNfVrsemkaBZt0oCbcMC4zen6WlYLFOV55UHgfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741183444; c=relaxed/simple;
	bh=HcsY7DDq4XH4OmEl92ldJL3YkDr23xKJetfRPqzjsGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lxetNjM/flM35clbHO5ZwxW6Q50t33lGsxGPagxxUUflAiBrMb+IT92LRpWwj253aqQ+L/KaUC5vCJckqtBaGPW6vOFTsS12zaSyFbvZc1KgfZvd4/ceMTD84SfVCo7r3L/8CTTm2seVfXy4aS7Nu+PuKsdNG+CrydERGuQcYAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qydRrlYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qydRrlYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7BDC4CED1;
	Wed,  5 Mar 2025 14:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741183443;
	bh=HcsY7DDq4XH4OmEl92ldJL3YkDr23xKJetfRPqzjsGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qydRrlYFn41HVh4alDbihgeqoOewUuIYpjMRLbkhPx9lZgzsheLabrRLrcLTojXwz
	 WhdNE2EHijZVi9WS2FoWbkzK8+OEkDxXCRnKV5x+wFFYFGZ0GUKI3KRND2debedK95
	 btLd0PB8JXn743GyWKLt2SLlhXo7cgZcMy/dJF9k=
Date: Wed, 5 Mar 2025 15:03:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tianchen Ding <dtcccc@linux.alibaba.com>
Cc: patches@lists.linux.dev, Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Levi Zim <rsworktech@outlook.com>,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH 6.6 238/676] bpf, sockmap: Several fixes to
 bpf_msg_pop_data
Message-ID: <2025030512-lens-refill-2e71@gregkh>
References: <20241206143653.344873888@linuxfoundation.org>
 <20241206143702.627526560@linuxfoundation.org>
 <445cf95d-b695-4e8d-b4ba-6ca0c12b1c52@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <445cf95d-b695-4e8d-b4ba-6ca0c12b1c52@linux.alibaba.com>

On Thu, Feb 27, 2025 at 05:40:02PM +0800, Tianchen Ding wrote:
> Hi,
> 
> On 12/6/24 10:30 PM, Greg Kroah-Hartman wrote:
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Zijian Zhang <zijianzhang@bytedance.com>
> > 
> > [ Upstream commit 5d609ba262475db450ba69b8e8a557bd768ac07a ]
> > 
> > Several fixes to bpf_msg_pop_data,
> > 1. In sk_msg_shift_left, we should put_page
> > 2. if (len == 0), return early is better
> > 3. pop the entire sk_msg (last == msg->sg.size) should be supported
> > 4. Fix for the value of variable "a"
> > 5. In sk_msg_shift_left, after shifting, i has already pointed to the next
> > element. Addtional sk_msg_iter_var_next may result in BUG.
> > 
> > Fixes: 7246d8ed4dcc ("bpf: helper to pop data from messages")
> > Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
> > Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> > Link: https://lore.kernel.org/r/20241106222520.527076-8-zijianzhang@bytedance.com
> > Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> We found the kernel crashed when running kselftests (bpf/test_sockmap) in
> kernel 6.6 LTS, which is introduced by this commit. I guess all other stable
> kernels (containing this commit) are also affected.
> 
> Please consider backporting the following 2 commits:
> fdf478d236dc ("skmsg: Return copied bytes in sk_msg_memcopy_from_iter")
> 5153a75ef34b ("tcp_bpf: Fix copied value in tcp_bpf_sendmsg")

Please submit the tested series to us, properly backported, and we will
be glad to review them for stable inclusion (remember to also properly
send patches for newer stable releases as needed.)

thanks,

greg k-h
