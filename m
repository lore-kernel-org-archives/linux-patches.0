Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2B1153828;
	Tue,  4 Feb 2025 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738695978; cv=none; b=PX3Cox4lpMDnHwWt4uJRcBExFtlbDu45e9E3zKOepEZ9sGBVPyBCewbmcZMYwG5QXH2CQo7ZbVTNkaUMSf6qSB46Lh7LsZxZJ/2yweJMjiSaaKJxGDYgybu+dJX8RHGME9J16AcRucrGLALAahhJzFSkWSOpl1hDXcywInBbNyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738695978; c=relaxed/simple;
	bh=KPY6FiGeI2uAKz4QBIHBmHTN/34Yd6fAL5zcch4KjRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q5QHXeXmzfMTXUGDf7eyp3JuOKsvclR2s+TBnV7A2Qr8f0QjwxrFn2jpZjqM60sMJ0VTrsyo6CM6/8kYLo06wsYHewcJIcWj/L4guGcTusuAbZLslmUow9bzLPujKJthsSDmmVzisRQLEWMgiAZZ2ZS1MojOgc0BDeoLWj97U+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdnusxaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdnusxaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6ABC4CEDF;
	Tue,  4 Feb 2025 19:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738695978;
	bh=KPY6FiGeI2uAKz4QBIHBmHTN/34Yd6fAL5zcch4KjRE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HdnusxaI90WGvCJINHmcHTv2Hdb6NOERcICiGiohUg08fBeptefdzRm3vtJgH7qb/
	 uA5LjjjyUy/NFeLSUV3hF7yvBxyOxHStjTozuVCwQfoJGC/4RkAM+GJGSOcYGczTJ6
	 JOuSQfnZxaixEienN/SggYDD1MJUFiqO8Aq5zP5zcB45MMoREhryRnU0wfxYf1Bnkb
	 TDvGbbhHzxDwiBN767jKYKZoJZUivAJq6wPS//WALcnMz74xgvgNB9kEIRV26sQWAi
	 wuE38b6/TQflXCa/gVYpoVZVTvsNirpzOB+pbYCiYjLX/j7StYV73ijjCd2C1l6yhS
	 /Qo2HGdx0Uq9g==
Date: Tue, 4 Feb 2025 11:06:16 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests 1/4] common: add and use min io for fio
Message-ID: <Z6JlKNhtRChvmMNR@bombadil.infradead.org>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
 <20241218112153.3917518-2-mcgrof@kernel.org>
 <dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4@oktw5u5q6jki>
 <Z3i0mwKXBUiut3DN@bombadil.infradead.org>
 <cjfenlexiawyze5trlgbpb4agu4olkosrgbfpyiuiefo4siott@smbcjylq2zwe>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cjfenlexiawyze5trlgbpb4agu4olkosrgbfpyiuiefo4siott@smbcjylq2zwe>

On Tue, Jan 07, 2025 at 05:19:01AM +0000, Shinichiro Kawasaki wrote:
> On Jan 03, 2025 / 20:10, Luis Chamberlain wrote:
> > On Mon, Dec 23, 2024 at 09:37:48AM +0000, Shinichiro Kawasaki wrote:
> > > Hi Luis, thanks for this patch. Please find my comments in line.
> > > 
> > > On Dec 18, 2024 / 03:21, Luis Chamberlain wrote:
> > > > When using fio we should not issue IOs smaller than the device supports.
> > > > Today a lot of places have in place 4k, but soon we will have devices
> > > > which support bs > ps. For those devices we should check the minimum
> > > > supported IO.
> > > > 
> > > > However, since we also have a min optimal IO, we might as well use that
> > > > as well. By using this we can also leverage the same lookup with stat
> > > > whether or not the target file is a block device or a file.
> > > > 
> > > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > > ---
> > > >  common/fio |  6 ++++--
> > > >  common/rc  | 10 ++++++++++
> > > >  2 files changed, 14 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/common/fio b/common/fio
> > > > index b9ea087fc6c5..5676338d3c97 100644
> > > > --- a/common/fio
> > > > +++ b/common/fio
> > > > @@ -192,12 +192,14 @@ _run_fio() {
> > > >  # Wrapper around _run_fio used if you need some I/O but don't really care much
> > > >  # about the details
> > > >  _run_fio_rand_io() {
> > > > -	_run_fio --bs=4k --rw=randread --norandommap --numjobs="$(nproc)" \
> > > > +	local test_dev_bs=$(_test_dev_min_io $TEST_DEV)
> > > 
> > > Some of the test cases that calls _run_fio_rand_io  can not refer to $TEST_DEV
> > > e.g., nvme/040. Instead of $TEST_DEV, the device should be extracted from the
> > > --filename=X option in the arguments.
> > 
> > Sure, I will fix all that, it will make it clearer its not always
> > TEST_DEV.
> > 
> > > I suggest to introduce a helper function
> > > as follows (_min_io is the function I suggest to rename from _test_dev_min_io).
> > > 
> > > # If --filename=file option exists in the given options and if the
> > > # specified file is a block device or a character device, try to get its
> > > # minimum IO size. Otherwise return 4096 as the default minimum IO size.
> > > _fio_opts_to_min_io() {
> > >         local arg dev
> > >         local -i min_io=4096
> > > 
> > >         for arg in "$@"; do
> > >                 [[ "$arg" =~ ^--filename= ]] || continue
> > >                 dev="${arg##*=}"
> > >                 if [[ -b "$dev" || -c "$dev" ]] &&
> > >                            ! min_io=$(_min_io "$dev"); then
> > >                         echo "Failed to get min_io from fio opts" >> "$FULL"
> > >                         return 1
> > >                 fi
> > >                 # Keep 4K minimum IO size for historical consistency
> > >                 ((min_io < 4096)) && min_io=4096
> > 
> > But here the file may be a regular file, and if you use 4k as the
> > default on a 16k XFS filesystem it won't work.
> 
> I guessed that the 16k XFS filesystem will allow 4k writes to regular files
> (In case this is wrong, correct me). 

If the filesystem has a 4k sector size it will be allowed, but if both
the fs block size and the fs sector size is 16k then no 4k IOs will be
allowed.

> Do you mean that 16k writes will be more
> appropriate blktests condition on 16k XFS filesystem?

And yes this too. Even if you do allow 4k writes with a 16k fs block
size but with a 4k fs sector size, you still want 16k IO writes on this fs.
One reason for exampe to want this is to avoid RMW which can happen on
4k IO writes.

> If this is the case, I agree with it.

Great.

> > This can be simplified
> > because using statx block size would be then be the correct thing to do
> > for a file. Then, it so turns out the the min-io can be obtained by
> > the same statx call to a block device as well.
> 
> Ah, now I see why you used the "stat --printf=%o" command.
> 
> I find that _xfs_run_fio_verify_io() and zbd/009,010 call _run_fio_verify_io()
> with the --directory fio option. To cover this case, _fio_opts_to_min_io() above
> will need change to cover both --filename and --directory options. When the
> --directory option is specified, we need to get the min_io size from the
> directory. Assuming that the "stat --printf=%o" command works for directories, I

Yes it does, this is with a 64k bs XFS fs:

stat --print=%o /mnt/poo
65536

The same fs statx would be used. Right now only XFS will
support LBS so its the only fs where we can test this currently on
x86_64.

The usage of statx --print=%o for this purpose is summarized in this
diagram:

https://docs.google.com/drawings/d/e/2PACX-1vQeZaBq2a0dgg9RDyd_XAJBSH-wbuGCtm95sLp2oFj66oghHWmXunib7tYOTPr84AlQ791VGiaKWvKF/pub?w=1006&h=929

> agree that this statx call approach will be simpler.

OK will follow through with this, thanks.

  Luis
