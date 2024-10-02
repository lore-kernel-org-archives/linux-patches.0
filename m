Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E63B3D994;
	Wed,  2 Oct 2024 14:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880633; cv=none; b=BrzMheSxhKYF/N6kX8kpdKv00iRj9xTDO1zPBnYsXmi2kiKhDCUz5fYLSb8sOksre2/r1rUPI74hW7skjllgmd1kQNsz1MEtsMGXdsduTMaDJbgfYUAf1HDCp1KbHEiQqdfa1D5rterap+K4mOEHVXt2Ai5qvws3Apzt6MMIlb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880633; c=relaxed/simple;
	bh=mi0eZRqNdbz+jxABe1vWtG1ezXtFnOV4LaCzPjFXNo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWtue+PYDJbFb1MgPTBW/oDlyavf0Sctz40N4m0C0WmDjn8CzV+Od/tg0HNGou9rIZfGg2EyO7bW8G5anJvRRzVfGnqHisr/Xa4hLRJzu2Z+2fCzsGKTHkPVFaoHBbvX8mjiTGDk5fmhCwvrcQQ+HTBr8iFfmNQWlmIuGX4ahB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FF5YWAG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FF5YWAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC23CC4CEC2;
	Wed,  2 Oct 2024 14:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880633;
	bh=mi0eZRqNdbz+jxABe1vWtG1ezXtFnOV4LaCzPjFXNo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0FF5YWAGJvbFwQm2DI2Oj17GemjzbVwx6MvffcvXAPXrXV8nPm2iS6EgDAO5Ums+k
	 Gve4HdjpfhV5VTBGQIPUUKkP24YLa2QURSmSK2Y3tkDVsvAQaW1mq7ZpKgVGxsSKhR
	 A7KSrrQjnzdFd+jBldkxGoHL1XwHvC3g24wU0gXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	SeongJae Park <sj@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 525/538] mm/damon/vaddr: protect vma traversal in __damon_va_thre_regions() with rcu read lock
Date: Wed,  2 Oct 2024 15:02:44 +0200
Message-ID: <20241002125813.169078593@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett <Liam.Howlett@oracle.com>

commit fb497d6db7c19c797cbd694b52d1af87c4eebcc6 upstream.

Traversing VMAs of a given maple tree should be protected by rcu read
lock.  However, __damon_va_three_regions() is not doing the protection.
Hold the lock.

Link: https://lkml.kernel.org/r/20240905001204.1481-1-sj@kernel.org
Fixes: d0cf3dd47f0d ("damon: convert __damon_va_three_regions to use the VMA iterator")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/b83651a0-5b24-4206-b860-cb54ffdf209b@roeck-us.net
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/vaddr.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -126,6 +126,7 @@ static int __damon_va_three_regions(stru
 	 * If this is too slow, it can be optimised to examine the maple
 	 * tree gaps.
 	 */
+	rcu_read_lock();
 	for_each_vma(vmi, vma) {
 		unsigned long gap;
 
@@ -146,6 +147,7 @@ static int __damon_va_three_regions(stru
 next:
 		prev = vma;
 	}
+	rcu_read_unlock();
 
 	if (!sz_range(&second_gap) || !sz_range(&first_gap))
 		return -EINVAL;


