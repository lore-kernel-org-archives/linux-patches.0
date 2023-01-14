Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B3B7C
	for <patches@lists.linux.dev>; Sat, 14 Jan 2023 06:51:51 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id ED79F5FC98;
	Sat, 14 Jan 2023 06:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1673679109; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQUB5MQ8DlGetT/ULoEgYqYuVUZe6n5gVXb9OLizluM=;
	b=XwrWc/n6vLXfrNa7a8+hz8lQ6BhukTs4/AQlxkB3n9wNOPU4ZUF/QUY03xYjFbiY/L6uRh
	zeePzItgIhK3XZttfEzkD1WGvSdKcdrhbzMwWUPW2ik1QrzoOdE9chgb1yEZp52PH73qut
	hTMTm+Se3JsWAE+rx4dBu/hp7QQiI4M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1673679109;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQUB5MQ8DlGetT/ULoEgYqYuVUZe6n5gVXb9OLizluM=;
	b=0QnS2ZjDVW32kRviXL9msAoT1IYLXRvnIrnEh5+j08JqV0543zPrlmlCQUi7oTjgFjEkK3
	hdPKg8janIEzrMCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AC4DB138FA;
	Sat, 14 Jan 2023 06:51:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 2B7kKAVRwmMlOwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Sat, 14 Jan 2023 06:51:49 +0000
Message-ID: <3e419e8e-cdd7-eaf5-0572-ae5c44d7b68e@suse.cz>
Date: Sat, 14 Jan 2023 07:49:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH for 6.1 regression] Revert "mm/compaction: fix set skip in
 fast_find_migrateblock"
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: patches@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, regressions@leemhuis.info,
 Jiri Slaby <jirislaby@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>,
 Mel Gorman <mgorman@techsingularity.net>, Michal Hocko <mhocko@kernel.org>,
 Pedro Falcato <pedro.falcato@gmail.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Chuyi Zhou <zhouchuyi@bytedance.com>,
 stable@vger.kernel.org
References: <20230113173345.9692-1-vbabka@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230113173345.9692-1-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/13/23 18:33, Vlastimil Babka wrote:
> This reverts commit 7efc3b7261030da79001c00d92bc3392fd6c664c.
> 
> We have got openSUSE reports (Link 1) for 6.1 kernel with khugepaged
> stalling CPU for long periods of time. Investigation of tracepoint data
> shows that compaction is stuck in repeating fast_find_migrateblock()
> based migrate page isolation, and then fails to migrate all isolated
> pages. Commit 7efc3b726103 ("mm/compaction: fix set skip in
> fast_find_migrateblock") was suspected as it was merged in 6.1 and in
> theory can indeed remove a termination condition for
> fast_find_migrateblock() under certain conditions, as it removes a place
> that always marks a scanned pageblock from being re-scanned. There are
> other such places, but those can be skipped under certain conditions,
> which seems to match the tracepoint data.
> 
> Testing of revert also appears to have resolved the issue, thus revert
> the commit until a more robust solution for the original problem is
> developed.
> 
> It's also likely this will fix qemu stalls with 6.1 kernel reported in
> Link 2, but that is not yet confirmed.
> 
> Link: https://bugzilla.suse.com/show_bug.cgi?id=1206848
> Link: https://lore.kernel.org/kvm/b8017e09-f336-3035-8344-c549086c2340@kernel.org/
> Fixes: 7efc3b726103 ("mm/compaction: fix set skip in fast_find_migrateblock")
> Cc: <stable@vger.kernel.org>

Oops, forgot:

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  mm/compaction.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index ca1603524bbe..8238e83385a7 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1839,6 +1839,7 @@ static unsigned long fast_find_migrateblock(struct compact_control *cc)
>  					pfn = cc->zone->zone_start_pfn;
>  				cc->fast_search_fail = 0;
>  				found_block = true;
> +				set_pageblock_skip(freepage);
>  				break;
>  			}
>  		}

