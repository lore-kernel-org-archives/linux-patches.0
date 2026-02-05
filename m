Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B633EF0C3;
	Thu,  5 Feb 2026 14:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770300389; cv=none; b=HCHjElV/rYhBCnmKsQMG9sHnHJaxKezz6paGCAI9d/7bS3a+sys5ehnu4bHgBUoOClsxvaq5MDeohN7NlZ2uSUlwJytSy767bi7YW6nyn+tOZ5eOOpwXy61nG6iR1olPCeTBmoXvcsvacG3Fw7CeYbvXf/gPO1BjvMeAtL+qBjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770300389; c=relaxed/simple;
	bh=Kp1IlxE0CR1DcVOJJSGnomgR9IVWBXNDq5XKUGX23MA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HMPd5BWDvE6JRR0/sRtbhviSb3/bG614eqCSY8538CIZ4S/ELKpx/01PCQbJTNm5NmZoShgu3FJMwknUDckpv169isPgUYulwqPRJeULaNoOjeH/VdJ35Eeo7Zz7GsXmcsaaCWK/J6wHkUA/c3mF/Lqf4pnokf5Zid1hKk509AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8WJek5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8WJek5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF59C4CEF7;
	Thu,  5 Feb 2026 14:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770300389;
	bh=Kp1IlxE0CR1DcVOJJSGnomgR9IVWBXNDq5XKUGX23MA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8WJek5OMLLHzWN5sihBk/O6od7+gwX8l3k4yPi5pMre7v227U4kjqr49CIigINPw
	 vfBGuvEvdvlWlOCeUs7iNB3LAluAtyDAX2t7m23cvDCenrMalXg6kjGYCn+UZ46eC3
	 gzcKZhJDZNS/cYcXMXk3KT2RcDcfaFgEWnr5BeVs=
Date: Thu, 5 Feb 2026 15:06:26 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Sterba <dsterba@suse.cz>
Cc: Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
	patches@lists.linux.dev, Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 004/161] btrfs: send: check for inline extents in
 range_is_hole_in_parent()
Message-ID: <2026020514-oat-plant-b273@gregkh>
References: <20260204143851.755002596@linuxfoundation.org>
 <20260204143851.919366239@linuxfoundation.org>
 <03a74299797f4864d0e563cd9517276f690a4bf0.camel@decadent.org.uk>
 <20260205135118.GX26902@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205135118.GX26902@suse.cz>

On Thu, Feb 05, 2026 at 02:51:18PM +0100, David Sterba wrote:
> On Wed, Feb 04, 2026 at 07:28:42PM +0100, Ben Hutchings wrote:
> > On Wed, 2026-02-04 at 15:37 +0100, Greg Kroah-Hartman wrote:
> > > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Qu Wenruo <wqu@suse.com>
> > > 
> > > [ Upstream commit 08b096c1372cd69627f4f559fb47c9fb67a52b39 ]
> > > 
> > > Before accessing the disk_bytenr field of a file extent item we need
> > > to check if we are dealing with an inline extent.
> > > This is because for inline extents their data starts at the offset of
> > > the disk_bytenr field. So accessing the disk_bytenr
> > > means we are accessing inline data or in case the inline data is less
> > > than 8 bytes we can actually cause an invalid
> > > memory access if this inline extent item is the first item in the leaf
> > > or access metadata from other items.
> > > 
> > > Fixes: 82bfb2e7b645 ("Btrfs: incremental send, fix unnecessary hole writes for sparse files")
> > > Reviewed-by: Filipe Manana <fdmanana@suse.com>
> > > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > > Reviewed-by: David Sterba <dsterba@suse.com>
> > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  fs/btrfs/send.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > > index d86b4d13cae48..f144171ed6b7e 100644
> > > --- a/fs/btrfs/send.c
> > > +++ b/fs/btrfs/send.c
> > > @@ -5892,6 +5892,8 @@ static int range_is_hole_in_parent(struct send_ctx *sctx,
> > >  		extent_end = btrfs_file_extent_end(path);
> > >  		if (extent_end <= start)
> > >  			goto next;
> > > +		if (btrfs_file_extent_type(leaf, fi) == BTRFS_FILE_EXTENT_INLINE)
> > > +			return 0;
> > 
> > This will leak path, unless (at least) commits 4c74a32ad323 "btrfs:
> > DEFINE_FREE for struct btrfs_path" and 4ca6f24a52c4 "btrfs: more trivial
> > BTRFS_PATH_AUTO_FREE conversions" are also backported.
> > 
> > That could be avoided by using { ret = 0; goto out; } here instead of
> > simply returning.
> 
> Right, the original patch assumes the automatic cleanup of btrfs_path, so
> for anything below it needs to be updated as you say.

Thanks for the review, I'll go drop this from all of the queues now.

greg k-h
