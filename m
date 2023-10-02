Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD08737A
	for <patches@lists.linux.dev>; Mon,  2 Oct 2023 12:38:39 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 71A89211C3;
	Mon,  2 Oct 2023 12:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1696250312; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3WQVSuM8f1XKbYHPZOprGX2nORQUomt4Hm5zfLQyVg=;
	b=Z7smfT6g59C4upjye0xt6u0/aK1cLq9ILbqv5RwmfJnLc2dAvUoFFrgZzeK7ynfLDzH7RX
	0ErjM0PVt0nknn1mUeXOdWO+ee0SXt9MnZfRyRDvqnfBLYd7q/NI852F9w4tTHCG9mYGr4
	naepL3oSC9E9AZr7MQ+jNzJyEHaZSvc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1696250312;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D3WQVSuM8f1XKbYHPZOprGX2nORQUomt4Hm5zfLQyVg=;
	b=iiVZps1Ki1Eb1u/undkL7t8OFyhHIfHeRIFXaSuEWWbJN7ylxqW2VrrgMU6fJySMg5Iovz
	RIYjDuwniXAWqaBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4703F13434;
	Mon,  2 Oct 2023 12:38:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id 70lyEMi5GmWgKwAAMHmgww
	(envelope-from <vbabka@suse.cz>); Mon, 02 Oct 2023 12:38:32 +0000
Message-ID: <6db4338b-279e-acc6-9e95-17e0f2716f0c@suse.cz>
Date: Mon, 2 Oct 2023 14:38:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 0/4] SLUB: calculate_order() cleanups
To: jaypatel@linux.ibm.com, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@linux.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Pekka Enberg <penberg@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 linux-mm@kvack.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20230908145302.30320-6-vbabka@suse.cz>
 <5c933e2b06ab9090d9190bac41ebbc175b0a9357.camel@linux.ibm.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <5c933e2b06ab9090d9190bac41ebbc175b0a9357.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/28/23 06:46, Jay Patel wrote:
> On Fri, 2023-09-08 at 16:53 +0200, Vlastimil Babka wrote:
>> Since reviewing recent patches made me finally dig into these
>> functions
>> in details for the first time, I've also noticed some opportunities
>> for
>> cleanups that should make them simpler and also deliver more
>> consistent
>> results for some corner case object sizes (probably not seen in
>> practice). Thus patch 3 can increase slab orders somewhere, but only
>> in
>> the way that was already intended. Otherwise it's almost no
>> functional
>> changes.
>> 
> Hi Vlastimil,

Hi, Jay!

> This cleanup patchset looks promising.
> I've conducted test
> on PowerPC with 16 CPUs and a 64K page size, and here are the results.
> 
> S
> lub Memory Usage
> 
> +-------------------+--------+------------+
> |                   | Normal | With Patch |
> +-------------------+--------+------------+
> | Total Slub Memory | 476992 | 478464     |
> | Wastage           | 431    | 451        |
> +-------------------+--------+------------+
> 
> Also, I have not detected any changes in the page order for slub caches
> across all objects with 64K page size.

As expected. Which should mean any benchmark differences should be noise and
not caused by the patches.

> Hackbench Results
> 
> +-------+----+---------+------------+----------+
> |     
>   |    | Normal  | With Patch |          |
> +-------+----+---------+-----
> -------+----------+
> | Amean | 1  | 1.1530  | 1.1347     | ( 1.59%) |
> |
> Amean | 4  | 3.9220  | 3.8240     | ( 2.50%) |
> | Amean | 7  | 6.7943  |
> 6.6300     | ( 2.42%) |
> | Amean | 12 | 11.7067 | 11.4423    | ( 2.26%) |
> | Amean | 21 | 20.6617 | 20.1680    | ( 2.39%) |
> | Amean | 30 | 29.4200
> | 28.6460    | ( 2.63%) |
> | Amean | 48 | 47.2797 | 46.2820    | ( 2.11%)
> |
> | Amean | 64 | 63.4680 | 62.1813    | ( 2.03%) |
> +-------+----+------
> ---+------------+----------+  
> 
> 
> Reviewed-by: Jay Patel
> <jaypatel@linux.ibm.com>
> Tested-by: Jay Patel <jaypatel@linux.ibm.com>

Thanks! Applied your Reviewed-and-tested-by:

> Th
> ank You 
> Jay Patel
>> Vlastimil Babka (4):
>>   mm/slub: simplify the last resort slab order calculation
>>   mm/slub: remove min_objects loop from calculate_order()
>>   mm/slub: attempt to find layouts up to 1/2 waste in
>> calculate_order()
>>   mm/slub: refactor calculate_order() and calc_slab_order()
>> 
>>  mm/slub.c | 63 ++++++++++++++++++++++++-----------------------------
>> --
>>  1 file changed, 27 insertions(+), 36 deletions(-)
>> 
> 

