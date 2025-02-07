Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8378C71747;
	Fri,  7 Feb 2025 20:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738961209; cv=none; b=ZWsWxe8dENW5wHX5x6n+yFTdxCrJE9L8cFgfaayLYKqEAFD7h3HDLURlwe4xhPPQWMUIsRspu+Ibai5XMK6AE9YvxskJCpKHanA5nK6C5CI4/BiBRk8hhL8IwbZyUmTYpE64u3rTULMMq4MVJxu+90UZipmlmZwhrPabng2OREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738961209; c=relaxed/simple;
	bh=1fYUJ+LhYeoDWIm+VOurfFaBDo1s6mGKw0VzRhYPhAc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GD+oEw5b3fYPf2KoFvwXy5bxlGzJUan97UVoMFl8kJVQBcO0bv5aTVlFiObqrukhksFS40dY4iwLyDGgcNyqcAZ2dMeatdoFoR+AU8l53ijlpzzzu0LTB2SfS+fTdyLH90/tU1feGP12ReRhFGsb8rijGoKaPT9CtDwMV//9//w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ou01An6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ou01An6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF79BC4CEE2;
	Fri,  7 Feb 2025 20:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738961209;
	bh=1fYUJ+LhYeoDWIm+VOurfFaBDo1s6mGKw0VzRhYPhAc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ou01An6jn/wT7n67rjrvNN+YGi+kDGXB9ZgOqjKiAavICJ+15ugnu1oXlhrgsrp1c
	 AiB1mKOkExQFve8I/Jm0pmBIKRMIH8S4FTrfdbff7nTJ07WS/Q7fSVWcM+qjoloHpD
	 BPtvSLhC4fSW+LnGKXbknYHjsyjEhmfXPzShtL6QgEhYKg+zJIbduSliGbVYoNstAv
	 ykXeZLJmxyIrHJc5E/X0wa72efiqouN5iL9mlVSc6U37MnxkoEEsTCO2voXA4p1F2V
	 8eNjV0lNN6xC2tpTfQgdZI4h7deTb+WBPvWzMu4BnG48eMqkovJRbhlN8q5oSJhrfR
	 a3+0FwAy8Sbsw==
Date: Fri, 7 Feb 2025 12:46:47 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"hare@suse.de" <hare@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: [PATCH blktests v2 4/4] common/xfs: check for max supported
 sector size
Message-ID: <Z6ZxNznj2MLoq2_4@bombadil.infradead.org>
References: <20250204225729.422949-1-mcgrof@kernel.org>
 <20250204225729.422949-5-mcgrof@kernel.org>
 <7ug4nasddicvqix5wjw5mbvjurvgdxmmj6j7i5xgb4dlozswjd@okvt2f3qfj32>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ug4nasddicvqix5wjw5mbvjurvgdxmmj6j7i5xgb4dlozswjd@okvt2f3qfj32>

On Fri, Feb 07, 2025 at 11:58:29AM +0000, Shinichiro Kawasaki wrote:
> On Feb 04, 2025 / 14:57, Luis Chamberlain wrote:
> > mkfs.xfs will use the sector size exposed by the device, if this
> > is larger than 32k this will fail as the largest sector size on XFS
> > is 32k. Provide a sanity check to ensure we skip creating a filesystem
> > if the sector size is larger than what XFS supports.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  common/xfs | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/common/xfs b/common/xfs
> > index 8b068837fa37..dbae572e4390 100644
> > --- a/common/xfs
> > +++ b/common/xfs
> > @@ -15,11 +15,18 @@ _xfs_mkfs_and_mount() {
> >  	local mount_dir=$2
> >  	local bs=$(_min_io $bdev)
> >  	local xfs_logsize="64m"
> > +	local sysfs="/sys/block/${bdev#/dev/}"
> > +	local logical_block_size=$(cat $sysfs/queue/logical_block_size)
> >  
> >  	if [[ $bs -gt 4096 ]]; then
> >  		xfs_logsize="128m"
> >  	fi
> >  
> > +	if [[ $logical_block_size -gt 32768 ]]; then
> > +		SKIP_REASONS+=("max sector size for XFS is 32768 but device $bdev has a larger sector size $logical_block_size")
> 
> Adding SKIP_REASONS here is not ideal, since this function is called from
> test() or test_device(). It's the better to check the requirement in
> requires() or device_requires(), before touching the test target devices.
> 
> If test() calls _xfs_mkfs_and_mount(), the test case should be able to
> control the sector size smaller than 32k, so no need to check the
> requirement.

I see, I'll fix.

> I think block/032 and nvme/012 fall in this category.

Indeed. I also noted _min_io() needs to return 4096 by default too as we
want to use it as default in case we get a lower value to retain
backward compatbility. That fixed some block/032 and nvme/012 issues
with 512 min-io values.

  Luis
