Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A80612D7;
	Tue, 20 Feb 2024 21:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463583; cv=none; b=PbpJw0E2dWcen0DadOcCYAbtZ70h0Oi+4rNG73iRrH51Owftgzs4Sas9G8T5JJQP0G9xly7Umji9epMBKVxHVxD/mp/TuSuzCCBpfoLZHL2LgBPNZihMjXyEbuRyY52W+umqgi6IfAXYNQamo+8kTnxkxdCX9FMpPLT3iR8TXbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463583; c=relaxed/simple;
	bh=y0N7vKSRMsThrjP6P8h3MqfL35IANBcCA15hY3vvmdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPjrysiw21Is2n+i9rnf/coZn9zRegfrkqrpXDT68KnOGI0lIE0VNQsuPaojBQyy0ewNMGA7hyjrxX6D/vwiZ5VjBBSh3fU0Hrh49rnM1jTGK/kVywSQNMFO2zNEqCoClav35VS08jSJ34F5UQuG3TLExQS5shhxO5K2Gx9KqyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g20mDwpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g20mDwpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18577C43390;
	Tue, 20 Feb 2024 21:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463583;
	bh=y0N7vKSRMsThrjP6P8h3MqfL35IANBcCA15hY3vvmdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g20mDwpjiFftIMDMbDgQj1q2ep5VTisc4Cw3DN6H5f4yq6IVNksjO6HLKdBGb9uG2
	 BU+RL2XfJnlEGdViAtDmYXSUZyQoFKTwxvPAbVXuWV2HOhPc6U8OKm9nwR8HaFieKw
	 9MzDw6BIcj8txpDuYTgfrhbLHQTjXzR3PQeBt1aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Guo Xuenan <guoxuenan@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 060/331] readahead: avoid multiple marked readahead pages
Date: Tue, 20 Feb 2024 21:52:56 +0100
Message-ID: <20240220205639.482094665@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit ab4443fe3ca6298663a55c4a70efc6c3ce913ca6 upstream.

ra_alloc_folio() marks a page that should trigger next round of async
readahead.  However it rounds up computed index to the order of page being
allocated.  This can however lead to multiple consecutive pages being
marked with readahead flag.  Consider situation with index == 1, mark ==
1, order == 0.  We insert order 0 page at index 1 and mark it.  Then we
bump order to 1, index to 2, mark (still == 1) is rounded up to 2 so page
at index 2 is marked as well.  Then we bump order to 2, index is
incremented to 4, mark gets rounded to 4 so page at index 4 is marked as
well.  The fact that multiple pages get marked within a single readahead
window confuses the readahead logic and results in readahead window being
trimmed back to 1.  This situation is triggered in particular when maximum
readahead window size is not a power of two (in the observed case it was
768 KB) and as a result sequential read throughput suffers.

Fix the problem by rounding 'mark' down instead of up.  Because the index
is naturally aligned to 'order', we are guaranteed 'rounded mark' == index
iff 'mark' is within the page we are allocating at 'index' and thus
exactly one page is marked with readahead flag as required by the
readahead code and sequential read performance is restored.

This effectively reverts part of commit b9ff43dd2743 ("mm/readahead: Fix
readahead with large folios").  The commit changed the rounding with the
rationale:

"...  we were setting the readahead flag on the folio which contains the
last byte read from the block.  This is wrong because we will trigger
readahead at the end of the read without waiting to see if a subsequent
read is going to use the pages we just read."

Although this is true, the fact is this was always the case with read
sizes not aligned to folio boundaries and large folios in the page cache
just make the situation more obvious (and frequent).  Also for sequential
read workloads it is better to trigger the readahead earlier rather than
later.  It is true that the difference in the rounding and thus earlier
triggering of the readahead can result in reading more for semi-random
workloads.  However workloads really suffering from this seem to be rare.
In particular I have verified that the workload described in commit
b9ff43dd2743 ("mm/readahead: Fix readahead with large folios") of reading
random 100k blocks from a file like:

[reader]
bs=100k
rw=randread
numjobs=1
size=64g
runtime=60s

is not impacted by the rounding change and achieves ~70MB/s in both cases.

[jack@suse.cz: fix one more place where mark rounding was done as well]
  Link: https://lkml.kernel.org/r/20240123153254.5206-1-jack@suse.cz
Link: https://lkml.kernel.org/r/20240104085839.21029-1-jack@suse.cz
Fixes: b9ff43dd2743 ("mm/readahead: Fix readahead with large folios")
Signed-off-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Guo Xuenan <guoxuenan@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/readahead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -469,7 +469,7 @@ static inline int ra_alloc_folio(struct
 
 	if (!folio)
 		return -ENOMEM;
-	mark = round_up(mark, 1UL << order);
+	mark = round_down(mark, 1UL << order);
 	if (index == mark)
 		folio_set_readahead(folio);
 	err = filemap_add_folio(ractl->mapping, folio, index, gfp);
@@ -577,7 +577,7 @@ static void ondemand_readahead(struct re
 	 * It's the expected callback index, assume sequential access.
 	 * Ramp up sizes, and push forward the readahead window.
 	 */
-	expected = round_up(ra->start + ra->size - ra->async_size,
+	expected = round_down(ra->start + ra->size - ra->async_size,
 			1UL << order);
 	if (index == expected || index == (ra->start + ra->size)) {
 		ra->start += ra->size;


