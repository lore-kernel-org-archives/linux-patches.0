Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771E418B0D
	for <patches@lists.linux.dev>; Fri, 26 May 2023 18:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SC3QuxZifneOZBhZF54TVMUnSROnxAUB8mJntY3DYLA=; b=aGq+uwJcZ2GwzvoAOVaDo+A/5e
	4GfeZUw+m2279aQn4gfFuyfOanPcGaDB2nTSnB+zXJHXDjAK7YI3gweGfiHmXDd3kURuJHwaBvyTZ
	R3zA+BIbA0SfXRSMeHsQampNLfBRkGpC1vL/1X0Vf3NeArkee+nlNFhUOsW1dTxCDWOFGdaJQn3Iz
	OTaqRm5wt/Cp8hULL+gEjXn7uFjzC4f/qlmApbPYMtL3WcCurdXgptPbigQP/dfVT+UPvnLEXbfPx
	l91JLrC4FpfZ+D6WZ3n6LuK9/qr04EVvVg0Q5u4TPM+sYaRV72Y7NQs0Qm4LF7/4qzZiv5fajb+ZV
	MHEmsflw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1q2cPP-0032TG-0U; Fri, 26 May 2023 18:43:27 +0000
Date: Fri, 26 May 2023 19:43:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: hughd@google.com, akpm@linux-foundation.org, brauner@kernel.org,
	djwong@kernel.org, p.raghav@samsung.com, da.gomez@samsung.com,
	rohan.puri@samsung.com, rpuri.linux@gmail.com,
	a.manzanares@samsung.com, dave@stgolabs.net, yosryahmed@google.com,
	keescook@chromium.org, hare@suse.de, kbusch@kernel.org,
	patches@lists.linux.dev, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Message-ID: <ZHD9zmIeNXICDaRJ@casper.infradead.org>
References: <20230526075552.363524-1-mcgrof@kernel.org>
 <ZHC6BM+ehSC5Atv8@casper.infradead.org>
 <ZHDtgdhauy0RZPeU@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHDtgdhauy0RZPeU@bombadil.infradead.org>

On Fri, May 26, 2023 at 10:33:53AM -0700, Luis Chamberlain wrote:
> On Fri, May 26, 2023 at 02:54:12PM +0100, Matthew Wilcox wrote:
> > You're coming at this from a block layer perspective, and we have two
> > ways of doing large block devices -- qemu nvme and brd.  tmpfs should
> > be like other filesystems and opportunistically use folios of whatever
> > size makes sense.
> 
> I figured the backing block size would be a good reason to use high
> order folios for filesystems, and this mimicks that through the super
> block block size. Although usage of the block size would be moved to
> the block device and tmpfs use an page order, what other alternatives
> were you thinking?

Use the readahead code like other filesystems to determine what size of
folios to allocate.  Also use the size of writes to determine what size
of folio to allocate, as in this patchset:

https://lore.kernel.org/linux-fsdevel/20230520163603.1794256-1-willy@infradead.org/
