Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1A202F71;
	Wed, 12 Feb 2025 21:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739394445; cv=none; b=CA9gg4sJjm4xDFIZJxRhf7eohb9ag50qpPIIRZ/mG58Jn83Umpaj6H0+ZZEXvhvFsS/+Do421pKne7gnnzWKvziyVzyO+RsC/LVWtsPz7buHQOyyBm4/YegUkvFnrxgGeYRljzwB2z91CZOJ68ABucMtZQ2NZXP0C8LnLzte6X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739394445; c=relaxed/simple;
	bh=Zd2ozCgHFPXaxUEfps+NbIAbJ6erz4SWmSC0QBhXIcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p//3EUhaBu0X5NGNA+17KUCVi/GbaLdGU7u8D/xj/+lqRRMI0FdSm4CPJi8SK26tWK99ZN2oklCkrccLWm4sV7jUrZjhpBTypWmOMMHa/nrJGBohGjWsHR92fNkpoRRcnDtj3H4yX9mFEL5YaIV7Y2sBXxUv+gzzMTKwS0WgVTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eyh5OLmk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eyh5OLmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED95C4CEDF;
	Wed, 12 Feb 2025 21:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739394445;
	bh=Zd2ozCgHFPXaxUEfps+NbIAbJ6erz4SWmSC0QBhXIcs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Eyh5OLmkbTNvvT6k5bCTai7Iwb+ebGJO22iF1AXhPixBkHrzCkuWOQFTjJLgDNE4P
	 c/K+oTkhgLK6umKaIP0wG1uA9Mzn/nzVty3YHvLlsHucqBicQZmdLGopSgsY9mxcxm
	 yMHh78DUBWsNa4ps2XzsuuQk1KYDygQCDow8A4tR5VXUqxnLAGJpk1ZQNAF4vGE/05
	 nUgVPKZqmcOc9+q+5QeSiM5Vm9nEYAZlPDWQ22h5jwRwd1lA0wbNPil5eqqD7JJpWD
	 akhgzpYxj9hdFX+sFz4q2bRhewm9AXUIR0iLvBFnCj1yInjuSo0IQnSn/bEFIvqfqL
	 tD78bg0lvarSw==
Date: Wed, 12 Feb 2025 13:07:23 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: shinichiro.kawasaki@wdc.com, linux-block@vger.kernel.org, hare@suse.de,
	patches@lists.linux.dev, gost.dev@samsung.com
Subject: Re: [PATCH blktests v3 1/6] common/xfs: ignore first umount error on
 _xfs_mkfs_and_mount()
Message-ID: <Z60Ni_d7nv9wHVXl@bombadil.infradead.org>
References: <20250212205448.2107005-1-mcgrof@kernel.org>
 <20250212205448.2107005-2-mcgrof@kernel.org>
 <2e6ea8bc-6e9a-4434-8ffb-ec16ead86df4@acm.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e6ea8bc-6e9a-4434-8ffb-ec16ead86df4@acm.org>

On Wed, Feb 12, 2025 at 12:58:36PM -0800, Bart Van Assche wrote:
> On 2/12/25 12:54 PM, Luis Chamberlain wrote:
> > We want to help capture error messages with _xfs_mkfs_and_mount() on
> > $FULL, to do that we should avoid spamming error messages for things
> > which we know are not fatal. Such is the case of when we try to
> > mkfs a filesystem but before that try to umount the target path.
> > The first umount is just for sanity, so ignore the error messages from
> > it.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >   common/xfs | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 569770fecd53..67a3b8a97391 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -15,7 +15,7 @@ _xfs_mkfs_and_mount() {
> >   	local mount_dir=$2
> >   	mkdir -p "${mount_dir}"
> > -	umount "${mount_dir}"
> > +	umount "${mount_dir}" >/dev/null 2>&1
> >   	mkfs.xfs -l size=64m -f "${bdev}" || return $?
> >   	mount "${bdev}" "${mount_dir}"
> >   }
> 
> Shouldn't ">/dev/null 2>&1" be added to the _xfs_mkfs_and_mount()
> caller rather than inside the _xfs_mkfs_and_mount() implementation?
> The above patch makes it impossible for any caller to capture the
> stdout output of umount.

That is the point. In this case the umount *can* fail, we do it for
sanity purposes. We don't care if umount failed.

  Luis
