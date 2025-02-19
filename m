Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1BB1C5D4C;
	Wed, 19 Feb 2025 08:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739952725; cv=none; b=pGt9Vz6uercCSrC1kZuyQRfofYPay96EZAGup5kmpDExqkHVmoZ1YMihmXlkh0Jzs7NENYPFwU2A5krdUENyN5Ivq6nzAViH7tKBx6qHGuOVZPo2LAzLQIxVZKqS5VDm9W3CXdxAZ9pT9yVc+41J76reUAIRUrGFpqgy0Yma/o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739952725; c=relaxed/simple;
	bh=LxhVye42dE4kczsJSlXO5KtSjYs1sm4CEC9GNTYMDu0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OmkquDHpWsQ64IMeluyfGO9wQIKul7srFBSgFWKz8F602727/AeFYYa6wrqXPO5VhnJxA3KV0QwGe8A9KZ5kQVCxxQ7XIrSI3v8Hy8O2c9ZOk09g19BdgNyJqxx4tkP/csfds+27lnCX0Nx3lQXl3eDU23V/YVrwo+I+LzykKG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJGmyY3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJGmyY3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9D4C4CED1;
	Wed, 19 Feb 2025 08:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739952724;
	bh=LxhVye42dE4kczsJSlXO5KtSjYs1sm4CEC9GNTYMDu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aJGmyY3T0P4j1dAiCLGuFL6n64DElahdwnjjIsNMV7nRl5WZr9L3Djm1/dvS2Dnnl
	 m7VrC01svYHqanP8khXxSdtx0yYhQYdyR1rp8MsljJ8F0PzNazo05rnyu0qhou2IbP
	 9lh+/s9h+g7lSd6zrWeGPOv5i0Y3ekzLHzYKZa9g=
Date: Wed, 19 Feb 2025 09:12:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pratyush Yadav <ptyadav@amazon.de>
Cc: stable@vger.kernel.org, Shu Han <ebpqwerty472123@gmail.com>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: Re: [PATCH 5.10] mm: call the security_mmap_file() LSM hook in
 remap_file_pages()
Message-ID: <2025021906-campus-glowworm-8aea@gregkh>
References: <20250210191056.58787-1-ptyadav@amazon.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210191056.58787-1-ptyadav@amazon.de>

On Mon, Feb 10, 2025 at 07:10:54PM +0000, Pratyush Yadav wrote:
> From: Shu Han <ebpqwerty472123@gmail.com>
> 
> commit ea7e2d5e49c05e5db1922387b09ca74aa40f46e2 upstream.
> 
> The remap_file_pages syscall handler calls do_mmap() directly, which
> doesn't contain the LSM security check. And if the process has called
> personality(READ_IMPLIES_EXEC) before and remap_file_pages() is called for
> RW pages, this will actually result in remapping the pages to RWX,
> bypassing a W^X policy enforced by SELinux.
> 
> So we should check prot by security_mmap_file LSM hook in the
> remap_file_pages syscall handler before do_mmap() is called. Otherwise, it
> potentially permits an attacker to bypass a W^X policy enforced by
> SELinux.
> 
> The bypass is similar to CVE-2016-10044, which bypass the same thing via
> AIO and can be found in [1].
> 
> The PoC:
> 
> $ cat > test.c
> 
> int main(void) {
> 	size_t pagesz = sysconf(_SC_PAGE_SIZE);
> 	int mfd = syscall(SYS_memfd_create, "test", 0);
> 	const char *buf = mmap(NULL, 4 * pagesz, PROT_READ | PROT_WRITE,
> 		MAP_SHARED, mfd, 0);
> 	unsigned int old = syscall(SYS_personality, 0xffffffff);
> 	syscall(SYS_personality, READ_IMPLIES_EXEC | old);
> 	syscall(SYS_remap_file_pages, buf, pagesz, 0, 2, 0);
> 	syscall(SYS_personality, old);
> 	// show the RWX page exists even if W^X policy is enforced
> 	int fd = open("/proc/self/maps", O_RDONLY);
> 	unsigned char buf2[1024];
> 	while (1) {
> 		int ret = read(fd, buf2, 1024);
> 		if (ret <= 0) break;
> 		write(1, buf2, ret);
> 	}
> 	close(fd);
> }
> 
> $ gcc test.c -o test
> $ ./test | grep rwx
> 7f1836c34000-7f1836c35000 rwxs 00002000 00:01 2050 /memfd:test (deleted)
> 
> Link: https://project-zero.issues.chromium.org/issues/42452389 [1]
> Cc: stable@vger.kernel.org
> Signed-off-by: Shu Han <ebpqwerty472123@gmail.com>
> Acked-by: Stephen Smalley <stephen.smalley.work@gmail.com>
> [PM: subject line tweaks]
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> ---
>  mm/mmap.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 9f76625a1743..2c17eb840e44 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -3078,8 +3078,12 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>  	}
>  
>  	file = get_file(vma->vm_file);
> +	ret = security_mmap_file(vma->vm_file, prot, flags);
> +	if (ret)
> +		goto out_fput;
>  	ret = do_mmap(vma->vm_file, start, size,
>  			prot, flags, pgoff, &populate, NULL);
> +out_fput:
>  	fput(file);
>  out:
>  	mmap_write_unlock(mm);
> -- 
> 2.47.1
> 
> 

This has required fixes for this commit which you did not include here,
so I'm going to have to drop this from the tree.  Same for the other
branch you submitted this against.

Please be more careful and always include all needed commits to resolve
a problem, we don't want to purposfully add bugs to the kernel tree that
we have already resolved.

thanks,

greg k-h
