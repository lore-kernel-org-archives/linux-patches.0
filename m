Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CD6346FCA;
	Wed,  3 Dec 2025 16:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778315; cv=none; b=b5DcoTerddmSUmzlBKH+4cSk3SeB+dlZgcCP8kOS/CpYrmCFSbkFXzOsEm3pLqDQX0wO+Iwy19eC7mWxPQPEk7/7//A5MqPx6Cmcxy1OBNpewcz5qwKbGBv0QtlzQgQEUW8rAz/frQ1EA0njeek6teCQXG7hV4fcTxBMcQtNPO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778315; c=relaxed/simple;
	bh=tooxfup+oLTa6KBNjnIosh0o7Q8hlHhONYwEIc/nQQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I94XyW6u2Kp3zcls9oa+pG09RpG9TueOMyLpsdmK0SROSr/tfcCeRgkOUWRC0CEc2s65YzKTzSL/THO4jK0Fwk852GfGLyDQbwyCx7OzZazjnThvAe33gGgY1jIBVxs6mLTJgHFCQWoDYgGWD7gN0RY7sS4bpKegputvkwfucL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BJhjIftu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJhjIftu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24C6C4CEF5;
	Wed,  3 Dec 2025 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778315;
	bh=tooxfup+oLTa6KBNjnIosh0o7Q8hlHhONYwEIc/nQQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJhjIftuo/jN2+hwDtXpC7dkcTjIZ7U3IXsDV6zBs+iT+lj5Jn/TLf/oVBdYqywhn
	 HwXq6Ip2eyR7ayrgaNR4VlBs5Fy99DL35ji+cZuSL26mS6Ipi819QYT4ot1MO5Kvzr
	 Gkd+H2w+P/1iVwIT0dn9vnaGUg1Ggd6JH89ouDUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/392] mm/mm_init: fix hash table order logging in alloc_large_system_hash()
Date: Wed,  3 Dec 2025 16:27:37 +0100
Message-ID: <20251203152425.458369764@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 63e131dc2b43e..0a5e9a4b923cb 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8921,7 +8921,7 @@ void *__init alloc_large_system_hash(const char *tablename,
 		panic("Failed to allocate %s hash table\n", tablename);
 
 	pr_info("%s hash table entries: %ld (order: %d, %lu bytes, %s)\n",
-		tablename, 1UL << log2qty, ilog2(size) - PAGE_SHIFT, size,
+		tablename, 1UL << log2qty, get_order(size), size,
 		virt ? (huge ? "vmalloc hugepage" : "vmalloc") : "linear");
 
 	if (_hash_shift)
-- 
2.51.0



