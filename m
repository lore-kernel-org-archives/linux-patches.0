Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6A848CD6;
	Mon, 11 Dec 2023 14:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dlRP9DCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BA8C433C7;
	Mon, 11 Dec 2023 14:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702306579;
	bh=/2xK5AOw5ZjGOpFh/e5xT+kya7iRo4QfH9a8w1mE5cU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dlRP9DCLueJbpcOa2YlDM+XoBOaf4grBQiUSE9k5lz5WUJZX4AUUCpL3FZW+CY/c0
	 vyrzWRyNk9bEB24b9RxGRLN7szSlXifXDjVjPktXVWYDZKZ7Pml/Q1KyaQ3xdQcefy
	 VPhObrTdhd2AuecuC9Hs4YwoPef5Z+lhN1z4hM+0=
Date: Mon, 11 Dec 2023 15:56:16 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 5.4 63/94] btrfs: add dmesg output for first mount and
 last unmount of a filesystem
Message-ID: <2023121106-henna-unclog-6d2f@gregkh>
References: <20231205031522.815119918@linuxfoundation.org>
 <20231205031526.359703653@linuxfoundation.org>
 <20231209172836.GA2154579@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231209172836.GA2154579@dev-arch.thelio-3990X>

On Sat, Dec 09, 2023 at 10:28:36AM -0700, Nathan Chancellor wrote:
> On Tue, Dec 05, 2023 at 12:17:31PM +0900, Greg Kroah-Hartman wrote:
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Qu Wenruo <wqu@suse.com>
> > 
> > commit 2db313205f8b96eea467691917138d646bb50aef upstream.
> > 
> > There is a feature request to add dmesg output when unmounting a btrfs.
> > There are several alternative methods to do the same thing, but with
> > their own problems:
> > 
> > - Use eBPF to watch btrfs_put_super()/open_ctree()
> >   Not end user friendly, they have to dip their head into the source
> >   code.
> > 
> > - Watch for directory /sys/fs/<uuid>/
> >   This is way more simple, but still requires some simple device -> uuid
> >   lookups.  And a script needs to use inotify to watch /sys/fs/.
> > 
> > Compared to all these, directly outputting the information into dmesg
> > would be the most simple one, with both device and UUID included.
> > 
> > And since we're here, also add the output when mounting a filesystem for
> > the first time for parity. A more fine grained monitoring of subvolume
> > mounts should be done by another layer, like audit.
> > 
> > Now mounting a btrfs with all default mkfs options would look like this:
> > 
> >   [81.906566] BTRFS info (device dm-8): first mount of filesystem 633b5c16-afe3-4b79-b195-138fe145e4f2
> >   [81.907494] BTRFS info (device dm-8): using crc32c (crc32c-intel) checksum algorithm
> >   [81.908258] BTRFS info (device dm-8): using free space tree
> >   [81.912644] BTRFS info (device dm-8): auto enabling async discard
> >   [81.913277] BTRFS info (device dm-8): checking UUID tree
> >   [91.668256] BTRFS info (device dm-8): last unmount of filesystem 633b5c16-afe3-4b79-b195-138fe145e4f2
> > 
> > CC: stable@vger.kernel.org # 5.4+
> > Link: https://github.com/kdave/btrfs-progs/issues/689
> > Reviewed-by: Anand Jain <anand.jain@oracle.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > Reviewed-by: David Sterba <dsterba@suse.com>
> > [ update changelog ]
> > Signed-off-by: David Sterba <dsterba@suse.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/btrfs/disk-io.c |    1 +
> >  fs/btrfs/super.c   |    5 ++++-
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> > 
> > --- a/fs/btrfs/disk-io.c
> > +++ b/fs/btrfs/disk-io.c
> > @@ -2829,6 +2829,7 @@ int open_ctree(struct super_block *sb,
> >  		goto fail_alloc;
> >  	}
> >  
> > +	btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
> 
> clang tells me this backport does not appear to be correct and will
> likely introduce a null pointer deference:
> 
>   fs/btrfs/disk-io.c:2832:55: warning: variable 'disk_super' is uninitialized when used here [-Wuninitialized]
>    2832 |         btrfs_info(fs_info, "first mount of filesystem %pU", disk_super->fsid);
>         |                                                              ^~~~~~~~~~
>   fs/btrfs/ctree.h:3002:41: note: expanded from macro 'btrfs_info'
>    3002 |         btrfs_printk(fs_info, KERN_INFO fmt, ##args)
>         |                                                ^~~~
>   fs/btrfs/disk-io.c:2630:38: note: initialize the variable 'disk_super' to silence this warning
>    2630 |         struct btrfs_super_block *disk_super;
>         |                                             ^
>         |                                              = NULL
>   1 warning generated.

Thanks for the notice, I've now reverted this.

greg k-h
