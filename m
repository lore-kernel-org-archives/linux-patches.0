Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59F934041D;
	Fri, 24 Jul 2026 15:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906792; cv=none; b=g/OiYWMCjiVVjmeGECbADAc/eGL7FqHxcYxA6JWeohLtWOBshBBXtoEEZPl1Rf1LXVOyFwP/dn13NOV736LLq/nbziZpEESuqxuBAjkX5PXzxY8NIFQNVyFW1n8+Lob3InFiK286LHoPWTDYrGmHzPLePRszx5FEpyj4f4KnrJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906792; c=relaxed/simple;
	bh=EG+ZVbL9Hf1dXUQVN6okne54iHKkSHQWgrmhbM/cDp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWzjzeDzxhINLtlRSt0/0kMt5z5sV1/pikeUj5TR+2Aj6+qJx/dzINqNpWqTG9ylgNF0wnJ8CiBwtmkWSM8Dkap6omfX0r6EWE/buH0NwnZUruONFjEUbc5x6XOrX7QmyeshWgKqMcFcFNSVkw9sclqUOBnrS2fUjGLnq9hYCPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E231ctce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E231ctce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2999E1F00A3D;
	Fri, 24 Jul 2026 15:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784906791;
	bh=bq/ZdJaOkGffsFXDh2JMtmlkUGLQcge7+7ciz2qz/9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E231ctce7rvnJRo/JEYng8O73cn5/1b/7DUlXMFpzeke5gkmCcuWszLp5w1XH/yoJ
	 9WYb5N0DUmuTYXdPvklD/qeqNmVZjmdHU1xlpSCtz/sueeKHAauMV9tsebottf/iTl
	 qwISj9kXnbXJORjuOkBLsJ6mefy/jpfFfiT5sDaA=
Date: Fri, 24 Jul 2026 17:26:20 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: harshit.m.mogalapalli@oracle.com, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 6.12.y] ext4: validate donor file superblock early in
 EXT4_IOC_MOVE_EXT
Message-ID: <2026072404-cultivate-cohesive-9fc6@gregkh>
References: <20260724143828.1668805-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724143828.1668805-1-yun.zhou@windriver.com>

On Fri, Jul 24, 2026 at 10:38:28PM +0800, Yun Zhou wrote:
> commit c143957520c6c9b5cd72e0de8b52b814f0c576fe upstream.
> 
> Reject the EXT4_IOC_MOVE_EXT ioctl early if the donor file does not
> belong to the same superblock as the original file.  Currently, this
> validation is performed inside ext4_move_extents() by
> mext_check_validity(), but only after lock_two_nondirectories() has
> already acquired the inode locks.  When the donor fd refers to a file
> on a different filesystem (e.g., overlayfs), this late validation
> creates a circular lock dependency:
> 
>   CPU0 (overlayfs write)            CPU1 (ext4 ioctl)
>   ----                              ----
>   inode_lock(ovl_inode)
>                                     mnt_want_write_file(filp)
>                                       sb_start_write(ext4_sb)   [sb_writers]
>     backing_file_write_iter()
>       vfs_iter_write(real_file)
>         file_start_write(real_file)
>           sb_start_write(ext4_sb)   [blocked by freeze]
>                                     lock_two_nondirectories()
>                                       inode_lock(ovl_inode)     [blocked]
> 
> With a concurrent freeze operation holding sb_writers write side, this
> forms a deadlock cycle: CPU0 waits for freeze to complete, freeze waits
> for CPU1's sb_writers reader to exit, CPU1 waits for CPU0's inode lock.
> 
> Since EXT4_IOC_MOVE_EXT exchanges physical extents between two files,
> it fundamentally requires both files to reside on the same ext4
> filesystem.  Moving the superblock check before any lock acquisition
> is both semantically correct and eliminates the circular dependency
> by ensuring that cross-filesystem donor fds are rejected before
> sb_writers or inode locks are taken.
> 
> Fixes: fcf6b1b729bc ("ext4: refactor ext4_move_extents code base")
> Reported-by: syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=ad6118a7584b607c67f2
> Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> Link: https://patch.msgid.link/20260608152521.1292656-1-yun.zhou@windriver.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> ---
>  fs/ext4/ioctl.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 99d185d00f37..e437cf1a84e5 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1366,6 +1366,11 @@ static long __ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  			goto mext_out;
>  		}
>  
> +		if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
> +			err = -EXDEV;
> +			goto mext_out;
> +		}
> +
>  		err = mnt_want_write_file(filp);
>  		if (err)
>  			goto mext_out;
> -- 
> 2.43.0
> 

I already merged the original, can you send a fix-up patch that I can
just apply instead?

thanks,

greg k-h
