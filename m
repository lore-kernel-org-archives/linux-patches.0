Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09AA168
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:58:35 +0000 (UTC)
Received: by mail-qv1-f46.google.com with SMTP id i13so17467410qvm.1
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iaC0YCrtT/rPnmyhp7ihbk8Lz4SJ7WcXKR/+CdI7JPM=;
        b=7Q7WS5d2agfo/F4H2fyAqAVNN2cmqwTaFwxyXYsv2JYh/s6qiEap6mBg5w5RBxc0/K
         JzAkUY5/7qOiXf4yEDA7DAA1PmV6nueRs1NLsDBydR4iAIDRaOzl+3L74lP1o8iUCNVZ
         RSxCjbX7WJMjAYwr/pGWLvZueqgV2MZ6ZOk79vneH5DiUeRgtCUxjDGjqO9hRX2BcNtJ
         ht+NPrOCiy/yAll11aMUyPcovgTKGWHr7pPa1PUNekVAQ/xWRzho1sVfhCuY9ehVUs6J
         nZPls2aUTLgGEI3SEe2z+eL4RW6SkLe+EWSKzxXNGUQpLkIVRAWwON3UMTRD3nbSTr5b
         l8ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iaC0YCrtT/rPnmyhp7ihbk8Lz4SJ7WcXKR/+CdI7JPM=;
        b=XT7mAw8d2LYEHHLrN/lpum4QgVVpDGYY4xJRueTR3ZFh4JEgnucjJZ5M+dSY85qjLm
         IrYXgICk7J9rOk0Q0LZ8aIFjXE1yMIvNGT+5qwYzIebt+4zat81ouZj1RVzAjdZQo03t
         MEuGi4AZ8C5hN8Zp2NmEOlLF4es2D44H+o+Fm2Xy/ksuqBsQmjtTo981hYu4/K3/ISZS
         X2ViDoUYi1tHZc6WHYKWRuuA0LoJcNTGhoFfm4APPK9frdoqln2P34zNywGGFVtZhHai
         k7cdNfk7pLRehEBKBMpYks9xTGgnVWoXUw2T6x0bXSzn6LyJlbertxE15etQMUoTlDFB
         dOBA==
X-Gm-Message-State: AOAM533dHFSZR8gw8TlIX56p7fqLENQiD+gHJ1fy/iC2xdiI1B33UEYP
	N0AzvgG8m3bu3A9PxcWbffmhiQ==
X-Google-Smtp-Source: ABdhPJyuER9txNmgBZfmekASFj+TvGxo1FSb3OsVQUh/JENKsWaKJ4qLColYbWniBQqraMK+xv266g==
X-Received: by 2002:a05:6214:c42:: with SMTP id r2mr5792582qvj.69.1639493914598;
        Tue, 14 Dec 2021 06:58:34 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id d15sm75772qtd.70.2021.12.14.06.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:58:34 -0800 (PST)
Date: Tue, 14 Dec 2021 15:58:31 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v2 27/33] zsmalloc: Stop using slab fields in struct page
Message-ID: <YbixF1aqq+rDy5J1@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-28-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-28-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:15:04PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> The ->freelist and ->units members of struct page are for the use of slab
> only.  I'm not particularly familiar with zsmalloc, so generate the same
> code by using page->index to store 'page' (page->index and page->freelist
> are at the same offset in struct page).  This should be cleaned up
> properly at some point by somebody who is familiar with zsmalloc.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
