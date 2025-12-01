Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C94258EDB;
	Mon,  1 Dec 2025 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588786; cv=none; b=bvbf7fzkWz7GZ22goww6AoibSZ1F9JDSnr+7blxvetbuTArJ/n+TV3RLZ0QETBfPddYxmkl8ikIt30XfBcAt1RkwUjtivEacAcJC507hcClGmPqfenH92Z76xUGpE97hrIkeBCRc9DTkDbCZMUuPdLvNgh51iuqpT+O6jqJ9VkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588786; c=relaxed/simple;
	bh=Kk+3QPCEc3KZIlf+exloAKoqxSPwmojAWsgGyiDbz9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXN+sZ1FUouUWxiiZS3U3Y7OPRfvBfh4KcxBYlD3Ol+XGtlr6QAyWFkbSih8twgax4smL1wXj1At8iqhW6GmJH+YV/O0D8edOEP4HC9aRQD4GxN6cHc6j5uxiKPuj/hX5ZBzcO/pk0pk1P1UXcfxkCIGxE6EewrzHekcFQZFHQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq+LRwTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq+LRwTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39AEC113D0;
	Mon,  1 Dec 2025 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588786;
	bh=Kk+3QPCEc3KZIlf+exloAKoqxSPwmojAWsgGyiDbz9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq+LRwTw6f0MSwr46L7gVEj3SjvpwuFioXskpYAUTHSSY8tysX9LvYinW5CUp0ZTj
	 m0pfLNiiZY0AUnOLRtc3SK+lr8wUY0BG3fQ6POzQdT2GQw6dCBpWbzqo06VNm0XsSA
	 n5XAUlrWOZ8DFBtOcsmW+alidKnVi6HJfgLJQuVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/187] mm/page_alloc: fix hash table order logging in alloc_large_system_hash()
Date: Mon,  1 Dec 2025 12:24:39 +0100
Message-ID: <20251201112247.387317659@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 66e4b78786a97..111f50054fc18 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8275,7 +8275,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? "vmalloc" : "linear");
 
 	if (_hash_shift)
-- 
2.51.0



