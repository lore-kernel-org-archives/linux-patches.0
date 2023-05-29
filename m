Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89ECB8BF3
	for <patches@lists.linux.dev>; Mon, 29 May 2023 15:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179ECC4339B;
	Mon, 29 May 2023 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685373486;
	bh=pCyIkcfuOGLfoej499SDyjDDnNMS1kghnwZewYrliwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hTHsIbQqENAiVjiPSoaIA0euFBF/SqcWn0yT1saGhHU024SyZPBV9CvWDVGKgGK11
	 Se9p61dpwbmP8da8vgz5zmzqkZWiOXRkq8wlBbgjundRwzrPtYgiaDiOmqHZRbeb79
	 W5DHRyicRTQA+Kw39q3bZEapSVKPmjRkOpp94+dFv/nSbUST/Kh7n3VUUfLu+j/ZCv
	 hiU03hqIBR+vwaTw3wy8w9celjteMDZW3na21VbLy9oWMNfpAieILENOW8rOBAP+RP
	 95tTtyPeOmnAqRL0wy26q9frAWBhJuL7P77nVwu85rRFqA16Pu5n5v+shXTfihXT84
	 XhvkcbNgKpuDQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1q3edH-0007Qt-H8; Mon, 29 May 2023 17:18:04 +0200
Date: Mon, 29 May 2023 17:18:03 +0200
From: Johan Hovold <johan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Petr Pavlu <petr.pavlu@suse.com>, gregkh@linuxfoundation.org,
	rafael@kernel.org, song@kernel.org, lucas.de.marchi@gmail.com,
	christophe.leroy@csgroup.eu, peterz@infradead.org, rppt@kernel.org,
	dave@stgolabs.net, willy@infradead.org, vbabka@suse.cz,
	mhocko@suse.com, dave.hansen@linux.intel.com,
	colin.i.king@gmail.com, jim.cromie@gmail.com,
	catalin.marinas@arm.com, jbaron@akamai.com,
	rick.p.edgecombe@intel.com, yujie.liu@intel.com, david@redhat.com,
	tglx@linutronix.de, hch@lst.de, patches@lists.linux.dev,
	linux-modules@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pmladek@suse.com, prarit@redhat.com,
	lennart@poettering.net
Subject: Re: [PATCH 2/2] module: add support to avoid duplicates early on load
Message-ID: <ZHTCK2_1pF61yWIr@hovoldconsulting.com>
References: <20230524213620.3509138-3-mcgrof@kernel.org>
 <8fc5b26b-d2f6-0c8f-34a1-af085dbef155@suse.com>
 <CAHk-=wiPjcPL_50WRWOi-Fmi9TYO6yp_oj63a_N84FzG-rxGKQ@mail.gmail.com>
 <6gwjomw6sxxmlglxfoilelswv4hgygqelomevb4k4wrlrk3gtm@wrakbmwztgeu>
 <CAHk-=whu8Wh4JP1hrc80ZvGgVW4GV6hw1vwzSiwOo9-1=Y1dWw@mail.gmail.com>
 <ZG/a+nrt4/AAUi5z@bombadil.infradead.org>
 <CAHk-=whiXzqprmQNRui3LbKQwvM8fg4nyAzWcU5qZs+kxBVzrA@mail.gmail.com>
 <ZHRpH-JXAxA6DnzR@hovoldconsulting.com>
 <CAHk-=wh6sXSO63kka+EWEqq0tGwtOnXYFWMXPQ6T_wZa+Np3MQ@mail.gmail.com>
 <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHSeOUpKtyc8VKx5@hovoldconsulting.com>

> On Mon, May 29, 2023 at 07:00:05AM -0400, Linus Torvalds wrote:
> > I do wonder what it is that is different in your setup

I took a closer look at some of the modules that failed to load and
noticed a pattern in that they have dependencies that are needed by more
than one device.

If attempts to load the drivers for two such devices are made in
parallel, only one of them may be successful in loading the shared
dependency which means that module loading is now aborted for the other.

I took a quick look at the kmod code

	https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/tree/libkmod/libkmod-module.c#n1305

and it does seem like this could happen if we start returning errors
when a module is already in the process of being loaded.

Johan
