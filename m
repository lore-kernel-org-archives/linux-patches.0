Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043AD1AD3E1
	for <patches@lists.linux.dev>; Wed, 22 Jan 2025 06:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737527239; cv=none; b=un6mPy/PQ80CdGxCu2pJhq+xZQ80hqy/rA9J/aBFfhAaqWpsYXxYPg608UJYDzu8aJomuOm9iJeqTs9RkSA72fUzNS1v5iDnJUCTvtWMe8cNVIBIDh6cIO/SO34KLAnhfuwLUxEcAuwm1Xnq2vHFPYyoZnHTPIAPUegkKI4troo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737527239; c=relaxed/simple;
	bh=3uyDNXZMF6q74hmz/0okmpumOJCrDAdJLd7qiVTTyr4=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ddPM+ynZSfsq0VlC/iLIkAemoZ8khIX6zNOEvXqiNFvVk/lQMJ8MzchkoQj/DXY4XwCKMQvHaSqVENd0llpDdEgqUW6oGAQZoEOqsSE3r5eRdph/0y/ZwiHlNxYCg9NIBMbyfLueI/+xfe/0qgZSKn+f3mV8QD8POS9rL3+GaX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iU0gmul2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iU0gmul2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B92E8C4CED6;
	Wed, 22 Jan 2025 06:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737527238;
	bh=3uyDNXZMF6q74hmz/0okmpumOJCrDAdJLd7qiVTTyr4=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=iU0gmul2B6dXARK1xobfHCBWcboxirQwrFdoNCs50x/Woyc+8oJ64DOKEuTPS+biF
	 SQiqJsbOrbjsKS6CWpnnZo4+kfsiP7lkMFSgKw8iXGf1Auno0LXnnrzCt2hFsybq/u
	 xtiFr+VDpguqSIryO3dnDtJ40bT/yGRqdqZKPC0EQBRc7+zscqanSQpWCECS6KDP4R
	 TpHWTliKeuanZbY7TqgvDaL33gGIm4Qut90ppRqSmIbWNgtCsWi35+hkw+s5XfIGVx
	 23R7xUOAtt6Q9xwXi+iChMUfoJ8omIs4N/LiahmcDYullalaGTKAIU+6O361VuGli3
	 9gARzjEtH8e0A==
Message-ID: <bef8db0a-f2ef-4aea-ab19-c3390f7bf93e@kernel.org>
Date: Wed, 22 Jan 2025 14:27:14 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 patches@lists.linux.dev
Subject: Re: [PATCH] f2fs: Fix format specifier in sanity_check_inode()
To: Nathan Chancellor <nathan@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>
References: <20250120-f2fs-fix-wformat-min_inline_xattr_size-v1-1-508cac1474fe@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20250120-f2fs-fix-wformat-min_inline_xattr_size-v1-1-508cac1474fe@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/20/25 20:59, Nathan Chancellor wrote:
> When building for 32-bit platforms, for which 'size_t' is 'unsigned int',
> there is a warning due to an incorrect format specifier:
> 
>    fs/f2fs/inode.c:320:6: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
>      318 |                 f2fs_warn(sbi, "%s: inode (ino=%lx) has corrupted i_inline_xattr_size: %d, min: %lu, max: %lu",
>          |                                                                                                 ~~~
>          |                                                                                                 %u
>      319 |                           __func__, inode->i_ino, fi->i_inline_xattr_size,
>      320 |                           MIN_INLINE_XATTR_SIZE, MAX_INLINE_XATTR_SIZE);
>          |                           ^~~~~~~~~~~~~~~~~~~~~
>    fs/f2fs/f2fs.h:1855:46: note: expanded from macro 'f2fs_warn'
>     1855 |         f2fs_printk(sbi, false, KERN_WARNING fmt, ##__VA_ARGS__)
>          |                                              ~~~    ^~~~~~~~~~~
>    fs/f2fs/xattr.h:86:31: note: expanded from macro 'MIN_INLINE_XATTR_SIZE'
>       86 | #define MIN_INLINE_XATTR_SIZE (sizeof(struct f2fs_xattr_header) / sizeof(__le32))
>          |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Use the format specifier for 'size_t', '%zu', to resolve the warning.
> 
> Fixes: 5c1768b67250 ("f2fs: fix to do sanity check correctly on i_inline_xattr_size")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Chao Yu <chao@kernel.org>

Thanks,
