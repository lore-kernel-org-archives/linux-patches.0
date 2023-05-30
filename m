Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D6B200AD
	for <patches@lists.linux.dev>; Tue, 30 May 2023 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JADWF5FGfjqal0Tm4srMFuXcLVsdz79srAuWZWBhE0U=; b=h83GzI9GcktWKcxm3mM6r0dFZw
	gDFov6i/D/ln27TGWCDBsfM8Dp2YSXIPS/PadQ/vuOP1h3KfOXRt/Ai8fqtSLwMPPA12Cqi9fsxx1
	busls/x8Bbmq5as1k5M4iPcu+jv5Y4OzfZeFCee+0guhE8+nmfE57I6/H7B7Ihh6piFFztXsoWYjP
	OYAhAjIj5Zrcp5vuE6HXHhK6/EWyS8a9n0RzpJbz+hN84xLsxNNYkNlVBLucSrghgbLJaaYT0asy9
	fMykJWPxnNC1FQbewSoj16im5rO8ZVWciD6VuY92UqYF/2BExw7xImmCHnXCRQD1CvyE6kA4zoUJp
	3FXLT1pw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q45Dk-00F0Eb-2F;
	Tue, 30 May 2023 19:41:28 +0000
Date: Tue, 30 May 2023 12:41:28 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Johan Hovold <johan@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
	gregkh@linuxfoundation.org, rafael@kernel.org, song@kernel.org,
	lucas.de.marchi@gmail.com, christophe.leroy@csgroup.eu,
	peterz@infradead.org, rppt@kernel.org, dave@stgolabs.net,
	willy@infradead.org, vbabka@suse.cz, mhocko@suse.com,
	dave.hansen@linux.intel.com, colin.i.king@gmail.com,
	jim.cromie@gmail.com, catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com,
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com,
	lennart@poettering.net
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZHZRaFWvLEvkoCMA@bombadil.infradead.org>
References: <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
 <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
 <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
 <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
 <CAHk-=wg7ihygotpO9x5a6QJO5oAom9o91==L_Kx-gUHvRYuXiQ@mail.gmail.com>
 <ZHYitt7P7W+8ZlSB@bombadil.infradead.org>
 <bav73qu5khl2dxkwpvy2hq34lyi56jn6yp7h5qlennka65kre3@zwwmrr55d2by>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bav73qu5khl2dxkwpvy2hq34lyi56jn6yp7h5qlennka65kre3@zwwmrr55d2by>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Tue, May 30, 2023 at 10:16:22AM -0700, Lucas De Marchi wrote:
> On Tue, May 30, 2023 at 09:22:14AM -0700, Luis Chamberlain wrote:
> > Lucas, any thoughts from modules kmod userspace perspective into
> > supporting anyone likely issuing concurrent modules requests with
> > differing arguments?
> 
> Changing module params like that without first explicitly removing the
> module was never supported by kmod or module-init-tools (I'm not digging
> the history before 2.6 kernel)

That's good enough.

> During boot, note there is already a shortcut
> if we have the sysfs node already in the "live" state or if the module is
> built-in. In that case we will return success or -EEXIST (if the
> KMOD_PROBE_IGNORE_LOADED flag was passed).

Linus' code would make duplicates wait and share the same return value,
ie, no new odd error code is returned. Or are you suggesting -EEXIST
should be returned to duplicates if the module succeeded to load
instead of 0 ?

> The only scenario I can think of during boot in which the module params
> could change would be when a buggy initrd is created, i.e.
> /etc/modprobed.d/*.conf is in the rootfs but absent from initrd.

This helps thanks.

> So returning the same error code seems good to me.

OK thanks! So just to confirm, it seems fine to return the same error
code if duplicates wait, or do you prefer for some reason for there to
be an exception and return -EEXIST if the module did succeed in the
duplicate case?

  Luis
