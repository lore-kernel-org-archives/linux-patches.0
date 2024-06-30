Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6455A47;
	Sun, 30 Jun 2024 03:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719717847; cv=none; b=t9CdQZIip3sQW9JCJe0S5WFaeNYWoznUe22ZSuTzqY/7hektGP84uR9xUZMtFFMtz2KGtGah874XQ0z01UNvgM7mrp4P2RgCXP4sHmc6lZHAlRVlFqyYDHMDgkJ0Qud7eg3W9B6RGFM8O2IcrH/BckQGKONisb+/sNcETr4oUPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719717847; c=relaxed/simple;
	bh=YTuELgDB0s2AVDlkCmDo3JFtEK4S7yL0csKaTMsvk6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEdNyDLKF4vGWnPF9lUbKBdrxr6iy7pRzp21a9EVJQ2ls2no88adoz1bOblJVgurZvprFmpRnAkCjFWmm0atJM+ZD+M0Gdt+FzswIkMV5f8+fMejXab7SH1qXKNyQSqEw7EQV0UKjWH6rCoWcPipNUd+qPUgvWjFelaDaFTz99Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ERUYqH4B; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ERUYqH4B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ylz6vqCuJzZf1PIz6xhbAzUrEmmlhojw5Hi3FLPU+YI=; b=ERUYqH4BdWzr1zw6sPM/8JroWj
	havIqKNQ2lFdqbOSxHpyoGlFp6KQsPUaBTrdPKHvGNzdMqc7a9IZlSlKbkItyComMQZIBK/6t8QxT
	uBqsvGd3a7LaDW38k3NEOk+Ip5X8D3NqUAXQkBAyU0HURZdT4SRPwYuZ9fevhJlCYYJTQikJYuGkv
	ro7fgL1mkFPYQAUzBJzs8RkMAuJ3l9Fmvx2YqjyPdHrIP9KbFETIVDWyrkytOCDWJv1g9e45GX0tx
	Fuu1KrxjBOsWnk3PVLVfACszP+2kRyOAGBBsJQ8o9geDWtaYN1DOSQ0UldMGbKfrlHiTuxQtLcZb/
	KSfZaQBw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNlAW-0000000HJS6-2N0N;
	Sun, 30 Jun 2024 03:24:00 +0000
Date: Sat, 29 Jun 2024 20:24:00 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com,
	ebiggers@google.com
Cc: p.raghav@samsung.com, hare@suse.de, kbusch@kernel.org,
	david@fromorbit.com, neilb@suse.de, gost.dev@samsung.com,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	patches@lists.linux.dev
Subject: Re: [RFC] bdev: use bdev_io_min() for statx DIO min IO
Message-ID: <ZoDP0LgeLV3H1JbB@bombadil.infradead.org>
References: <20240628212350.3577766-1-mcgrof@kernel.org>
 <Zn-o3jQj4RkJobjS@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zn-o3jQj4RkJobjS@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Fri, Jun 28, 2024 at 11:25:34PM -0700, Christoph Hellwig wrote:
> On Fri, Jun 28, 2024 at 02:23:50PM -0700, Luis Chamberlain wrote:
> > We currently rely on the block device logical block size for the
> > offset alignment. While this *works* it doesn't work with performance
> > in mind. That's exactly what the minimum_io_size attribute is for.
> > 
> > This would for example enhance performance for DIO on 4k IU drives which
> > have for example an LBA format of 512 bytes for both HDDs and NVMe.
> > Another use case is to ensure that DIO will be used with 16k IOs on
> > existing market 16k IU drives with an LBA format of 4k or 512 bytes.
> 
> The minimum_io_size clearly is the minimum I/O size, not the minimal
> nice to have one. 

I may have misread the below documentation then, because it seems to
suggest this is a performance parameter, not a real minimum. Do we need
to update it?

What:           /sys/block/<disk>/queue/minimum_io_size
Date:           April 2009
Contact:        Martin K. Petersen <martin.petersen@oracle.com>
Description:
                [RO] Storage devices may report a granularity or preferred
                minimum I/O size which is the smallest request the device can
                perform without incurring a performance penalty.  For disk
                drives this is often the physical block size.  For RAID arrays
                it is often the stripe chunk size.  A properly aligned multiple
                of minimum_io_size is the preferred request size for workloads
                where a high number of I/O operations is desired.

If this is not the right place, do we need to use a new topology entry
for the IU? Today the NVMe drive uses it for the NPWG which these days
is the IU.

> Changing this will break existing setups.

My impression was that STATX_DIOALIGN was rather new, so any new
enhancements due to the difficulties in getting DIO alignment right,
this was the right place to do so.

Let me  know if you have other suggestions.

  Luis
