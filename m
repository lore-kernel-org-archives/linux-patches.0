Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E67A2C99
	for <patches@lists.linux.dev>; Fri, 10 Dec 2021 18:26:14 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2F3C21116;
	Fri, 10 Dec 2021 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1639160771; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/UbW0ZhlY6juPUlloosi+upV54XzRqkoxBUDz/LC9M=;
	b=DEzJI8fLtSoX6HvwvsaUUn0wt8ZXfQaUFovygnNB1R0Pjgpk9THshxWraDr+00h4T0XZ8F
	eJbKUG1U/boAamOw+tE+CBBvxQBEy+JEpE6x3Ojs85hRnBsoYOFNgZTG83rjRZ1ufMnIkQ
	0ghuEU8PvONkJU4PQusTW2f5PNaCI+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1639160771;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z/UbW0ZhlY6juPUlloosi+upV54XzRqkoxBUDz/LC9M=;
	b=wWBxwUM4UrZ3mtHbY4xKX4SrU2C6KfZlUvLflJXG2vtIVtnNfCgVN9zEkO3CcvsY4lPUrj
	p/dOzudjFAfWkDCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 654F713BFF;
	Fri, 10 Dec 2021 18:26:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id tB0uF8Obs2GwKgAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 10 Dec 2021 18:26:11 +0000
Message-ID: <f3f02e1e-88b2-a188-1679-9c6256d19c7a@suse.cz>
Date: Fri, 10 Dec 2021 19:26:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
 Marco Elver <elver@google.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
References: <20211201181510.18784-1-vbabka@suse.cz>
 <20211201181510.18784-32-vbabka@suse.cz> <20211210163757.GA717823@odroid>
From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2 31/33] mm/sl*b: Differentiate struct slab fields by
 sl*b implementations
In-Reply-To: <20211210163757.GA717823@odroid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/10/21 17:37, Hyeonggon Yoo wrote:
> On Wed, Dec 01, 2021 at 07:15:08PM +0100, Vlastimil Babka wrote:
>> With a struct slab definition separate from struct page, we can go further and
>> define only fields that the chosen sl*b implementation uses. This means
>> everything between __page_flags and __page_refcount placeholders now depends on
>> the chosen CONFIG_SL*B.
> 
> When I read this patch series first, I thought struct slab is allocated
> separately from struct page.
> 
> But after reading it again, It uses same allocated space of struct page.

Yes. Allocating it elsewhere is something that can be discussed later. It's
not a simple clear win - more memory used, more overhead, complicated code...

> So, the code should care about fields that page allocator cares when
> freeing page. (->mapping, ->refcount, ->flags, ...)
> 
> And, we can change offset of fields between page->flags and page->refcount,
> If we care about the value of page->mapping before freeing it.
> 
> Did I get it right?

Yeah. Also whatever aliases with compound_head must not have bit zero set as
that means a tail page.

>> Some fields exist in all implementations (slab_list)
>> but can be part of a union in some, so it's simpler to repeat them than
>> complicate the definition with ifdefs even more.
> 
> Before this patch I always ran preprocessor in my brain.
> now it's MUCH easier to understand than before!
> 
>> 
>> The patch doesn't change physical offsets of the fields, although it could be
>> done later - for example it's now clear that tighter packing in SLOB could be
>> possible.
>>
> 
> Is there a benefit if we pack SLOB's struct slab tighter?

I don't see any immediate benefit, except avoiding the page->mapping alias
as you suggested.

> ...
> 
>>  #ifdef CONFIG_MEMCG
>>  	unsigned long memcg_data;
>> @@ -47,7 +69,9 @@ struct slab {
>>  	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
>>  SLAB_MATCH(flags, __page_flags);
>>  SLAB_MATCH(compound_head, slab_list);	/* Ensure bit 0 is clear */
>> +#ifndef CONFIG_SLOB
>>  SLAB_MATCH(rcu_head, rcu_head);
> 
> Because SLUB and SLAB sets slab->slab_cache = NULL (to set page->mapping = NULL),

Hm, now that you mention it, maybe it would be better to do a
"folio->mapping = NULL" instead as we now have a more clearer view where we
operate on struct slab, and where we transition between that and a plain
folio. This is IMHO part of preparing the folio for freeing, not a struct
slab cleanup as struct slab doesn't need this cleanup.

> What about adding this?:
> 
> SLAB_MATCH(mapping, slab_cache);
> 
> there was SLAB_MATCH(slab_cache, slab_cache) but removed.

With the change suggested above, it wouldn't be needed as a safety check
anymore.

>> +#endif
>>  SLAB_MATCH(_refcount, __page_refcount);
>>  #ifdef CONFIG_MEMCG
>>  SLAB_MATCH(memcg_data, memcg_data);
> 
> I couldn't find any functional problem on this patch.
> but it seems there's some style issues.
> 
> Below is what checkpatch.pl complains.
> it's better to fix them!

Not all checkpatch suggestions are correct and have to be followed, but I'll
check what I missed. Thanks.

> WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
> #7: 
> With a struct slab definition separate from struct page, we can go further and
> 
> WARNING: Possible repeated word: 'and'
> #19: 
> implementation. Before this patch virt_to_cache() and and cache_from_obj() was
> 
> WARNING: space prohibited between function name and open parenthesis '('
> #49: FILE: mm/kfence/core.c:432:
> +#elif defined (CONFIG_SLAB)
> 
> ERROR: "foo * bar" should be "foo *bar"
> #73: FILE: mm/slab.h:20:
> +void * s_mem;/* first object */
> 
> ERROR: "foo * bar" should be "foo *bar"
> #111: FILE: mm/slab.h:53:
> +void * __unused_1;
> 
> ERROR: "foo * bar" should be "foo *bar"
> #113: FILE: mm/slab.h:55:
> +void * __unused_2;
> 
> ---
> Thanks,
> Hyeonggon.

