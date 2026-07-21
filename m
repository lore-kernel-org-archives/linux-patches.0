Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D4347142F;
	Tue, 21 Jul 2026 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664773; cv=none; b=fRzpH5eEqg7HlDX9FqiqchU7shWP/IzCN7ri8w3RuEfhK1a9Fmck8tHDlNXJisMhFzzpqPmSHW7uE1fcGS0L5CcczMI6pEdu3Ho+qO96sJUZznnMaUHmmr4Ewp7bTmgMzMVuGjaXbeALMUkPMRuirE6jyJ3P7/uHV0FkLwBTeSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664773; c=relaxed/simple;
	bh=CTogLM8w2vZx/P3tBa+RSK07d+ZOn7tGFZXtfJHYgjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL00mhn9uXxfO9uD3N4AUhPEBaZUK1zsndRko/e9BAOWrs5ctKwTxurgYipJRIt5s2IYeWsvMOoWUPiFWNTdTcEtEV86ounVDf0FuQHzVPgb97R3G7C2eZlwZ+2BQa7jR2BOoUqocjJoFwbqyPlDn7kBaDm68j0rylOiaeRfzmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvlOSHlS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvlOSHlS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2971F00A3A;
	Tue, 21 Jul 2026 20:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664772;
	bh=XStsiovzHE6nZYj0pXqHyzpM/cSMUr52V/aRmZtHavw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KvlOSHlSr9241C6FrjLi6MLUFqa9MID9gsx3Aq/Hi2AajDJKbm3b3mr5gTulozTIW
	 pTNUsATp7MhekXBRdRz9aARArpPAqyCb/6SGSebtMHy7EeV2ocCgoIYmf5sjVm91lt
	 68w7OFARZmL9w0ieM0/dcHl3gIlwcMxRhzRwWEOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingfu Zhou <yingfu.zhou@shopee.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Matthew Wilcox <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0054/1266] mm/vmscan: flush deferred TLB before freeing large folios
Date: Tue, 21 Jul 2026 17:08:11 +0200
Message-ID: <20260721152443.009505171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

In reclaim, shrink_folio_list() unmaps PTEs with a deferred, batched TLB
flush. The batch is only flushed by try_to_unmap_flush() near the end of
the function, just before the order-0 folios collected in @free_folios are
handed back to the allocator.

Large folios don't go through @free_folios -- they're freed inline at the
free_it label via destroy_large_folio(), which runs before that flush. So
a large folio's pages can be returned to the buddy allocator and reused
while another CPU still holds a stale TLB entry for them, and that CPU then
reads or executes through the stale translation into the reused page. For
file-backed large folios (e.g. executable text) this shows up as random
SIGSEGV/SIGILL in user space, with fault addresses that don't match the
code being run.

Flush the deferred batch before freeing a large folio inline, the same way
the order-0 path already waits for the flush.

Upstream this is fixed as a side effect of commit bc2ff4cbc329 ("mm: free
folios in a batch in shrink_folio_list()"), which is a larger change; this
is the minimal fix for -stable.

Reported-by: Yingfu Zhou <yingfu.zhou@shopee.com>
Fixes: bd4c82c22c36 ("mm, THP, swap: delay splitting THP after swapped out")
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index aba757e5c59784..8eb498351d9b30 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2123,10 +2123,12 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 * Is there need to periodically free_folio_list? It would
 		 * appear not as the counts should be low
 		 */
-		if (unlikely(folio_test_large(folio)))
+		if (unlikely(folio_test_large(folio))) {
+			try_to_unmap_flush();
 			destroy_large_folio(folio);
-		else
+		} else {
 			list_add(&folio->lru, &free_folios);
+		}
 		continue;
 
 activate_locked_split:
-- 
2.53.0



