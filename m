Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A535F8CF;
	Wed,  3 Dec 2025 16:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780152; cv=none; b=spIknFU+v2J+hOLEE1Mj3FAD0KV6lJMM52nEIkDP3M2hxGVom6iNRHYNYsbhew4K64JXSGGAPaxcCaCOMoJxbCmRlSfBhkX/DYcPRMl145D73fKZRIj3wX5UhAMoOJOhgKDicB1RJG/EV78fS0bYtMJEDZp/nKhrIx3ll/pnYQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780152; c=relaxed/simple;
	bh=QkadBt5dhCGOomIvbpvyUhL4e8WjKoX7H9Q+9Pd+Ark=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jQ2jl0bnhGlXDo+5+dIahejCuK7JYoyhRfBHPCWlLdWqLl4hK/cNC6ZIKPN2qasoh5g3OTUIU90UTjuw726veodSotl4Z33WuDGxPppLHq0acUzFgr3WiqsYqthwacZlcIso3mVqmXMSe3LINLRbnHlys7US4evaJah1JSn9jS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yfEIpuUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yfEIpuUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00314C4CEF5;
	Wed,  3 Dec 2025 16:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780152;
	bh=QkadBt5dhCGOomIvbpvyUhL4e8WjKoX7H9Q+9Pd+Ark=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yfEIpuUW9VEw9LCCxdcOzTEhNK/3eOt6fsZ9FNPAwU4GGZp/apRiImy3lT1Hu8wGH
	 TL1KP2ViQadhNJcM8SF/xVU/EpC6jzp7X4qoSo1z5aMmVxLWbO3bPc26ubJLuw0pW0
	 rxGXDUHpXt2qSFelQsREwZcsXION9vI/PXyy2aCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 472/568] mm/mm_init: fix hash table order logging in alloc_large_system_hash()
Date: Wed,  3 Dec 2025 16:27:54 +0100
Message-ID: <20251203152457.987473219@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac J. Manjarres <isaacmanjarres@google.com>

[ Upstream commit 0d6c356dd6547adac2b06b461528e3573f52d953 ]

When emitting the order of the allocation for a hash table,
alloc_large_system_hash() unconditionally subtracts PAGE_SHIFT from log
base 2 of the allocation size.  This is not correct if the allocation size
is smaller than a page, and yields a negative value for the order as seen
below:

TCP established hash table entries: 32 (order: -4, 256 bytes, linear) TCP
bind hash table entries: 32 (order: -2, 1024 bytes, linear)

Use get_order() to compute the order when emitting the hash table
information to correctly handle cases where the allocation size is smaller
than a page:

TCP established hash table entries: 32 (order: 0, 256 bytes, linear) TCP
bind hash table entries: 32 (order: 0, 1024 bytes, linear)

Link: https://lkml.kernel.org/r/20251028191020.413002-1-isaacmanjarres@google.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 0d6c356dd6547adac2b06b461528e3573f52d953)
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 86066a2cf258a..d760b96604eca 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -9225,7 +9225,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)
-- 
2.51.0



