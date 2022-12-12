Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E6A23BD
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 10:54:36 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 47AFF3380E;
	Mon, 12 Dec 2022 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1670842469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jz7Lips898H9fEO8FHmnp/U+76VwTMZfI3iV22huR7g=;
	b=NPhcr4mM7jngyRfUkBlHonm+HGcTi0wz/1yZ/4z9opH+ikoBkU+eMJD5LcKrtJWEJ4kuRf
	8wlEC2fB9ooi/Y4TL1B6T2Cuzm6uZHe2EoSSUjlkUUvHFK9IEETO0fFBYk3gAhlLFldx33
	+L31eHsss/i+cwP6azCY7+7Zc3kd0uM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1670842469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jz7Lips898H9fEO8FHmnp/U+76VwTMZfI3iV22huR7g=;
	b=O3k2kmLtaN98bHfuHywbtpiQfgfDvFKe3xdnCl/j7OeVZVogmPjrbyQWR6aW8L9zdbKTyp
	next6oVtHfsYK9BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 15B7F13456;
	Mon, 12 Dec 2022 10:54:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id OPiABGUIl2MiUQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 12 Dec 2022 10:54:29 +0000
Message-ID: <f318ccc3-eb03-e359-cb6f-157d0b4aed31@suse.cz>
Date: Mon, 12 Dec 2022 11:54:28 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 10/12] mm, slub: remove percpu slabs with CONFIG_SLUB_TINY
Content-Language: en-US
To: Hyeonggon Yoo <42.hyeyoo@gmail.com>, Baoquan He <bhe@redhat.com>
Cc: Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, patches@lists.linux.dev,
 Dennis Zhou <dennis@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20221121171202.22080-1-vbabka@suse.cz>
 <20221121171202.22080-11-vbabka@suse.cz> <Y4NEkF8DI1uXFRv4@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <Y4NEkF8DI1uXFRv4@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/27/22 12:05, Hyeonggon Yoo wrote:
> On Mon, Nov 21, 2022 at 06:12:00PM +0100, Vlastimil Babka wrote:
>> SLUB gets most of its scalability by percpu slabs. However for
>> CONFIG_SLUB_TINY the goal is minimal memory overhead, not scalability.
>> Thus, #ifdef out the whole kmem_cache_cpu percpu structure and
>> associated code. Additionally to the slab page savings, this reduces
>> percpu allocator usage, and code size.
> 
> [+Cc Dennis]

+To: Baoquan also.

> Wondering if we can reduce (or zero) early reservation of percpu area
> when #if !defined(CONFIG_SLUB) || defined(CONFIG_SLUB_TINY)?

Good point. I've sent a PR as it was [1], but (if merged) we can still
improve that during RC series, if it means more memory saved thanks to less
percpu usage with CONFIG_SLUB_TINY.

[1]
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/tag/?h=slab-for-6.2-rc1

>> This change builds on recent commit c7323a5ad078 ("mm/slub: restrict
>> sysfs validation to debug caches and make it safe"), as caches with
>> enabled debugging also avoid percpu slabs and all allocations and
>> freeing ends up working with the partial list. With a bit more
>> refactoring by the preceding patches, use the same code paths with
>> CONFIG_SLUB_TINY.
>> 
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 

