Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34A933076;
	Fri, 24 Nov 2023 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xstE6kbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB075C433C7;
	Fri, 24 Nov 2023 18:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852382;
	bh=3au6NInuJNzXRVnYPhjFDTXU3LZor+61XBxvaBVVcR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xstE6kbJJprq10XN5AxCojS7nSobO6HcK2WtLkDJ1nrXu0U75av0sbqRviX+RRU3W
	 ZqJH4HzSDt+WVmnuBfnD74xJCYAKuQza2OWZm7TtuF0qTca5gyl/9wbgr8g33Y9HKC
	 MmCr0pMpk3Da1xCFXXKRYsGmX0uYbVLRTqqK+jYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Christoph Lameter <cl@linux.com>,
	Shakeel Butt <shakeelb@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 334/372] mm: kmem: drop __GFP_NOFAIL when allocating objcg vectors
Date: Fri, 24 Nov 2023 17:52:01 +0000
Message-ID: <20231124172021.518691014@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Gushchin <roman.gushchin@linux.dev>

commit 24948e3b7b12e0031a6edb4f49bbb9fb2ad1e4e9 upstream.

Objcg vectors attached to slab pages to store slab object ownership
information are allocated using gfp flags for the original slab
allocation.  Depending on slab page order and the size of slab objects,
objcg vector can take several pages.

If the original allocation was done with the __GFP_NOFAIL flag, it
triggered a warning in the page allocation code.  Indeed, order > 1 pages
should not been allocated with the __GFP_NOFAIL flag.

Fix this by simply dropping the __GFP_NOFAIL flag when allocating the
objcg vector.  It effectively allows to skip the accounting of a single
slab object under a heavy memory pressure.

An alternative would be to implement the mechanism to fallback to order-0
allocations for accounting metadata, which is also not perfect because it
will increase performance penalty and memory footprint of the kernel
memory accounting under memory pressure.

Link: https://lkml.kernel.org/r/ZUp8ZFGxwmCx4ZFr@P9FQF9L96D.corp.robot.car
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: Christoph Lameter <cl@linux.com>
Closes: https://lkml.kernel.org/r/6b42243e-f197-600a-5d22-56bd728a5ad8@gentwo.org
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2854,7 +2854,8 @@ static void commit_charge(struct folio *
  * Moreover, it should not come from DMA buffer and is not readily
  * reclaimable. So those GFP bits should be masked off.
  */
-#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | __GFP_ACCOUNT)
+#define OBJCGS_CLEAR_MASK	(__GFP_DMA | __GFP_RECLAIMABLE | \
+				 __GFP_ACCOUNT | __GFP_NOFAIL)
 
 /*
  * mod_objcg_mlstate() may be called with irq enabled, so


