Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497404A3E;
	Sat,  4 Jan 2025 04:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735963807; cv=none; b=ch0KblgbaEoueYA0Fq2uFW0SNmwlymgp4pElypMZ4nhFgmb1bo9GpNJIpesNhGP2PtIhcx+CNaRUpJx4lSI+CDq2VTXOiM/m0jMh/w3a9XCAQMip8CkhHInpkLAMLNJl6vuqLijlcr8jx33kJNYWjZbNspNoBw5IoFbmuSDeGsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735963807; c=relaxed/simple;
	bh=R9EiuKyaHVJXyVyeCs2TLB7u2aRjbjTaxwvfzcJ/BPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pu2Y7Z9cztpTL2cWcABG6NTBQ7sSxILS3R4lUVjewnqWCgWJEvCnbBqjjFKop2bqqD0OW9DcEVJ4//Lw8aBfN1uUMaEkhY1pAuZAEbL7DqfqrOjFtpE5exNW9TLMoGBGJHuBFlzB90h6+51QqX0N9Or419j78weWYatAfDZQfMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mb2ejfpt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mb2ejfpt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3CBC4CED1;
	Sat,  4 Jan 2025 04:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735963804;
	bh=R9EiuKyaHVJXyVyeCs2TLB7u2aRjbjTaxwvfzcJ/BPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mb2ejfptAaUqONw6WfBzZ9X+yZhwdwuL1I+ppi2DdP3Lsiv9FoPwIij0e9rR/l5V3
	 dbhJXWmqWL/5Ti3liSL3+hXKSNVs8D3Jt/D/Y0utya+TDtmDe1ADUY+DT9llUhfzJ9
	 ifJGWCcoTpKz9pthLG537zL9+MPZV0bj4hPPT0prPUlMrVMOq9a+v8TqisRhclkTk6
	 /wUPeSDTkotwScAiBxdyRJgmOz7Yg0lzF24sfw5FaxtTd4K8iCrAh1WSkAxcnBqXKB
	 JwkazH63SheKzMzvQrAx+GgNOfXuG5tGDIEBtXQ+gQdHGXY4LQw7nEqf8AiyMeG/uo
	 9MccHuilhLqVA==
Date: Fri, 3 Jan 2025 20:10:03 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests 1/4] common: add and use min io for fio
Message-ID: <Z3i0mwKXBUiut3DN@bombadil.infradead.org>
References: <20241218112153.3917518-1-mcgrof@kernel.org>
 <20241218112153.3917518-2-mcgrof@kernel.org>
 <dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4@oktw5u5q6jki>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dn545vjkmyinrejvdfb45ve6xa3cebbcwvhdajkxzbhtl2yww4@oktw5u5q6jki>

On Mon, Dec 23, 2024 at 09:37:48AM +0000, Shinichiro Kawasaki wrote:
> Hi Luis, thanks for this patch. Please find my comments in line.
> 
> On Dec 18, 2024 / 03:21, Luis Chamberlain wrote:
> > When using fio we should not issue IOs smaller than the device supports.
> > Today a lot of places have in place 4k, but soon we will have devices
> > which support bs > ps. For those devices we should check the minimum
> > supported IO.
> > 
> > However, since we also have a min optimal IO, we might as well use that
> > as well. By using this we can also leverage the same lookup with stat
> > whether or not the target file is a block device or a file.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  common/fio |  6 ++++--
> >  common/rc  | 10 ++++++++++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> > 
> > diff --git a/common/fio b/common/fio
> > index b9ea087fc6c5..5676338d3c97 100644
> > --- a/common/fio
> > +++ b/common/fio
> > @@ -192,12 +192,14 @@ _run_fio() {
> >  # Wrapper around _run_fio used if you need some I/O but don't really care much
> >  # about the details
> >  _run_fio_rand_io() {
> > -	_run_fio --bs=4k --rw=randread --norandommap --numjobs="$(nproc)" \
> > +	local test_dev_bs=$(_test_dev_min_io $TEST_DEV)
> 
> Some of the test cases that calls _run_fio_rand_io  can not refer to $TEST_DEV
> e.g., nvme/040. Instead of $TEST_DEV, the device should be extracted from the
> --filename=X option in the arguments.

Sure, I will fix all that, it will make it clearer its not always
TEST_DEV.

> I suggest to introduce a helper function
> as follows (_min_io is the function I suggest to rename from _test_dev_min_io).
> 
> # If --filename=file option exists in the given options and if the
> # specified file is a block device or a character device, try to get its
> # minimum IO size. Otherwise return 4096 as the default minimum IO size.
> _fio_opts_to_min_io() {
>         local arg dev
>         local -i min_io=4096
> 
>         for arg in "$@"; do
>                 [[ "$arg" =~ ^--filename= ]] || continue
>                 dev="${arg##*=}"
>                 if [[ -b "$dev" || -c "$dev" ]] &&
>                            ! min_io=$(_min_io "$dev"); then
>                         echo "Failed to get min_io from fio opts" >> "$FULL"
>                         return 1
>                 fi
>                 # Keep 4K minimum IO size for historical consistency
>                 ((min_io < 4096)) && min_io=4096

But here the file may be a regular file, and if you use 4k as the
default on a 16k XFS filesystem it won't work. This can be simplified
because using statx block size would be then be the correct thing to do
for a file. Then, it so turns out the the min-io can be obtained by
the same statx call to a block device as well.

Thoughts?

  Luis
