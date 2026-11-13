Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591128;
	b=IhHSdCtZMwlueNvCg2u5EA6b5r3mVIIMyphfLLj0IHH4R6ph1Jceq8S11Sr1OYd1iW2T
	 uRUnIqUXdLOLRrl0K7HQ91x8tkgRrKYv3YLt3vk+23iEFMxISMzZKByWoJOBpSAOg3n8j
	 dGfhZqj7FS1StWvtQZiFKIVacnEdAzCPjd6+8ssCj91hwqdIMgHy1L1BNAdtzsSrPNb3J
	 raGSLLRxr3BqE2SVg6sjkrxsIPrhvFBVzfCvUZdH+q+GrtdajCIdb2PSoG6zam704tgTC
	 jLRMD0DBUMM3N2NcQSk5ewCzchdQcjTuzXA3MSTv5TNpaxiQClIr3AukoFmNrgQuBZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kh65Jw6odd7sCz6x/oTx11E/XhaZR500jXkLaMuJZDo=;
	b=yS9pU8dT8ZggjtlaG1bwzo/mACDAQB1aH/TQFJnrVfwpD67mNWKJgHd9yISVKmKAijly
	 O0Ndo+MXOwOZqqz92ZwL9Spy0qHRhj3T5lleKu1G5Wz2XfUml18H+N1WUm96dxlO8+qxS
	 FgfC9GECDse9wC9KMcLe9typvel//Ss4GdeKgo2UMcNV7xlvK94hafHk266k5ZoX54d6J
	 FjBP9XW8X8vAQs6PTGh/qtUsaCzS7NkArw0kC2xIrIZocJ7tPcIWcNQwT4Ik7hBu8Ewzy
	 EXaQ7aBqifCP07RgCN3i66LRggT1EvGP4lhkklbInynRQ03gyMew9+8nSxcyrHM7NhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhBIddcM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52684606BD0F;
	Fri, 13 Nov 2026 17:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhBIddcM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAD31F000C6;
	Fri, 13 Nov 2026 17:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591128;
	bh=Kh65Jw6odd7sCz6x/oTx11E/XhaZR500jXkLaMuJZDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhBIddcMY6aN5a5flIF7Oi1zcuoT6Nldv2t4daD6IgXbqbcM1oQSJbSWefu0rcumN
	 jUNXwDclBvNiK8Ft7K/yPz9UGlyOL4nDUF2ilKIcZvL+IZ/JzOz8xzcU++73Uivefz
	 CROfk4s5th1oH94/0I/b+IPGqX75FZPu99deZndI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 275/670] mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Fri, 13 Nov 2026 10:47:19 -0500
Message-ID: <20261113153821.211266881@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 854e5ff8b3ce2a776586cabebaeae645c992345b ]

collapse_file() can fail its reference-count or dirty-folio check after
unmapping with TTU_BATCH_FLUSH.  Both paths put back the isolated folio,
then unlock it and drop the lookup reference before reaching the common
try_to_unmap_flush().

The page-cache reference does not keep the folio stable once the lock is
released.  Another collapse can replace and free it.  With its PTEs
already gone, that collapse cannot flush the first task's per-task TLB
batch, and retract_page_tables() skips short or unaligned VMAs.  A CPU can
therefore retain a user translation to the freed folio.  This has been
reproduced with unprivileged MADV_COLLAPSE on a memfd.

Flush at out_unlock while the lookup reference and folio lock are still
held.  The common flush continues to cover the accumulated pagelist on
both success and rollback, preserving batching on successful collapses.

Link: https://lore.kernel.org/20261007041001.43181-1-kylebot@openai.com
Fixes: 6d9df8a5889c ("mm/thp: collapse_file() do try_to_unmap(TTU_BATCH_FLUSH)")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Hugh Dickins <hughd@google.com>
Assisted-by: LLM
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7a54ce0f126bc..1250d878d7242 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2018,6 +2018,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		index += folio_nr_pages(folio);
 		continue;
 out_unlock:
+		/*
+		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		folio_unlock(folio);
 		folio_put(folio);
 		goto xa_unlocked;
@@ -2028,9 +2033,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the folios, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
-- 
2.53.0



