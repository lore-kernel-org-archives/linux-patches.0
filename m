Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152B214532C;
	Sun, 30 Jun 2024 20:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719780172; cv=none; b=NdNPpIBJQknCeQoBY8CeF7m4oPwgUnYX65riEpnGsss/N/cb4Hxld9q/xsvshxKtqIoSh8d2gHJeNdZ7m0fZLqylcBzA8E12KHwl7gbGsOtbsL9PFNBB9PPF5P0D+FnGENhgPGXOArAdkA25LEiwuU/yHdUXsP+2Dy0K1TnCMB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719780172; c=relaxed/simple;
	bh=lbBafADEkEaqDBQaN6jcW6aY0X5GhnIsg+P9SGsv4GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wi8LRRBm3ByWszqP/eATdy3qM7BByHAwuktp/fsZkO9AcAker6HSG19W3UplSaWmIgR5Jq/jSY4bmMfhkfw9OT/70ScXN86htSibLClDMdcAqY9MTXqb7IsAHfY8Jg2dpymNBLrFQZCl5lCitaXurWmJYkaPSKNMkPgJ5iMI32U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eZxNcw+n; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eZxNcw+n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EEDwXxAH5hVi2e+sIf29tXbBOc6lcXR1V9m+i/ZIVgk=; b=eZxNcw+nVHspGGMuJkgfHQVEZ/
	8az/MqFP0jxI74bWxKIIGEXOAnT6kwPgjqLpDaWkQJJ94nCgz+WU5v3vtsMPbDgwbzSKICEDLIaYm
	7Gel/IKa3PZuCG6Zp9nN+6a2eEeUV/H/TLx+Qdb7IQbOpSFH5w6aAb9W1YVHUxJ3YSxqBZ4zqkMJq
	85Oq+A/CZNCfqbuaQjkNMSRXi7UWnsLkrjsYXiOZrnBfuxFiCzdzFEYHzW8k6qCtCrrTxv36pptGl
	pBKNbL/cviJBFEt11Sj+mDCcJUGue8hEHHsvw+6dO+xmFWmaJf8RV1/VsZ7f9NpsOwjcb8UuYrCsh
	HzCmlHWQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sO1Nl-000000011Fu-2N7w;
	Sun, 30 Jun 2024 20:42:45 +0000
Date: Sun, 30 Jun 2024 13:42:45 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: martin.petersen@oracle.com, ebiggers@google.com, p.raghav@samsung.com,
	hare@suse.de, kbusch@kernel.org, david@fromorbit.com, neilb@suse.de,
	gost.dev@samsung.com, linux-block@vger.kernel.org,
	linux-mm@kvack.org, patches@lists.linux.dev
Subject: Re: [RFC] bdev: use bdev_io_min() for statx DIO min IO
Message-ID: <ZoHDRfMomK8hnDXI@bombadil.infradead.org>
References: <20240628212350.3577766-1-mcgrof@kernel.org>
 <Zn-o3jQj4RkJobjS@infradead.org>
 <ZoDP0LgeLV3H1JbB@bombadil.infradead.org>
 <ZoDzC1qlEYTBkLPA@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZoDzC1qlEYTBkLPA@infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Sat, Jun 29, 2024 at 10:54:19PM -0700, Christoph Hellwig wrote:
> On Sat, Jun 29, 2024 at 08:24:00PM -0700, Luis Chamberlain wrote:
> > > The minimum_io_size clearly is the minimum I/O size, not the minimal
> > > nice to have one. 
> > 
> > I may have misread the below documentation then, because it seems to
> > suggest this is a performance parameter, not a real minimum. Do we need
> > to update it?
> 
> queue_limits.min_io is corretly described and a performance hint.

OK, great!

> The statx dio_offset_align is actual minimum I/O size and alignment and
> not in any way related to the performance hint in minimum_io_size.

Oh, darn, I just read again 825cf206ed510 ("statx: add direct I/O
alignment information") and the block layer change through commit
2d985f8c6b91b ("vfs: support STATX_DIOALIGN on block devices") and
no where do I see any mention of it being  a min. Should we clarify
that?

And should we add a respective value for performance? I suspect
userspace will want to work with optimal values, not ones which could
for instance incur read-modify-write. Altough we have BLKIOMIN to get
the optimal performance min IO and BLKIOOPT to get the optimal size it
is not terribly clear to me that users know they should prefer to align
to BLKIOMIN and use that for an DIO size for writes when possible.

  Luis
