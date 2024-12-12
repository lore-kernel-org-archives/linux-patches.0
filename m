Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0B21578A;
	Thu, 12 Dec 2024 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016466; cv=none; b=qgdGTk7idpGN3RqPELHJzdQOxamiMFV9tjoEje/dLgz0Xo7bJucEOMvZ80YrRruT8ZYm93xBbUH+InsZKgWoyeRQsxsiVY+zXT14AYnzm2XuUJouxGeL91SY7t/atpo4j+DFipqknvpifSg2gOrVZkuGzIz6Sw1NZmMdWPkg8dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016466; c=relaxed/simple;
	bh=v6p9KqZrZbDIxO1VyAQE9ALL6kofsjpxXyFVkzyUVIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kf5Gp1XAa5t4pVmCfkyzvCZArghYX30tS6mQVxB5sgeletxwEXnT0EvW7m8cAWNJkPCKwCjlTj77PAWKysfmf2k3R/G2e5dwfDnMl4M1tXb0Ebx6hwq6caU+oQz7y7gAdydyLZfG+X5oZ4S3nH7hZ9KIHRFR1HSa2uU3W1Zg4wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCGLtpyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCGLtpyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD76C4CECE;
	Thu, 12 Dec 2024 15:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016465;
	bh=v6p9KqZrZbDIxO1VyAQE9ALL6kofsjpxXyFVkzyUVIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCGLtpykOX5AE99vxFbF7z2q1xgK7kmwrWld37KoWUYk80wxeYS85r5UtSZohBDgn
	 CXd2Q+7cjtHqMmHAyHaF2y3Lkhxc2NlMyxPYGYkhOpqIuB5EW5OmdVxEDJBRW5UvRB
	 0KWkUD7iBSkkwMxOPci4eLXiEM2vVHU5EcCeBDcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 207/466] mm: fix vrealloc()s KASAN poisoning logic
Date: Thu, 12 Dec 2024 15:56:16 +0100
Message-ID: <20241212144314.965566335@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

commit d699440f58ce9bd71103cc7b692e3ab76a20bfcd upstream.

When vrealloc() reuses already allocated vmap_area, we need to re-annotate
poisoned and unpoisoned portions of underlying memory according to the new
size.

This results in a KASAN splat recorded at [1].  A KASAN mis-reporting
issue where there is none.

Note, hard-coding KASAN_VMALLOC_PROT_NORMAL might not be exactly correct,
but KASAN flag logic is pretty involved and spread out throughout
__vmalloc_node_range_noprof(), so I'm using the bare minimum flag here and
leaving the rest to mm people to refactor this logic and reuse it here.

Link: https://lkml.kernel.org/r/20241126005206.3457974-1-andrii@kernel.org
Link: https://lore.kernel.org/bpf/67450f9b.050a0220.21d33d.0004.GAE@google.com/ [1]
Fixes: 3ddc2fefe6f3 ("mm: vmalloc: implement vrealloc()")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/vmalloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7ed39d104201..f009b21705c1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4093,7 +4093,8 @@ void *vrealloc_noprof(const void *p, size_t size, gfp_t flags)
 		/* Zero out spare memory. */
 		if (want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
-
+		kasan_poison_vmalloc(p + size, old_size - size);
+		kasan_unpoison_vmalloc(p, size, KASAN_VMALLOC_PROT_NORMAL);
 		return (void *)p;
 	}
 
-- 
2.47.1



