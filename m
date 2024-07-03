Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DC13DDD3;
	Wed,  3 Jul 2024 12:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720009962; cv=none; b=sacQPE+7B8BRlQmPdeWljEVFliTHs2NvxuoIfZDXOjr4vS4wChsHJ7mpt+kpoy+06R9UCtIU80F2CSlkqVyLnJffhLPyt7B74Tj9lXMxR6pC6ZXUMOvEmO91snMPhdkE9JMkeTxsuh80KomI9Ohes9GlRLLSgZr5tbSrtX7b+cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720009962; c=relaxed/simple;
	bh=DM2p1NLEURC4vLbJ5fwuFCXuX68Fky+XI6wY4XFaVX0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bfMG/DFpL40QEaY54/ngWZv5xojvSEIW2L+UO6EWzF/Ot1dB3snpOSV3vKEiQR9QEObccGGI3/dQgL3uhXcBawBNhtXqkHtxGsIqdX3M2KbNxdIkUXqrOCCqw/kqiosPwbEJ2nrbN+d9cf08mLMPDelO8v3hKbtaUfU/7kWd0vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YvkQuW3L; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YvkQuW3L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oT5x1BRWHTtzs46y9z/r4KPl8eY01NHj5LtX0weEUsU=; b=YvkQuW3Lm0b+RSxW/Xoecnk0Qu
	uZ3X45bqmwnp4DA0U7dVT1o3AgXZne0noNpO93taN1QZ1aMWDQPXkUtxPqVeCZvJeXvedrHuv+WZv
	akvAS19XK68yfun94SHwJmM/053nrjWFAbnM1JcsGRhtLKUcsMT4KZeKI1L3rUzAkAmdVqvyPwpNv
	hPKxj+cbiHXcaH8fr7/XTvLBwjeHsO0+s7WoHLyRju0ooQE6WwIzbO60a8z3FdqNX317UURQKjAxR
	9Hshsz64HQqZec1xGS6cnWUo1nUO6UUiMfz+EZ8ZvzPhGTabB79ly4yX9Hvi2xhShGqUO9OTFvO0u
	mh1L9b1g==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sOzA0-00000001otM-0HqV;
	Wed, 03 Jul 2024 12:32:32 +0000
Date: Wed, 3 Jul 2024 13:32:31 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
	Christoph Lameter <cl@linux.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <keescook@chromium.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v2] slab, rust: extend kmalloc() alignment guarantees to
 remove Rust padding
Message-ID: <ZoVE34S2fOyUdZYg@casper.infradead.org>
References: <20240703072520.45837-2-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703072520.45837-2-vbabka@suse.cz>

On Wed, Jul 03, 2024 at 09:25:21AM +0200, Vlastimil Babka wrote:
> -	if (is_power_of_2(size))
> -		align = max(align, size);
> +	if (flags & SLAB_KMALLOC)
> +		align = max(align, 1U << (ffs(size) - 1));

hmm ... maybe this would be faster:

	if (flags & SLAB_KMALLOC) {
		u32 tmp = size & (size - 1);
		align = max(align, size - tmp);
	}

(if size is 2^n, tmp is 0.  otherwise, tmp is size with the lowest bit
clear, so size-tmp is the largest POT that divides size evenly)
