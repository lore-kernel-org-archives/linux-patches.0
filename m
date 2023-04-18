Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D65F23A7
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 18:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y/wE/R9Dcq9B6NYciIuhBA/N45s6bRLmpBHThTjOxQg=; b=jc0q0X/Stu0gCYHzxjw2YLMSYK
	g+4WCw/KVSVM7FtcywTLV3RGc6XplWnEgKfSo1u2tqgex5fiqgYrAgUQ7yeeveB70AXx3fWbE9wS0
	T6EdB8GrRaz7IhwZ7cl23Z1grJoRtjp96PL8oV63XpK/YTv/FWlwuH4KCE/iljkVQZEkEL+eBMDxC
	IhSL0b8zBkUVqVFgqg7N+saruwD3wcr0/6rswZ+fGmL6Y7YoFwZp6NIy1V/+aMxMyz3nOnZLORiv3
	hhkyTmjiFTwA/qjEub0if7Bj/1PwzybfOo1akaTMPztJAYfzrwYTHL9mSop0tEsiUt+vRVOHTZOdg
	VcXV7aeA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1poq68-0034Zx-1b;
	Tue, 18 Apr 2023 18:30:36 +0000
Date: Tue, 18 Apr 2023 11:30:36 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: christophe.leroy@csgroup.eu, tglx@linutronix.de, peterz@infradead.org,
	song@kernel.org, rppt@kernel.org, dave@stgolabs.net,
	willy@infradead.org, vbabka@suse.cz, mhocko@suse.com,
	dave.hansen@linux.intel.com, colin.i.king@gmail.com,
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, david@redhat.com,
	patches@lists.linux.dev, linux-modules@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pmladek@suse.com,
	prarit@redhat.com, torvalds@linux-foundation.org,
	gregkh@linuxfoundation.org, rafael@kernel.org
Subject: Re: [PATCH v3 3/4] module: add debug stats to help identify memory
 pressure
Message-ID: <ZD7hzIvJxFNDnzpU@bombadil.infradead.org>
References: <20230414050836.1984746-1-mcgrof@kernel.org>
 <20230414050836.1984746-4-mcgrof@kernel.org>
 <6110982a-bb68-c88b-6fd1-24d2c49d9fd7@suse.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6110982a-bb68-c88b-6fd1-24d2c49d9fd7@suse.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Mon, Apr 17, 2023 at 01:18:14PM +0200, Petr Pavlu wrote:
> On 4/14/23 07:08, Luis Chamberlain wrote:

<-- Petr's spell checking -->

> Note that there are plenty of other typos in the added comments and
> documentation. Please review them with a spell checker.

Yes I am terrible at that, I've now integrated a spell checker into
my workflow. Fixed all these, thanks.

> > @@ -2500,6 +2503,18 @@ static noinline int do_init_module(struct module *mod)
> >  {
> >  	int ret = 0;
> >  	struct mod_initfree *freeinit;
> > +#if defined(CONFIG_MODULE_STATS)
> > +	unsigned int text_size = 0, total_size = 0;
> > +
> > +	for_each_mod_mem_type(type) {
> > +		const struct module_memory *mod_mem = &mod->mem[type];
> > +		if (mod_mem->size) {
> > +			total_size += mod_mem->size;
> > +			if (type == MOD_TEXT || type == MOD_INIT_TEXT)
> > +				text_size += mod->mem[type].size;
> 
> 'text_size += mod_mem->size;' would be simpler.

Sure.

> > +extern struct dentry *mod_debugfs_root;
> 
> Files kernel/module/stats.c and kernel/module/tracking.c both add this extern
> declaration. Can it be moved to kernel/module/internal.h?

Sure.

> > +#if defined(CONFIG_MODULE_DECOMPRESS)
> > +	if (flags & MODULE_INIT_COMPRESSED_FILE)
> > +		atomic_long_add(info->compressed_len, &invalid_mod_byte);
> 
> Variable invalid_mod_byte is not declared, should be invalid_mod_bytes.

Arnd already sent a fix for that, thanks.

> > +int try_add_failed_module(const char *name, size_t len, enum fail_dup_mod_reason reason)
> 
> Function try_add_failed_module() is only called from
> module_patient_check_exists() which always passes in a NUL-terminated string.
> The len parameter could be then dropped and the comparison in
> try_add_failed_module() could simply use strcmp().

Sure, did that.

> Indentation in try_add_failed_module() uses spaces instead of tabs in a few
> places.

Fixed.

> > +	size = MAX_PREAMBLE + min((unsigned int)(floads + fbecoming) * MAX_BYTES_PER_MOD,
> > +			  (unsigned int) MAX_FAILED_MOD_PRINT * MAX_BYTES_PER_MOD);
> 
> Using
> 'size = MAX_PREAMBLE + min((unsigned int)(floads + fbecoming), (unsigned int)MAX_FAILED_MOD_PRINT) * MAX_BYTES_PER_MOD;'
> is a bit simpler and avoids any theoretical overflow of
> '(floads + fbecoming) * MAX_BYTES_PER_MOD'.

Sure.

> > +	len += scnprintf(buf + len, size - len, "%25s\t%15s\t%25s\n",
> > +			 "module-name", "How-many-times", "Reason");
> 
> "module-name" -> "Module-name"

OK sure.

> Function module_stats_init() requires mod_debugfs_root being initialized which
> is done in module_debugfs_init(). Both functions are recorded to be called via
> module_init(). Just to make sure, is their ordering guaranteed in some way?

Link order takes care of that and main.o goes first.

> mod_debugfs_root is initialized in module_debugfs_init() only if
> CONFIG_MODULE_DEBUG is set. However, my reading is that feature
> CONFIG_MODULE_UNLOAD_TAINT_TRACKING is orthogonal to it and doesn't require
> CONFIG_MODULE_DEBUG, so it looks this change breaks this tracking?

Ah yes We need a bool CONFIG_MODULE_DEBUGFS which is selected by those
that need it. Added.

  Luis
