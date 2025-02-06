Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B11E5B87;
	Thu,  6 Feb 2025 14:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738852266; cv=none; b=CWhlc9fA1DgQhxoUr+gBFfEXgWWr/mpgWeKZieR8NxZ9qthQd+fdwFxRxBCsuan/eSFaT3x4u+uFD5poUwgRQ8CTdyG1idKxT9XJNdnNBY7TDdzcM/09g7uZU0WSMkQ1+Vm1CrkB+S9glw4NI+UHL1JG93ifJb+uzJAMUkciZiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738852266; c=relaxed/simple;
	bh=XnuDuBDRTFnjXLyL42QAl0W86xsDDJwS1IDugYHTjZg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GDDMF5+ccCDE7Y2omy4FaP0w8zzf985jy2DhDSuNwAguu4BhPmCyB5zQSp5ewAxdsle1D9WUCBzYCgJhXMIEVsnNiy3iHPe6MX3wFHkGZSLzKRK8FSCgtbWF0cYmT6XTVKXA7zyGlQiwWcO+sHEzGghY8y+Fiwl6OHM26Hr36Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFMW6kCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFMW6kCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB9EC4CEE2;
	Thu,  6 Feb 2025 14:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738852265;
	bh=XnuDuBDRTFnjXLyL42QAl0W86xsDDJwS1IDugYHTjZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bFMW6kCxctO6i62XX6ea6UMqtG3Bw/yU3iktsuHEdTdNiCwQkGqyyWnHJ39FeW7Mm
	 HB1Px2jj+YR4zhB3dE3eX+DYcV90B3RU7VNnzV+QQcE9AYzI6fYTGhKe21t8meQGRz
	 ZdOVhMeKNw8wrGNgjeIg7wZ/jVIY4lqs4URt0cDE=
Date: Thu, 6 Feb 2025 15:31:02 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Koichiro Den <koichiro.den@canonical.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>, Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 6.12 102/114] btrfs: avoid monopolizing a core when
 activating a swap file
Message-ID: <2025020634-grid-goldfish-c9ef@gregkh>
References: <20241230154218.044787220@linuxfoundation.org>
 <20241230154222.045141330@linuxfoundation.org>
 <q6zj7uvssfaqkz5sshi7i6oooschrwlyapb7o47y36ylz4ylf7@dkopww2lfuko>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q6zj7uvssfaqkz5sshi7i6oooschrwlyapb7o47y36ylz4ylf7@dkopww2lfuko>

On Thu, Feb 06, 2025 at 08:41:33PM +0900, Koichiro Den wrote:
> On Mon, Dec 30, 2024 at 04:43:39PM GMT, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Filipe Manana <fdmanana@suse.com>
> > 
> > commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.
> > 
> > During swap activation we iterate over the extents of a file and we can
> > have many thousands of them, so we can end up in a busy loop monopolizing
> > a core. Avoid this by doing a voluntary reschedule after processing each
> > extent.
> > 
> > CC: stable@vger.kernel.org # 5.4+
> > Reviewed-by: Qu Wenruo <wqu@suse.com>
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/btrfs/inode.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct ino
> >  			ret = -EAGAIN;
> >  			goto out;
> >  		}
> > +
> > +		cond_resched();
> >  	}
> >  
> >  	if (file_extent)
> > 
> > 
> 
> Hi, please let me confirm; is this backport really ok? I mean, should the
> cond_resched() be added to btrfs_swap_activate() loop? I was able to
> reproduce the same situation:
> 
>     $ git rev-parse HEAD
>     319addc2ad901dac4d6cc931d77ef35073e0942f
>     $ b4 mbox --single-message  c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com
>     1 messages in the thread
>     Saved ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
>     $ patch -p1 < ./c37ea7a8de12e996091ba295b2f201fbe680c96c.1733929328.git.fdmanana@suse.com.mbx
>     patching file fs/btrfs/inode.c
>     Hunk #1 succeeded at 7117 with fuzz 1 (offset -2961 lines).
>     $ git diff
>     diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>     index 58ffe78132d9..6fe2ac620464 100644
>     --- a/fs/btrfs/inode.c
>     +++ b/fs/btrfs/inode.c
>     @@ -7117,6 +7117,8 @@ noinline int can_nocow_extent(struct inode *inode, u64 offset, u64 *len,
>                             ret = -EAGAIN;
>                             goto out;
>                     }
>     +
>     +               cond_resched();
>             }
>     
>             if (file_extent)
> 
> The same goes for all the other stable branches applied. Sorry if I'm
> missing something.

Hm, looks like patch messed this up :(

Can you send a revert for the branches that this was wrong on, and then
the correct fix, and I'll be glad to queue them all up.

thanks,

greg k-h
