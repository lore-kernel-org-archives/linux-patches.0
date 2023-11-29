Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD441878;
	Wed, 29 Nov 2023 01:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OFbO5Iiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04455C433C8;
	Wed, 29 Nov 2023 01:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1701222025;
	bh=HmNrww6d/IdSj6VMUUS4+C7kZBzUcs1stKqAd+f2GDI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OFbO5Iiq4NbCDQDMOhXa48gf5AnMFz/E6NkY5oxwaV9edgoiICl8AUF/smuB8h+2v
	 UaIKsc7ZGPmkHitOViAsmLbJ3iQCjPZ9v75p2KYfbaegY2nLGYd152PLhUbaf+It3j
	 zNIuiFDzfx7R8k9tDRpTaWBowNIC6Ul2gIzvowu8=
Date: Tue, 28 Nov 2023 17:40:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: willy@infradead.org, ndesaulniers@google.com,
 linux-fsdevel@vger.kernel.org, llvm@lists.linux.dev,
 patches@lists.linux.dev, Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH] buffer: Add cast in grow_buffers() to avoid a
 multiplication libcall
Message-Id: <20231128174024.a74bfa551718082ca8808a98@linux-foundation.org>
In-Reply-To: <20231128-avoid-muloti4-grow_buffers-v1-1-bc3d0f0ec483@kernel.org>
References: <20231128-avoid-muloti4-grow_buffers-v1-1-bc3d0f0ec483@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Nov 2023 16:55:43 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> When building with clang after commit 697607935295 ("buffer: fix
> grow_buffers() for block size > PAGE_SIZE"), there is an error at link
> time due to the generation of a 128-bit multiplication libcall:
> 
>   ld.lld: error: undefined symbol: __muloti4
>   >>> referenced by buffer.c:0 (fs/buffer.c:0)
>   >>>               fs/buffer.o:(bdev_getblk) in archive vmlinux.a
> 
> Due to the width mismatch between the factors and the sign mismatch
> between the factors and the result, clang generates IR that performs
> this overflow check with 65-bit signed multiplication and LLVM does not
> improve on it during optimization, so the 65-bit multiplication is
> extended to 128-bit during legalization, resulting in the libcall on
> most targets.
> 
> To avoid the initial situation that causes clang to generate the
> problematic IR, cast size (which is an 'unsigned int') to the same
> type/width as block (which is currently a 'u64'/'unsigned long long').
> GCC appears to already do this internally because there is no binary
> difference with the cast for arm, arm64, riscv, or x86_64.
> 
> ...
>
> I am aware the hash in the commit message is not stable due to being on
> the mm-unstable branch but I figured I would write the commit message as
> if it would be standalone, in case this should not be squashed into the
> original change. I did not add a comment to the source around this
> workaround but I can if so desired.

That's good.  Yes, I'll squash it into the base patch, but the Link: to
this fix will appear in the permanent record, for the inquisitive.

> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1091,7 +1091,7 @@ static bool grow_buffers(struct block_device *bdev, sector_t block,
>  	 * Check for a block which lies outside our maximum possible
>  	 * pagecache index.
>  	 */
> -	if (check_mul_overflow(block, size, &pos) || pos > MAX_LFS_FILESIZE) {
> +	if (check_mul_overflow(block, (sector_t)size, &pos) || pos > MAX_LFS_FILESIZE) {
>  		printk(KERN_ERR "%s: requested out-of-range block %llu for device %pg\n",
>  			__func__, (unsigned long long)block,
>  			bdev);

This seems appropriate.  Changing the type of incoming arg `size' feels
a bit fake - this is the per-bdev buffer_head size and expressing that
as a sector_t is misleading and unrealistic.

