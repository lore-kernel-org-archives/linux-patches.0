Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B90227EB4
	for <patches@lists.linux.dev>; Thu, 27 Feb 2025 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740649217; cv=none; b=bZ0Q+v+h+M0zClmi9AJqtGGLacqtV7zOP9EuFi+J54jQT1jyMpTy9h3UtVr7n8CgpHOoMWwYMfBGvfZ8FClp7OjK48h2ybQfL4w5MbNTBkcJC5aM0C5tZihMPMseAmGIK5XoEZId0AZ084wkm0ZId/CL9sU99LCvk8qOavTRa+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740649217; c=relaxed/simple;
	bh=EEXIRx6reIB0eQTcIZZ/5RTO9C7ruM7nE+KfhaCS6jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xb4NusuF5ZIOinxIIq2D44+jNCvSTySXkh/i04PO3OASzRSQ2r0aMaEWyEEyj/6UwMr4XnQrlZXAG91yLJ9UG1rF8si7q/q/0UVvdHTWjYaJGqA3TrBPKtwk//LpNAJIeDO00BpJXDBljqdy3wFObVEkt6vQk6nm4oviF0czM9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=PKCHsH3j; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="PKCHsH3j"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1740649205; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=j9ZR+GBvrG/gafVcZuHcfzZzaTrIy3pXM8NhiHSvvgY=;
	b=PKCHsH3jVfJq+cnf2v+hI+hnjUxs6ewhboDTfWUzcA93gDJ/egKajmZKb3PlyjqgF7jRIPFgf2HD9mVPwyaboHqYTrdG/TOWIA24sZZhnkDLZkvq0QAPjaqhdBczOufyKHE+CaqauNmjEp4Y4XW4VLMy/dUESNSPpzAWQEcu6js=
Received: from 30.74.130.95(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0WQLwyRm_1740649203 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 27 Feb 2025 17:40:04 +0800
Message-ID: <445cf95d-b695-4e8d-b4ba-6ca0c12b1c52@linux.alibaba.com>
Date: Thu, 27 Feb 2025 17:40:02 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.6 238/676] bpf, sockmap: Several fixes to
 bpf_msg_pop_data
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, Zijian Zhang <zijianzhang@bytedance.com>,
 John Fastabend <john.fastabend@gmail.com>,
 Martin KaFai Lau <martin.lau@kernel.org>, Sasha Levin <sashal@kernel.org>,
 stable@vger.kernel.org, Levi Zim <rsworktech@outlook.com>,
 Daniel Borkmann <daniel@iogearbox.net>
References: <20241206143653.344873888@linuxfoundation.org>
 <20241206143702.627526560@linuxfoundation.org>
Content-Language: en-US
From: Tianchen Ding <dtcccc@linux.alibaba.com>
In-Reply-To: <20241206143702.627526560@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 12/6/24 10:30 PM, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Zijian Zhang <zijianzhang@bytedance.com>
> 
> [ Upstream commit 5d609ba262475db450ba69b8e8a557bd768ac07a ]
> 
> Several fixes to bpf_msg_pop_data,
> 1. In sk_msg_shift_left, we should put_page
> 2. if (len == 0), return early is better
> 3. pop the entire sk_msg (last == msg->sg.size) should be supported
> 4. Fix for the value of variable "a"
> 5. In sk_msg_shift_left, after shifting, i has already pointed to the next
> element. Addtional sk_msg_iter_var_next may result in BUG.
> 
> Fixes: 7246d8ed4dcc ("bpf: helper to pop data from messages")
> Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
> Reviewed-by: John Fastabend <john.fastabend@gmail.com>
> Link: https://lore.kernel.org/r/20241106222520.527076-8-zijianzhang@bytedance.com
> Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

We found the kernel crashed when running kselftests (bpf/test_sockmap) in 
kernel 6.6 LTS, which is introduced by this commit. I guess all other 
stable kernels (containing this commit) are also affected.

Please consider backporting the following 2 commits:
fdf478d236dc ("skmsg: Return copied bytes in sk_msg_memcopy_from_iter")
5153a75ef34b ("tcp_bpf: Fix copied value in tcp_bpf_sendmsg")

Thanks.
