Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC26356751;
	Fri, 31 Jul 2026 06:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785478065; cv=none; b=m7la+YVelqkzPkN2t+aJwD6GgaWkmM6SSOSNmfLUm29HN9HkperULZ+eCMstU1VYSRrtlz3gf/0zw5WUBIW7CGN3zj6CzVuOqLeoyrqSZTKSvpZVnPYWpnJZ2QeRP/Gfs+FHg1XHTzN7qLLjOQVD4RlocbHgOrg6nK4qLAp2nrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785478065; c=relaxed/simple;
	bh=WaNdN+YQuV0PIYy8AFzhGPMHE+BepQ0e2VLF6AjfEMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rfbuidhk9t/d0Fmita/QFm09NA1FYPPiljAj2VWKGPGy7lsMjC6SVl5jJkzev/PR9ZNWGz+Jw/USI8bROUGZr+LsQYLcV+7Rf4gT1MzMjVrH1GEVRcpkI9uhmdXcPBXiNd/1O9mgj6Hpb6Hpms5f4TktNM+nSmAVXecaNjIyDrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hr7H8Ara; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hr7H8Ara"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A6A1F000E9;
	Fri, 31 Jul 2026 06:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785478063;
	bh=tSaQcQO13V9eH1T+8uK2VpcXOjUx0fX6Ia1smb5+GIQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hr7H8Araf/h1q8yhZed3sMeLAaH/DInMeSfq7/g6+yXWtxaF4uoAzd8ROUXu6wnFK
	 pnGZU3f+mfDltD1+QWOPmxWvrv4zq1FnWm4a+u56Abr8YWwUwfhX9xO1K3MkarD8dX
	 P0p228cz27khvYFIcS4lEH12shHvKmX2vHKVbr8w=
Date: Fri, 31 Jul 2026 08:07:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Xiubo Li <xiubo.li@clyso.com>
Subject: Re: [PATCH 7.1 625/744] ceph: add owner/capability checks for
 CEPH_IOC_SET_LAYOUT*
Message-ID: <2026073115-tilt-lavender-4ca2@gregkh>
References: <20260730141444.267951807@linuxfoundation.org>
 <20260730141457.560203325@linuxfoundation.org>
 <CAOi1vP8Ka3cbvY-wKg-WE+oTWmuJwgQpwJ1-mxSU6YrbtMRyKQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP8Ka3cbvY-wKg-WE+oTWmuJwgQpwJ1-mxSU6YrbtMRyKQ@mail.gmail.com>

On Thu, Jul 30, 2026 at 07:39:26PM +0200, Ilya Dryomov wrote:
> On Thu, Jul 30, 2026 at 4:49 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Max Kellermann <max.kellermann@ionos.com>
> >
> > commit cee38bbf5556a8e0a232ccae41649580827d7806 upstream.
> >
> > These permission checks were already missing in the initial
> > impementation of these ioctls.  This Ceph allows any user who owns a
> > file descriptor to manipulate the layout of any file, even if they
> > don't have write permissions.
> >
> > It might be a good idea to guard other ioctls with permission checks
> > as well or even disallow regular users (even if they own the file) to
> > manipulate layout settings completely, as this may be abused to DoS
> > the Ceph servers, but right now, I find it most urgent to have setter
> > checks at all.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 8f4e91dee2a2 ("ceph: ioctls")
> > Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> > Reviewed-by: Xiubo Li <xiubo.li@clyso.com>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  fs/ceph/ioctl.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > --- a/fs/ceph/ioctl.c
> > +++ b/fs/ceph/ioctl.c
> > @@ -72,6 +72,9 @@ static long ceph_ioctl_set_layout(struct
> >         struct ceph_ioctl_layout nl;
> >         int err;
> >
> > +       if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
> > +               return -EACCES;
> > +
> >         if (copy_from_user(&l, arg, sizeof(l)))
> >                 return -EFAULT;
> >
> > @@ -142,6 +145,9 @@ static long ceph_ioctl_set_layout_policy
> >         int err;
> >         struct ceph_mds_client *mdsc = ceph_sb_to_fs_client(inode->i_sb)->mdsc;
> >
> > +       if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
> > +               return -EACCES;
> > +
> >         /* copy and validate */
> >         if (copy_from_user(&l, arg, sizeof(l)))
> >                 return -EFAULT;
> >
> >
> 
> Hi Greg,
> 
> There is a concern about the correctness of this patch, please drop it
> for now.

Ok, dropped now from all branches.  If you want it back, please let us
know in the future.

thanks,

greg k-h
