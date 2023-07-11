Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3B318AFE
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 16:14:51 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3a1ebb85f99so5099836b6e.2
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 09:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1689092090; x=1691684090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vq9YViWYg4uFChvJGSLE3j7fYiOn1S8zzbS7MgZUOXM=;
        b=JnU40aqXrl+cQXJk+/mWGhypL/UL4FW42fibfXNLp4FDHbP6XSKttylnrv712ddyCS
         QQiAkK4VyodEzrwPiYTOu3AnXnDvRdzb3zq1Eb9j/1HiZN1ZbrRv0XaTUkXjQRh/C60X
         aRnapaN/LqPA5iZkV1sZtWXCNBY011f1uE2TI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689092090; x=1691684090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vq9YViWYg4uFChvJGSLE3j7fYiOn1S8zzbS7MgZUOXM=;
        b=BicE8bFHnPEHFu3ulJUMGuRgBq5VWidYFmhYKugGKtTe7njnEgpN0sydTJ1vOKWuGB
         04OwGKpzpxnMiX84i0+kcsFK7DBml+jwDI12iST8M6BREeri6DsTp0+HKxkdGqvN7ANn
         NhVKh4ei5ZLdymAriaw7t3A8i1qC6+pUlE5qJRqVZwgz7FOlptsZTUbTFtr6B+qV92qW
         ZGY1wV3aALIdIMbpuVmEKHQOuJ3wI/Fd8dFsacaj8eTwh3mwVJOVWHR4QjL7MjRdeswr
         nbxiZhTJn6SsWZ9+Rf+UJTA5qJpwOThX907uONQdBv1jA1LYeHutQMwybdES0/HLHxfZ
         qDGw==
X-Gm-Message-State: ABy/qLavA4Q3vzrZtUDyeS9uyCBhbTjyKdVPgNnUA3GRIL/QvdYuKNG/
	lL3b9/FX4ZJ88s0oegHDDqZetA==
X-Google-Smtp-Source: APBJJlHccKfb9VbDm1W28Cl55SHynKCuE6YH+AftvD/+oHJ7aeij8ZFnaHC/iLkVZXwDULUqM4kjfQ==
X-Received: by 2002:a05:6358:290b:b0:134:e4c4:ebff with SMTP id y11-20020a056358290b00b00134e4c4ebffmr16820772rwb.11.1689092090568;
        Tue, 11 Jul 2023 09:14:50 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id c10-20020a63724a000000b0055386b1415dsm1802755pgn.51.2023.07.11.09.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 09:14:49 -0700 (PDT)
Date: Tue, 11 Jul 2023 09:14:49 -0700
From: Kees Cook <keescook@chromium.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
	Andrey Konovalov <andreyknvl@google.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slub: remove redundant kasan_reset_tag() from
 freelist_ptr calculations
Message-ID: <202307110914.8D460C7@keescook>
References: <20230711134623.12695-3-vbabka@suse.cz>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711134623.12695-3-vbabka@suse.cz>

On Tue, Jul 11, 2023 at 03:46:24PM +0200, Vlastimil Babka wrote:
> Commit d36a63a943e3 ("kasan, slub: fix more conflicts with
> CONFIG_SLAB_FREELIST_HARDENED") has introduced kasan_reset_tags() to
> freelist_ptr() encoding/decoding when CONFIG_SLAB_FREELIST_HARDENED is
> enabled to resolve issues when passing tagged or untagged pointers
> inconsistently would lead to incorrect calculations.
> 
> Later, commit aa1ef4d7b3f6 ("kasan, mm: reset tags when accessing
> metadata") made sure all pointers have tags reset regardless of
> CONFIG_SLAB_FREELIST_HARDENED, because there was no other way to access
> the freepointer metadata safely with hw tag-based KASAN.
> 
> Therefore the kasan_reset_tag() usage in freelist_ptr_encode()/decode()
> is now redundant, as all callers use kasan_reset_tag() unconditionally
> when constructing ptr_addr. Remove the redundant calls and simplify the
> code and remove obsolete comments.
> 
> Also in freelist_ptr_encode() introduce an 'encoded' variable to make
> the lines shorter and make it similar to the _decode() one.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Thanks, this is much more readable!

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
