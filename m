Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C01F29CA
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 14:25:59 +0000 (UTC)
Received: by mail-qv1-f53.google.com with SMTP id u16so17369308qvk.4
        for <patches@lists.linux.dev>; Tue, 14 Dec 2021 06:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4CJNUkLQ95R/HuXRfbt5kTDCyUiZWcPKbo8o+BZ2P9o=;
        b=3Kar3KrUGMnENoK3rNq3UQzjiOvLaqzPD83UIv8tsIehXxyeyaJoX+WgRzjQ5dr89T
         CfdbVI6gbThVAHrSMkb3BGNqgi+1l5j+2zXv0GIKLHqTeSH8YG4mfYeyd6T75XtSkiDK
         lDg3dOwie+FYdbQmkoJWs7qAXzfQ6dqx7tiGbuacOKBSErxjtz+77Y4RDbK1CWZyCCg5
         51oOMJ5MgKA6wIdc2zFxBWIyR5jv50kEu1QTzWSnrwBd6tEZNSxXozbf4FFki+6pPfV6
         wr6Vzd322WkxY9uhKmDyDDuDG8W4OjB34YRTIN/eU3WXBTtdxW79A4plqDpOCKe/Kmf4
         3yGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4CJNUkLQ95R/HuXRfbt5kTDCyUiZWcPKbo8o+BZ2P9o=;
        b=RRPMHb2XnAFuauZ2KYXZE3/N5/3sIfVJNPfNtJh+j0QKphwzTPHIfllT8cY3Z63O4z
         c212lWIZA6aYQCDrH0vbNbzrfW6JSCV4v0xMYKE3aYfWTg2JwX0Y+I9od5LcjaGxmew7
         LTy7R1hlqzkMq+uyxq4CVZ23F0mqstWRpQXBKDxMTOheT1Pue98VeFGzkJ4jcYk/2i8j
         d1zW7ENcVevbvFDVegBwuRensxb0isKIxIUfaR6ltzZHNcdn1HJ8QnSvztRQb0VNcpAW
         95q5vJ3jf5T47Y7OSRb0/A587UqtDZrgOK+tq9sBrLvXlUqfW4Sj3iq1FKPHmy/6vGiu
         Tv4w==
X-Gm-Message-State: AOAM531P91ue+YjuT9ledpARcWWNcMRKOFfbufdq5Vw1xAvQxc4vimNx
	YHIm+kCq5sT0kjn2jcLtpnwhqdoShSkrvw0/
X-Google-Smtp-Source: ABdhPJxguFNpnz2C/xkeG81bhcyW8p3toTDAZe9gt+T8Cch1L7L/cY3aiDW6YlR4z6NJzaecuciERA==
X-Received: by 2002:a05:6214:2609:: with SMTP id gu9mr5869620qvb.97.1639491958415;
        Tue, 14 Dec 2021 06:25:58 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:e1e4])
        by smtp.gmail.com with ESMTPSA id f34sm53610qtb.7.2021.12.14.06.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:25:58 -0800 (PST)
Date: Tue, 14 Dec 2021 15:25:55 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 05/33] mm: Add account_slab() and unaccount_slab()
Message-ID: <Ybipc3WleEW7oIhN@cmpxchg.org>
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-6-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211201181510.18784-6-vbabka@suse.cz>

On Wed, Dec 01, 2021 at 07:14:42PM +0100, Vlastimil Babka wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> These functions take struct slab instead of struct page and replace
> (un)account_slab_page(). For now their callers just convert page to slab.
> 
> [ vbabka@suse.cz: replace existing functions instead of calling them ]
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
