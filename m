Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416B3A9D9D;
	Mon, 23 Mar 2026 15:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278678; cv=none; b=OVHDtJ5E/jh+Jq5CcTLZ+H5YCNEPqj4Eprj+aADWFfElR3elHOgC/bqg60he5PGNsF+c9bo8GPq4iIzUJFi/+1MM8yFKqFp0Jtzwa6OZ1SwPlF1ohnZrXaoZ+IWP8BYmhZSfu1hVXnexbo9RkueRABzmY90A751VSyiuhBN3d/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278678; c=relaxed/simple;
	bh=+wSBZK6WmXwtKTpR0P7bOOIgqOQ6N7gghYuU4gFYsDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FixMh7LNBb6gDuITQmcuRH5bjS6R3tKU5oW/7jBlfN8gkVJxrd0cjsLAkR7EnOIE10PD8aPtcj0qn6objH1m3FaglUv2X5I94YHah5ZdD23ZCZko6h+rDUFK/Fc1ZZZn7uc0D1XttDB0W88vKNj35y0HjTXeMW4hXoVkA0IOUiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2IE7aP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2IE7aP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F26C4CEF7;
	Mon, 23 Mar 2026 15:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278678;
	bh=+wSBZK6WmXwtKTpR0P7bOOIgqOQ6N7gghYuU4gFYsDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2IE7aP7rVV9RCmmI+iC3TEHzrKxwCMadDc4B1h3t4X+rBzTfn0Xkm++eyOBhR/wI
	 hcTd1E29LAjLWwkIEa+kdG/3n9LzqML50FerkF1fC4TfOxuT9UEKQc+RgtPdRzPfXy
	 yda3lOM1B7NlebWbtYyKBYNrsy5GNG6+2q2CGW/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 385/567] mm/kfence: fix KASAN hardware tag faults during late enablement
Date: Mon, 23 Mar 2026 14:45:05 +0100
Message-ID: <20260323134543.373004557@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Potapenko <glider@google.com>

[ Upstream commit d155aab90fffa00f93cea1f107aef0a3d548b2ff ]

When KASAN hardware tags are enabled, re-enabling KFENCE late (via
/sys/module/kfence/parameters/sample_interval) causes KASAN faults.

This happens because the KFENCE pool and metadata are allocated via the
page allocator, which tags the memory, while KFENCE continues to access it
using untagged pointers during initialization.

Use __GFP_SKIP_KASAN for late KFENCE pool and metadata allocations to
ensure the memory remains untagged, consistent with early allocations from
memblock.  To support this, add __GFP_SKIP_KASAN to the allowlist in
__alloc_contig_verify_gfp_mask().

Link: https://lkml.kernel.org/r/20260220144940.2779209-1-glider@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Ernesto Martinez Garcia <ernesto.martinezgarcia@tugraz.at>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ dropped page_alloc.c hunk adding __GFP_SKIP_KASAN ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -945,14 +945,14 @@ static int kfence_init_late(void)
 #ifdef CONFIG_CONTIG_ALLOC
 	struct page *pages;
 
-	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL, first_online_node,
-				   NULL);
+	pages = alloc_contig_pages(nr_pages_pool, GFP_KERNEL | __GFP_SKIP_KASAN,
+				   first_online_node, NULL);
 	if (!pages)
 		return -ENOMEM;
 
 	__kfence_pool = page_to_virt(pages);
-	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL, first_online_node,
-				   NULL);
+	pages = alloc_contig_pages(nr_pages_meta, GFP_KERNEL | __GFP_SKIP_KASAN,
+				   first_online_node, NULL);
 	if (pages)
 		kfence_metadata_init = page_to_virt(pages);
 #else
@@ -962,11 +962,13 @@ static int kfence_init_late(void)
 		return -EINVAL;
 	}
 
-	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE, GFP_KERNEL);
+	__kfence_pool = alloc_pages_exact(KFENCE_POOL_SIZE,
+					  GFP_KERNEL | __GFP_SKIP_KASAN);
 	if (!__kfence_pool)
 		return -ENOMEM;
 
-	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE, GFP_KERNEL);
+	kfence_metadata_init = alloc_pages_exact(KFENCE_METADATA_SIZE,
+						 GFP_KERNEL | __GFP_SKIP_KASAN);
 #endif
 
 	if (!kfence_metadata_init)


