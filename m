Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4805783CBC;
	Wed, 21 Feb 2024 17:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708538288; cv=none; b=E8feB9tgd9he5hsQOcEFsU/Qmw+DIg4AJlFEdbTNowPDyg6qs7TR0ZMSBqOra3UUCIADU7x2oCgXRJpL75B3JZ3ew3drDAfWkgN09OzCsGFkZiLSqFn3ZdP2qWNCxPfIsIE7zZZcJeIJRO/jUvpLAENoarQjBHSNa7pYAmPb/SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708538288; c=relaxed/simple;
	bh=Qd4H9cwhdO03wCSxu3Rwcedshj+Ug0aM05NpqY+BD/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aG1h5ovY5xuQpv1DCjemlXFCzNRNdTBsH3PUkWe7y6AXWDYUGvjcjeaN31K0+Sz30HKM9quJgIPY0KU35KwjGUBRLBYhMLOb3xK7CmD2drCFUcoOISSXm8B6R3Kii+rpYPNRmTszBCseRc86t2EM1MP3Ow8v4322uPPERzGI4Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMUExuEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMUExuEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A6EC433F1;
	Wed, 21 Feb 2024 17:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708538287;
	bh=Qd4H9cwhdO03wCSxu3Rwcedshj+Ug0aM05NpqY+BD/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rMUExuEkDaaPNDdULuXD3xLOn7NjMn5T9IBe4+L2Tk7IsvfIqKLGSfgI8X2jPFenB
	 2/b6KCy6KFQHYVze9D82azNc5fsEWyHWZh0EnHKDbvv9Ubg5lu+psnU4w0ONmEQX27
	 nuhhrZ88Or39j3z18fpPxpF6PsorPLEvxKWqh5F4=
Date: Wed, 21 Feb 2024 18:58:05 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5.4 258/267] nilfs2: replace WARN_ONs for invalid DAT
 metadata block requests
Message-ID: <2024022159-boxcar-jab-2a89@gregkh>
References: <20240221125940.058369148@linuxfoundation.org>
 <20240221125948.348622258@linuxfoundation.org>
 <CAKFNMonCSHt1ziZo=UcUvRSRfoARYUT+YycnoF2jQx78XENOyA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKFNMonCSHt1ziZo=UcUvRSRfoARYUT+YycnoF2jQx78XENOyA@mail.gmail.com>

On Thu, Feb 22, 2024 at 12:25:51AM +0900, Ryusuke Konishi wrote:
> On Wed, Feb 21, 2024 at 11:30 PM Greg Kroah-Hartman wrote:
> >
> > 5.4-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> >
> > commit 5124a0a549857c4b87173280e192eea24dea72ad upstream.
> >
> > If DAT metadata file block access fails due to corruption of the DAT file
> > or abnormal virtual block numbers held by b-trees or inodes, a kernel
> > warning is generated.
> >
> > This replaces the WARN_ONs by error output, so that a kernel, booted with
> > panic_on_warn, does not panic.  This patch also replaces the detected
> > return code -ENOENT with another internal code -EINVAL to notify the bmap
> > layer of metadata corruption.  When the bmap layer sees -EINVAL, it
> > handles the abnormal situation with nilfs_bmap_convert_error() and finally
> > returns code -EIO as it should.
> >
> > Link: https://lkml.kernel.org/r/0000000000005cc3d205ea23ddcf@google.com
> > Link: https://lkml.kernel.org/r/20230126164114.6911-1-konishi.ryusuke@gmail.com
> > Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> > Reported-by: <syzbot+5d5d25f90f195a3cfcb4@syzkaller.appspotmail.com>
> > Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/nilfs2/dat.c |   27 +++++++++++++++++----------
> >  1 file changed, 17 insertions(+), 10 deletions(-)
> >
> > --- a/fs/nilfs2/dat.c
> > +++ b/fs/nilfs2/dat.c
> > @@ -40,8 +40,21 @@ static inline struct nilfs_dat_info *NIL
> >  static int nilfs_dat_prepare_entry(struct inode *dat,
> >                                    struct nilfs_palloc_req *req, int create)
> >  {
> > -       return nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
> > -                                           create, &req->pr_entry_bh);
> > +       int ret;
> > +
> > +       ret = nilfs_palloc_get_entry_block(dat, req->pr_entry_nr,
> > +                                          create, &req->pr_entry_bh);
> > +       if (unlikely(ret == -ENOENT)) {
> > +               nilfs_error(dat->i_sb,
> > +                         "DAT doesn't have a block to manage vblocknr = %llu",
> > +                         (unsigned long long)req->pr_entry_nr);
> > +               /*
> > +                * Return internal code -EINVAL to notify bmap layer of
> > +                * metadata corruption.
> > +                */
> > +               ret = -EINVAL;
> > +       }
> > +       return ret;
> >  }
> >
> >  static void nilfs_dat_commit_entry(struct inode *dat,
> > @@ -123,11 +136,7 @@ static void nilfs_dat_commit_free(struct
> >
> >  int nilfs_dat_prepare_start(struct inode *dat, struct nilfs_palloc_req *req)
> >  {
> > -       int ret;
> > -
> > -       ret = nilfs_dat_prepare_entry(dat, req, 0);
> > -       WARN_ON(ret == -ENOENT);
> > -       return ret;
> > +       return nilfs_dat_prepare_entry(dat, req, 0);
> >  }
> >
> >  void nilfs_dat_commit_start(struct inode *dat, struct nilfs_palloc_req *req,
> > @@ -154,10 +163,8 @@ int nilfs_dat_prepare_end(struct inode *
> >         int ret;
> >
> >         ret = nilfs_dat_prepare_entry(dat, req, 0);
> > -       if (ret < 0) {
> > -               WARN_ON(ret == -ENOENT);
> > +       if (ret < 0)
> >                 return ret;
> > -       }
> >
> >         kaddr = kmap_atomic(req->pr_entry_bh->b_page);
> >         entry = nilfs_palloc_block_get_entry(dat, req->pr_entry_nr,
> >
> >
> 
> Hi Greg,
> 
> Please drop this patch for 5.4 as well as the patch for 4.19.
> (same reason as the review comment for the 4.19 patch)
> 
> I will send an equivalent replacement patch.

Now dropped, thanks!

greg k-h
