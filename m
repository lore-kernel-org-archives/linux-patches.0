Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647C229CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:28:21 +0000 (UTC)
Received: by mail-qk1-f169.google.com with SMTP id a11so16829506qkh.13
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:28:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0mEhtUHa3In092LmFmhKJEI0iaOCZlUUVXCaetRX6yo=;
        b=3noOipxlcOqvV7IUx9TxpmIpufDyVpNVRvbJ9PXJXgXLNA2TjMILUiDlLVI0LUIhiP
         wXLLwE44ulXTaJNKPwl+Q5NUK5mFIYb1FDXkG+nc3btXkYGlWDBsILIyXvBPUZZGGtfG
         BahbRYodtKSSV2vvgYNdq36jDWWAs6O62NK7HEaVfYVOfM9dqzG4VjItRwBntTnDO3ca
         hKs29fEGkiYQfaev8jeGQWP9QpmYiseRktHmJqS41RRCEw6yq+GZJUw15M640bngTNJF
         xrKPHqt638XoytQyy910uyCt2PDSTeIcX3CC1mneu3RVDkxP8KRn2t+J6GqgAnEqB422
         r0Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0mEhtUHa3In092LmFmhKJEI0iaOCZlUUVXCaetRX6yo=;
        b=TdjO96NaODHJSUvhS/l2M8HUfdaSPvwpESfG+gNRER9T8bTtOXNeeh7pJVsweqB8ec
         lWz89yE0AGiJWA9ZzbkhOHhl120HneBV20Jl2QPR58f9MZheCUx98viCwKD8ajgNiIr/
         tOVFmDKJJ6nzWtxummlQm5rgjFjlunpvX/ONHDnVAHPZtbF+N8SlN1s/E6LcoEzZIqSn
         pHA8lY9F5syTx6KwulOa+X/3nqofZt/msShW1TuHg0m7dZA80cNBJ19eXGty8H2SP0La
         cLZxh0Vnmlyj6x3GQ8z+7jE2U0X68nCn2vOf9ZvvC4lGK8tsfZuv6/btvzbQ4VQ0V34N
         4O8g==
X-Gm-Message-State: AOAM533L/LRhCW8TGZsXkvaMzXNTTzNFE9VmtZlgqtONacDfGj0JGlIC
	7cX6qgDBrB6yUiUuugXqy6y16Q==
X-Google-Smtp-Source: ABdhPJzmyIjJbeXrsKQTgThfe8Qk3T74+v8nY1M5Xo32hGFboszz1/WB8WbuwqojQPh5dhivXO2yLA==
X-Received: by 2002:a05:620a:ccc:: with SMTP id b12mr4260001qkj.147.1639492100394;
        Tue, 14 Dec 2021 06:28:20 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id 22sm42704qtw.12.2021.12.14.06.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:28:20 -0800 (PST)
Date: Tue, 14 Dec 2021 15:28:17 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 07/33] mm: Convert __ksize() to struct slab
Message-ID: <YbiqARAqznAss8oT@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-8-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-8-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:14:44PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> In SLUB, use folios, and struct slab to access slab_cache field.
> In SLOB, use folios to properly resolve pointers beyond
> PAGE_SIZE offset of the object.
> 
> [ vbabka@suse.cz: use folios, and only convert folio_test_slab() == true folios
>   to struct slab ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Awesome.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
