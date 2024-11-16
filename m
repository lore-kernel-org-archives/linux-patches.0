Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B1D2913;
	Sat, 16 Nov 2024 01:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731722281; cv=none; b=pilYqN5AInbyAjg/eljkGshafDU4aLfOeGKt1tk9NVCvgbhxLtp9BQPSZrAFbevkEeN+El+5P5Of3lDbR/pxNrckzaJuU3Ji/aI6Efp87EzY105sD2JedPZlSz1Fgftr1X5rkrna5X597JHIL0yUFkkfN2vb6SEzDVB/WjQRtOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731722281; c=relaxed/simple;
	bh=eiJcqMDEhlGGOW3OTvAOY7MzaUC9F0+ELd8mjZOdWGA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uJ/dMzVZvm3m3pDRlRulltguxsKHdYbBj0bMEBNNqX9q9p7uO76LTClcWPZUrDAVk4UfpfNxwZsbxnoO3DxjDb9V78dmIl4MHEeu02MVic54JdOQnz8kNuvxaekZoLdd43ckz7+zVzvZvuHQ+5cOx85iQ1J855NA6fzI/gzq1FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XqxnH3lfqzpb1X;
	Sat, 16 Nov 2024 09:56:03 +0800 (CST)
Received: from kwepemk500005.china.huawei.com (unknown [7.202.194.90])
	by mail.maildlp.com (Postfix) with ESMTPS id B14BD180106;
	Sat, 16 Nov 2024 09:57:55 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 kwepemk500005.china.huawei.com (7.202.194.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Nov 2024 09:57:54 +0800
Subject: Re: [PATCH] ubifs: Fix uninitialized use of err in
 ubifs_jnl_write_inode()
To: Nathan Chancellor <nathan@kernel.org>, Richard Weinberger <richard@nod.at>
CC: <linux-mtd@lists.infradead.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
References: <20241115-ubifs-fix-uninitialized-err-v1-1-446849982e27@kernel.org>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <b560f413-70f1-8ebb-7403-34591658ca86@huawei.com>
Date: Sat, 16 Nov 2024 09:57:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20241115-ubifs-fix-uninitialized-err-v1-1-446849982e27@kernel.org>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemk500005.china.huawei.com (7.202.194.90)

ÔÚ 2024/11/16 0:10, Nathan Chancellor Ð´µÀ:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>    fs/ubifs/journal.c:986:20: error: variable 'err' is uninitialized when used here [-Werror,-Wuninitialized]
>      986 |                 ubifs_ro_mode(c, err);
>          |                                  ^~~
> 
> Set err to -EPERM before the call to ubifs_ro_mode() and reuse it in the
> return statement to resolve the warning.
> 
> Fixes: 957e1c4e1779 ("ubifs: ubifs_jnl_write_inode: Only check once for the limitation of xattr count")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   fs/ubifs/journal.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

My mistake, thanks for fixing it.

Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
> 
> diff --git a/fs/ubifs/journal.c b/fs/ubifs/journal.c
> index 8e98be64237154105cd6f7cb62cf0338ac26d3e9..36ba79fbd2ff80ff3d5c1f0bf965e439d8c55ab2 100644
> --- a/fs/ubifs/journal.c
> +++ b/fs/ubifs/journal.c
> @@ -983,8 +983,9 @@ int ubifs_jnl_write_inode(struct ubifs_info *c, const struct inode *inode)
>   
>   	if (kill_xattrs && ui->xattr_cnt > ubifs_xattr_max_cnt(c)) {
>   		ubifs_err(c, "Cannot delete inode, it has too much xattrs!");
> +		err = -EPERM;
>   		ubifs_ro_mode(c, err);
> -		return -EPERM;
> +		return err;
>   	}
>   
>   	/*
> 
> ---
> base-commit: fe051552f5078fa02d593847529a3884305a6ffe
> change-id: 20241115-ubifs-fix-uninitialized-err-96ba6a1e756c
> 
> Best regards,
> 

