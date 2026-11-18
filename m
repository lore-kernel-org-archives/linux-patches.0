Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047503;
	b=KpH/DKqiIIIGumli9yEdHpyBF+yyPVCiJa0BgsF+eZFtROjSEK6iADJauFMOTnzGD0Ph
	 ePtPOUmxDB7IupBCJhTmFGr+unL6K5y94HRnFEhDJWKOniqvFOR4zb+9zOxDt6RbTJtS+
	 9Y5oDIrjtAF/FZkVyANqXum887RIg07MeDUwiR1FQ5ymlmJtFBze5M0PGarpj08iXtCQq
	 RhUnsSgLOu81vto7nh0iJI1K3Ape25Sai015+G1P0qx/DJZj7EWszbJONClPk6RM0Uj+t
	 07bWnSNneKCrr8zwkn4URzPWWupOvtioJYfXpJC83F8gPfRDVwfUwS9R/+s2PuO9jVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WAVRZiGC6dkYHI5VQwFkl9+hpxdTEqCBPBGfY59mNyI=;
	b=lTYn1dKyZsvnuK7KPOSxk4mgA259xv4OLCMf8ErmwF1O1b7Q7w7bVXF4+ERvC/umsVmU
	 isoWm6hbEyJsi0CADbJn2aA8Ai4txAzUocSO0jcoQvO2NITry2kzHwOMmM1AUK4sAZrFk
	 Yt+RqLQmyFWYmqo001GYsWWbw/uquGB9WQmWnkyKPlUCYTcdq6VkUj1GoJdHpM3pCJF3I
	 EU7/V5lfc+pKHwgUSgRAdfd21b7+eS0/fBxL7fmQ+Q7/m2xpK7HNNm6dc9eIg2Xoda6SV
	 9LXcmK/mqAEm/377sG8vrvWQ3Ikh5KpYQlt6JZv3D8CMITeUmaU6unbfWuC6nbgu8Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nW94g/45";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF60606A31C;
	Thu, 19 Nov 2026 00:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nW94g/45
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FE91F000C4;
	Thu, 19 Nov 2026 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047503;
	bh=WAVRZiGC6dkYHI5VQwFkl9+hpxdTEqCBPBGfY59mNyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nW94g/455o2KTHmCMjG2MWzu/2l89kLdl0+Pb0dmFvUQQLGIDoK1OiWoAf3gaiKVy
	 MVIm3W0j3UHmaURsAFcW3SwDSRRB/ZwWqdaR6wYRH3CrZSg6mTXLDebTYp4vNwq/i8
	 /7hbJLDvv7xCO8RhVd68H83qoPTU7w4pse4XcfsE=
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
Subject: [PATCH 6.1 1662/2857] mm/khugepaged: flush deferred unmaps before dropping a failed folio
Date: Wed, 18 Nov 2026 15:44:56 +0100
Message-ID: <20261118150301.168453946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context and comments to use pages instead of folios ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/khugepaged.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9738b70bbd453..f21b78228cb40 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2011,6 +2011,11 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		WARN_ON_ONCE(xas_error(&xas));
 		continue;
 out_unlock:
+		/*
+		 * The page may have been unmapped with TTU_BATCH_FLUSH.
+		 * Flush before releasing the lock and our last reference.
+		 */
+		try_to_unmap_flush();
 		unlock_page(page);
 		put_page(page);
 		goto xa_unlocked;
@@ -2056,9 +2061,8 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 xa_unlocked:
 
 	/*
-	 * If collapse is successful, flush must be done now before copying.
-	 * If collapse is unsuccessful, does flush actually need to be done?
-	 * Do it anyway, to clear the state.
+	 * Flush before copying the pages, or releasing them in rollback.
+	 * This is a no-op if out_unlock already flushed the batch.
 	 */
 	try_to_unmap_flush();
 
-- 
2.53.0



