Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C0DAD23
	for <patches@lists.linux.dev>; Fri, 26 May 2023 07:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=5sDzoLLiNk6KHdYH8uCoV/dBsj9Jyf+/G1i59BLdhsE=; b=aNld4o2VvRGiQ7vUI5arJSgX/L
	6HnGHoys0fJ0NyQtFF23FYlkQQzjBbOG2VhMIvldNEf22GLVMNLTPM709hyKOlQD0gLZxwuctNBgy
	5xB+UXzv2lZoitwyBzx9gtzjlhfkbRrUBPE63O6bJwBIPoLlAiT5sqXh83wJrFBVWWsyd0+6vzmLw
	Zg+CCpzYhsYjajho25CSz1p1EJHOT1tTxSqrc5eVEUGlE72Ih/0P9mhN8JBy4HyPPn6fJ2fJsrvnB
	8F5DFRPYRHJ48DzQkK2rZN5deuJkdDWpeanaIbyclKM98/ZFBFaHcLpjk6EO/3caforvAU1V5EiBJ
	7SdjKf2Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1q2SIj-001WZa-2E;
	Fri, 26 May 2023 07:55:53 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hughd@google.com,
	akpm@linux-foundation.org,
	willy@infradead.org,
	brauner@kernel.org,
	djwong@kernel.org
Cc: p.raghav@samsung.com,
	da.gomez@samsung.com,
	rohan.puri@samsung.com,
	rpuri.linux@gmail.com,
	a.manzanares@samsung.com,
	dave@stgolabs.net,
	yosryahmed@google.com,
	keescook@chromium.org,
	hare@suse.de,
	kbusch@kernel.org,
	mcgrof@kernel.org,
	patches@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 0/8] add support for blocksize > PAGE_SIZE
Date: Fri, 26 May 2023 00:55:44 -0700
Message-Id: <20230526075552.363524-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

This is an initial attempt to add support for block size > PAGE_SIZE for tmpfs.
Why would you want this? It helps us experiment with higher order folio uses
with fs APIS and helps us test out corner cases which would likely need
to be accounted for sooner or later if and when filesystems enable support
for this. Better review early and burn early than continue on in the wrong
direction so looking for early feedback.

I have other patches to convert shmem_file_read_iter() to folios too but that
is not yet working. In the swap world the next thing to look at would be to
convert swap_cluster_readahead() to folios.

As mentioned at LSFMM, if folks want to experiment with anything related to
Large Block Sizes (LBS) I've been trying to stash related patches in
a tree which tries to carry as many nuggets we have and can collect into
a dedicated lage-block tree. Many of this is obviously work in progress
so don't try it unless you want to your systems to blow up. But in case you
do, you can use my large-block-20230525 branch [0]. Similarly you can also
use kdevops with CONFIG_QEMU_ENABLE_EXTRA_DRIVE_LARGEIO support to get
everything with just as that branch is used for that:
                                                                                                                                                                                              
  make
  make bringup
  make linux

Changes on this v2:

  o the block size has been modified to block order after Matthew Wilcox's
    suggestion. This truly makes a huge difference in making this code
    much more easier to read and maintain.
  o At Pankaj Raghav's suggestion I've put together a helper for
    poison flags and so this now introduces that as is_folio_hwpoison().
  o cleaned up the nits / debug code as pointed out by Matthew Wilcox
  o clarified the max block size we support is computed by the MAX_ORDER,
    and for x86_64 this is 8 MiB.
  o Tested up to 4 MiB block size with a basic test nothing blew up

Future work:

  o shmem_file_read_iter()
  o extend struct address_space with order and use that instead
    of our own block order. We may still need to have our own block order,
    we'll need to see.
  o swap_cluster_readahead() and friends coverted over to folios
  o test this well

[0] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=large-block-20230525
[1] https://github.com/linux-kdevops/kdevops

Luis Chamberlain (8):
  page_flags: add is_folio_hwpoison()
  shmem: convert to use is_folio_hwpoison()
  shmem: account for high order folios
  shmem: add helpers to get block size
  shmem: account for larger blocks sizes for shmem_default_max_blocks()
  shmem: consider block size in shmem_default_max_inodes()
  shmem: add high order page support
  shmem: add support to customize block size order

 include/linux/page-flags.h |   7 ++
 include/linux/shmem_fs.h   |   3 +
 mm/shmem.c                 | 139 +++++++++++++++++++++++++++++--------
 3 files changed, 119 insertions(+), 30 deletions(-)

-- 
2.39.2
