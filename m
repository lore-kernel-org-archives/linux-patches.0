Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149829CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:24:53 +0000 (UTC)
Received: by mail-qk1-f174.google.com with SMTP id p4so16831119qkm.7
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6ZhNyxZ+/TQ4WsAmdsb0cRpOF/CcnnWOZZylVjAI/M8=;
        b=ifOZJ8qK1boo4M0TOXjc2YRoL/2yBNK5mhlaCojsjw1q7pStrJjH+ViMSwdmeX8XJ5
         JUBQ8cRg7icQa7IB3j7e7C7MEFhQy9OZl8bCrbhcsRedL8P62lPdxR3/xkihXfDLrAXS
         sSi2fC3QSdt+eNSupe2M9T1oHxidgI0QOUkhZRfly6hDfjGkU9PPegka8UBWE3jORsMf
         RgEGxhrWLy15rUOSXDgc00IvgZf4gx0fZBvxlydUDaQQ2rWt3ffu44L9OKFePfsz0n5l
         cj9jecu9s72/ZjOb8clr+DHwYlYa0yUVoH4oK+7H4IkeXCeWfuMzzLbGOwlVaT1gAVtZ
         A3FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6ZhNyxZ+/TQ4WsAmdsb0cRpOF/CcnnWOZZylVjAI/M8=;
        b=qg18orrB+/w5ZvA5AmtRHCGCTxKKOWXyM8PKBBPwOqqbSqgwc8G1BpjnAysM//+Y3N
         PhRW6UPD9JZSi+BfmpftXDoODSPWc9k8vJe52J9c3ASDIwkA2owVUTJZY9goW6U7QTbA
         DI3EWmntkLsXfnRrMnQaQP7uGw5o2LBqoKxO79FcQvyAnEIWN/finVwX2OBz+hyUL08g
         ABV3ZdEv68fMalzvyUJDK35TIwU1EFj/BP5oSalzSDuOR9ybeNIEm9TzON5lVV/SHMW2
         IW+VcsgQN1xf8MxOFCC3EaAi/zJtV2wwHcNCYcgFoFpSfT49giwKsNcUPD05rI1bDBo1
         I1Tw==
X-Gm-Message-State: AOAM532AinIvEvrSNXzgIq7F133pTzSanXxWjRAHQtYyTswMFzAWhjMP
	t6TLc73RietK9ZxBPsaW18t9Xg==
X-Google-Smtp-Source: ABdhPJzqKvPZa20V6sdeC2p3P4Ju0XqUP6Ryi/y06fYLAn/YKFN/FEshhCfjTnXVve6veolOkGyUug==
X-Received: by 2002:a37:747:: with SMTP id 68mr4249578qkh.227.1639491892557;
        Tue, 14 Dec 2021 06:24:52 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id x1sm32689qtj.9.2021.12.14.06.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:24:52 -0800 (PST)
Date: Tue, 14 Dec 2021 15:24:49 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 04/33] mm: Split slab into its own type
Message-ID: <YbipMSj4YbzjkqSj@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-5-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-5-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:14:41PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> Make struct slab independent of struct page. It still uses the
> underlying memory in struct page for storing slab-specific data,
> but slab and slub can now be weaned off using struct page directly.
> Some of the wrapper functions (slab_address() and slab_order())
> still need to cast to struct folio, but this is a significant
> disentanglement.
> 
> [ vbabka@suse.cz: Rebase on folios, use folio instead of page where possible.
> 
>   Do not duplicate flags field in struct slab, instead make the related
>   accessors go through slab_folio(). For testing pfmemalloc use the
>   folio_*_active flag accessors directly so the PageSlabPfmemalloc wrappers can
>   be removed later.
> 
>   Make folio_slab() expect only folio_test_slab() == true folios and
>   virt_to_slab() return NULL when folio_test_slab() == false.
> 
>   Move struct slab to mm/slab.h.
> 
>   Don't represent with struct slab pages that are not true slab pages, but
>   just a compound page obtained directly rom page allocator (with large
>   kmalloc() for SLUB and SLOB). ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
