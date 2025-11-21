Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F052C339B3C;
	Fri, 21 Nov 2025 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732011; cv=none; b=FXfpvVjS+2Ay5pfbm28WV88YdEFq58Dn+2S0ddwOUkL0DPtbDTErYSMBjSO5PAwhj5dTDg0efrnByToR17l7yYbXAn7aSSSGp/qXjs1MuxgAzUauJwIHeCkq4PkHCfGUFdneh3vTv8lmW7j+VmuFUwyMB6JJfL6jkacVYG8yXUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732011; c=relaxed/simple;
	bh=XA944S/2g3XXYD5nuxMhRmuMmJWbZW5UJCGcy8jdy6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjPQpBisNtVR9eEK7b9gB2BPP1+nsqJlCG7B9lLPfYpkUXJo78+t10866vr4VkFFR4nTpfL2Ucr075w43EJTaXk0VCLBo+uCTD/qpxTSzxL/Shed97gat7VDyi6MyYfn7OGuMtgVudXNJ+SWMe4w5QYk5BbmAQw/5oZp/Vvq8NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EdjRA4IF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EdjRA4IF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38CCC4CEF1;
	Fri, 21 Nov 2025 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732010;
	bh=XA944S/2g3XXYD5nuxMhRmuMmJWbZW5UJCGcy8jdy6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EdjRA4IFPXlH7UDbpRgjy29cO8OzQlz5ZAQIjOCLJKj6UDvNNfYgI6sOlceTh/09m
	 N2OB+HKHfXVnGZ6WR8Yfji79BrDea17+qzPtb7Dau0XsoVlgZOqCmzUoHmerq2AoSs
	 hcq5yKMXNsNVuNK8jHy3v6vxDAMeBJ3qT3kVPnf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 125/185] mm/mm_init: fix hash table order logging in alloc_large_system_hash()
Date: Fri, 21 Nov 2025 14:12:32 +0100
Message-ID: <20251121130148.386832186@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2428,7 +2428,7 @@ void *__init alloc_large_system_hash(con
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)


