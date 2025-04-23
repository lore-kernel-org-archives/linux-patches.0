Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6330E2367A0;
	Wed, 23 Apr 2025 15:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421341; cv=none; b=KNsojPWPMOw/qB1Kht9oXTQfcuTAkSh9k7YMSHdFqMZGZ61Vz2VU8j1S8e8CQT1YtsKKMPauJL+1FBILRsah9rE21qtf+MlVYAR5u6xFR5udV9fgGy5r+17FuMqBeny+GWUqtcQkEPXuWL3s39EI8DWosSNvaJRramwHTdnsqEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421341; c=relaxed/simple;
	bh=SlGeXQMO8f8SNagA77D5mkSDCScVQeO0XiQhpieUubQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bi9tymMH/gB7VNkYY0txBhhzqanp3zcVDoGIWnGT+HBfdasrfEK9ZC9H7W5X8F9bkgh76AqeWeWuBbnT8UuEVKP57yWVkg7cXbyQKqUNFe9tEa7hevFikam+Gh36DW0cKa8A+t8VNAqTiZ84thMBgVbjH7x0MTN1AY2gcZEttjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPICuGzH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPICuGzH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F9FC4CEE2;
	Wed, 23 Apr 2025 15:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745421341;
	bh=SlGeXQMO8f8SNagA77D5mkSDCScVQeO0XiQhpieUubQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aPICuGzHJiE/ZAhQL8vi4oOMgHcKKwnx/jCoDcSv5hoSbfGmJMkd8PjUypcTzL4dR
	 wXOymo5SuKs3UNM8w3gfsgXnAZfsca8MGvarm9mkNp+ASyos96xDUkN/Rqu0NpBVur
	 uGW+391cpKh6BFLV1GlN31SwDZr6k4TYZeF58hWciLdRpJfGFEERD5AE+HbQTqu/W/
	 37ZIRo2hFv1rc/8IL+uhrIfbbUPxZu2WpNrTaon3uXWjFGucGgrF3tCdV/n3QyXIe3
	 JnY+FYYI8gNdFRf0sb0OOhfwb+jbfH05JgmigFzoVk3Po0toHLEH9BMrGd/uSXlPzA
	 CCp+p0YzrA4Pg==
Date: Wed, 23 Apr 2025 08:15:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.14 122/241] fs: move the bdex_statx call to
 vfs_getattr_nosec
Message-ID: <20250423151540.GK25700@frogsfrogsfrogs>
References: <20250423142620.525425242@linuxfoundation.org>
 <20250423142625.563593359@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250423142625.563593359@linuxfoundation.org>

On Wed, Apr 23, 2025 at 04:43:06PM +0200, Greg Kroah-Hartman wrote:
> 6.14-stable review patch.  If anyone has any objections, please let me know.

You might want to hold this patch (for 6.14 and 6.12) until "devtmpfs:
don't use vfs_getattr_nosec to query i_mode" lands, since (AFAICT) it's
needed to fix a hang introduced by this patch.

(Unless that's already queued for stable, but afaict it isn't)

--D

> ------------------
> 
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 777d0961ff95b26d5887fdae69900374364976f3 ]
> 
> Currently bdex_statx is only called from the very high-level
> vfs_statx_path function, and thus bypassing it for in-kernel calls
> to vfs_getattr or vfs_getattr_nosec.
> 
> This breaks querying the block ѕize of the underlying device in the
> loop driver and also is a pitfall for any other new kernel caller.
> 
> Move the call into the lowest level helper to ensure all callers get
> the right results.
> 
> Fixes: 2d985f8c6b91 ("vfs: support STATX_DIOALIGN on block devices")
> Fixes: f4774e92aab8 ("loop: take the file system minimum dio alignment into account")
> Reported-by: "Darrick J. Wong" <djwong@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Link: https://lore.kernel.org/20250417064042.712140-1-hch@lst.de
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  block/bdev.c           |  3 +--
>  fs/stat.c              | 32 ++++++++++++++++++--------------
>  include/linux/blkdev.h |  6 +++---
>  3 files changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index 9d73a8fbf7f99..e5147cab21b21 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -1268,8 +1268,7 @@ void sync_bdevs(bool wait)
>  /*
>   * Handle STATX_{DIOALIGN, WRITE_ATOMIC} for block devices.
>   */
> -void bdev_statx(struct path *path, struct kstat *stat,
> -		u32 request_mask)
> +void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask)
>  {
>  	struct inode *backing_inode;
>  	struct block_device *bdev;
> diff --git a/fs/stat.c b/fs/stat.c
> index f13308bfdc983..3d9222807214a 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -204,12 +204,25 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
>  				  STATX_ATTR_DAX);
>  
>  	idmap = mnt_idmap(path->mnt);
> -	if (inode->i_op->getattr)
> -		return inode->i_op->getattr(idmap, path, stat,
> -					    request_mask,
> -					    query_flags);
> +	if (inode->i_op->getattr) {
> +		int ret;
> +
> +		ret = inode->i_op->getattr(idmap, path, stat, request_mask,
> +				query_flags);
> +		if (ret)
> +			return ret;
> +	} else {
> +		generic_fillattr(idmap, request_mask, inode, stat);
> +	}
> +
> +	/*
> +	 * If this is a block device inode, override the filesystem attributes
> +	 * with the block device specific parameters that need to be obtained
> +	 * from the bdev backing inode.
> +	 */
> +	if (S_ISBLK(stat->mode))
> +		bdev_statx(path, stat, request_mask);
>  
> -	generic_fillattr(idmap, request_mask, inode, stat);
>  	return 0;
>  }
>  EXPORT_SYMBOL(vfs_getattr_nosec);
> @@ -295,15 +308,6 @@ static int vfs_statx_path(struct path *path, int flags, struct kstat *stat,
>  	if (path_mounted(path))
>  		stat->attributes |= STATX_ATTR_MOUNT_ROOT;
>  	stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
> -
> -	/*
> -	 * If this is a block device inode, override the filesystem
> -	 * attributes with the block device specific parameters that need to be
> -	 * obtained from the bdev backing inode.
> -	 */
> -	if (S_ISBLK(stat->mode))
> -		bdev_statx(path, stat, request_mask);
> -
>  	return 0;
>  }
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index d37751789bf58..38fc78501ef2d 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1664,7 +1664,7 @@ int sync_blockdev(struct block_device *bdev);
>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
>  int sync_blockdev_nowait(struct block_device *bdev);
>  void sync_bdevs(bool wait);
> -void bdev_statx(struct path *, struct kstat *, u32);
> +void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
>  void printk_all_partitions(void);
>  int __init early_lookup_bdev(const char *pathname, dev_t *dev);
>  #else
> @@ -1682,8 +1682,8 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
>  static inline void sync_bdevs(bool wait)
>  {
>  }
> -static inline void bdev_statx(struct path *path, struct kstat *stat,
> -				u32 request_mask)
> +static inline void bdev_statx(const struct path *path, struct kstat *stat,
> +		u32 request_mask)
>  {
>  }
>  static inline void printk_all_partitions(void)
> -- 
> 2.39.5
> 
> 
> 
