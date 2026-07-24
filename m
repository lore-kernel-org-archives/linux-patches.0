Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F65327BFB;
	Fri, 24 Jul 2026 14:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784902830; cv=none; b=DI71dONYIw4ZVmXszpdns/QC2XLZI+P8ywTGmEkB8M+WZEk478NejY8gee9FVCi5bH+hgsQ3zLogdOs6h5dVaVsEC2IwXmQ50QWc2Vri03pdrqquKV1B1cz7+v5LkeA+zUqSilTduAr/6x7Bd99zZJar0puTzB8N5AEikaryNb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784902830; c=relaxed/simple;
	bh=+xzcvR0Ab2oEaU3Ut4c8tKYDVynRAw9pDoflEtm1LRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X++Ules6Erm6MsPlhqenS6xp+5F3K0IgmWiwIH3jrF29gtt+FGQwDBR481IWyhqlOf/7NV6pb+xXoY1M7Q6/MLvD2CQoK/jHhU9h4x4gPVBo2k7haDtNCRXt0GjSXfGrgtYIGWd2GO4/p1W22teTIIbJIk07Hjkw5NILCkedpTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbHu2MCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbHu2MCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45271F000E9;
	Fri, 24 Jul 2026 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784902829;
	bh=Z73spiwCN650D0YwBhUB8P3fZvlkJaEt6chGSBqtq70=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GbHu2MCyR72qe9KlUmy3OoIgcSD+YrKYOF667V6qUMzlzhqtOS4axQgfIBGeXysUf
	 AnfE2UJ+B2wPpgjrC7v7yWlh+8S99zkeNhZzxNLttQnMwdvAwq8zvUEmC8UE8wRvKu
	 li8vEJkxrEmxYXVj3h6R0BaYxIsfYGzgCdpC2hFU=
Date: Fri, 24 Jul 2026 16:20:18 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Zhou, Yun" <yun.zhou@windriver.com>
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+ad6118a7584b607c67f2@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
	vegard.nossum@oracle.com
Subject: Re: [PATCH 6.12 0309/1276] ext4: validate donor file superblock
 early in EXT4_IOC_MOVE_EXT
Message-ID: <2026072404-bleep-expensive-5cdd@gregkh>
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152453.007613078@linuxfoundation.org>
 <79f8b3b5-bbdb-415c-9211-ae1858cb5dd5@oracle.com>
 <59dae82b-5307-4018-8e17-8bd447b7271e@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <59dae82b-5307-4018-8e17-8bd447b7271e@windriver.com>

On Fri, Jul 24, 2026 at 10:06:39PM +0800, Zhou, Yun wrote:
> On 7/24/2026 9:02 PM, Harshit Mogalapalli wrote:
> > On 21/07/26 8:42 pm, Greg Kroah-Hartman wrote:
> > > diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> > > index c3758c64fc4e03..a8a024bb62b4f7 100644
> > > --- a/fs/ext4/ioctl.c
> > > +++ b/fs/ext4/ioctl.c
> > > @@ -1372,6 +1372,9 @@ static long __ext4_ioctl(struct file *filp,
> > > unsigned int cmd, unsigned long arg)
> > >                       goto mext_out;
> > >               }
> > > 
> > > +             if (file_inode(filp)->i_sb !=
> > > file_inode(fd_file(donor))->i_sb)
> > > +                     return -EXDEV;
> > > +
> > >               err = mnt_want_write_file(filp);
> > >               if (err)
> > >                       goto mext_out;
> > 
> > I have run an AI-assisted backport review and took a look at
> > d9db3e516000 ("ext4: validate donor file superblock early in
> > EXT4_IOC_MOVE_EXT").
> > 
> > Upstream c143957520c6 uses CLASS(fd, donor), so its new direct
> > return -EXDEV is safe: leaving the scope performs fdput(). The 6.12
> > backport instead uses an explicit fdget() and releases the donor only
> > via mext_out:
> > 
> >         + if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb)
> >         +        return -EXDEV; <---
> > 
> >           err = mnt_want_write_file(filp);
> >           if (err)
> >                  goto mext_out;
> > 
> > ...
> > mext_out:
> >          fdput(donor);
> > 
> > Thus the new cross-superblock return bypasses fdput(). In particular,
> > when the caller has a shared files_struct, fdget() obtains a counted
> > file reference, which is then leaked on this path.
> > 
> > I think the stable patch needs a small branch-specific adjustment:
> > set err = -EXDEV and goto mext_out instead of returning directly.
> > Thoughts? or we need to drop this and redo this again. I think impact is
> > mostly a leak/DoS risk but I still think we need to get this fixed.
> > 
> 
> You're right. The fix is simply:
> 
>    if (file_inode(filp)->i_sb != file_inode(fd_file(donor))->i_sb) {
>       err = -EXDEV;
>       goto mext_out;
>    }

Great, can someone send a fixup patch for this?

thanks,

greg k-h
