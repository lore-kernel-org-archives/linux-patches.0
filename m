Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C7E13CA99;
	Tue, 16 Jul 2024 14:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721138854; cv=none; b=KriOnzzD1cGbtCm/toV61UN+/a2audlyg24Mxlgrze+AmYfKS16NVkh5vxE3xrYpnxQRW9GO2G+9wlba5WhP5at3Zf0faqmTrYAv1UnHd+ALogEbZ37qCLBFP+Iugxr4KQkeJ/vsi6o18G4QakfHs3SYGf3i7AwmzfXsRi4uOew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721138854; c=relaxed/simple;
	bh=hUHT8w0jInxT5QPrOrvFpsI7ZTXUPfC3lLQv6yahZVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OS4Cz4sRDPDGkMgIp9cBBeETunskcQkiDPravK1SXyBSyGD3vzgkD/2ZuTojfx+epQ0UokIWmMRkFdPOu3UIRt+uDd3EN265iphOK4vGfsjmwR1ZkdbWyA/2dGwlXslQ6YHx88iIm0g5HrztDx+Zs2SqFe3Td6B4EVb2R8xuC5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iH2Ql0y6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iH2Ql0y6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226B2C116B1;
	Tue, 16 Jul 2024 14:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721138853;
	bh=hUHT8w0jInxT5QPrOrvFpsI7ZTXUPfC3lLQv6yahZVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iH2Ql0y6wQ7XbD9NPu/BQtT+ZoiXvpHCZHBPedK9BD7quqKPQ2Kn2KNgeoJzKYvYn
	 rVcUtFkSrG2/OTa9bDCK4mUKCiyhhKcPnU8Fg2yHwc/ollZ6N/O1nJLsklNE5PESLn
	 d50GDml4sJx/cF0WTZebMMsTCpqQykHAmNU3YTZU=
Date: Tue, 16 Jul 2024 16:07:30 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: libaokun@huaweicloud.com
Cc: stable@vger.kernel.org, sashal@kernel.org, tytso@mit.edu, jack@suse.cz,
	patches@lists.linux.dev, yi.zhang@huawei.com, yangerkun@huawei.com,
	Baokun Li <libaokun1@huawei.com>
Subject: Re: [PATCH 6.6/6.9] ext4: avoid ptr null pointer dereference
Message-ID: <2024071624-ascent-breeding-7fb1@gregkh>
References: <20240716092929.864207-1-libaokun@huaweicloud.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240716092929.864207-1-libaokun@huaweicloud.com>

On Tue, Jul 16, 2024 at 05:29:29PM +0800, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> When commit 13df4d44a3aa ("ext4: fix slab-out-of-bounds in
> ext4_mb_find_good_group_avg_frag_lists()") was backported to stable, the
> commit f536808adcc3 ("ext4: refactor out ext4_generic_attr_store()") that
> uniformly determines if the ptr is null is not merged in, so it needs to
> be judged whether ptr is null or not in each case of the switch, otherwise
> null pointer dereferencing may occur.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/ext4/sysfs.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext4/sysfs.c b/fs/ext4/sysfs.c
> index 63cbda3700ea..d65dccb44ed5 100644
> --- a/fs/ext4/sysfs.c
> +++ b/fs/ext4/sysfs.c
> @@ -473,6 +473,8 @@ static ssize_t ext4_attr_store(struct kobject *kobj,
>  			*((unsigned int *) ptr) = t;
>  		return len;
>  	case attr_clusters_in_group:
> +		if (!ptr)
> +			return 0;
>  		ret = kstrtouint(skip_spaces(buf), 0, &t);
>  		if (ret)
>  			return ret;
> -- 
> 2.39.2
> 
> 

Now queued up, thanks for the fix!

greg k-h
