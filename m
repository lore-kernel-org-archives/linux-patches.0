Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B509133987;
	Tue, 20 Feb 2024 21:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463160; cv=none; b=YAhAxWOgWcaP05nIg9fIjzYNxrfZ5rH3QDF5tfD64XdoRsdSkzsWvfwIVY2p7mXSYwnoAE+2laCKAlSSWrCJAwmvUCmwxHy2sD1RjbcfJTUyGHEtwM3NFu80hjhnyd9wOsUQ2WlxFmwwdNXycq6KhhW4GBBptoRe6/YpaEMLOqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463160; c=relaxed/simple;
	bh=3PEnCicm7d7FJerC2Sg9l9EcEk6FCpxF0h6pYwk7t+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qS/nOMMGS/jxhrBc7WJYRKo0HYmF02WvjLxi8V+z3cONaZpH1EEQFg8bvCwkRNiTfk6by2IbvhaC326iaSkMtmpbl9WZqCg84CkDBYNvS8RlsD6T40i78aTNrHFLWrTeptuBDudBLF0pmvaM61CaJJyDdpy332tiQXdu6xTJ8f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Knq6D+XR; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Knq6D+XR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b1oaZ4uPiDGpYZmU+3jdrqrbCDfnpJTHzkrQ6aiwH5o=; b=Knq6D+XRs7VpPpG/F1RiBblhWt
	duwbEZfSwWDZ77y/IVlyyoLq3CWl8N0ofIgfjAlTjcfrra308BB72QdyR5IfhcR4An01KCd1DizzL
	7W08mg6LdEYCVwCmpPzOtg48CIbG8xocwspBZvJHjDYyDhD7jX1J/u5gz4Zjjad6GwPe4wkKBEirC
	Ttkvhqdf640cOz9gudwX5y8XjHY9UTyWnBzxAaCu1OzqNuV1lwMlbw+eRkvmakP9Hj2Sq0t1GDREG
	R3RgrwK2QXayeH2uvRgdBZuIkSoreBSHKl4KNUSqgXmGBlsvx3mUqkM1xbcbHx2A3W6Adlbfxge8P
	Q31nNdjQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rcXJJ-0000000GZBe-2EW1;
	Tue, 20 Feb 2024 21:05:53 +0000
Date: Tue, 20 Feb 2024 21:05:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>, Guo Xuenan <guoxuenan@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.1 036/197] readahead: avoid multiple marked readahead
 pages
Message-ID: <ZdUUMQOoGtZkyYVO@casper.infradead.org>
References: <20240220204841.073267068@linuxfoundation.org>
 <20240220204842.159580701@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220204842.159580701@linuxfoundation.org>

On Tue, Feb 20, 2024 at 09:49:55PM +0100, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.

Maybe hold off on this one?

kernel test robot noticed a -21.4% regression of vm-scalability.throughput on:
commit: ab4443fe3ca6298663a55c4a70efc6c3ce913ca6 ("readahead: avoid multiple marked readahead pages")

https://lore.kernel.org/linux-fsdevel/202402201642.c8d6bbc3-oliver.sang@intel.com/

Not a definite no just yet; nobody's dug into it, but some caution
seems warranted.

> ------------------
> 
> From: Jan Kara <jack@suse.cz>
> 
> commit ab4443fe3ca6298663a55c4a70efc6c3ce913ca6 upstream.
> 
> ra_alloc_folio() marks a page that should trigger next round of async
> readahead.  However it rounds up computed index to the order of page being
> allocated.  This can however lead to multiple consecutive pages being
> marked with readahead flag.  Consider situation with index == 1, mark ==
> 1, order == 0.  We insert order 0 page at index 1 and mark it.  Then we
> bump order to 1, index to 2, mark (still == 1) is rounded up to 2 so page
> at index 2 is marked as well.  Then we bump order to 2, index is
> incremented to 4, mark gets rounded to 4 so page at index 4 is marked as
> well.  The fact that multiple pages get marked within a single readahead
> window confuses the readahead logic and results in readahead window being
> trimmed back to 1.  This situation is triggered in particular when maximum
> readahead window size is not a power of two (in the observed case it was
> 768 KB) and as a result sequential read throughput suffers.
> 
> Fix the problem by rounding 'mark' down instead of up.  Because the index
> is naturally aligned to 'order', we are guaranteed 'rounded mark' == index
> iff 'mark' is within the page we are allocating at 'index' and thus
> exactly one page is marked with readahead flag as required by the
> readahead code and sequential read performance is restored.
> 
> This effectively reverts part of commit b9ff43dd2743 ("mm/readahead: Fix
> readahead with large folios").  The commit changed the rounding with the
> rationale:
> 
> "...  we were setting the readahead flag on the folio which contains the
> last byte read from the block.  This is wrong because we will trigger
> readahead at the end of the read without waiting to see if a subsequent
> read is going to use the pages we just read."
> 
> Although this is true, the fact is this was always the case with read
> sizes not aligned to folio boundaries and large folios in the page cache
> just make the situation more obvious (and frequent).  Also for sequential
> read workloads it is better to trigger the readahead earlier rather than
> later.  It is true that the difference in the rounding and thus earlier
> triggering of the readahead can result in reading more for semi-random
> workloads.  However workloads really suffering from this seem to be rare.
> In particular I have verified that the workload described in commit
> b9ff43dd2743 ("mm/readahead: Fix readahead with large folios") of reading
> random 100k blocks from a file like:
> 
> [reader]
> bs=100k
> rw=randread
> numjobs=1
> size=64g
> runtime=60s
> 
> is not impacted by the rounding change and achieves ~70MB/s in both cases.
> 
> [jack@suse.cz: fix one more place where mark rounding was done as well]
>   Link: https://lkml.kernel.org/r/20240123153254.5206-1-jack@suse.cz
> Link: https://lkml.kernel.org/r/20240104085839.21029-1-jack@suse.cz
> Fixes: b9ff43dd2743 ("mm/readahead: Fix readahead with large folios")
> Signed-off-by: Jan Kara <jack@suse.cz>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Guo Xuenan <guoxuenan@huawei.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  mm/readahead.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -483,7 +483,7 @@ static inline int ra_alloc_folio(struct
>  
>  	if (!folio)
>  		return -ENOMEM;
> -	mark = round_up(mark, 1UL << order);
> +	mark = round_down(mark, 1UL << order);
>  	if (index == mark)
>  		folio_set_readahead(folio);
>  	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
> @@ -591,7 +591,7 @@ static void ondemand_readahead(struct re
>  	 * It's the expected callback index, assume sequential access.
>  	 * Ramp up sizes, and push forward the readahead window.
>  	 */
> -	expected = round_up(ra->start + ra->size - ra->async_size,
> +	expected = round_down(ra->start + ra->size - ra->async_size,
>  			1UL << order);
>  	if (index == expected || index == (ra->start + ra->size)) {
>  		ra->start += ra->size;
> 
> 
