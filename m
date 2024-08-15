Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DDA1B32CD;
	Thu, 15 Aug 2024 14:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731164; cv=none; b=FkFLjLj2LKoi+9bQ9/AZqj2Wq9vfD0PkNzJuYS/km6tZznRvNtYiBdPHVMfCVZzB7G8XFdiqMBQBYPDHyQhSQ6TYynCHJroikXF97n9bSNE5SJk5DuD6X3vqo/ibzVNs98AsLyUIH3AHej/QQ4piSzTXjRQ774pFeoJUCZg2LUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731164; c=relaxed/simple;
	bh=BGrgjzYhIhZy1M9Zm8PF5CCYxdDb50dDKsoUYKtHOFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8Hv5B1rxCLyPI4IhCAS+G7MxGU/4W4JMI1Bg9dAyEM+PWdWAIcu1RfMHTdT9TeXi4u3zqY5aXn/YdqR7bq8RC78AjLRKpD75QNAG2gkRD7E/WgNXB1fYe9ODP6K/xa+x4yT13IDX47dMQLOWu/X07oowTozST4KtJTb4rTzUuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPOt4iQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPOt4iQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821B3C32786;
	Thu, 15 Aug 2024 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731164;
	bh=BGrgjzYhIhZy1M9Zm8PF5CCYxdDb50dDKsoUYKtHOFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPOt4iQjf8egXq4Cojh9ObTi18QhM1x0UsSArus4X8yIwgK7/xJygbA+jJ6pRZwob
	 0hwQ5djEBHR9QcZIL4N8YU/AnwbtMXE4j75Iqs3XGeUvXWgrr0+qoYB32DTDaWoGbP
	 q5ZS4nb03YBNit7pDJFPQFOl8lDzqquNOOosO4Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/259] perf: Prevent passing zero nr_pages to rb_alloc_aux()
Date: Thu, 15 Aug 2024 15:22:56 +0200
Message-ID: <20240815131904.467445870@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit dbc48c8f41c208082cfa95e973560134489e3309 ]

nr_pages is unsigned long but gets passed to rb_alloc_aux() as an int,
and is stored as an int.

Only power-of-2 values are accepted, so if nr_pages is a 64_bit value, it
will be passed to rb_alloc_aux() as zero.

That is not ideal because:
 1. the value is incorrect
 2. rb_alloc_aux() is at risk of misbehaving, although it manages to
 return -ENOMEM in that case, it is a result of passing zero to get_order()
 even though the get_order() result is documented to be undefined in that
 case.

Fix by simply validating the maximum supported value in the first place.
Use -ENOMEM error code for consistency with the current error code that
is returned in that case.

Fixes: 45bfb2e50471 ("perf: Add AUX area to ring buffer for raw data streams")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240624201101.60186-6-adrian.hunter@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2347dda682abd..39cf0040e6dfb 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5830,6 +5830,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 			return -EINVAL;
 
 		nr_pages = vma_size / PAGE_SIZE;
+		if (nr_pages > INT_MAX)
+			return -ENOMEM;
 
 		mutex_lock(&event->mmap_mutex);
 		ret = -EINVAL;
-- 
2.43.0



