Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED70D2C80
	for <patches@lists.linux.dev>; Tue, 14 Dec 2021 11:51:41 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2DA891F37C;
	Tue, 14 Dec 2021 11:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1639482694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6efcRJNZehu3o7Pp7wg4mncnN1XYB+O+/iUJw08HrA=;
	b=N+yr/RKDb778O9AfUXUH/4yemRO/Zu1rSvAK5VnY52nbNOT76mWDQRs8hNmyy+U0JRiucy
	whr59dCe5Rs+RUD3pyl9/jwkMQ04++VkC2KrO48A5mSBHvTOc1ytmq6T8VdwbB9k0sb8ys
	H94tn0/2qk96UHeI1JZ9rT8liH072ws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1639482694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E6efcRJNZehu3o7Pp7wg4mncnN1XYB+O+/iUJw08HrA=;
	b=6UFyUQfv4IIfp73uEXTXyhRQ8rqAE6PiaC3V20jG7HRJtfQyHoixx/v9uHJc/3DUQPnd5o
	xCuleBbwOCKneNBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EC7E113BA4;
	Tue, 14 Dec 2021 11:51:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id VeH+OEWFuGGbeAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 14 Dec 2021 11:51:33 +0000
Message-ID: <765ffdf0-491b-1f44-21a4-d57138477daf@suse.cz>
Date: Tue, 14 Dec 2021 12:51:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] mm/slob: Remove unnecessary page_mapcount_reset()
 function call
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Christoph Lameter <cl@linux.com>,
 David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, patches@lists.linux.dev,
 Marco Elver <elver@google.com>, Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com
References: <20211212065241.GA886691@odroid>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20211212065241.GA886691@odroid>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/12/21 07:52, Hyeonggon Yoo wrote:
> After commit f1ac9059ca34 ("mm/sl*b: Differentiate struct slab fields
> by sl*b implementations"), we can reorder fields of struct slab
> depending on slab allocator.
> 
> For now, page_mapcount_reset() is called because page->_mapcount and
> slab->units have same offset. But this is not necessary for
> struct slab. Use unused field for units instead.
> 
> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>

Will add to the series, thanks!

> ---
>  mm/slab.h | 4 ++--
>  mm/slob.c | 1 -
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/slab.h b/mm/slab.h
> index 90d7fceba470..dd0480149d38 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -50,8 +50,8 @@ struct slab {
>  	struct list_head slab_list;
>  	void * __unused_1;
>  	void *freelist;		/* first free block */
> -	void * __unused_2;
> -	int units;
> +	long units;
> +	unsigned int __unused_2;
>  
>  #else
>  #error "Unexpected slab allocator configured"
> diff --git a/mm/slob.c b/mm/slob.c
> index 39b651b3e6e7..7b2d2c7d69cc 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -404,7 +404,6 @@ static void slob_free(void *block, int size)
>  			clear_slob_page_free(sp);
>  		spin_unlock_irqrestore(&slob_lock, flags);
>  		__ClearPageSlab(slab_page(sp));
> -		page_mapcount_reset(slab_page(sp));
>  		slob_free_pages(b, 0);
>  		return;
>  	}

