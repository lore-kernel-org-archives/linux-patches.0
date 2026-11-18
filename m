Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038227;
	b=SVUkZNoVUWr/x8kYCswoxcZd4q7rRnqpFelpEzAZNNOOO0XDxwxkESpdsmgz4Z4w05Ud
	 7u6EZIfa3gwfM6Fj6Oo0kw9awdizZJVLTHkz0oJ4ymQTQZf8WMon4NDO7SzJlehtxPwQX
	 UCZ+w/CK3eI92TJezijH8F0ZiQBNmnuAqQ1280lowfL14p1N+nMleAmLsS1pwYQBz0sMw
	 TUbSAzAsIx3XkqgEcbXOXmEz1KfI2jnwqSjmrm+yGGFyKpbzDTjoTX2Yh1yDseewALOrD
	 3B6XQvVoxKsxfC3HVp1Sonw7etgMG+CBz//0NyTGUu+eQm6yvDf3CHszbla8m3symvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EAY+4GG7iUefRFocgN4XmAIglN1ymolH8XwFVm0jVLw=;
	b=EkJH7orioGM4m/VldZUvdsCYtB6rro9y8VYaT9LkyzE1q5hmI2qXo+uYXHS43f9NRU5i
	 wuEWOKpv2kKz1k00gYsB1DJ7cYLXcS4neslCQjOevGEyf+dDDHEiVqx6WOXwTfs9XpHnV
	 y1pMTgEjVy2pmio2cZ5RS9Gmo4Mbpk2fMBufEsnhRnII3iF/BRoisrWFBdI76bibDppoG
	 O63iKtQTEvYiq4+6FSPka5Pa3fSmjjcTw3B4i35sL1J6E501f8f46j0QExJFQ6CnKny5j
	 CvG89Hdw3smV5PClhAzTkY2+GbB93J3pfx/ojj2C6eb2TUfs3VGFQnzV1gEJfjY1hpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGL7v2Cj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09641606A331;
	Wed, 18 Nov 2026 21:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGL7v2Cj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBD51F000C4;
	Wed, 18 Nov 2026 21:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038226;
	bh=EAY+4GG7iUefRFocgN4XmAIglN1ymolH8XwFVm0jVLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGL7v2CjlEXD8UFbbw1ZfYsGvdsgldVtR8f+Onk1qU0YQtt0rxe1atmvzvEt1dTGi
	 AkEuNuF7xmiDcjYAI/oN1jUamsp2CLpWnygXaCfs1EKnEEfyu0sy/kAHN1ozfM71DO
	 sU530IxDbcXcCkaGM8O3jZVY/vNhKBnD7aJoQ1DM=
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
Subject: [PATCH 6.6 1670/3318] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Wed, 18 Nov 2026 15:38:12 +0100
Message-ID: <20261118150411.896493331@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted surrounding comment context for the existing single-page folio mapcount check. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index e29bd73de12ae..b7f5bbfb5c91d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -707,6 +707,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		if (folio_test_swapcache(folio) || folio_test_dirty(folio)) {
 			if (!folio_trylock(folio))
 				continue;
+			/*
+			 * KSM folios can gain new mappings at any time, so we must
+			 * not clear their dirty flag.
+			 */
+			if (folio_test_ksm(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+
 			/*
 			 * If folio is shared with others, we mustn't clear
 			 * the folio's dirty flag.
-- 
2.53.0



