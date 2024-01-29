Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9478D157E61;
	Mon, 29 Jan 2024 17:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548498; cv=none; b=IgcQqU5mZFzU8/+WvO6Tjvu45oqqly6EK5rACKD3JReugVSZ1ujSXjv+ex4gbzii7FZ21Kj4MEINJ7ji2U62LTNO74B78UUER2ELVXLzt8GoSqeGgz+jNft88q2NwfA3O6hwWReNPEnI4QpgI7w/Ur4OWi9e6LG3JPwwHX1GNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548498; c=relaxed/simple;
	bh=bwFl4hcqTGuoAKvE9+ldnMspZbXmTu5rLx25zgLGPD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSV6/ZTgIrfijxsysbxETeIpcz+To7l8djk/KPqdwnwghnm6K8CEtl+3yx1n9Ib2btT49EH+1h+osjSCHZ3KFy+WVhmGC40ApuhNv15uKQMOaEN699WuF2qW6XWd9xKJ466v8NpH+veYXAoJYC1O45Lpx50qu5zMzh2fm0Atuec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjMGqtKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjMGqtKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA49C433F1;
	Mon, 29 Jan 2024 17:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548498;
	bh=bwFl4hcqTGuoAKvE9+ldnMspZbXmTu5rLx25zgLGPD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjMGqtKov9vn1fcsOz8dprLjPRPxT9cPD7HVjeIUn7MUJ6F0hRHxOXTi/7FS37iFN
	 dU9F9zprwalrp7h5nS3apKVRyNZxxsyhm9zX6+8PO1epG3PxLtqgwSn/3uGD42TOqm
	 +hvq+Z4ofT8rQZC0JgrI97oRLWhDoCjES8pU+nnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 125/331] mm/rmap: fix misplaced parenthesis of a likely()
Date: Mon, 29 Jan 2024 09:03:09 -0800
Message-ID: <20240129170018.593253783@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Steven Rostedt (Google) <rostedt@goodmis.org>

commit f67f8d4a8c1e1ebc85a6cbdb9a7266f14863461c upstream.

Running my yearly branch profiler to see where likely/unlikely annotation
may be added or removed, I discovered this:

correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
       0   457918 100 page_try_dup_anon_rmap         rmap.h               264
[..]
  458021        0   0 page_try_dup_anon_rmap         rmap.h               265

I thought it was interesting that line 264 of rmap.h had a 100% incorrect
annotation, but the line directly below it was 100% correct. Looking at the
code:

	if (likely(!is_device_private_page(page) &&
	    unlikely(page_needs_cow_for_dma(vma, page))))

It didn't make sense. The "likely()" was around the entire if statement
(not just the "!is_device_private_page(page)"), which also included the
"unlikely()" portion of that if condition.

If the unlikely portion is unlikely to be true, that would make the entire
if condition unlikely to be true, so it made no sense at all to say the
entire if condition is true.

What is more likely to be likely is just the first part of the if statement
before the && operation. It's likely to be a misplaced parenthesis. And
after making the if condition broken into a likely() && unlikely(), both
now appear to be correct!

Link: https://lkml.kernel.org/r/20231201145936.5ddfdb50@gandalf.local.home
Fixes:fb3d824d1a46c ("mm/rmap: split page_dup_rmap() into page_dup_file_rmap() and page_try_dup_anon_rmap()")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rmap.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -261,8 +261,8 @@ static inline int page_try_dup_anon_rmap
 	 * guarantee the pinned page won't be randomly replaced in the
 	 * future on write faults.
 	 */
-	if (likely(!is_device_private_page(page) &&
-	    unlikely(page_needs_cow_for_dma(vma, page))))
+	if (likely(!is_device_private_page(page)) &&
+	    unlikely(page_needs_cow_for_dma(vma, page)))
 		return -EBUSY;
 
 	ClearPageAnonExclusive(page);


