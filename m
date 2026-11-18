Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053856;
	b=eBHVOQUzLI0V38wH2OIQqUZ5FkLWG+lIPeW6u/hoPWMQpu61ymO4NpfISQST0zj12Wb/
	 5xzz02N8x/d3VaXbFfo3RvGrxpOtowFv0/2IiaPVm/jBKh1Yq61dSt/7lV/2vRGtjE7YJ
	 aDoP/qd6sFW8zfY0LAdzZZPz169ItcLn7BXw9aSkXDbvlui5xovwGenDjdw0JgOQvTkII
	 Mv0nnSqmz6l4BdcZaZk65i4W0F6cl2x/kyzv6lkdrtTM4kq6OGCIMndiE+lpakEz3wRyJ
	 IAvklx+2zJQRfgE9wRdFVjriB7AI9xnl0MhGOKGaPoZhEXeQG6jbrwDTgkbqlhERtkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053856;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r9Zk8yIdJwfBYp/t9Mt/5SMUnLxNEv5JnMqKRpDOa3Q=;
	b=H6P/AZ3LF/OTj49wBt+KayjZLCq+1Gm2I2trobkkUgufhjYzFA4NLLe7p5nS0HmmjE6X
	 HJa2FCRHlR84QLML6VhwN1zHjY+WE3oriWPqarYfu46CJnQxi1NQigiACLWMR2RQ8o/QN
	 KkkdIVstmLn6bJXCuIJZGZE5F+S63K7G4hK0wNmtF5KSslBYUKqYmsDFC9SYmV1p4EUQT
	 J9wuyQZKSb0TyBvxrUKlEeBEFV/qR35ByItt0XUdHWS+KBpu58I6+2XyQQ+gSo2zQNYg7
	 u1O1N7Yrq1ou53fJnfdM7ICPQ9P8VCF391ooSyi9xVf6N4JBukAytudKp+4onooHDkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QAbZ0G/O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF84606A32C;
	Thu, 19 Nov 2026 02:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QAbZ0G/O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2405D1F000C4;
	Thu, 19 Nov 2026 02:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053855;
	bh=r9Zk8yIdJwfBYp/t9Mt/5SMUnLxNEv5JnMqKRpDOa3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QAbZ0G/OR6MBBr0P47z4fQgPCSL0FjexKTfoDQGnTdj7VAo9VbzMF6/le+jcI0iR+
	 yA5aErzTI68TKcIp7Bmu/2xAhX9AIYYFfavPjccxU+axqzYlu5mkYA8vRIiMifugW+
	 yFdJjbCBmRI5Frq3pyxQcpbI1ohyXhsDMwD0AOs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1026/2214] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Wed, 18 Nov 2026 15:45:02 +0100
Message-ID: <20261118150053.389416437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 22d043c1da48d6c7274f9dd900714b6d58b7b9c6 ]

MADV_FREE can clear the dirty flag of a singly mapped KSM folio. The
folio remains in the stable tree and can gain new mappings without being
dirtied again. Once marked lazyfree, reclaim can discard data that those
mappings still need.

KSM always marks a folio dirty when converting it to a KSM folio in
try_to_merge_one_page(). Marking a folio lazyfree clears PG_swapbacked
but leaves PG_dirty unchanged. Preserving PG_dirty makes reclaim restore
PG_swapbacked instead of discarding the folio. This also protects folios
that were already lazyfree when KSM converted them.

Skip KSM folios before clearing their dirty flag, checking under the
folio lock to serialize with KSM conversion.

Fixes: 854e9ed09ded ("mm: support madvise(MADV_FREE)")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Xu Xin <xu.xin@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-34-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: Adapted the folio-based KSM guard to the existing page-based APIs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 3079da08c19de..668d2fa835d4e 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -651,6 +651,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (PageSwapCache(page) || PageDirty(page)) {
 			if (!trylock_page(page))
 				continue;
+			/*
+			 * KSM pages can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (PageKsm(page)) {
+				unlock_page(page);
+				continue;
+			}
+
 			/*
 			 * If page is shared with others, we couldn't clear
 			 * PG_dirty of the page.
-- 
2.53.0



