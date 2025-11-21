Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4F7258EFC;
	Fri, 21 Nov 2025 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731370; cv=none; b=DOlL4twIgZCp7FbOsRcc4RvrE6AzPZw3zGw6WuyuAZMgKLuSnG5wHa8KWM+fmn/26a25+kes9jbYbsDAOVfOGyJ8nFUmxP/Qa4OxZXNQygkhSwCVBEF7gzOy9PfE1/3DP3om6DkE8CENJlC8hegreAIi+Z/iEnHZ3ED3Xa2dqWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731370; c=relaxed/simple;
	bh=MiLNc611i9nss9mPLSFKtlUcfl44M6oWvzMbcraR0EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVdU7QLUyj/zFZuPiY23U1VkTWEsmw00PmkWLA/uuTYeilipe9chKT59k3N5tzFhps/k3s2+um5XhnJR3bhDxYZEf6gYj/ebMj/cT6YJbHC4GWR12GavqiiGQarWHIpuCVVTeRhCac+fiZfb+hspPxRe/yVz3vBLDd1srErazKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdHhzB5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdHhzB5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A86C116C6;
	Fri, 21 Nov 2025 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731370;
	bh=MiLNc611i9nss9mPLSFKtlUcfl44M6oWvzMbcraR0EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdHhzB5gEpH/hFgPJBnJcxslrAif9Y63XflKVTiGxP7QDProxrUcyr9VlEoz6KK7E
	 oI0JxoKHcBs3vEMkkjxP9/L1MgV1hBpbqdy4sHmsie+FnsrwYWLFnqU33qGGIzJuqR
	 jiDiFo9tUV0Dpa+HZRBQz4L8lNmV6ep1NJpgFi9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 183/247] mm/mm_init: fix hash table order logging in alloc_large_system_hash()
Date: Fri, 21 Nov 2025 14:12:10 +0100
Message-ID: <20251121130201.291160370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 0d6c356dd6547adac2b06b461528e3573f52d953 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2537,7 +2537,7 @@ void *__init alloc_large_system_hash(con
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)


