Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF4E8492
	for <patches@lists.linux.dev>; Tue,  8 Aug 2023 09:53:53 +0000 (UTC)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 949231F88D;
	Tue,  8 Aug 2023 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1691488432; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mE/Rlif6LEotEbhW7qL2YSR5OM+dvqWF2/m03kvt0U0=;
	b=DvAX8NpbbBMqlMysbAG+fvQDGkmOrXEnblMCzccKAo+xL0aP0tDUfc+TKuoKgigvLFBpAm
	wMIbsOj3BbC3tmFDw56FqL+p6V0HK4/yEs6LkLNlcISHGFGYSZHRlOT7fXERua/QBNiZfA
	Oom//yntN8wykThY1yl9lnlENpHwyQ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1691488432;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=mE/Rlif6LEotEbhW7qL2YSR5OM+dvqWF2/m03kvt0U0=;
	b=lWyzyMKKMywL36JbUfDPqD01yvvtDsJ+aNWVgtYFd44duwe5t5YZyhSH//3WkNBkaKQxrp
	TP/N0eVhQTSA//Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 60A6A13451;
	Tue,  8 Aug 2023 09:53:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id YNCLFrAQ0mSBJQAAMHmgww
	(envelope-from <vbabka@suse.cz>); Tue, 08 Aug 2023 09:53:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	Pekka Enberg <penberg@kernel.org>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [RFC v1 0/5] SLUB percpu array caches and maple tree nodes
Date: Tue,  8 Aug 2023 11:53:43 +0200
Message-ID: <20230808095342.12637-7-vbabka@suse.cz>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Also available in git, based on v6.5-rc5:

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=slub-percpu-caches-v1

At LSF/MM I've mentioned that I see several use cases for introducing
opt-in percpu arrays for caching alloc/free objects in SLUB. This is my
first exploration of this idea, speficially for the use case of maple
tree nodes. We have brainstormed this use case on IRC last week with
Liam and Matthew and this how I understood the requirements:

- percpu arrays will be faster thank bulk alloc/free which needs
  relatively long freelists to work well. Especially in the freeing case
  we need the nodes to come from the same slab (or small set of those)

- preallocation for the worst case of needed nodes for a tree operation
  that can't reclaim due to locks is wasteful. We could instead expect
  that most of the time percpu arrays would satisfy the constained
  allocations, and in the rare cases it does not we can dip into
  GFP_ATOMIC reserves temporarily. Instead of preallocation just prefill
  the arrays.

- NUMA locality is not a concern as the nodes of a process's VMA tree
  end up all over the place anyway.

So this RFC patchset adds such percpu array in Patch 2. Locking is
stolen from Mel's recent page allocator's pcplists implementation so it
can avoid disabling IRQs and just disable preemption, but the trylocks
can fail in rare situations.

Then maple tree is modified in patches 3-5 to benefit from this. This is
done in a very crude way as I'm not so familiar with the code.

I've briefly tested this with virtme VM boot and checking the stats from
CONFIG_SLUB_STATS in sysfs.

Patch 2:

slub changes implemented including new counters alloc_cpu_cache
and free_cpu_cache but maple tree doesn't use them yet

(none):/sys/kernel/slab/maple_node # grep . alloc_cpu_cache alloc_*path free_cpu_cache free_*path | cut -d' ' -f1
alloc_cpu_cache:0
alloc_fastpath:56604
alloc_slowpath:7279
free_cpu_cache:0
free_fastpath:35087
free_slowpath:22403

Patch 3:

maple node cache creates percpu array with 32 entries,
not changed anything else

-> some allocs/free satisfied by the array

alloc_cpu_cache:11950
alloc_fastpath:39955
alloc_slowpath:7989
free_cpu_cache:12076
free_fastpath:22878
free_slowpath:18677

Patch 4:

maple tree nodes bulk alloc/free converted to loop of normal alloc to use
percpu array more, because bulk alloc bypasses it

-> majority alloc/free now satisfied by percpu array

alloc_cpu_cache:54178
alloc_fastpath:4959
alloc_slowpath:727
free_cpu_cache:54244
free_fastpath:354
free_slowpath:5159

Patch 5:

mas_preallocate() just prefills the percpu array, actually preallocates only a single node
mas_store_prealloc() gains a retry loop with mas_nomem(mas, GFP_ATOMIC | __GFP_NOFAIL)

-> major drop of actual alloc/free

alloc_cpu_cache:17031
alloc_fastpath:5324
alloc_slowpath:631
free_cpu_cache:17099
free_fastpath:277
free_slowpath:5503

Would be interesting to see how it affects the workloads that saw
regressions from the maple tree introduction, as the slab operations
were suspected to be a major factor.

Vlastimil Babka (5):
  mm, slub: fix bulk alloc and free stats
  mm, slub: add opt-in slub_percpu_array
  maple_tree: use slub percpu array
  maple_tree: avoid bulk alloc/free to use percpu array more
  maple_tree: replace preallocation with slub percpu array prefill

 include/linux/slab.h     |   4 +
 include/linux/slub_def.h |  10 ++
 lib/maple_tree.c         |  30 +++++-
 mm/slub.c                | 221 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 258 insertions(+), 7 deletions(-)

-- 
2.41.0

