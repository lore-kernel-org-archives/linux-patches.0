Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCA67496
	for <patches@lists.linux.dev>; Fri, 14 Jul 2023 08:01:17 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 843231FD8E;
	Fri, 14 Jul 2023 08:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1689321676; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8U17kbz9Qkptcs1GwSYT3csRlRYjC4fhM5H0d02U/E=;
	b=odJB0X3qOZtM7xGukmtCbfRh9tQcXwNUCh9xJy4OArvO5BukiOADI4s2idS1syBbnam+zD
	lxM+AW7ZV44CSH2OfWt/HqRBVGBYbjc23WFlgJKVwi30/2qgAuciKunAbz+0yZjcXABs2k
	Gz5+uU4OkOrF2XIoQ5OGsLiIfkH0Urg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1689321676;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q8U17kbz9Qkptcs1GwSYT3csRlRYjC4fhM5H0d02U/E=;
	b=aQQaKGxcoITzKyKP44+lF3oiDzLXl6huK7wAVryUOU7dge/jmHI5/IDab+h8UHpYUQ+8+C
	iLYe1lUDzp8idCDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4513513A15;
	Fri, 14 Jul 2023 08:01:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id KeAdEMwAsWQDSAAAMHmgww
	(envelope-from <vbabka@suse.cz>); Fri, 14 Jul 2023 08:01:16 +0000
Message-ID: <7c33a6c3-4ded-e0e4-820d-ffc337da9800@suse.cz>
Date: Fri, 14 Jul 2023 10:01:15 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/2] mm/slub: remove freelist_dereference()
From: Vlastimil Babka <vbabka@suse.cz>
To: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 Matteo Rizzo <matteorizzo@google.com>, Jann Horn <jannh@google.com>,
 Andrey Konovalov <andreyknvl@google.com>, Marco Elver <elver@google.com>,
 Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com,
 linux-hardening@vger.kernel.org
References: <20230711134623.12695-3-vbabka@suse.cz>
 <20230711134623.12695-4-vbabka@suse.cz> <202307110917.DEED145F0@keescook>
 <b18ca2ce-5ebc-1a38-bb9d-a8bb9070cdb1@suse.cz>
Content-Language: en-US
In-Reply-To: <b18ca2ce-5ebc-1a38-bb9d-a8bb9070cdb1@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/23 09:44, Vlastimil Babka wrote:
> On 7/11/23 18:21, Kees Cook wrote:
>> On Tue, Jul 11, 2023 at 03:46:25PM +0200, Vlastimil Babka wrote:
>>>  
>>>  #ifndef CONFIG_SLUB_TINY
>>> -- 
>>> 2.41.0
>>> 
>> 
>> I like reducing the complexity here, but I find dropping the "object"
>> reassignment makes this a bit harder to read. What about:
> 
> Alright.
> 
>> 	object = kasan_reset_tag(object);
>> 	unsigned long ptr_addr = (unsigned long)object + s->offset;
>> 	freeptr_t p = *(freeptr_t *)(ptr_addr);
> 
> Are we really so benevolent with declaration-after-statement now? :)

I've left the declarations separate for now so it's similar to
get_freepointer_safe(). Pushed the result to slab/for-6.6/cleanup and
for-next. Thanks for the reviews!

>> 	return freelist_ptr_decode(s, p, ptr_addr);
>> 
>> ?
>> 
>> They're the same result, so either way:
>> 
>> Acked-by: Kees Cook <keescook@chromium.org>
>> 
> 

