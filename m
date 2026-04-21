Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28B919E839
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 02:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.119
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776737024; cv=none; b=BfBt0ELySVkNKoIEuivn82if7xI2cwfgEFNxywFhuph//8GO+Y5OiDln1fbRXG46cy4VxSY2nMmV0NYDaFxk+5SSGpcYGQ8fkpz/8nfP2L38qpGZb/43gCsqDm7vQcF6W2npj4GEG21LTJa9Y77Ah9OTQH/4BiTT3H0Sgp75pCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776737024; c=relaxed/simple;
	bh=dHUjxAOXkLVdU/zS2QOs1dhm6nRPmHFNN046VJ1KWAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rys8KWTEHYBlrKOfvkv+F+docQ1ChRZofCHafa/40SAKVVPa72H1EQ/TQwDdL+XhebKXV9qgmuSU/9w1K+ANDT+lcZVSJLP0vaA7I6fTNdecd/VwYy1rAQ4plo98sePFIzNXNdMrH12jHr5cAjENAOdhzEdgs/koq0POYiA+of8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=e3IRNHOk; arc=none smtp.client-ip=115.124.30.119
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="e3IRNHOk"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776737018; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PT9p61QumOTma43BB/QkhxMPjLowSNcnP2HWwqiAW7s=;
	b=e3IRNHOkOAFEoQWlXpszyWRrZV/9e3p96YW1ze0U1t3KrvmMfKxpj8C6JwtNmYWCpyqCe6bJ26Qag/hNuIC7Egnd/Si9T8dQtiUbvTcfEJ5Hx8sNlBq7/OJ//xEBExS7GyS3AmXTB8Rs22SGyM9Vdk9o6FL4TkDAxqnx1MXhXos=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X1RNrF5_1776737016;
Received: from 30.221.132.26(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X1RNrF5_1776737016 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 10:03:36 +0800
Message-ID: <78d564f5-5511-4c67-b6b4-6670b3babbbf@linux.alibaba.com>
Date: Tue, 21 Apr 2026 10:03:34 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0-6.12] erofs: ensure all folios are managed in
 erofs_try_to_free_all_cached_folios()
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Zhan Xusheng <zhanxusheng@xiaomi.com>, Chunhai Guo <guochunhai@vivo.com>,
 xiang@kernel.org, chao@kernel.org, linux-erofs@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
References: <20260420132314.1023554-1-sashal@kernel.org>
 <20260420132314.1023554-198-sashal@kernel.org>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260420132314.1023554-198-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2026/4/20 21:19, Sasha Levin wrote:
> From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> 
> [ Upstream commit 5de6951fedb29700ace53b283ccb951c8f712d12 ]
> 
> folio_trylock() in erofs_try_to_free_all_cached_folios() may
> successfully acquire the folio lock, but the subsequent check
> for erofs_folio_is_managed() can skip unlocking when the folio
> is not managed by EROFS.
> 
> As Gao Xiang pointed out, this condition should not happen in
> practice because compressed_bvecs[] only holds valid cached folios
> at this point — any non-managed folio would have already been
> detached by z_erofs_cache_release_folio() under folio lock.
> 
> Fix this by adding DBG_BUGON() to catch unexpected folios
> and ensure folio_unlock() is always called.
> 
> Suggested-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
> Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> LLM Generated explanations, may be completely bogus:
> 
> Now I have a complete picture. Let me compile my analysis.

This is NOT a bugfix, but I don't mind if such random
patch backports to stable kernels.

Thanks,
Gao Xiang
