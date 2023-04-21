Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4F12F24
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=m1e8oWBFoE6cQzJQhP6tkmJTF5BRaTgWrs55dNNPGgw=; b=Smrt+UFGINhHo2Xrc2HQAomUpt
	KdADUqVFMhwxbRWcmREvw1bQBiMRmv7u1VHSLfO2r5em1Zj/XxTAmw7/HcUR9ttQaF8d2Diefdw5D
	uoOtzyqYMfwT0U2ruXS6u6GrihqG+LVtt0vIr5CDhAK044jw6tnpZR3cyj05xH1uyLXFnDn6VrPEw
	gDyQonGbIXXkHeEJRLBmWe+u9G6HvUBs46RoibpsVWVWM0htT4eotGxHKOtZ4TZBsk9CJ3yt5Prei
	aviVAba62+KGLTyAuC4pZQGaPad4uPr+wnbwU9BXDzPk/txPucorIgTpV2x7DbBnOHFLXUIBD/soV
	vZjX6KMQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1ppzSv-00Fi3h-IU; Fri, 21 Apr 2023 22:42:53 +0000
Date: Fri, 21 Apr 2023 23:42:53 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/8] shmem: convert to use folio_test_hwpoison()
Message-ID: <ZEMRbcHSQqyek8Ov@casper.infradead.org>
References: <20230421214400.2836131-1-mcgrof@kernel.org>
 <20230421214400.2836131-3-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421214400.2836131-3-mcgrof@kernel.org>

On Fri, Apr 21, 2023 at 02:43:54PM -0700, Luis Chamberlain wrote:
> The PageHWPoison() call can be converted over to the respective folio call
> folio_test_hwpoison(). This introduces no functional changes.

Um, no.  Nobody should use folio_test_hwpoison(), it's a nonsense.

Individual pages are hwpoisoned.  You're only testing the head page
if you use folio_test_hwpoison().  There's folio_has_hwpoisoned() to
test if _any_ page in the folio is poisoned.  But blindly converting
PageHWPoison to folio_test_hwpoison() is wrong.

If anyone knows how to poison folio_test_hwpoison() to make it not
work, I'd appreciate it.

> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  mm/shmem.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5bf92d571092..6f117c3cbe89 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3483,7 +3483,7 @@ static const char *shmem_get_link(struct dentry *dentry,
>  		folio = filemap_get_folio(inode->i_mapping, 0);
>  		if (IS_ERR(folio))
>  			return ERR_PTR(-ECHILD);
> -		if (PageHWPoison(folio_page(folio, 0)) ||
> +		if (folio_test_hwpoison(folio) ||
>  		    !folio_test_uptodate(folio)) {
>  			folio_put(folio);
>  			return ERR_PTR(-ECHILD);
> @@ -3494,7 +3494,7 @@ static const char *shmem_get_link(struct dentry *dentry,
>  			return ERR_PTR(error);
>  		if (!folio)
>  			return ERR_PTR(-ECHILD);
> -		if (PageHWPoison(folio_page(folio, 0))) {
> +		if (folio_test_hwpoison(folio)) {
>  			folio_unlock(folio);
>  			folio_put(folio);
>  			return ERR_PTR(-ECHILD);
> @@ -4672,7 +4672,7 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
>  		return &folio->page;
>  
>  	page = folio_file_page(folio, index);
> -	if (PageHWPoison(page)) {
> +	if (folio_test_hwpoison(folio)) {
>  		folio_put(folio);
>  		return ERR_PTR(-EIO);
>  	}
> -- 
> 2.39.2
> 
