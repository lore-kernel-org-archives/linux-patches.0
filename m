Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C153D69;
	Sat, 29 Jun 2024 06:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719642339; cv=none; b=iZ6qJdddIli5gRjemik3w5FSVEllcSWc+FnJrQc4+RquAUHTgVWUxidaHDTmiBiezYVUn0gAjq39FuF0lm9SyZfgtHt+EfRUzME/cO8digj39dHmKL0BoaUJfSohgjc3+Dz5tRqpORyl2GlXDyMj/JS8qOx4cwzchvXtHxqBAiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719642339; c=relaxed/simple;
	bh=fs48/52NADoG38JxBDzweblcs7YENA8fbMWo1V11K3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PpoqJ2OUSrVV4VpVxLeoe1OFeLvKEc7rJiebol9AbFXW/Zi3qzaZaqL3x9fBuc/slpLXkP2DaAH5lMQh5RYPUk6n/MnzxgkTz5AMG+tg5AX2+uwvGpowtLV7+EPrlzxfEdLBEPVNZLA8PP89JhVuTVFevQLCw3eCrEn51GTScs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cbPxcAT3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cbPxcAT3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jF9YptaNEcUba9vHIIDGNCL4tXi5jsBItIWsaKNJPwg=; b=cbPxcAT3Gh3u2Oz3d7cmQVA67k
	347sgcuute+AWlp4+E7nY+LkVucOZZalnmncbVo28Ij1pWEBh87fgItCyKJUbmUKDuFXSmSGxjnag
	JtrpNd5T6b57FdFYWoeycdTF+hQwU20E6FjE9hu1qIQUzTktVbPkhd+vQIP7Akg431skZZhkHev1j
	23nQWUdYuEKMBFWH6FeezVP08ObPx8gl4GxgxAITn6pkvvkGd4lN49Dxiw0mavc1MOagQjwlyb87+
	hLmTLtV25YjxKuD5ihXB8J92uBMslXNFAV9dEk9XqoZIdYZXmlNrhV6spFSu0xi2CfZ9QHQtmWUjL
	Z8VBY0Jw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sNRWg-0000000G0B4-2Z6g;
	Sat, 29 Jun 2024 06:25:34 +0000
Date: Fri, 28 Jun 2024 23:25:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: p.raghav@samsung.com, hare@suse.de, kbusch@kernel.org,
	david@fromorbit.com, neilb@suse.de, gost.dev@samsung.com,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	patches@lists.linux.dev
Subject: Re: [RFC] bdev: use bdev_io_min() for statx DIO min IO
Message-ID: <Zn-o3jQj4RkJobjS@infradead.org>
References: <20240628212350.3577766-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240628212350.3577766-1-mcgrof@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Jun 28, 2024 at 02:23:50PM -0700, Luis Chamberlain wrote:
> We currently rely on the block device logical block size for the
> offset alignment. While this *works* it doesn't work with performance
> in mind. That's exactly what the minimum_io_size attribute is for.
> 
> This would for example enhance performance for DIO on 4k IU drives which
> have for example an LBA format of 512 bytes for both HDDs and NVMe.
> Another use case is to ensure that DIO will be used with 16k IOs on
> existing market 16k IU drives with an LBA format of 4k or 512 bytes.

The minimum_io_size clearly is the minimum I/O size, not the minimal
nice to have one.  Changing this will break existing setups.

