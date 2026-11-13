Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590417;
	b=2W3Ptrj2cpxm65+JC2Lkk9B8ca/lOajw2R7Mnf3P6P2i89jmlGr60EdLfOU7p7CJEmm7
	 u2Kzzw3sIzrWRMB5tXodiaXWppypBkpc/5KUIkAYLnjXa4INdWctxijscYbhG5blNtA9D
	 kPQZf4/jQP8M+9dalK9R3rfy6R5X0mAyvPhUf8ZMwC/nfSqnj3ouXEaDSlOsuon+PKkNn
	 0UcyT3hlKIzIuXJhXLyBhAolDiC5DyEkvkf+16lgi8AS5fptZAIC+3hY6CjwZMyD36lrW
	 ws1Q6Av6GgojX/4Li79xJiVTHUFKVUCN5WrdN5FKBa+GzIBNWVaYspBfVFXXyzIF0Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zMzMV9SFelv8CAx1J2Jxv49YAmYsLS2jzEFVbokSxAQ=;
	b=BrPuQYSgF+pVrSFGG8EeUmJcPEimKu/LXYQWXkHOyIUDuLzPD+ptNfcmoSBEzQxoAdH7
	 vd2iq8o5JO/yAQr9DJtFV9PqJ8R7K5f0yBwpjnESADP1lEuGa2gELwU4sw8GdZjZcgsZ8
	 qe/qN5xZKp4oqhPd8J5xRGsbBcLbRCxj3F5cD0Jd6ao7SC0XB17kF9rfIddy9b20WBi22
	 LoMOZ+Ze/lE+IkcAqJR8dZ91SME7NjmZ8l7qWtAvk5w/1/DxNaO9GfgRxrNi+BCpiRvs+
	 15RbbQShdFdWrEi6h0mca0SQ9B9ZeuWickUEEKB3aRwRM3uGuzdaxIc/Ya2ZEpGa70A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gsUkbULh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D2E606A8A2;
	Fri, 13 Nov 2026 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gsUkbULh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD571F000C4;
	Fri, 13 Nov 2026 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590416;
	bh=zMzMV9SFelv8CAx1J2Jxv49YAmYsLS2jzEFVbokSxAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsUkbULhYa0cg57Kah1kxv3JADmVprpyxVYF2uc7bZt8lGlhbxe97vihB+VHFtzGT
	 q+NEbLtVrgmWKHDSeqluCS5hhJDIPN4hKj2+h43oOgJtpqZ/eczi9XIH7dAM+MabA5
	 iNGxxdEHczt1OFssLL/kVEpECcaScYSAokxUQoh8=
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
Subject: [PATCH 6.18 382/686] mm/madvise: fix data loss from MADV_FREE on a KSM page
Date: Fri, 13 Nov 2026 10:48:35 -0500
Message-ID: <20261113153833.883949829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/madvise.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index 729d8f2f07fd8..bd0a5093a2df2 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -755,6 +755,15 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
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
 			 * If we have a large folio at this point, we know it is
 			 * fully mapped so if its mapcount is the same as its
-- 
2.53.0



